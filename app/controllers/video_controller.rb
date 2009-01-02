class VideoController < ActiveResource::Base
  require "sesamevault_api.rb"
  require 'net/http'
  
  self.site = 'http://craigslist.com/ads'
  self.user = 'some_username'
  self.password = 'some_password'
  
  def new

  end
  
  def upload
    session = new_session
    upload_key = session.new_upload_key
    logger.debug upload_key
    upload_url = 'upload/new/file?upload_key=' + upload_key
    filename = 'myfile.mp4'
    upload_url = session.add_sig_to_url(upload_url, filename)
    upload_url = "http://www.sesamevault.com/" + upload_url
    logger.debug upload_url
    url = URI.parse(upload_url)
    logger.debug url
    post_args = { 'upload_file' => params[:upload_file] }
    resp, data = Net::HTTP.post_form(url, post_args)
    logger.debug resp
    
    # session.upload_progress(upload_key) do |progress|
    #   @status_received = progress[:status][:received]
    #   @status_size = progress[:status][:size]
    # end
  end
  
  private
  def new_session
    SesameVault::Session.new("olivern", "computer")
  end
end
