class RichAttribute < ActiveRecord::Base
  has_and_belongs_to_many :flatshares
  has_and_belongs_to_many :flatseekers
  has_and_belongs_to_many :adverts
  validates_presence_of :name
  
  attr_accessor :selected
  
end
