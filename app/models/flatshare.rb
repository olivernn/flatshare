class Flatshare < Advert
  acts_as_mappable :auto_geocode => {:field => :postcode, :error_message => 'Unable to geocode postcode'}
  acts_as_favorite
  
  # not implemented yet, this will auto detect the area from the response of the geocode call
  #before_create :geocode_postcode
  
  #has_and_belongs_to_many :rich_attributes

  #validations                                            
  validates_numericality_of :bills, :housemates, :deposit
  validates_presence_of :postcode, :bills, :deposit
  validates_as_uk_postcode :postcode
  
  def self.find_current
    find(:all, :conditions => ['created_at >?', 14.days.ago])
  end
  
  def nearest_stations
    Station.find(:all, :origin =>[self.lat, self.lng], :order =>"distance asc", :limit => 5)
  end
    
  def self.filter_by_distance(search_params)
    unless search_params[:station].empty?
      unless search_params[:distance].empty?
        @search_station = Station.find(:all, :condition => 'name = ?"' + search_params + '"')
        if @search_station
          find(:all, :origin => [@search_station.lat, @search_station.lng], :conditions => 'distance <?' + search_params[:distance])
        end
      end
    end
  end
  
  def self.search(search_params)
    two_weeks_ago = Time.now - 14 * (60 * 60 * 24)
    area = Area.interpret(search_params[:area])
    if search_params[:max_rent]
      if area
        if search_params[:station]
          #search using maximum rent, area and distance to station
          station = Station.find_by_name(search_params[:station])
          if station
            find(:all, :origin => [station.lat, station.lng], :conditions => ['distance <? AND area IN (?) AND rent <? AND quarantine = false AND created_at >?', search_params[:distance][0,1], area, search_params[:max_rent], two_weeks_ago])
          else
            #query.area_eq(area).rent_lt(search_params[:max_rent]).quarantine_eq(0).created_at_gt(two_weeks_ago).find
            find(:all, :conditions => ['area IN(?) AND rent <? AND quarantine = false AND created_at >?', area, search_params[:max_rent], two_weeks_ago])
          end
        else
          #search using maximum rent and area
          #query.area_eq(area).rent_lt(search_params[:max_rent]).quarantine_eq(0).created_at_gt(two_weeks_ago).find
          find(:all, :conditions => ['area IN(?) AND rent <? AND quarantine = false AND created_at >?', area, search_params[:max_rent], two_weeks_ago])
        end
      else
        if search_params[:station]
          #search using maximum rent and distance to station
          station = Station.find_by_name(search_params[:station])
          if station
            find(:all, :origin => [station.lat, station.lng], :conditions => ['distance <? AND rent <? AND quarantine = false AND created_at >?', search_params[:distance][0,1], search_params[:max_rent], two_weeks_ago])
          else
            query.rent_lt(search_params[:max_rent]).quarantine_eq(0).created_at_gt(two_weeks_ago).find
          end
        else
          #search using maximum rent
          query.rent_lt(search_params[:max_rent]).quarantine_eq(0).created_at_gt(two_weeks_ago).find
        end
      end
    else
      if area
        if search_params[:station]
          #search using area and distance to station
          station = Station.find_by_name(search_params[:station])
          if station
            find(:all, :origin => [station.lat, station.lng], :conditions => ['distance <? AND area =? AND quarantine = false AND created_at >?', search_params[:distance][0,1], area, two_weeks_ago])
          else
            #query.area_eq(area).quarantine_eq(0).created_at_gt(two_weeks_ago).find
            find(:all, :conditions => ['area in(?) AND quarantine = false AND created_at >?', area, two_weeks_ago])
          end
        else
          #search using area
          #query.area_eq(area).quarantine_eq(0).created_at_gt(two_weeks_ago).find
          find(:all, :conditions => ['area IN (?)', area])
        end
      else
        if search_params[:station]
          #search using distance to station
          station = Station.find_by_name(search_params[:station])
          find(:all, :origin => [station.lat, station.lng], :conditions => ['distance <? AND quarantine = false AND created_at >?', search_params[:distance][0,1], two_weeks_ago]) if station
        end
      end
    end
  end
  
  def matching_adverts
    two_weeks_ago = Time.now - 14 * (60 * 60 * 24)
    if self.couples
      Flatseeker.find(:all, :conditions => ['rent >= ? AND area =? AND room_type =?  AND quarantine = false AND created_at >?', self.rent, self.area, self.room_type, two_weeks_ago], :order => 'created_at DESC', :limit => 15)
    else
      Flatseeker.find(:all, :conditions => ['rent >= ? AND area =? AND room_type =? AND couples = FALSE AND quarantine = false AND created_at >?', self.rent, self.area, self.room_type, two_weeks_ago], :order => 'created_at DESC', :limit => 15)
    end
  end
  
  def local_places
    PlaceSearch.new(self.lat, self.lng).get_local_places
  end
  
  private
  def geocode_postcode
    loc = GeoKit::Geocoders::MultiGeocoder.geocode(self.postcode)
    if loc.success
      self.lat = loc.lat
      self.lng = loc.lng
      self.area = loc.area
      entered_area = Area.find_by_name(self.area)
      unless entered_area
        self.area = loc.city.split(",").first unless Area.find_by_name(self.area)
      else
        self.area = entered_area
      end
    else
      logger.info "geocoding failed"
    end
  end
end
