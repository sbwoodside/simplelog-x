# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.15' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')


Rails::Initializer.run do |config|
  # Specify gems that this application depends on.
  # They can then be installed with "rake gems:install" on new installations and frozen with rake gems:unpack
  # You have to specify the :lib option for libraries, where the Gem name (sqlite3-ruby) differs from the file itself (sqlite3)
  #config.gem "rspec",            :lib => false
  #config.gem "rspec-rails",      :lib => false
  #config.gem "remarkable_rails", :lib => false
  #config.gem "has_many_polymorphs", :version => "1.13"

  # Settings in config/environments/* take precedence over those specified here

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc

  # see http://www.fngtps.com/2006/01/lazy-sweeping-the-rails-page-cache
  #config.action_controller.page_cache_directory = RAILS_ROOT+"/public/cache/"
end

# Include your application configuration below
# TODO probably some or all of this should be moved elsewhere

# Some storage for application-wide stuff and constants
SL_CONFIG = Hash.new
#@@stored_prefs = Hash.new
@@stored_blacklist = Array.new

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
#require 'server.rb'

# Some required stuff (there are additional requires in the environment sub files)
require 'htmlentities'  # useful string extension
require 'cgi'           # we use this in places
require 'digest/sha1'   # for password hashing
require 'digest/md5'    # for creating MD5 hashes (gravatar)
#require 'redcloth'      # for textile support
require 'tagging_extensions'
require 'bluecloth/lib/bluecloth' # for markdown filtering
require 'rubypants'               # nice quotes, dashes, etc (smartypants)

#require 'has_many_polymorphs'