class SlideshowController < ApplicationController
  def advert
    image_urls = Array.new
    Advert.find(params[:id]).images.each do |image|
      image_urls << image.filename
    end
    render :partial => 'shared/slideshow', :locals => {:image_urls => image_urls}
  end
  
  def local
    local_pictures = Flickr.new(@flatshare.lat, @flatshare.lng, @flatshare.area, params[:flickr][:tags])
    advert = Advert.find(params[:id])
    local_pictures = Flickr.new(advert.lat, advert.lng, advert.area, params[:flickr][:tags])
    render :partial => 'shared/slideshow', :locals => {:image_urls => image_urls}
  end
end