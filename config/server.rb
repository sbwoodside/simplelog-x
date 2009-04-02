# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

##################################################################
# BE SURE TO RESTART YOUR WEB SERVER AFTER YOU MODIFY THIS FILE! #
##################################################################

# Are you using Dreamhost?
  SL_CONFIG[:DREAMHOST]     = 'no'  # (yes or no) are you deploying this app on a DH server? (see DH_README for details)
# Database type
  SL_CONFIG[:DB_TYPE_MYSQL] = 'yes' # (yes or no) are you using mysql as the database type?

# Set your mail configuration for comment notification (optional)
  ActionMailer::Base.smtp_settings = {
    :address        => '',
    :port           => 25, 
    :domain         => '',
    :user_name      => '',
    :password       => '',
    :authentication => :login
  }

  ActionMailer::Base.delivery_method = :sendmail
