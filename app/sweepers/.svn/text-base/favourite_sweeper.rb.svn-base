class FavouriteSweeper < ActionController::Caching::Sweeper
  observe Favorite
  
  #if a flatshare advert is updated then we need to flush that fragment cache
  def after_update(favourite)
    expire_favourite_cache(favourite)
  end
  
  def after_create(favourite)
    expire_favourite_cache(favourite)
  end
  
  def after_destroy(favourite)
    expire_favourite_cache(favourite)
  end
  
  private
  def expire_favourite_cache(favourite)
    expire_fragment(:controller => 'user', :action => 'index', :id => favourite.user_id, :part => 'favourite_adverts')
  end
end