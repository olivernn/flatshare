class ImageSweeper < ActionController::Caching::Sweeper
  observe Image
  
  def after_update(image)
    expire_image_cache(image)
  end
  
  def after_create(image)
    expire_image_cache(image)
  end
  
  def after_destroy(image)
    expire_image_cache(image)
  end
  
  private
  def expire_image_cache(image)
    expire_fragment(:controller => 'user', :action => 'view', :id => image.advert_id, :part => 'pictures')
  end
end