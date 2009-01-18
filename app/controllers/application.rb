# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  # this is just during testing so that we can use http authentication to prevent access to this site
  #requires_authentication :using => :http_auth #this is a method further down the page
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_flatshare_session_id'
  
  caches_page :show_picture
  
  helper_method :logged_in, :is_admin
  
  def advert_contact_number
    render :partial => 'shared/telephone_number', :locals => {:user => User.find(params[:id])}
  end
  
  def add_to_favourites
    new_favourite(params[:id])
    flash.now[:notice] = 'Advert added to favourites'
    #render :update => 'user/add_to_favourites'
  end
  
  #this method will generate some random text
  def random_text(length)
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ23456789'  
    text = ''  
    length.times { text << chars[rand(chars.size)] } 
    text
  end
  
  def get_help_text
    help = HelpText.get_help(params[:name])
    text = help.help_text if help
    render :partial => 'shared/help_text', :locals => {:text => text}
  end
  
  def show_picture
    @picture = Picture.find(params[:id])
    send_data(@picture.data, :filename => @picture.name, :type => @picture.content_type, :disposition => "inline")
  end
  
  protected
  def get_frequency
    #need to perform the sort so that monthly is always the first value, this is because we store the rent & bills per month
    Lookup.find(:all, :conditions => ['name = "Frequency"'], :order => 'value ASC')
  end
  
  def new_favourite(id)
    @user = get_user
    @advert = Advert.find(id)
    @user.has_favorite(@advert)
  end
  
  #method for setting up a google map
  def set_up_map(centre, markers)
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true, :local_search => true, :anchor => :bottom_right, :offset_width => 10, :offset_height => 10)
    @map.center_zoom_init(centre, 14)
    markers.each do |marker|
      @map.overlay_init(marker)
    end
  end

  #method that will display anything on a map
  def map_display(mappable)
    marker = GMarker.new([mappable.lat, mappable.lng])
    set_up_map([mappable.lat, mappable.lng], marker)
  end
  
  # def get_areas(input_string)
  #   @areas = Lookup.find(:all, :conditions => ['name = "Area" AND value LIKE ?', '%' + input_string + '%'], :order => 'value ASC')
  #   render :partial => 'shared/areas'
  # end
  
  def get_stations(input_string)
    @stations = Station.find(:all, :select => 'DISTINCT name, id', :conditions => ['name LIKE ?', '%' + input_string + '%'], :order => 'name ASC')
    render :partial => 'shared/stations'
  end
  
  def get_room_types
    Lookup.find(:all, :conditions => ['name = "RoomType"'])
  end
  
  def get_lookup_values(table_name)
    Lookup.find(:all, :conditions => ['name = "' + table_name + '"'])
  end
  
  def send_message
    @message = Message.create(params[:message])
    if @message
      flash[:notice] = 'Message successfully sent'
    else
      flash[:warning] = 'Problem sending message, please try again'
    end
  end
  
  #display the flash for an ajax call
  def ajax_flash(type, message)
    if type == 'notice'
      flash[:notice] = message
    end
    render :update => 'shared/ajax_flash'
  end
  
  #user authentication, test user is set up, paid and authorised to view these pages
  def logged_in
    session[:original_uri] = request.request_uri
    user = User.find_by_id(session[:user_id])
    if user
      if user.authority > 0
        true
      else
        #user account has been created but payment hasnt been received
        flash.now[:notice] = "Please make payment"
        redirect_to(:controller => 'payments', :action => 'index')
        false
      end
    else
      #user has not logged in
      # flash.now[:notice] = "Please log in" #-- removed this becuase it keeps being displayed  when it shouldn't!
      redirect_to(:controller => 'user', :action => 'login')
      false
    end
  end
  
  def is_admin
    session[:original_uri] = request.request_uri
    user = User.find_by_id(session[:user_id])
    if user
      if user.authority == 9
        true
      else
        #admin has not logged in
        flash[:notice] = "Please log in"
        redirect_to(:controller => 'user', :action => 'login')
        false
      end
    else
      #admin has not logged in
      flash[:notice] = "Please log in"
      redirect_to(:controller => 'user', :action => 'login')
      false
    end       
  end
    
  def get_user
    User.find(session[:user_id])
  end
  
  def http_auth(username,password)
    return username == "test_user" && password == "trewerg3"
  end
end
