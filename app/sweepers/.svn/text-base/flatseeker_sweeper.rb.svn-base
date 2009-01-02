class FlatseekerSweeper < ActionController::Caching::Sweeper
  observe Flatseeker
  
  #if a flatseeker advert is updated then we need to flush that fragment cache
  def after_update(flatseeker)
    expire_flatseeker_cache(flatseeker)
  end
  
  def after_create(flatseeker)
    expire_flatseeker_cache(flatseeker)
  end
  
  private
  def expire_flatseeker_cache(flatseeker)
    expire_fragment(:controller => 'flatseeker', :action =>'view', :id => flatseeker.id, :part => 'rich_attr')
    expire_fragment(:controller => 'flatseeker', :action =>'view', :id => flatseeker.id, :part => 'pictures')
    expire_fragment(:controller => 'user', :action => 'index', :id => flatseeker.user_id, :part => 'advert')
    expire_fragment(:controller => 'user', :action => 'edit_advert', :id => flatseeker.id, :part => 'pictures')
    expire_fragment(:controller => 'user', :action =>'view', :id => flatseeker.id, :part => 'rich_attr')
    expire_fragment(:controller => 'user', :action =>'view', :id => flatseeker.id, :part => 'pictures')
    expire_fragment(%r{[0-9].part=matching_adverts.cache})
    
    expire_page(:controller => 'user', :action => 'view_advert', :id => flatseeker.id)
  end
end