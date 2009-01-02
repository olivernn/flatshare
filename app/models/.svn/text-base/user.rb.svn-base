require 'digest/sha1'

class User < ActiveRecord::Base 
  acts_as_favorite_user
  
  has_many :adverts
  has_many :messages
  has_many :flatshares
  has_many :flatseekers
  has_many :places
  has_many :flags
  
  validates_presence_of :first_name, :second_name, :email
  #validates_numericality_of :contact_number
  validates_format_of :contact_number,
     :with => /^((\(?0\d{4}\)?\s?\d{3}\s?\d{3})|(\(?0\d{3}\)?\s?\d{3}\s?\d{4})|(\(?0\d{2}\)?\s?\d{4}\s?\d{4}))(\s?\#(\d{4}|\d{3}))?$/i
  
  validates_uniqueness_of :email
  validates_format_of :email,
     :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
     :message => 'please enter a valid email address'
  
  validates_length_of :password, :minimum => 6, 
                      :message => "password must be at least 6 characters long",
                      :if => :password
  
  validates_confirmation_of :password
  
  validates_acceptance_of :terms_and_conditions
  
  attr_accessor :password_confirmation, :current_password, :terms_and_conditions
  attr_protected :authority
  
  def before_validation
    self.contact_number.gsub!(/[ ]/, '') unless self.contact_number.blank?
  end
  
  def validate
    errors.add_to_base("Missing password") if hashed_password.blank?
  end
  
  def full_name
    [first_name, second_name].join(' ')
  end
  
  def count_unread_messages
    self.messages.find_unread.size
  end
  
  def has_favourites
    Favorite.exists?(:user_id => self.id)
  end
  
  def has_advert
    Advert.exists?(:user_id => self.id)
  end
  
  def get_advert
    self.adverts.find(:first)
  end
  
  def has_flatshare_advert
    !self.flatshares.empty?
  end
    
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
  def self.authenticate(email, password)
    user = self.find_by_email(email)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end
    
  def generate_new_password(pwd)
    create_new_salt
    self.hashed_password = User.encrypted_password(pwd, self.salt)
  end
  
  def get_favourites
    Advert.find(:all, :joins => "INNER JOIN favorites ON favorites.favorable_id = adverts.id", :select => "adverts.*", :conditions => ["favorites.user_id =?", self.id])
  end
      
  private
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt # wibble makes this harder to guess
    Digest::SHA1.hexdigest(string_to_hash)
  end
  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  
  def valid_email?
    TMail::Address.parse(self.email)
  rescue
    errors.add_to_base("Must be a valid email")
  end
end
