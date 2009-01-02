class Batch < ActiveRecord::Base
  #this model will hold all the batch jobs that the application needs to run
  #these jobs are kicked off by the script/runner and cron
  
  def self.new_matching_adverts
    #this job will loop through all the users and check for any new matching adverts and send a mail with each matching adverts details in
    #this should be run every day
    logger.debug "***** new_matching_adverts *****"
  
    User.find(:all).each do |user|
      matches = Array.new
      if user.has_advert
        adverts = user.get_advert.matching_adverts
        adverts.each do |advert|
          if advert.is_new
            matches << advert
          end
        end
        email = UserMailer.deliver_matching_adverts(user, matches) unless matches.empty?
        logger.debug email
      end
    end
  end
  
  def self.send_advert_notice
    #this job will loop through all the flags and send an email to the owners of adverts that have been flagged too many times
    #this needs to be ran daily
    logger.debug "***** send_advert_notice *****"
    
    bad_user = User.find_by_sql("SELECT adverts.id AS advert_id, users.* FROM adverts, flags, users WHERE flags.advert_id = adverts.id AND flags.flag_type = 'Inaccurate' AND users.id = adverts.user_id AND flags.handled = false GROUP BY advert_id HAVING count(*) > 1;")
    bad_user.each do |usr|
      flags = Flag.find(:all, :conditions => ["advert_id =?", usr[:advert_id]])
      
      #send email to advert owner
      usr_email = UserMailer.deliver_advert_innacurate_warning(flags, usr)
      logger.debug usr_email
            
      #send email to admin
      advert = Advert.find(usr[:advert_id])
      admin_email = UserMailer.deliver_advert_innacurate_admin(advert, usr)
      logger.debug admin_email
      
      #quarantine the advert
      advert.place_in_quarantine
      
      #mark each flag as being dealt with so that the user doesn't get sent a message twice
      flags.each do |flag|
        flag.update_attribute(:handled, true)
      end
    end
  end

  def self.stale_advert_check
    #this batch job will send an email to owners of adverts that are more than two weeks old but younger than 4 weeks old
    #this needs to be run once a week
    Advert.find(:all, :conditions => ["created_at < '#{Time.now - 14 * (60 * 60 * 24)}' AND created_at > '#{Time.now - 28 * (60 * 60 * 24)}'"]).each do |advert|
      UserMailer.deliver_stale_advert(User.find(advert.user_id))
    end
  end
  
  def self.remove_stale_sessions
    #this batch job clears out the sessions that are older than 30 mins
    #this job needs every 15 mins
    CGI::Session::ActiveRecordStore::Session.destroy_all( ['updated_at <?', 30.minutes.ago] ) 
  end
  
  def self.refresh_welcome_page
    #this batch job will expire the welcome page cache periodically
    #this job needs running every 2 hours
    require 'open-uri'
    ActionController::Base::expire_page('/')
    #uncomment the line below when live to regenerate the cache
    #open("http://londonflatmate.net")
  end
end
