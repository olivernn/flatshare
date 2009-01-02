class PageSweeper < ActionController::Caching::Sweeper
  observe Page
  
  #if a flatshare advert is updated then we need to flush that fragment cache
  def after_update(page)
    expire_page_cache(page)
    expire_page_cache_with_conditions(page)
  end
  
  def after_create(page)
    expire_page_cache(page)
  end
  
  def after_destroy(page)
    expire_page_cache(page)
  end
  
  private
  def expire_page_cache(page)
    expire_page(:controller => 'pages', :action => 'article_list')
    expire_page(:controller => 'pages', :action => 'show_article', :id => page.id)
    expire_action(:controller => 'pages', :action => 'show_article', :id => page.id)
    expire_fragment('footer')
  end
  
  def expire_page_cache_with_conditions(page)
    expire_page(:controller => 'pages', :action => page.permalink.gsub('-', '_'))    
  end
end