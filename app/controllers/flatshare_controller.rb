class FlatshareController < ApplicationController
  layout 'standard'
  auto_complete_for :rich_attribute, :name
  
  caches_page :index, :search
  cache_sweeper :favourite_sweeper
  
  def index
    search
    render :action => 'search'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    #@flatshare_pages, @flatshares = paginate :flatshares, :per_page => 10
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true)
    @map.center_zoom_init([51.510018,-0.130424,], 14)
    @flatshares = Flatshare.find(:all)
    if @flatshares
      @flatshares.each do |@flatshare|
        @map.overlay_init GMarker.new([@flatshare.lat,@flatshare.lng], :info_window => render_to_string(:partial => "info_window", :object => @flatshare))
      end
    end
  end

  def view_advert
    @local_information = Page.display('local_information')
    @flatshare = Flatshare.find(params[:id])
    @flatshare.increment!("views_counter")
    respond_to do |format|
      format.html {render :action => 'view_advert_non_js'}
      format.js {render :action => 'view_advert.rjs'}
    end
  end
  
  def show
    @flatshare = Flatshare.find(params[:id])
  end

  def new
    @flatshare = Flatshare.new
    @frequency = get_lookup_values("Frequency")
    @room_type = get_lookup_values("RoomType")
  end

  def create
    @flatshare = Flatshare.new(params[:flatshare])
    if @flatshare.save
      add_rich_attributes(@flatshare)
      flash[:notice] = 'Flatshare was successfully created.'
      redirect_to :action => 'show', :id => @flatshare
    else
      @frequency = get_frequency
      render :action => 'new'
    end
  end

  def edit
    @flatshare = Flatshare.find(params[:id])
    @flatshare_attributes = @flatshare.rich_attributes
    @frequency = get_frequency
  end

  def update
    @flatshare = Flatshare.find(params[:id])
    if @flatshare.update_attributes(params[:flatshare])
      flash[:notice] = 'Flatshare was successfully updated.'
      redirect_to :action => 'show', :id => @flatshare
    else
      @frequency = get_frequency
      render :action => 'edit'
    end
  end

  def destroy
    Flatshare.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def list_flatshare
    @map = Variable.new("map")
    @flatshares = Flatshare.search(params[:flatshare])
    unless !@flatshares || @flatshares.empty?
      if request.xhr?
        @map_markers = Array.new
        unless @flatshares.empty?
          @flatshares.each do |advert|
            @map_markers << GMarker.new([advert.lat,advert.lng], :info_window => render_to_string(:partial => "flatshare/info_window", :locals => { :advert => advert}))
          end
        @map_centre = get_map_centre(@flatshares)
        end
      else
        render :action => 'list'
      end
    else
      flash.now[:notice] = "No matching flatshares found"
    end
  end
  
  def search
    # get the data to build the page from the database
    @distances = get_lookup_values('Distance')
    @search = Page.display('flatshare_search')
    @local_information = Page.display('local_information')
    @flatshares = Flatshare.find_current
    # use the flatshare data to build the map
    set_up_map
    set_up_map_markers(@flatshares)
    centre_on_bounds(@flatshares)
  end
  
  def message_advert_owner
    @user = get_user
    @flatshare = Flatshare.find(params[:id])
  end
  
  #local information methods
  def local_pictures
    @local_information = Page.display('local_information')
    @flatshare = Advert.find(params[:id])
    render :partial => 'local_pictures'
  end
  
  def search_flickr
    @flatshare = Advert.find(params[:id])
    @local_pictures = Flickr.new(@flatshare.lat, @flatshare.lng, @flatshare.area, params[:flickr][:tags])
    logger.debug @local_pictures.create_request(params[:flickr])
    render :partial => 'flickr_slideshow'
  end
  
  def local_travel
    @local_information = Page.display('local_information')
    @flatshare = Advert.find(params[:id])
    render :partial => 'local_travel'
  end
  
  def search_travel
    @journey = Journey.new(params[:origin], params[:travel][:destination])
    logger.info "timeout" unless @journey.success
    render :partial => 'travel_results'
  end
    
  def local_places
    @flatshare = Advert.find(params[:id])
    @places = @flatshare.local_places
    render :partial => 'local_places_results'
  end
  
  #methods for favourites
  def add_to_favourites
    new_favourite(params[:id])
    flash.now[:notice] = 'Flatshare added to favourites'
  end
  
  #auto complete methods
  def auto_complete_for_flatshare_area
    @areas = Area.get_areas(params[:flatshare][:area]) rescue nil
    render :partial => 'shared/areas'
  end
  
  def auto_complete_for_flatshare_station
    get_stations(params[:flatshare][:station]) rescue nil
  end
  
  # picture upload actions follow
  def get_picture
    @flatshare = Flatshare.find(params[:id])
    @picture = Picture.new
  end
  
  def save_picture
    @flatshare = Flatshare.find(params[:id])
    if @flatshare.pictures.size < 5
      @picture = @flatshare.pictures.create(params[:picture])
      if @picture
        render :action => 'show', :id => @flatshare
      else
        render :action => 'get_picture'
      end
    else
      flash[:notice] = "Only 5 photos allowed"
      render :action => 'edit'
    end
  end
  
  private
  def centre_on_bounds(adverts)
    unless adverts.empty?
      sorted_lat = adverts.collect(&:lat).compact.sort
      sorted_lng = adverts.collect(&:lng).compact.sort
      @map.center_zoom_on_bounds_init([[sorted_lat.first, sorted_lng.first],
                                       [sorted_lat.last, sorted_lng.last]])
    else
      @map.center_zoom_init([51.510018,-0.130424,], 12)
    end
  end
  
  def calculate_bounds(adverts)
    sorted_lat = adverts.collect(&:lat).compact.sort
    sorted_lng = adverts.collect(&:lng).compact.sort
    GLatLngBounds.new([[sorted_lat.first, sorted_lng.first],
                 [sorted_lat.last, sorted_lng.last]])
  end
  
  def set_up_map
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true, :map_type => true, :local_search => true, :anchor => :bottom_right, :offset_width => 10, :offset_height => 10)
  end
  
  def set_up_map_markers(adverts)
    @map_markers = Array.new
    unless adverts.empty?
      adverts.each do |advert|
        @map_markers << GMarker.new([advert.lat,advert.lng], :info_window => render_to_string(:partial => "flatshare/info_window", :locals => { :advert => advert}))
      end
      @map_markers.each do |marker|
        @map.overlay_init(marker)
      end
    end
  end
  
  def get_map_centre(adverts)
    Array.class_eval do
      # this method will compute the mathmatical mean of the contents of an array
      def mean
        inject(0){ |sum, n| sum + n } / length.to_f
      end
    end
    Ym4r::GmPlugin::GLatLng.new([adverts.collect(&:lat).mean, adverts.collect(&:lng).mean])
  end
    
  def add_rich_attributes(advert)
    advert = params[:rich_attribute]
    advert[:selected].split(",").each do |tag|
      @advert_attribute = RichAttribute.find(:first, :conditions => ["name=?", tag.strip])
      unless @advert_attribute
        @advert_attribute = RichAttribute.create(:name => tag)
      end
      @flatshare.rich_attributes << @advert_attribute
    end
  end
end
