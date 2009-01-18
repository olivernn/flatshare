class UserController < ApplicationController
  layout 'standard'
  auto_complete_for :rich_attribute, :name
  
  before_filter :logged_in, :except => [:login, :reset_password, :generate_password, :add_user, :view_advert, :get_help_text, :show_picture, :slideshow_images]
  before_filter :is_admin, :only => :clear_all_cache
  
  caches_page :new_flatseeker, :new_flatshare, :view_advert, :show_picture
  cache_sweeper :flatseeker_sweeper, :flatshare_sweeper,
                :only => [:update_advert, :edit_advert, :refresh_advert, :create_flatshare, :create_flatseeker]
                
  cache_sweeper :message_sweeper, :favourite_sweeper
  
  def auto_complete_for_flatshare_area
    @areas = Area.get_areas(params[:flatshare][:area]) rescue nil
    render :partial => 'shared/areas'
  end
  
  def auto_complete_for_flatseeker_area
    @areas = Area.get_areas(params[:flatseeker][:area]) rescue nil
    render :partial => 'shared/areas'
  end
  
  def add_user
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash[:notice] = "Welcome #{@user.full_name}"
      email = UserMailer.deliver_welcome(@user)
      session[:user_id] = @user.id
      #this redirect will take the flow into the payments section of the app, disabled during pilot
      #@user = User.new
      #redirect_to(:controller => 'payments', :action => 'index')
      
      #the following code is used during pilot to allow people to sign up without promotion code or paying
      @user.update_attribute(:authority, 1)
      redirect_to :controller => 'user', :action => 'index'
    end
  end
  
  def reset_password
    @page = Page.find_by_permalink('reset_password')
  end
  
  def generate_password
    @page = Page.find_by_permalink('reset_password')
    user = User.find_by_email(params[:user][:email])
    if user
      new_password = random_text(8)
      user.generate_new_password(new_password)
      user.save
      email = UserMailer.deliver_new_password(user, new_password)
      logger.debug email
      flash[:notice] = "Password reset"
      redirect_to :action => 'login'
    else
      flash[:notice] = "Couldn't reset that password"
      redirect_to :action => 'reset_password'
    end
  end
  
  def change_password
    @user = User.authenticate(get_user.email, params[:user][:current_password])
    if @user
      if @user.update_attributes(params[:user])
        redirect_to :action => 'index' and flash[:notice] = "Password changed successfully"
      else
        render :action => 'edit_password'
      end
    else
      redirect_to :action => 'edit_password' and flash[:notice] = "Password incorrect"
    end
  end
  
  def edit_user
    @user = get_user
  end
  
  def update_user
    @user = get_user
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated"
      redirect_to :action => 'index'
    else
      render :action => 'edit_user'
    end
  end

  def login
    session[:user_id] = nil
    @page = Page.display("login")
    if request.post?
      user = User.authenticate(params[:email], params[:password])
      if user
        flash[:notice] = "Hello " + user.full_name
        update_reg = %r{/user/update_(advert|user)/[0-9a-zA-Z]}
        uri = session[:original_uri] unless session[:original_uri] == '/user/logout' || update_reg.match(session[:original_uri])
        session[:original_uri] = nil
        session[:user_id] = user.id
        redirect_to(uri || {:action => 'index'})
      else
        flash[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Goodbye"
    redirect_to(:controller => 'pages', :action => 'welcome')
  end
  
  def index
    @page = Page.display("my_account")
    @user = get_user
    @advert = @user.adverts.find(:first)
    @messages = @user.messages.find(:all) unless read_fragment :action => 'index', :part => 'messages', :id => @user.id
    @matching_adverts = @advert.matching_adverts if @advert unless read_fragment :action => 'index', :part => 'matching_adverts', :id => @user.id
    @favourite_adverts = @user.get_favourites unless read_fragment :action => 'index', :part => 'favourite_adverts', :id => @user.id
  end

#method will view adverts other than the users own
  def view_advert
    begin
      @advert = Advert.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error "attempt to view invalid advert #{params[:id]}"
      redirect_to :action => 'index' and flash[:notice] = "Invalid advert"
    else
      render :partial => 'view_advert' if request.xhr?
    end
  end
  
# method to display a particular advert on a map
  def map_advert
    @advert = Advert.find(params[:id])
    if @advert.type == Flatshare
      display_map(@advert)
    end
    render :partial => 'advert_map'
  end
  
#show a set of adverts on a map
  def map_adverts
    @page = Page.display("map_adverts")
    @map_markers = Array.new
    flatshare_ids = Array.new
    get_user.adverts.find(:first).matching_adverts.each do |matching_advert|
      @map_markers << GMarker.new([matching_advert.lat,matching_advert.lng], :info_window => render_to_string(:partial => "flatshare/info_window", :locals => { :advert => matching_advert}))
      flatshare_ids << matching_advert.id
    end
    map_centre = get_map_centre(flatshare_ids)
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true, :local_search => true, :anchor => :bottom_right, :offset_width => 10, :offset_height => 10)
    @map.center_zoom_init([map_centre.lat,map_centre.lng,], 14)
    @map_markers.each do |marker|
      @map.overlay_init(marker)
    end
  end
  
