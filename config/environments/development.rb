# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_controller.perform_caching             = false
config.action_view.cache_template_loading            = false
config.action_view.debug_rjs                         = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# EMAIL
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.logger = Rails.logger
ActionMailer::Base.raise_delivery_errors = true
# doesn't work config.action_mailer.default_url_options = { :host => "localhost:3000" }
ActionMailer::Base.smtp_settings = {
  :address        => 'smtp1.sympatico.ca', # for simon at least...
  :port           => '25',
  :authentication => :plain # :plain, :login or :cram_md5
}
