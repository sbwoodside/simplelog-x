# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_simplelog_sbwoodside',
  :secret      => '6c911fb0ff3e81c876f86a3c607ab66f86a07c848d561fd09ce4fb0b71fe8ebdc67309424eca5040602587e6b3ec727a60b30a29e858e936f553c5de536b1fec'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