#allows the user to email an advert to their freinds, not yet implemented
  def send_to_friend
    logger.debug request.method
    if request.post?
      advert = Advert.find(params[:id])
      email = UserMailer.deliver_send_to_friend(get_user, advert, params[:comment], params[:friend_email])
    else
      render :partial => 'shared/send_to_friend', :locals => {:advert => advert}
    end
  end
  
#methods for viewing and deleting favourites
  def delete_favourite
    Favorite.find(:first, :conditions => ["user_id =? AND favorable_id =?", session[:user_id], params[:id]]).destroy
    flash[:notice] = "Favourite removed"
    redirect_to(:action => 'index')
  end

# the following are methods for CRUD actions with places, this feature has not yet been implemented
  def new_place
    @place = Place.new
    @category = get_lookup_values("Place_Type")
  end
  
  def create_place
    if get_user.places.create(params[:place])
      flash[:notice] = "Place successfully created"
      redirect_to :action => 'index'
    else
      redirect_to :action => 'new_place'
    end
  end
  
  def view_place
    @place = Place.find(params[:id])    
  end
  
  def map_places
    @map_markers = Array.new
    @places = get_user.places.find(:all)
    total_lat = 0
    total_lng = 0
    @places.each do |place|
      @map_markers << GMarker.new([place.lat, place.lng], :info_window => render_to_string(:partial => "place_info_window", :locals => { :place => place}))
      total_lat += place.lat
      total_lng += place.lng
    end
    set_up_map([total_lat/@places.size, total_lng/@places.size], @map_markers)
  end
  
  def edit_place
    @place = Place.find(params[:id])
    @category = get_lookup_values("Place_Type")
  end
  
  def update_place
    @place = Place.find(params[:id])
    if @place.update_attributes(params[:place])
      flash[:notice] = "Place successfully updated"
      redirect_to :action => 'index'
    else
      redirect_to :action => 'edit_place'
    end
  end
  
  def show_place_map
    @place = Place.find(params[:id])
    map_display(@place)
    render :partial => 'shared/map'
  end

# the following methods are for dealing with the messages  
  def show_messages
    @messages = get_user.messages.search(params[:page])
  end
  
  def view_message
    @message = Message.find(params[:id])
    @message.update_attribute(:read, true)
  end
  
  def reply_message
    @message = Message.find(params[:id])
  end
  
  def new_message
    @user = get_user
    @message = Message.new
    @message.from_id = @user.id
    @message.user_id = params[:id]
    render :partial => 'shared/send_message', :object => @message
  end
  
  def send_message
    message = Message.create(params[:message])
    if message
      flash.now[:notice] = 'Message successfully sent'
    else
      flash.now[:warning] = 'Problem sending message, please try again'
    end
  end 
  
  def delete_message
    Message.find(params[:id]).destroy
    redirect_to :action => 'show_messages' unless request.xhr?
  end
  
# the following are generic methods for showing and editing adverts
  def show_advert
    @advert = get_user.adverts.find(:first)
    if @advert[:type] == 'Flatshare'
      @stations = @advert.nearest_stations
    end
  end
  
  def edit_advert
    @frequency = get_frequency
    @room_type = get_lookup_values("RoomType")
    @advert = get_user.adverts.find(:first)
    @images = @advert.images.find(:all)
    @rich_attribute = RichAttribute.new
    @rich_attribute.selected = @advert.selected_rich_attributes
    logger.debug @rich_attribute.selected
  end
  
  def update_advert
    @advert = Advert.find(params[:id])
    if @advert[:type] == 'Flatshare' 
      advert_parameters = params[:flatshare]
    else
      advert_parameters = params[:flatseeker]
    end
    if @advert.update_attributes(advert_parameters)
      @advert.add_rich_attributes(params[:rich_attribute][:selected])
      if @advert.quarantine
        unless @advert.remove_from_quarantine
          @frequency = get_lookup_values("Frequency")
          @room_type = get_lookup_values("RoomType")
           @pictures = @advert.pictures.find(:all)  
          flash[:warning] = 'Change advert to remove from quarantine'
          render :action => 'edit_advert'
        else
          flash[:notice] = "Advert removed from quarantine"
          render :action => 'show_advert', :id => @advert
        end
      else
        flash.now[:notice] = 'Advert was successfully updated.'
        render :action => 'view_advert', :id => @advert
      end
    else
      @frequency = get_frequency
      @room_type = get_lookup_values("RoomType")
      @pictures = @advert.pictures.find(:all)
      render :action => 'edit_advert'
    end
  end  
  
  def refresh_advert
    Advert.find(params[:id]).refresh
    flash.now[:notice] = "Advert refreshed"
  end
  
