class MessageSweeper < ActionController::Caching::Sweeper
  observe Message
  
  #if a flatshare advert is updated then we need to flush that fragment cache
  def after_update(message)
    expire_message_cache(message)
  end
  
  def after_create(message)
    expire_message_cache(message)
  end
  
  def after_destroy(message)
    expire_message_cache(message)    
  end
  
  private
  def expire_message_cache(message)
    expire_fragment(:controller => 'user', :action => 'index', :id => message.user_id, :part => 'messages')
  end
end