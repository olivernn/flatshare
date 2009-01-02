class Flatseeker < Advert
  acts_as_favorite
  #has_and_belongs_to_many :rich_attributes
    
  def self.search(search_params)
    page = search_params[:page]
    search_params[:rent] ||= search_params[:flatseeker][:rent]
    search_params[:area] ||= search_params[:flatseeker][:area]
    if search_params[:rent]
      if search_params[:area]
        #search using area and maximum rent
        #query.area(search_params[:area]).rent_lt(search_params[:rent]).find
        paginate(:per_page => 5, :page => page, :conditions =>[ 'area =? AND rent >=? AND quarantine = false', search_params[:area], search_params[:rent]], :order => 'created_at DESC')
      else
        #search using maximum rent
        #query.rent_lt(search_params[:rent]).find
        paginate(:per_page => 5, :page => page, :conditions =>[ 'rent >=? AND quarantine = false', search_params[:rent]], :order => 'created_at DESC')
      end
    else
      if search_params[:area]
        #search using area
        #query.area_eq(search_params[:area]).find
        paginate(:per_page => 5, :page => page, :conditions =>[ 'area =? AND quarantine = false', search_params[:area]], :order => 'created_at DESC')
      else
        false
      end
    end
  end
  
  def matching_adverts
    two_weeks_ago = Time.now - 14 * (60 * 60 * 24)
    if self.couples
      Flatshare.find(:all, :conditions => ['rent <= ? AND area =? AND room_type =? AND couples = TRUE AND quarantine = false AND created_at >?', self.rent, self.area, self.room_type, two_weeks_ago], :order => 'created_at DESC', :limit => 15)
    else
      Flatshare.find(:all, :conditions => ['rent <= ? AND area =? AND room_type =? AND quarantine = false AND created_at >?', self.rent, self.area, self.room_type, two_weeks_ago], :order => 'created_at DESC', :limit => 15)
    end
  end
     
  def monthly_rent
    self.rent
  end
  
  def weekly_rent
    (self.rent*12)/52
  end
end