# the following methods are all for creating, viewing and editing a users flatshare advert
  def new_flatshare
    @flatshare = Flatshare.new
    @frequency = get_frequency
    @room_type = get_lookup_values("RoomType")
  end
  
  def create_flatshare
    @flatshare = get_user.flatshares.create(params[:flatshare])
    if @flatshare.save
      add_rich_attributes(params[:rich_attribute], @flatshare)
      flash[:notice] = "Advert successfully created"
      redirect_to :action => 'show_advert'
    else
      @frequency = get_frequency
      @room_type = get_lookup_values("RoomType")
      render :action => 'new_flatshare'
    end
  end

#the following methods create a flatseeker advert
  def new_flatseeker
    @flatseeker = Flatseeker.new
    @frequency = get_frequency
    @room_type = get_lookup_values("RoomType")
  end
  
  def create_flatseeker
    @flatseeker = get_user.flatseekers.create(params[:flatseeker])
    if @flatseeker.save
      add_rich_attributes(params[:rich_attribute], @flatseeker)
      flash[:notice] = "Advert successfully created"
      redirect_to :action => 'show_advert'
    else
      @frequency = get_frequency
      @room_type = get_lookup_values("RoomType")
      render :action => 'new_flatseeker'
    end
  end
  
  def show_flatshare
    @flatshare = Flatshare.find(params[:id])
  end

  def edit_flatshare(user)
    @flatshare = user.flatshares
    @flatshare_attributes = @flatshare.rich_attributes
    @frequency = get_lookup_values("Frequency")
    @room_type = get_lookup_values("RoomType")
  end

  def update_flatshare
    @flatshare = Flatshare.find(params[:id])
    if @flatshare.update_attributes(params[:flatshare])
      flash[:notice] = 'Flatshare was successfully updated.'
      redirect_to :action => 'show_flatshare', :id => @flatshare
    else
      @frequency = get_frequency
      render :action => 'edit_flatshare'
    end
  end

# the following methods are for creating, viewing and editing a users flatseeker advert

# picture upload actions follow
  def get_picture
    @advert = get_user.get_advert
    @picture = Picture.new
    render :partial => 'get_picture'
  end

  def save_picture
    @advert = get_user.get_advert
    if @advert.pictures.size < 5
      @picture = @advert.pictures.create(params[:picture])
      if @picture
        render :action => 'show_advert'
      else
        render :action => 'get_picture'
      end
    else
      flash[:notice] = "Only 5 photos allowed"
      render :action => 'edit'
    end
  end

  def slideshow_images
    @images = Advert.find(params[:id]).images
    render :partial => 'slideshow'
  end

  def show_picture
    @picture = Picture.find(params[:id])
    send_data(@picture.data, :filename => @picture.name, :type => @picture.content_type, :disposition => "inline")
  end
  
  def delete_picture
    @picture = Picture.find(params[:id]).destroy
    @all_pictures = Picture.find(:all, :conditions => ['advert_id =?', @picture.advert_id])
    if request.xhr?
      render :partial => 'edit_pictures', :locals => {:pictures => @all_pictures}
    else
      render :action => 'edit_advert'
    end
  end
    
  
  def show_all_pictures
    @user = get_user
    if @user.has_flatshare_advert
      @advert = Flatshare.find(params[:id])
    else
      @advert = Flatseeker.find(params[:id])
    end
    @pictures = @advert.pictures.find
  end
  
  private
  def display_map(flatshare)
    @map = GMap.new("map_div")
    @map.control_init(:large_map => false, :map_type => true, :local_search => false, :anchor => :bottom_right, :offset_width => 10, :offset_height => 10)
    @map.overlay_init(GMarker.new([flatshare.lat,flatshare.lng]))
    @map.center_zoom_init([flatshare.lat,flatshare.lng], 15)
  end
  
  def show_flatshare_advert(user)
    @flatshare = user.flatshares
    render :partial => 'flatshare/advert', :object => @flatshare
  end
  
  def show_flatseeker_advert(user)
    @flatseeker = user.flatseekers
    render :partial => 'flatseekers/advert', :object => @flatseeker
  end
  
  def get_map_centre(ids)
    lat = Flatshare.average(:lat, :conditions => ["id IN (?)", ids])
    lng = Flatshare.average(:lng, :conditions => ["id IN (?)", ids])
    Ym4r::GmPlugin::GLatLng.new([lat, lng])
  end
    
  def get_matching_adverts(advert, user)
    if user.has_flatshare_advert
      Flatseeker.matches(advert)
    else
      Flatshare.matches(advert)
    end
  end
  
  def add_rich_attributes(rich_attributes, advert)
    rich_attributes[:selected].split(",").each do |tag|
      @advert_attribute = RichAttribute.find(:first, :conditions => ["name=?", tag.strip])
      unless @advert_attribute
        advert.rich_attributes << RichAttribute.create(:name => tag)
      else
        advert.rich_attributes << @advert_attribute
      end
    end
  end
  
end
