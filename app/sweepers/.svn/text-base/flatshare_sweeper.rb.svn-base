class FlatshareSweeper < ActionController::Caching::Sweeper
  observe Flatshare
  
  #if a flatshare advert is updated then we need to flush that fragment cache
  def after_update(flatshare)
    expire_flatshare_cache(flatshare)
  end
  
  def after_create(flatshare)
    expire_flatshare_cache(flatshare)
  end
  
  def after_destroy(flatshare)
    expire_flatshare_cache(flatshare)
  end
  
  private
  def expire_flatshare_cache(flatshare)
    # expire fragments cached
    expire_fragment(:controller => 'flatshare', :action =>'view', :id => flatshare.id, :part => 'rich_attr')
    expire_fragment(:controller => 'flatshare', :action =>'view', :id => flatshare.id, :part => 'stations')
    expire_fragment(:controller => 'flatshare', :action =>'view', :id => flatshare.id, :part => 'pictures')
    expire_fragment(:controller => 'user', :action => 'edit_advert', :id => flatshare.id, :part => 'pictures')
    expire_fragment(:controller => 'user', :action => 'index', :id => flatshare.user_id, :part => 'advert')
    expire_fragment(:controller => 'user', :action => 'index', :id => flatshare.user_id, :part => 'advert')
    expire_fragment(:controller => 'user', :action =>'view', :id => flatshare.id, :part => 'rich_attr')
    expire_fragment(:controller => 'user', :action =>'view', :id => flatshare.id, :part => 'pictures')
    expire_fragment(:controller => 'user', :action =>'view', :id => flatshare.id, :part => 'stations')
    expire_fragment(%r{[0-9].part=matching_adverts.cache})
    
    # expire pages cached
    expire_page(:controller => 'user', :action => 'view_advert', :id => flatshare.id)
    expire_page(:controller => 'flatshare', :action => 'index')
    
    # expire actions cached
  end
end