# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

class Admin::PrefsController < Admin::BaseController
  
  # monitor prefs errors for use later
  def record_pref_err(nice_name = '', name = '', error = '')
    return Hash['nice_name' => nice_name, 'name' => name, 'error' => error]
  end
  
  # remove the http:// from URLs if necessary
  def strip_http(url = '')
    return url.gsub('http://', '')
  end
  
  # get prefs list
  def prefs_list
    sql = "DELETE FROM sessions" # clear the sessions table
    ActiveRecord::Base.connection.execute(sql)
    @prefs_hash = Hash[ Preference.find(:all).map { |p| [ p.name , { 'nice_name' => p.nice_name, 'description' => p.description, 'value' => p.value } ] } ]
    $admin_page_title = 'Preferences'
    if session[:was_on_tab] # switch to correct tab
      @onload = "swapTab('#{session[:was_on_tab]}')"
      session[:was_on_tab] = nil
    else
      @onload = "document.forms['prefs_form'].elements['preferences[domain]'].focus()"
    end
    render :template => 'admin/prefs/prefs_list'
  end
  
  # TODO isn't it a bit odd to have a database of prefs but hardcode the checks?
  def prefs_save
    # worry about errors here, assume we have none to start
    @write_errors = false
    # blank array to store them
    @errors_list = []
    if !params[:preferences]['domain'] or params[:preferences]['domain'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Domain', 'domain', 'cannot be blank. [<a href="#" onclick="swapTab(\'site_details\')" title="Show the Site Details tab">Site details</a>]')
    end
    if !params[:preferences]['site_name'] or params[:preferences]['site_name'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Site name', 'site_name', 'cannot be blank. [<a href="#" onclick="swapTab(\'site_details\')" title="Show the Site Details tab">Site details</a>]')
    end
    if !params[:preferences]['site_primary_author'] or params[:preferences]['site_primary_author'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Site owner', 'site_primary_author', 'cannot be blank. [<a href="#" onclick="swapTab(\'site_details\')" title="Show the Site Details tab">Site details</a>]')
    end
    if !params[:preferences]['author_email'] or params[:preferences]['author_email'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Owner email', 'author_email', 'cannot be blank. [<a href="#" onclick="swapTab(\'site_details\')" title="Show the Site Details tab">Site details</a>]')
    end
    if !params[:preferences]['items_on_index'] or params[:preferences]['items_on_index'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Items on index', 'items_on_index', 'cannot be blank. [<a href="#" onclick="swapTab(\'display_settings\')" title="Show the Display tab">Display</a>]')
    elsif params[:preferences]['items_on_index'].gsub(/[^0-9]/, '') == ''
      @errors_list[@errors_list.length] = record_pref_err('Items on index', 'items_on_index', 'must be a number. [<a href="#" onclick="swapTab(\'display_settings\')" title="Show the Display tab">Display</a>]')
    end
    if !params[:preferences]['items_in_feed'] or params[:preferences]['items_in_feed'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Items in feed', 'items_in_feed', 'cannot be blank. [<a href="#" onclick="swapTab(\'display_settings\')" title="Show the Display tab">Display</a>]')
    elsif params[:preferences]['items_in_feed'].gsub(/[^0-9]/, '') == ''
      @errors_list[@errors_list.length] = record_pref_err('Items in feed', 'items_in_feed', 'must be a number. [<a href="#" onclick="swapTab(\'display_settings\')" title="Show the Display tab">Display</a>]')
    end
    if !params[:preferences]['search_results'] or params[:preferences]['search_results'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Items in quicksearch', 'search_results', 'cannot be blank. [<a href="#" onclick="swapTab(\'display_settings\')" title="Show the Display tab">Display</a>]')
    elsif params[:preferences]['search_results'].gsub(/[^0-9]/, '') == ''
      @errors_list[@errors_list.length] = record_pref_err('Items in quicksearch', 'search_results', 'must be a number. [<a href="#" onclick="swapTab(\'display_settings\')" title="Show the Display tab">Display</a>]')
    end
    if !params[:preferences]['search_results_full'] or params[:preferences]['search_results_full'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Items in full seach', 'search_results_full', 'cannot be blank. [<a href="#" onclick="swapTab(\'display_settings\')" title="Show the Display tab">Display</a>]')
    elsif params[:preferences]['search_results_full'].gsub(/[^0-9]/, '') == ''
      @errors_list[@errors_list.length] = record_pref_err('Items in full search', 'search_results_full', 'must be a number. [<a href="#" onclick="swapTab(\'display_settings\')" title="Show the Display tab">Display</a>]')
    end
    if !params[:preferences]['time_format'] or params[:preferences]['time_format'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Time format', 'time_format', 'cannot be blank. [<a href="#" onclick="swapTab(\'display_settings\')" title="Show the Display tab">Display</a>]')
    end
    if !params[:preferences]['date_format'] or params[:preferences]['date_format'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Date format', 'date_format', 'cannot be blank. [<a href="#" onclick="swapTab(\'display_settings\')" title="Show the Display tab">Display</a>]')
    end
    if !params[:preferences]['language'] or params[:preferences]['language'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Language', 'language', 'cannot be blank. [<a href="#" onclick="swapTab(\'advanced_settings\')" title="Show the Advanced tab">Advanced</a>]')
    end
    if !params[:preferences]['extended_link_text'] or params[:preferences]['extended_link_text'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Extended link text', 'extended_link_text', 'cannot be blank. [<a href="#" onclick="swapTab(\'content_settings\')" title="Show the Content tab">Content</a>]')
    end
    if !params[:preferences]['copyright_year'] or params[:preferences]['copyright_year'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Copyright year', 'copyright_year', 'cannot be blank. [<a href="#" onclick="swapTab(\'meta_information\')" title="Show the Meta Info tab">Meta Info</a>]')
    end
    if !params[:preferences]['email_subject'] or params[:preferences]['email_subject'] == ''
      @errors_list[@errors_list.length] = record_pref_err('Email subject', 'email_subject', 'cannot be blank. [<a href="#" onclick="swapTab(\'meta_information\')" title="Show the Meta Info tab">Meta Info</a>]')
    end
    # check if we have any
    @write_errors = true if @errors_list.length > 0
    
    # we'll check for errors
    errors = false
    # loop through the preferences
    params[:preferences].each do |key, value|
      if key == 'search_results' or key == 'items_on_index' or key == 'items_in_feed'
      # make sure some values are non-negative numbers
        value = value.to_i.abs.to_s
      end
      if key == 'domain' or key == 'rss_url'
        value = strip_http(value)
      end
      if key == 'domain'
        value = (value[-1, 1] == '/' ? value[0, value.length-1] : value)
      end
      # find them in the db
      pref = Preference.find(:first, :conditions => ['name = ?', key])
      if pref
      # found it, save it
        pref.value = value
        if !pref.save
        # there was an error
          errors = true
        end
      end
    end
    
    # unset prefs hash
    Preference.clear_hash
    
    if @write_errors
    # if we have errors, let's show the list again with pretty Rails-style error message
      prefs_list
      return
    else
      # remember which tab they were on
      session[:was_on_tab] = params[:current_tab]
      if !errors
      # preferences saved successfully
        flash[:notice] = '<b>Success:</b> Preferences were saved.'
        redirect_to '/admin/prefs'
      else
      # we had ACTUAL errors, as in we couldn't save data for some reason
        flash[:notice] = '<span class="red"><b>Failed:</b> Some of your preferences could not be saved. Please try again.</span>'
        redirect_to '/admin/prefs'
      end
    end
  end
  
  
end

