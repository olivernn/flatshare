class Flag < ActiveRecord::Base
  belongs_to :advert
  belongs_to :user
  
  validates_presence_of :flag_comment
  
  def before_create
    #dont want the same person flaggin the same advert loads of times
    if Flag.exists?(["user_id =? AND advert_id =? AND flag_type =?", self.user_id, self.advert_id, self.flag_type])
      false
    end
  end
  
  def self.get_inaccurate_adverts
    find(:all, :conditions)
  end
end

#below is the query needed to get all the users with an advert with too many
#SELECT users.* FROM adverts, flags, users WHERE flags.advert_id = adverts.id AND flags.flag_type = 'Inaccurate' AND users.id = adverts.user_id GROUP BY advert_id HAVING count(*) > 3
