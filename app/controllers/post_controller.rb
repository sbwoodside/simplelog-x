# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# Weblog posts. Also does archives and a feed for the posts.
# TODO, eventually it might be nice if this and admin/posts_controller could be merged, and named posts and use REST
class PostController < ApplicationController
  layout 'site', :except => ['search']  # use the post layout, unless this is a search or a feed
  helper :site
  
  $page_title = Preference.get_setting('SLOGAN')  # default page title (set in prefs)
  
  # we need a list of tags on every page this controller will serve, so let's
  # just go ahead and get them automatically every time
  before_filter :load_tags_and_authors
  def load_tags_and_authors
    @tags = Tag.find(:all).map { |t| t.name } # get all the tags in use
    if Preference.get_setting('SHOW_AUTHOR_OF_POST') == 'yes'
      @authors_list = Author.get_all # get authors if necessary
    end
  end
  
  
  ### GENERAL POST DISPLAY
  # display most recent or just one post
  def index
    if params[:link]
      @posts = Post.find_individual(params[:link])
      display_404 and return unless @posts.first
      @comment = Comment.new
      $page_title = (Preference.get_setting('SIMPLE_TITLES') == 'yes' ? create_html_title(@posts.first) : @posts.first.title)
    else
      @posts = Post.find_current  # get all the current posts (set number in preferences)
      $page_title = Preference.get_setting('SLOGAN')  # set the page title
    end
  end
  
  # list of tags (a tag archive, if you will)
  def tags_list
    $page_title = 'Tags.'
    render :template => 'archives/list_tags'
  end
  
  
  ### ARCHIVES
  # archives list pages that contains links to all the entries in various ways
  def archives_list
    @posts = Post.find_all_posts
    $page_title = 'Archives.'
    render :template => 'archives/list'
  end
  def by_year
    @posts = Post.find_by_year(params[:year])
    display_404 and return unless @posts.length > 0
    $page_title = 'Yearly archive: ' + params[:year]
    render :template => 'post/index'
  end
  def by_month
    @posts = Post.find_by_month(params[:month], params[:year])
    display_404 and return unless @posts.length > 0
    $page_title = 'Monthly archive: ' + Time.parse("#{params[:month]}/01/#{params[:year]}").strftime('%B, %Y')
    render :template => 'post/index'
  end
  def by_day
    @posts = Post.find_by_day(params[:day], params[:month], params[:year])
    display_404 and return unless @posts.length > 0
    $page_title = 'Daily archive: ' + Date.parse("#{params[:month]}/#{params[:day]}/#{params[:year]}").strftime('%d %B, %Y')
    render :template => 'post/index'
  end
  
  
  ### AUTHORS
  # show posts by a certain author. TODO: add ability to show list of authors
  # TODO would move to author_controller but it's being used for logging in
  def authors
    @posts = Post.find_by_author(params[:id])
    display_404 and return unless @posts.length > 0
    $page_title = 'Author archive: ' + Site.get_author_name(params[:id]) + '.'
    render :template => 'post/index'
  end
  
  
  ### SEARCH
  # search posts for a string and return them for ajax inclusion (set number of
  # results in preferences), customize results in the search view
  def search
    if params[:q]
      # run the search and return some posts
      @posts = Post.find_by_string(params[:q])
      $page_title = 'Search results for: &quot;' + params[:q] + '&quot;'
      render :template => 'search/results'
    end
  end
  def search_full
    if params[:q]
      # run the search and return some posts
      @posts = Post.find_by_string_full(params[:q])
      $page_title = 'Search results for: &quot;' + params[:q] + '&quot;'
      render :template => 'search/full_results'
    end
  end
  
  
  ### FEEDS
  # Feed for posts
  def feed
    @posts = Post.find_for_feed # set number in preferences
    respond_to { |format| format.xml { render :layout => false } }
  end

  # rss feed with just comments
  def feed_comments_rss
    # get recent comments for the feed
    @comments = Comment.find_for_feed
    render :xml => 'comment/feed'
  end
  


end


