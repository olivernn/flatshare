class FlatseekersController < ApplicationController
  layout 'standard'
  auto_complete_for :rich_attribute, :name
  
  caches_page :index, :search
  cache_sweeper :favourite_sweeper
  cache_sweeper :flatseeker_sweeper, :only => [:destroy]
  
  def index
    search
    render :action => 'search'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list_old
    @flatseeker_pages, @flatseekers = paginate :flatseekers, :per_page => 10
  end
  
  def search
    @page = Page.display('flatseeker_search')
  end
    
  def show
    @flatseeker = Flatseeker.find(params[:id])  
    @flatseeker.increment!("views_counter") 
    render :partial => 'advert' if request.xhr?
  end

  def new
    @flatseeker = Flatseeker.new
    @frequency = get_frequency
  end

  def create
    @flatseeker = Flatseeker.new(params[:flatseeker])
    if @flatseeker.save
      add_rich_attributes(@flatseeker)
      flash[:notice] = 'Flatseeker was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @flatseeker = Flatseeker.find(params[:id])
  end

  def update
    @flatseeker = Flatseeker.find(params[:id])
    if @flatseeker.update_attributes(params[:flatseeker])
      flash[:notice] = 'Flatseeker was successfully updated.'
      redirect_to :action => 'show', :id => @flatseeker
    else
      render :action => 'edit'
    end
  end

  def destroy
    Flatseeker.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
  
  def list
    @flatseekers = Flatseeker.search(params)
    if !@flatseekers || @flatseekers.empty?
      flash.now[:notice] = "No matching adverts"
    end
    if request.xhr?
      render :update do |page|
        page['flatseeker_search_results'].visual_effect :fade, :duration => 0.2
        page['flash'].replace :partial => 'shared/flash'
        page.delay(0.2) do
          page['flatseeker_search_results'].replace_html :partial => 'list'
          page['flatseeker_search_results'].visual_effect :appear, :duration => 0.2
        end
      end
    end
  end
  
  #methods for favourites
  def add_to_favourites
    new_favourite(params[:id])
    flash.now[:notice] = 'Flatseeker added to favourites'
    redirect_to :action => 'search' unless request.xhr?
  end
  
  def auto_complete_for_flatseeker_area
    @areas = Area.get_areas(params[:flatseeker][:area])
    render :partial => 'shared/areas'
  end
  
  private
  def add_rich_attributes(advert)
    advert = params[:rich_attribute]
    advert[:selected].split(",").each do |tag|
      @advert_attribute = RichAttribute.find(:first, :conditions => ["name=?", tag.strip])
      unless @advert_attribute
        @advert_attribute = RichAttribute.create(:name => tag)
      end
      @flatseeker.rich_attributes << @advert_attribute
    end
  end
  
  def get_matching_flatseekers
    unless params[:flatseekers][:min_rent].empty?
      unless params[:flatseekers][:area].empty?
        #search using area and maximum rent
        Flatseker.query.area_eq(params[:flatseekers][:area]).rent_lt(params[:flatshare][:min_rent])
      else
        #search using maximum rent
        Flatseker.query.rent_lt(params[:flatseekers][:min_rent])
      end
    else
      unless params[:flatseekers][:area].empty?
        #search using area
        Flatseker.query.area_eq(params[:flatseekers][:area])
      end
    end
  end
end
