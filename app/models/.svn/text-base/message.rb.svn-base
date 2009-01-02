class Message < ActiveRecord::Base
  belongs_to :user
  
  validates_presence_of :subject, :message
  acts_as_textiled :message
  
  def self.find_unread
    find_all_by_read(false)
  end
  
  def senders_name
    User.find(self.from_id).full_name
  end
  
  def self.search(page)
      paginate :per_page => 10, :page => page, :order => 'created_at DESC'
  end
  
  def senders_advert
    Advert.find_by_user_id(self.from_id)
  end
  
  def after_create
    recipient = User.find(self.user_id)
    sender = User.find(self.from_id)
    email = UserMailer.deliver_message_received(recipient, self, sender)
    logger.debug email
  end
end
