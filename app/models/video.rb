class Video < ActiveRecord::Base
  require "sesamevault_api.rb"
  belongs_to :advert
  
  def filename=(upload_file)
    base_part_of(upload_file.original_filename)
  end
  
  def create_new_session
    SesameVault::Session.new("olivern", "computer")
  end
end