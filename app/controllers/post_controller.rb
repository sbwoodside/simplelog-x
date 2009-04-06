# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# the post controller handles all the work of displaying posts, archives and feeds, as well as searching
class PostController < ApplicationController
  layout 'site', :except => ['search', 'feed_all_rss', 'feed_comments_rss']  # use the post layout, unless this is a search or a feed
  
  helper :site  # grab the site helper for prefs and such (thanks garrett dimon for this idea!)
  
  $page_title = Preference.get_setting('SLOGAN')  # default page title (set in prefs)
  
  # we need a list of tags on every page this controller will serve, so let's
  # just go ahead and get them automatically every time
  before_filter :pre_post
  def pre_post
    @tags = Tag.find(:all).map { |t| t.name } # get all the tags in use
    if Preference.get_setting('SHOW_AUTHOR_OF_POST') == 'yes'
      @authors_list = Author.get_all # get authors if necessary
    end
  end
  
  cache_sweeper :site_sweeper, :only => [:create, :update, :destroy]

  #
  # helper methods
  # we're going to put some helper methods here so we can share them
  # with the views and this controller
  #
  
  # build a short preview of `text` to be used in search returns
  helper_method :truncate_words
  def truncate_words(text, length = 30, end_string = '...')
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end

  # create a nice title to be used in the browser
  # looks like: The first few words... (27 April, 2006)
  # customize the date format in preferences
  helper_method :create_html_title
  def create_html_title(post, include_date = true)
    return post.synd_title + (include_date ? '(' + post.created_at.strftime(Preference.get_setting('DATE_FORMAT')) + ')' : '')
  rescue
  # just in case something goes wrong...
    return 'Untitled'
  end
  
  # get an author's name
  helper_method :get_author_name
  def get_author_name(author)
    @author = Author.find(:all, :conditions => ['id = ?', author])
    if @author.length > 0
    # we found an author
      return @author[0].name
    else
    # no author found...
      return ''
    end
  end
  
  #
  # done with helper methods
  #
  
  # main page of the site
  def list
    @posts = Post.find_current  # get all the current posts (set number in preferences)
    $page_title = Preference.get_setting('SLOGAN')  # set the page title
    render :template => 'index'
  end
  # we should also be able to get to the list with 'index'
  def index
    list
    render :action => 'list'
  end
  
  # archives list pages that contains links to all the entries in various ways
  def archives_list
    @posts = Post.find_all_posts
    $page_title = 'Archives.'
    render :template => 'archives/list'
  end
  
  # list of tags (a tag archive, if you will)
  def tags_list
    $page_title = 'Tags.'
    render :template => 'archives/list_tags'
  end
  
  # yearly archive
  def by_year
    # get all the posts from this month
    @posts = Post.find_by_year(params[:year])
    # we didn't find a post... send them packin'!
    if @posts.length < 1
      redirect_to '/'
      return
    end
    $page_title = 'Yearly archive: ' + params[:year]  # set the page title
    render :template => 'archives/yearly'
  end
  
  # monthly archive
  def by_month
    # get all the posts from this month
    @posts = Post.find_by_month(params[:month], params[:year])
    # we didn't find a post... send them packin'!
    display_404 and return unless @posts.length > 0
    # set the page title
    $page_title = 'Monthly archive: ' + Time.parse("#{params[:month]}/01/#{params[:year]}").strftime('%B, %Y')
    render :template => 'archives/monthly'
  end
  
  # daily archive (many people probably won't use this, but who knows)
  def by_day
    # get all the posts from this day
    @posts = Post.find_by_day(params[:day], params[:month], params[:year])
    # we didn't find a post... send them packin'!
    display_404 and return unless @posts.length > 0
    # set the page title
    $page_title = 'Daily archive: ' + Time.parse("#{params[:month]}/#{params[:day]}/#{params[:year]}").strftime('%d %B, %Y')
    render :template => 'archives/daily'
  end
  
  # individual post archive
  def show
    @post = Post.find_individual(params[:link])
    # we didn't find a post... send them packin'!
    display_404 and return unless @post
    # create comment
    @comment = Comment.new
    # set the page title
    $page_title = (Preference.get_setting('SIMPLE_TITLES') == 'yes' ? create_html_title(@post[0]) : @post[0].title)
    render :template => 'posts/show'
  end

  # add a comment to a post, checking it against the blacklist
  def add_comment
    # they didn't come with the right stuff
    if params[:do] != '1' or (params[:human_check] and params[:human_check] != '8') or !params[:comment][:post_id]
      logger.warn("[Human check #{Time.sl_local.strftime('%m-%d-%Y %H%:%M:%S')}]: Comment did not pass human check so it was blocked.")
      redirect_to '/' and return false
    end
    # grab the ticket info
    @comment = Comment.new(params[:comment])
    # grab the user's IP
    @comment.ip = request.remote_ip
    # save it (gets checked for spam as well)
    if @comment.save
    # comment was saved successfully
      if Preference.get_setting('COMMENTS_APPROVED') != 'yes'
      # approval is required, notify accordingly
        flash[:notice] = 'Your comment will be reviewed and will appear once it is approved.'
        redirect_to params[:return_url] + "#comments"
      else
      # comment is posted, let's send them there
        redirect_to params[:return_url] + '#c' + @comment.id.to_s
      end
    else
    # whoops!
      @post = Post.find_individual(params[:link])
      # set the page title
      $page_title = (Preference.get_setting('SIMPLE_TITLES') == 'yes' ? create_html_title(@post[0]) : @post[0].title)
      render :template => 'posts/show'
    end
  end
  
  # author archives
  def by_author
    # get all the posts written by this author
    @posts = Post.find_by_author(params[:id])
    # we didn't find any posts... send them packin'!
    if @posts.length < 1
      redirect_to '/'
      return
    end
    # set the page title
    $page_title = 'Author archive: ' + get_author_name(params[:id]) + '.'
    render :template => 'archives/by_author'
  end
  
  # display tag archives
  def tagged
    # get all posts tagged with this tag
    @posts = Tag.find_by_name(params[:tag]).posts.sort {|a,b| a.created_at <=> b.created_at}.reverse # must be a better way to sort
    $page_title = 'Tag archive: ' + params[:tag] + '.'  # set the page title
    render :template => 'archives/by_tag'
  rescue
    render :template => 'errors/unknown_request', :status => 404 # tag wasn't found, probably
  end
  
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
  
  # rss feed
  def feed_all_rss
    # get all the posts for the feed (set number in preferences)
    @posts = Post.find_for_feed
    render :template => 'feeds/posts'
  end

  # rss feed for comments
  def feed_comments_rss
    # get recent comments for the feed
    @comments = Comment.find_for_feed
    render :template => 'feeds/comments'
  end

end