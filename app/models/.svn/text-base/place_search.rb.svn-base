class PlaceSearch
  require 'hpricot'
  require 'open-uri'
  
  attr_accessor :lat, :lng, :key
  
  def initialize(lat, lng)
    @lat = lat
    @lng = lng
    @key = "d4d1b39b8e2ccde70a054cfc32b374a8"
  end
  
  def get_local_places
    places = Array.new
    begin
      response = open(create_request) { |f| Hpricot(f) }
      response.search("//place").each do |p|
        places << create_place(p)
      end
      places
    #this should catch a timeout error and stop everything blowing up
    rescue StandardError, Interrupt
      nil
    end
  end
  
  private
  def create_request
    "http://trustedplaces.com/api/rest/place/geo/?lng=#{self.lng}&lat=#{self.lat}&rad=500&key=#{self.key}"
  end
  
  def create_place(place)
    Place.new(place.search("//name").inner_html,
              place.search("//address").inner_html,
              place.search("//rating").inner_html,
              place.search("//description").inner_html,
              place.search("//url").inner_html,
              place.search("//category").inner_html,
              place.search("//id").inner_html)
  end
end
