# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

class Admin::TagsController < Admin::BaseController
  # Tags keep everything nice and organized (somewhat) and apply (at present) to posts and pages
  
  # strip quotes, spaces, special chars from tags
  def clean_tag(input)
    return nil if input.nil?
    input.gsub(' ', '').gsub("'", '').gsub(/[^a-zA-Z0-9 ]/, '')
  end
  
  # get a list of tags, paginated, with sorting
  def tag_list
    # grab the sorter
    @sorter = SortingHelper::Sorter.new self, %w(name post_count), params[:sort], params[:order], 'name', 'ASC'
    # grab the paginator
    @tag_pages = Paginator.new self, Tag.count, 20, params[:page]
    # grab the tags and get posts counts as well for sorting
    @tags = Tag.find(:all, :select => 'tags.id, tags.name, count(taggings.tag_id) as post_count', :joins => 'left outer join taggings on tags.id = taggings.tag_id', :group => 'tags.id, tags.name', :order => @sorter.to_sql, :limit => @tag_pages.items_per_page, :offset =>  @tag_pages.current.offset)
    $admin_page_title = 'Listing tags'
    render :template => 'admin/tags/tag_list'
  end
  
  # show posts tagged with this tag
  def tag_show
    @tag = Tag.find(params[:id])
    @posts = Post.find_by_tag(@tag.name, false)
    $admin_page_title = 'Showing posts tagged with "' + @tag.name + '"'
    render :template => 'admin/tags/tag_show'
  end

  # create a new tag
  def tag_new
    @tag = Tag.new
    $admin_page_title = 'New tag'
    @onload = "document.forms['tag_form'].elements['tag[name]'].focus()"
    render :template => 'admin/tags/tag_new'
  end
  
  # save a new tag (no spaces)
  def tag_create
    # let's create our new tag
    @tag = Tag.new(params[:tag])
    @tag.name = clean_tag(@tag.name)
    if @tag.save
      # tag was saved successfully
      flash[:notice] = 'Tag was created.'
      redirect_to '/admin/tags'
    else
      # whoops!
      # remember the update checking if it's there
      # TODO what the hell is this? checking for new version of simplelog?
      @update_checker = session[:update_check_stored] if session[:update_check_stored] != nil
      render :action => 'tag_new', :template => 'admin/tags/tag_new'
    end
  end

  # load the tag we're editing
  def tag_edit
    @tag = Tag.find(params[:id])
    @posts = Post.find_by_tag(@tag.name, false)
    @old_name = @tag.name
    $admin_page_title = 'Editing tag'
    @onload = "document.forms['tag_form'].elements['tag[name]'].focus()"
    render :template => 'admin/tags/tag_edit'
  end

  # update an existing tag
  # first we have to see if this tag has the same name as another, because if
  # it does, we're going to merge the two tags together with the name inputted.
  # so if someone has two tags: (1) red (2) blue and they go into red and change
  # its name to blue, we'll take all the posts tagged with red and tag them blue
  # and then delete the red tag.
  def tag_update
    old_tag_name = clean_tag params[:old_name] # it's possible this is nil!
    new_tag_name = clean_tag params[:tag][:name]
    old_tag = Tag.find :first, :conditions => ['name = ?', old_tag_name] # why doesn't Tag.find_by_name work?
    new_tag = Tag.find :first, :conditions => ['name = ?', new_tag_name]
    if old_tag_name == new_tag_name
      flash[:notice] = "You didn't change the name of the tag."
    elsif new_tag # collision!
      old_tag.taggables.each do |item|
        item.tags.delete old_tag # eliminate the old tag
        item.tags << new_tag # deals with duplicates internally
      end
      old_tag.destroy
      flash[:notice] = "Tag #{old_tag_name} was merged into existing tag #{new_tag_name}."
    else
      old_tag.name = new_tag_name
      old_tag.save!
      flash[:notice] = "Tag #{old_tag_name} was changed to #{new_tag_name}"
    end
    redirect_to '/admin/tags'
  end
  
  # destroy an existing tag! destroy! destroy! destroy!
  def tag_destroy
    Tag.find(params[:id]).destroy
    flash[:notice] = 'Tag was destroyed.'
    if session[:was_searching]
      # they came from somewhere, let's send them back there
      session[:was_searching] = nil
      q = session[:prev_search_string]
      session[:prev_search_string] = nil
      redirect_to '/admin/tags/search?q=' + q
    else
      # not sure where they came from, just send them to normal place
      redirect_to '/admin/tags'
    end
  end
  
  # search for tags
  def tag_search
    session[:was_searching] = 1
    session[:prev_search_string] = params[:q]
    @tags = Tag.find_by_string(params[:q], 20) #this will be broken now... umm... TODO fix.
    $admin_page_title = 'Search results'
    render :template => 'admin/tags/tag_search'
  end
  
end
