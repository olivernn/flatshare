class UserMailer < ActionMailer::Base
  
  def welcome(user)
    @subject = 'Welcome to LondonFlatmate.net'
    @body["user"] = user
    @recipients = user.email
    @from = 'app@LondonFlatshare.net'
    @sent_on = Time.now
    @headers = {}
  end
  
  def new_password(user, pwd)
    @subject = 'LondonFlatmate.net: password changed'
    @body["user"] = user
    @body["password"] = pwd
    @recipients = user.email
    @from = 'app@LondonFlatshare.net'
    @sent_on = Time.now
    @headers = {}
  end
  
  def payment_receipt(user)
    @subject = 'LondonFlatmate.net: Payment Received'
    @body["user"] = user
    @recipients = user.email
    @from = 'app@LondonFlatshare.net'
    @sent_on = Time.now
    @headers = {}
  end
  
  def message_received(user, message, sender)
    @subject = 'LondonFlatmate.net: Message received'
    @body["user"] = user
    @body["message"] = message
    @body["sender"] = sender
    @recipients = user.email
    @from = 'app@LondonFlatshare.net'
    @sent_on = Time.now
    @headers = {}
  end
  
  def send_to_friend(user, advert, comment, recipient)
    @subject = 'LondonFlatmate.net: Have a look at this'
    @body["user"] = user
    @body["advert"] = advert
    @body["comment"] = comment
    @recipients = recipient
    @from = 'app@LondonFlatshare.net'
    @sent_on = Time.now
    @headers = {}
  end
  
  def matching_adverts(user, adverts)
    @subject = 'LondonFlatmate.net: New matching adverts'
    @body["user"] = user
    @body["adverts"] = adverts
    @recipients = user.email
    @from = 'app@LondonFlatshare.net'
    @sent_on = Time.now
    @headers = {}
  end
  
  def advert_innacurate_warning(flags, user)
    @subject = 'LondonFlatmate.net: Innacurate Advert'
    @body["user"] = user
    @body["flags"] = flags
    @recipients = user[:email]
    @from = 'app@LondonFlatshare.net'
    @sent_on = Time.now
    @headers = {}
  end
  
  def advert_innacurate_admin(advert, user)
    @subject = 'LondonFlatmate.net: Innacurate Advert'
    @body["user"] = user
    @body["advert"] = advert
    @recipients = 'admin@LondonFlatshare.net'
    @from = 'app@LondonFlatshare.net'
    @sent_on = Time.now
    @headers = {}
  end
  
  def stale_advert(user)
    @subject = 'LondonFlatmate.net: Was your advert successful?'
    @body["user"] = user
    @recipients = user.email
    @from = 'app@LondonFlatshare.net'
    @sent_on = Time.now
    @headers = {}
  end
  
  def contact_mail(message, address)
    @subject = 'LondonFlatmate.net: Contact Form'
    @body["address"] = address
    @body["message"] = message
    @recipients = 'admin@LondonFlatmate.net'
    @from = 'app@LondonFlatshare.net'
    @sent_on = Time.now
    @headers = {}
  end
  
  def invitation(recipient)
    ActionMailer::Base.smtp_settings = {:address => "smtp.gmail.com",
    :port => 587,
    :authentication => :plain,
    :user_name => "oliver@londonflatmate.net",
    :password => 'computer'}
    
    @subject = 'LondonFlatmate.net Invitation'
    @recipients = recipient
    @from = 'oliver@londonflatmate.net'
    @sent_on = Time.now
    @headers = {}
  end
end
