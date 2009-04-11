# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

require 'preference' # used to get preferences site-wide

class ApplicationController < ActionController::Base
  
  #
  # i <3 you, application controller. you do all the stuff that needs to be
  # done on the application layer (which isn't much in this case).
  #
  
  # nearly everything should use the post layout, except the admin section (which we'll deal with later)
  layout 'site' # TODO so why is this duplicated in so many other controllers?
  
  helper :site
  
  # we need to make sure the Site class has the application params on each load
  before_filter :load_params_and_req
  def load_params_and_req
    # send params to the Site class
    Site.get_params_and_req(params, request)
  end
  
  # in the case of an http error
  def handle_unknown_request
    $params = request.request_uri # the requested URI
    # we're still going to build the 'about' block, so let's get that data
    @posts = Post.find_current
    @tags = Tag.find(:all).map { |t| t.name }
    $page_title = Preference.get_setting('ERROR_PAGE_TITLE')
    @error = true # for use later
    puts "handle_unknown_request for #{request.request_uri}"
    render :template => 'errors/unknown_request', :status => 404
  end
  
  def display_404
    render :template => 'errors/unknown_request', :status => 404
  end
  
end


class Time #:nodoc:
  
  # extends Time to add a simplelog localtime object which uses preference-set
  # offset and the current server time to get the accurate user's time
  def self.sl_local
    return (Time.now+(Preference.get_setting('OFFSET').to_i*60*60)).getgm
  end
  
  # localize a timestamp to simplelog localtime
  def self.sl_localize(t)
    return (t+(Preference.get_setting('OFFSET').to_i*60*60)).getgm
  end
  
  # localized time in DB format
  def self.sl_local_db
    return Time.sl_local.strftime('%Y-%m-%d %H:%M%:S')
  end
  
end