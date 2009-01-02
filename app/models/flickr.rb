class Flickr < ActiveRecord::Base
  require 'hpricot'
  require 'open-uri'
  require 'builder'
  
  attr_accessor :photo_urls, :lat, :lng, :area, :tags
  
  def initialize(lat, lng, area, tags)
    @lat = lat
    @lng = lng
    @area = area
    @tags = tags
    self.search
  end
  
  def search
    request = create_request({:tags => self.area, :lat => self.lat, :lon => self.lng, :tags => self.tags})
    response = open(request) { |f| Hpricot(f) }
    @photo_urls = create_photo_urls(response.search("//photo"))
  end
  
  def create_request(options)
    attributes = String.new
    options.merge(set_defaults(options)).each_pair do |name, value|
      attributes << "&#{name}=#{value}"
    end
    uri = "http://api.flickr.com/services/rest/?method=flickr.photos.search#{attributes}"
    logger.debug uri
    uri
  end

  def set_defaults(options)
    options[:lat] ||= self.lat
    options[:lon] ||= self.lng
    options[:radius] ||= 1
    options[:units] ||= 'km'
    options[:page] ||= 1
    options[:per_page] ||= 30
    #options[:group_id] ||= "95559002@N00"
    options[:accuracy] ||= 16
    options[:api_key] ||= "9d99560e74a2d5de9c7f9e3e1e0a0f9f"
    options[:sort] ||= "date-posted-desc"
    options[:content_type] ||= 1
    options[:tag_mode] ||= "any"
    options[:format] ||= "feed-rss_200"
    options[:tags] << "%2C+local%2C+street%2C+park%2C+outside" if options[:tags].empty?
    options
  end
  
  def create_photo_urls(photos)
    urls = Array.new
    logger.debug photos.size
    photos.each do |photo|
      urls << "http://farm#{photo.attributes['farm']}.static.flickr.com/#{photo.attributes['server']}/#{photo.attributes['id']}_#{photo.attributes['secret']}.jpg"
    end
    urls
  end
  
  def create_xspf
    xspf = Builder::XmlMarkup.new()
    xspf.instruct!
    xspf.playlist(:version => 1, :xmlns => "http://xspf.org/ns/0/") do
      xspf.trackList do
        self.photo_urls.each do |url|
          xspf.track do
            xspf.location url
          end
        end
      end
    end
  end
end