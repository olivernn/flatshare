class Advert < ActiveRecord::Base  
  belongs_to :user
  has_many :pictures
  has_many :images
  has_many :quarantines
  has_and_belongs_to_many :rich_attributes
  
  acts_as_favorite
  acts_as_textiled :description
  
  #validations
  validates_numericality_of :rent
  validates_presence_of :date_available, :headline
  validates_length_of :description, :minimum => 100, :too_short=>"please enter at least %d character"
  
  attr_accessor :rent_frequency, :bills_frequency
  
  def to_param
    "#{id}-#{CGI.escape(headline.gsub(' ', '-'))}"
  end
  
  # emergency fix applied to stop false positives for contact details
  #def validate
  #  [self.description, self.interests, self.headline].each do |field|
  #    if field =~ /\b[_a-zA-Z0-9-]+(\.[_a-zA-Z0-9-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*\.(([0-9]{1,3})|([a-zA-Z]{2,3})|(aero|coop|info|museum|name))\b/ || field =~ /\b0\d{2,4}[ -]{1}[\d]{3}[\d -]{1}[\d -]{1}[\d]{1,4}\b/ || field =~ /\b01|2|3|7\d\d\d\d\d\d\d\d\d\b/
  #      errors.add_to_base("Contact details are not allowed in the advert")
  #    end
  #  end
  #end
  
  def owner
    User.find(self.user_id)
  end
  
  def self.featurable
    find(:all, :joins => "INNER JOIN images ON images.advert_id = adverts.id", :select => 'DISTINCT adverts.*', :order => 'adverts.created_at ASC, adverts.views_counter ASC', :limit => 6)
  end
  
  def selected_rich_attributes
    ra = self.rich_attributes.find(:all)
    selected = Array.new
    ra.each do |atr|
      selected << atr.name
      selected << ','
    end
    selected.to_s.chop
  end
  
  def add_rich_attributes(attribute_list)
    attribute_list.gsub!(', ', ',')
    self.rich_attributes.clear
    attribute_list.split(",").each do |tag|
      advert_attribute = RichAttribute.find(:first, :conditions => ["name=?", tag.strip])
      unless advert_attribute
        advert_attribute = RichAttribute.create(:name => tag)
      end
      self.rich_attributes << advert_attribute
    end
  end
  
  def is_new
    !(self.created_at < (Time.now - (60 * 60 * 24))) #checks that the advert is not more than 24 hours old
  end
  
  #quarantines the advert, serialises it into the quarantine table
  def place_in_quarantine
    self.quarantines.create(:advert => self)
    self.update_attribute(:quarantine, true)
  end
  
  #can only unquarantine an advert if it has been changed
  def remove_from_quarantine
    original_advert = self.quarantines.find(:first, :order => 'created_at DESC').advert
    #need to check that something has changed
    if original_advert.description != self.description || original_advert.headline != self.headline || original_advert.room_type != self.room_type || original_advert.furnished != self.furnished || original_advert.couples != self.couples
      self.update_attribute(:quarantine, false)
      Quarantine.delete_all("advert_id = #{original_advert.id}")
      true
    else
      false
    end
  end
  
  #sets the created_on date to todays date
  def refresh
    self.update_attribute(:created_at, Time.now())
  end
  
  def refresh_applicable
    three_days_ago = Time.now - 3 * (60 * 60 * 24)
    self.created_at < three_days_ago
  end
  
  #get pictures near to the advert
  def local_photos
    xml = open("http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=b5d467685e70a84f79bc78f8d0953555&tags=battersea&sort=date-posted-desc&content_type=1&lat=51.4715810000&lon=-0.1682200000&radius=1&radius_units=km&extras=geo&per_page=20&page=1") { |f| Hpricot(f) }
  end
  
  def snippet
    wordcount = 35
    (self.description.split[0..(wordcount-1)].join(" ") + (self.description .split.size > wordcount ? "..." : "")).gsub(/<\/?[^>]*>/,  "")
  end
  
  def before_save
    if bills_frequency == "Weekly"
      self.bills = (self.bills * 52)/12
    end
    
    if rent_frequency == "Weekly"
      self.rent = (self.rent * 52)/12
    end
  end
end
