# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def accordion(titles, expanders, options = {})
    js = %Q(window.onload = function(){
      var titles = document.getElementsByClassName("#{titles}");
      var expanders = document.getElementsByClassName("#{expanders}");
      var myEffect = new Fx.Accordion(titles, expanders, #{options_for_javascript(options)});
    };)
    javascript_tag(js.chop!)
  end
  
  def display_boolean(value)
    if value
      "Yes"
    else
      "No"
    end
  end
  
  def button(type)
    #"<button type='submit' class='form_button'><img src='/images/#{type}_button.png'/></button>"
    "<input class='button' type='image' src='/images/#{type}_button.png' alt='Form Submit Button'>"
  end
  
  #displays a nice page title easily
  def title(text)
    content_for(:title) { text }
  end
  
  #allows us to specify the keywords for a page
  def meta_keywords(keywords)
    content_for(:keywords) { keywords }
  end
  
  #allows us to specify the description for a page
  def meta_description(description)
    content_for(:description) { description }
  end
  
  #creates a bookmark link for the current page
  def add_bookmark
    title = "'The best place to advertise your flatshare'"
    url = "'http://londonflatmate.net#{request.request_uri}'"  
    %Q|<a href="javascript:bookmarksite(#{title}, #{url});">Bookmark this page</a>|
  end
  
  #icons for use with showing the state of a message
  def message_status(message)
    if message.read
      icon('email_open', 'message already read')
    else
      icon('email', 'new message')
    end
  end
  
  #if the advert is new on today display an icon
  def is_new_advert(advert_date)
    if advert_date >= Time.now - (60 * 60 * 24)
      icon("new", "new advert")
    end
  end
  
  #if the advert has pictures display an icon
  def has_pictures(pictures)
    if pictures.size > 0
      icon("picture", "advert has pictures")
    end
  end
    
  #method for having nice icon links
  def icon(name, text)
    image_tag "/images/icons/" + name + ".png", :alt => text, :title => text
  end
  
  #method for displaying a link to map adverts only if they are flatshare adverts
  def map_adverts_link(adverts)
    if adverts.first[:type] == 'Flatshare'
      link_to icon('map', 'show these adverts on a map'), :action => 'map_adverts'
    end
  end
  
  def counter(number)
    case number
    when 1
      "once"
    when 2
      "twice"
    else
      number.to_s + " times"
    end
  end
  
  def display_image(img)
    link_to image_tag(img.public_filename(:thumb)), img.public_filename
  end
  
  def display_image_inline(img)
    link_to_remote(image_tag(img.public_filename(:thumb)),
      img.public_filename,
      :update => 'message_form',
      :before   => visual_effect(:fade, 'message_form', :duration => 0.2), 
    	:complete => visual_effect(:appear, 'message_form', :duration => 0.2))
  end
  
  def display_picture(picture)
    link_to_remote("<img class='picture' src='#{url_for(:action => 'show_picture', :id => picture.id)}'/>",
      :url      => {:action => 'large_picture', :id => picture},
      :update   => 'message_form', 
    	:before   => visual_effect(:fade, 'message_form', :duration => 0.2), 
    	:complete => visual_effect(:appear, 'message_form', :duration => 0.2))
  end
  
  def large_picture
    render :partial => 'shared/picture'
    "<img class='picture' src='#{url_for(:action => 'show_picture', :id => picture.id)}'/>"
  end

  def refresh_advert_link(advert)
    if advert.refresh_applicable
      link_to_remote( icon('arrow_refresh', 'refresh your advert'), {:url => {:action => 'refresh_advert', :id => advert.id}}, :id => 'refresh_advert_button')
    end
  end

  def text_field_with_help(form, name, css_class, help_name, help_location)
    text_field form, name, :class => css_class, :onfocus => remote_function(:url => {:action => 'get_help_text', :name => help_name}, :update => help_location,:complete => visual_effect(:appear, help_location, :duration => 0.2)), :onblur => visual_effect(:fade, help_location, :duration => 0.2)
  end
  
  def text_area_with_help(form, name, css_class, help_name, help_location)
    text_area form, name, :class => css_class, :onfocus => remote_function(:url => {:action => 'get_help_text', :name => help_name}, :update => help_location, :complete => visual_effect(:appear, help_location, :duration => 0.2)), :onblur => visual_effect(:fade, help_location, :duration => 0.2)
  end
  
  def password_field_with_help(form, name, css_class, help_name, help_location)
    password_field form, name, :class => css_class, :onfocus => remote_function(:url => {:action => 'get_help_text', :name => help_name}, :update => help_location, :complete => visual_effect(:appear, help_location, :duration => 0.2)), :onblur => visual_effect(:fade, help_location, :duration => 0.2)
  end
  
  def auto_complete_with_help(form, name, css_class, help_name, help_location)
    text_name = help_name || form + "_" + name
    text_field_with_auto_complete  form, name, :frequency => 0.01, :class => css_class, :onfocus => remote_function(:url => {:action => 'get_help_text', :name => text_name}, :update => help_location, :complete => visual_effect(:appear, help_location, :duration => 0.2)), :onblur => visual_effect(:fade, help_location, :duration => 0.2)
  end
  
  def fieldset_help(help_location)
    "<div class='help_holder'><div id='#{help_location}'></div></div>"
  end
  
  def advert_controls(advert)
    if advert.user_id == session[:user_id]
      render :partial => 'shared/advert_owner_controls', :locals => {:advert => advert }
    else
      render :partial => 'shared/advert_controls', :locals => {:advert => advert }
    end
  end
    
  def show_advert(advert, action)
    if advert[:type] == 'Flatshare'
      @flatshare = advert
      if action == 'show'
    	  render :partial => 'flatshare/advert', :object => @flatshare
    	else
        render :partial => 'flatshare/form', :object => @flatshare
      end
    else
      @flatseeker = advert
      if action == 'show'
    	  render :partial => 'flatseekers/advert', :object => @flatseeker
    	else
    	  render :partial => 'flatseekers/form', :object => @flatseeker
    	end
    end
  end
  
  def show_message_link(text, message)
    link_to_remote text, :url => {:action => "view_message", :id => message.id}
  end
end
