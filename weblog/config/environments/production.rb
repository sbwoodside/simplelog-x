# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests

# Caching
config.action_controller.perform_caching = true
config.cache_classes = true

# Logging
###config.logger = nil

# Other
config.action_controller.consider_all_requests_local = false

require 'bluecloth/lib/bluecloth' # for markdown filtering
require 'rubypants'               # nice quotes, dashes, etc (smartypants)