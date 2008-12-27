# This software is licensed under GPL v2 or later. See doc/LICENSE for details.

# The Tag model. This model is automatically generated and added to your app if you run the tagging generator
# included with has_many_polymorphs.

class Tag < ActiveRecord::Base

  DELIMITER = " " # Controls how to split and join tagnames from strings. You may need to change the <tt>validates_format_of parameters</tt> if you change this.

  # If database speed becomes an issue, you could remove these validations and rescue the ActiveRecord database constraint errors instead.
  validates_presence_of :name
  validates_uniqueness_of :name, :case_sensitive => false
  
  # Change this validation if you need more complex tag names.
  validates_format_of :name, :with => /^[a-zA-Z0-9\_\-]+$/, :message => "can not contain special characters"
  
  # Set up the polymorphic relationship.
  has_many_polymorphs :taggables, 
    :from => [:posts, :pages], 
    :through => :taggings, 
    :dependent => :destroy,
    :skip_duplicates => false, 
    :parent_extend => proc {
      # Defined on the taggable models, not on Tag itself. Return the tagnames associated with this record as a string.
      def to_s
        self.map(&:name).sort.join(Tag::DELIMITER)
      end
    }
    
  # Callback to strip extra spaces from the tagname before saving it. If you allow tags to be renamed later, you might want to use the <tt>before_save</tt> callback instead.
  def before_create
    self.name = self.name.gsub(' ', '').gsub("'", '').gsub(/[^a-zA-Z0-9 ]/, '')
    #self.name = name.downcase.strip.squeeze(" ")
  end
  
  # Tag::Error class. Raised by ActiveRecord::Base::TaggingExtensions if something goes wrong.
  class Error < StandardError
  end

  #TODO maybe restore this?
  #def self.find_by_string(str, limit = 20)
  #  # use plain old SQL to find this, it's not that complicated
  #  results = Tag.find(:all, {:select => 'tags.id, tags.name, count(posts_tags.tag_id) as post_count', :joins => 'left outer join posts_tags on tags.id = posts_tags.tag_id', :group => 'tags.id, tags.name', :conditions => ['name like ?', '%' + str + '%'], :limit => limit})
  #  return results
  #end
end
