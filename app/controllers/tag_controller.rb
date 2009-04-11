# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# TODO: generally speaking we should only display tags that are currently actually attached to anything
#       I don't know if they get automatically deleted maybe at that point though. Check.
class TagController < ApplicationController
  layout 'site'
  helper :site
  
  # TODO: This is really stupid, because it's needed by the layout not by me.
  before_filter :load_tags_and_authors
  def load_tags_and_authors
    @tags = Tag.find(:all).map { |t| t.name } # get all the tags in use
  end
  
  # list the available tags
  def index
    $page_title = 'Tags'
  end
  
   # display all posts tagged with a tag
  def show
    @tag = params[:tag]
    $page_title = "Tag archive for '" + @tag + "'"
    tag = Tag.find_by_name(@tag)
    display_404 and return unless tag
    @posts = tag.posts.sort {|a,b| a.created_at <=> b.created_at}.reverse
  end
  
end


