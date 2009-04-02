# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.

# Caching
config.action_controller.perform_caching = false
config.cache_classes = false
###config.action_controller.perform_caching = true
###config.cache_classes = true

# Logging
config.whiny_nils = true
config.action_mailer.raise_delivery_errors = false # Don't care if the mailer can't send

# Other
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs = true


require 'bluecloth/lib/bluecloth' # for markdown filtering
require 'rubypants'               # nice quotes, dashes, etc (smartypants)