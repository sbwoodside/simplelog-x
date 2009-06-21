# This software is licensed under GPL v2 or later. See doc/LICENSE for details.

class Blacklist < ActiveRecord::Base
  
  #
  # useful for blocking different types of comments
  #
  
  # table name (no plural here)
  set_table_name 'blacklist'
  
  # validations
  validates_presence_of :item
  
  # before we create, let's set the creation date
  def before_create
    # set the time
    self.created_at = Time.sl_local
  end
  
  # returns the cache
  def self.cache
    return @@stored_blacklist
  end
  
  # add an item to the cached array
  def self.add_to_cache(item)
    @@stored_blacklist << item
  end
  
  # remove an item from the cached array
  def self.delete_from_cache(item)
    for i in self.cache
      if i.item == item.item
      # we found the item, delete it
        @@stored_blacklist.delete(i)
      end
    end
  end
  
  # clear the local cached version of the blacklist (user submitted new blacklist
  # items or removed others)
  def self.clear_cache
    @@stored_blacklist.clear
  end
    
end