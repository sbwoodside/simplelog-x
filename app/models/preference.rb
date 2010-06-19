# This software is licensed under GPL v2 or later. See doc/LICENSE for details.

class Preference < ActiveRecord::Base
  
  #
  # this model simply retrieves and sets preference values from the db
  #
  
  # get a preference value
  def self.get_setting(name)
    # drop the case
    name = name.downcase
    # check for it
    @@stored_prefs ||= Hash.new # create it if it's not initialized yet
    if !@@stored_prefs[name]
      #logger.warn("WE ARE HITTING DB FOR: #{name.downcase} (cache length: #{@@stored_prefs.length.to_s})")
      #logger.warn("CURRENT CACHE: #{@@stored_prefs.inspect}")
      result = Preference.find(:first, :conditions => ['name = ?', name])
      if result
        # we found our preference, return the value
        @@stored_prefs[name] = result.value    
        return result.value
      end
      # if we've got nothing, let's return an empty string
      @@stored_prefs[name] = ''
    else
      return @@stored_prefs[name]
    end
  end
  
  # clear the local cached version of prefs (user submitted prefs save or asked
  # us to clear the cache)
  def self.clear_hash
    @@stored_prefs.clear
  end
  
  # set a preference to a value
  def self.set_setting(name, value)
    # drop the case
    name = name.downcase
    # find it
    pref = Preference.find(:first, :conditions => ['name = ?', name])
    if pref
      pref.update_attribute('value', value)
      # update the preference cache
      @@stored_prefs[name] = value
    end
  end
  
end