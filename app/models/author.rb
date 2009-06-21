# This software is licensed under GPL v2 or later. See doc/LICENSE for details.

class Author < ActiveRecord::Base
  
  # associations
  has_many :posts, :dependent => :destroy
  
  # accessors
  attr_accessor :password
  
  # validations
  validates_presence_of :name, :email
  validates_presence_of :password, :on => :create
  validates_format_of :email, :with => /^([0-9a-zA-Z]([-.\w]*[0-9a-zA-Z])*@(([0-9a-zA-Z])+([-\w]*[0-9a-zA-Z])*\.)+[a-zA-Z]{2,9})$/i, :message => 'must be a valid email address', :if => Proc.new { |author| author.email != '' }
  validates_uniqueness_of :email
  
  # prepends HTTP to a URL if necessary
  def self.prepend_http(url = '')
    if url and url != '' and not(url =~ /^http/i)
      url = 'http://' + url
    end
    return url
  end
  
  # hashes a password
  def self.do_password_hash(password = nil)
    Digest::SHA1.hexdigest(password) if password
  end
  
  def validate_on_update
    if self.password and self.password != ''
    # update the password if a new one was specified
      self.hashed_pass = Author.do_password_hash(self.password)
    end
  end
  
  def before_create
    # hash the pass before creating a author
    self.hashed_pass = Author.do_password_hash(self.password)
    # check the URL
    self.url = Author.prepend_http(url)
    # before an author is created, set its modification date to now
    self.modified_at = Time.sl_local
  end
  
  def before_update
    # check the URL
    self.url = Author.prepend_http(url)
  end
  
  # once we're done creating or updating, we need to trash our password accessor
  def after_create
    @password = nil
  end
  def after_update
    @password = nil
  end
  
  # get all authors sorted by name
  def self.get_all
    self.find(:all, :order => 'name asc')
  end
  
  # get all active authors sorted by name
  def self.get_all_active
    self.find(:all, :conditions => 'is_active = true', :order => 'name asc')
  end
  
  # authorize a author for access to the admin section and xmlrpc access
  def self.authorize(email, pass, do_hash = false, return_id = false)
    pass = (do_hash ? self.do_password_hash(pass) : pass)
    @author = Author.find(:first, :conditions => ['email = ? and hashed_pass = ? and is_active = true', email, pass])
    return (return_id ? @author : (@author ? true : false))
  end
  
end