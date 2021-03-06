# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# This is a very basic CMS
class Admin::PagesController < Admin::BaseController
  
  # get a list of pages, paginated, with sorting
  def page_list
    @sorter = SortingHelper::Sorter.new self, %w(created_at title permalink is_active), params[:sort], (params[:order] ? params[:order] : 'DESC'), 'created_at', 'ASC'
    @pager = Paginator.new self, Page.count, 20, params[:page]
    @pages = Page.find(:all, :order => @sorter.to_sql, :limit => @pager.items_per_page, :offset => @pager.current.offset)
    $admin_page_title = 'Listing pages'
    render :template => 'admin/pages/page_list'
  end

  # create a new page
  def page_new
    @page     = Page.new
    $admin_page_title = 'New page'
    @onload   = "document.forms['page_form'].elements['page[permalink]'].focus()"
    render :template => 'admin/pages/page_new'
  end

  # save a new page
  def page_create
    # let's create our new post
    @page = Page.new(params[:page])
    if @page.save
    # page was saved successfully
      flash[:notice] = 'Page was created.'
      if Preference.get_setting('RETURN_TO_PAGE') == 'yes'
      # if they have a pref set as such, return them to the page,
      # rather than the list
        redirect_to '/admin/pages/edit/' + @page.id.to_s
      else
        redirect_to '/admin/pages'
      end
    else
    # whoops!
      @preview  = (@page.body_raw ? @page.body_raw: '')
      # remember the update checking if it's there
      @update_checker = session[:update_check_stored] if session[:update_check_stored] != nil
      render :action => 'page_new', :template => 'admin/pages/page_new'
    end
  end

  # load the page we're editing
  def page_edit
    @page     = Page.find(params[:id])
    @plink    = Post.permalink(@page)
    #@preview  = (@page.body ? @page.body : '')
    $admin_page_title = 'Editing page'
    @onload   = "document.forms['page_form'].elements['page[permalink]'].focus()"
    render :template => 'admin/pages/page_edit'
  end

  # update an existing page
  def page_update
    # find our post
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      # page was updated successfully
      flash[:notice] = 'Page was updated.'
      if Preference.get_setting('RETURN_TO_PAGE') == 'yes'
      # if they have a pref set as such, return them to the page,
      # rather than the list
        redirect_to '/admin/pages/edit/' + @page.id.to_s
      else
        redirect_to '/admin/pages'
      end
    else
      # whoops!
      #@preview  = (@page.body_raw ? @page.body_raw: '')
      # remember the update checking if it's there
      @update_checker = session[:update_check_stored] if session[:update_check_stored] != nil
      render :action => 'page_edit', :template => 'admin/pages/page_edit'
    end
  end

  def page_destroy
    Page.find(params[:id]).destroy
    flash[:notice] = 'Page was destroyed.'  
    if session[:was_searching]
    # they came from somewhere, let's send them back there
      session[:was_searching] = nil
      q = session[:prev_search_string]
      session[:prev_search_string] = nil
      redirect_to '/admin/pages/search?q=' + q
    else
    # not sure where they came from, just send them to normal place
      redirect_to '/admin/pages'
    end
  end
  
  # search for pages
  def page_search
    session[:was_searching] = 1
    session[:prev_search_string] = params[:q]
    @pages = Page.find_by_string(params[:q], 20, false)
    $admin_page_title = 'Search results'
    render :template => 'admin/pages/page_search'
  end
  
  # update the permalink and preview it
  def page_permalink
    render :text => Post.to_permalink(params[:value])
  end
  
end


