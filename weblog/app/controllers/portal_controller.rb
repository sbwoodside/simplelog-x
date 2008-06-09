#added by Simon

require 'feed-normalizer'

class PortalController < ApplicationController
  layout 'portal', :except => ['everything_feed']
  helper :site
  caches_page :list, :minifeed
  
  $page_title = 'Home'
  
  # we need a list of tags on every page this controller will serve, so let's
  # just go ahead and get them automatically every time
  before_filter :pre_post
  def pre_post
    @tags = Post.get_tags    # get all the tags in use
    if Preference.get_setting('SHOW_AUTHOR_OF_POST') == 'yes'    # get authors if necessary
      @authors_list = Author.get_all
    end
  end
  
  def list
    @myposts = Post.find_current
  end
  
  # show the mini-feed for all of the subsections
  # are there better ways of doing this? probably. do many ways work? no.
  # be very afraid of messing with the data returned by FeedNormalizer
  # also, calling feednormalizer on my own feed causes an infinite recursion
  # and render_to_string of the RSS rxml doesn't work either
  def minifeed
    @all = Array.new
    # Posts from SimpleLog (this app)
    posts = Post.find_current    # get all the current posts (set number in preferences)
    for x in posts
      temp = FeedNormalizer::Entry.new
      temp.title = x.title
      temp.urls = [ Post.permalink( x ), 'hi' ]
      temp.date_published = x.created_at
      #myauth = author_info(x, '')
      temp.authors = [ x.author.name, 'hi' ]
      temp.description = x.body + ((x.extended and x.extended != '') ? x.extended : '')
      @all << { 'class' => 'blog-item', 'obj' => temp }
    end
    # Post from SimpleLog Comments (this app comments)
    comments = Comment.find_current
    for x in comments
      y = x.post
      temp = FeedNormalizer::Entry.new
      temp.title = y.title ##Post.find(x.post_id)  ## look up title of post for x.post_id
      temp.urls = [ Post.permalink(y) + '#c' + x.id.to_s, 'hi' ]
      temp.date_published = x.created_at
      temp.authors = x.name
      temp.description = x.body
      @all << { 'class' => 'blog-comment-item', 'obj' => temp }
    end
    # Posts from the forum (beast app)
    begin
      feed = FeedNormalizer::FeedNormalizer.parse open('http://forum.watstart.ca/posts.rss')
      @stories = []
      @stories.push(*feed.entries)
      for x in @stories
        @all << { 'class' => 'forum-item', 'obj' => x }
      end
    rescue
    end
      # Posts from the wiki
    begin
      wikifeed = FeedNormalizer::FeedNormalizer.parse open('http://wiki.watstart.ca/HomePage/recentchanges.xml')
      wikipages = []
      wikipages.push(*wikifeed.entries)
      for x in wikipages
        @all << { 'class' => 'wiki-item', 'obj' => x }
      end
    rescue
    end
    
    @all = @all.sort_by { |x| x['obj'].date_published }.reverse
  end
  
  
  # we should also be able to get to the list with 'index'
  def index
    list
    render :action => 'list'
  end
  
  def everything_feed
    list # compiles the complete list into @all which is an array
    # use @all[0]['obj'] to get the 1st FeedNormalizer entry etc.
    render :template => 'feeds/everything'
  end

end






