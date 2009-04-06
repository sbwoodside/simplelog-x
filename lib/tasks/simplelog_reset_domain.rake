# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

#
# this rake task will reset the domain preference set in the DB
# and is useful in cases when you accidentally set it to the wrong
# value and don't want to have to connect to the DB itself
#

namespace :simplelog do

  namespace :reset do
    
    desc "Reset your domain preference to '', or pass new value with VALUE=X (ex: rake simplelog:reset:domain VALUE=mysite.com"
    task :domain => :environment do
      
      require 'preference'
      new_val = (ENV.include?('VALUE') ? ENV['VALUE'] : '')
      puts "Resetting domain preference to '#{new_val}'..."
      Preference.set_setting('domain', new_val)
      puts "Done!"
      # unset prefs hash
      Preference.clear_hash
      puts "Done! You might want to restart your application/server."
      
    end
    
  end
  
end