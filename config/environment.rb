# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Some storage for application-wide stuff and constants
SL_CONFIG = Hash.new
@@stored_prefs = Hash.new
@@stored_blacklist = Array.new

Rails::Initializer.run do |config|
  # Use the database for sessions instead of the file system
  config.action_controller.session_store = :active_record_store
  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  # Use Active Record's schema dumper instead of SQL when creating the test database
  config.active_record.schema_format = :ruby
  # see http://www.fngtps.com/2006/01/lazy-sweeping-the-rails-page-cache
  config.action_controller.page_cache_directory = RAILS_ROOT+"/public/cache/"
end

##################################################################
# Don't change anything below this line! Seriously!              #
##################################################################

  # Logging settings (warnings only, otherwise logs get REALLY big)
  #RAILS_DEFAULT_LOGGER.level = Logger::WARN

  # SimpleLog version
  SL_CONFIG[:VERSION] = '2.0.2'
  # Where to check for updates
  SL_CONFIG[:UPDATES_URL] = 'simplelog.net/updates/version.xml'
  # Where to get the blacklist
  SL_CONFIG[:BLACKLIST_URL] = 'simplelog.net/blacklist/current/'
  # Used in cookies
  SL_CONFIG[:USER_EMAIL_COOKIE] = '_sl_email'
  SL_CONFIG[:USER_HASH_COOKIE] = '_sl_hash'
  
  # we load our site's config now
  require 'server.rb'

  # Some required stuff (there are additional requires in the environment sub files)
  require 'htmlentities'  # useful string extension
  require 'cgi'           # we use this in places
  require 'digest/sha1'   # for password hashing
  require 'digest/md5'    # for creating MD5 hashes (gravatar)
  require 'redcloth'      # for textile support
  require 'tagging_extensions'
