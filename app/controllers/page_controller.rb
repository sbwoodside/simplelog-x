# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# the page controller handles "static" pages
class PageController < ApplicationController
  layout 'site'
  helper :site
  
  $page_title = Preference.get_setting('SLOGAN')  # default page title (set in prefs)
  
  # we need a list of tags on every page this controller will serve, so let's
  # just go ahead and get them automatically every time
  before_filter :pre_page
  def pre_page
    @tags = Tag.find(:all).map { |t| t.name } # get all the tags in use
    if Preference.get_setting('SHOW_AUTHOR_OF_POST') == 'yes'
      @authors_list = Author.get_all # get authors if necessary
    end
  end
  
  cache_sweeper :site_sweeper, :only => [:create, :update, :destroy]
  
  # show a page based on its permalink (/pages/:permalink)
  def show
    @page = Page.find_by_link(params[:link])
    display_404 and return unless @page
    # set the page title
    $page_title = @page.title
    render :template => 'pages/show'
  end
  
end


