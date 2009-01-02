class StationsController < ApplicationController
  layout 'standard'
  before_filter :is_admin
    
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @station_pages, @stations = paginate :stations, :per_page => 10
  end

  def show
    @station = Station.find(params[:id])
  end

  def new
    @station = Station.new
  end

  def create
    @station = Station.new(params[:station])
    if @station.save
      flash[:notice] = 'Station was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @station = Station.find(params[:id])
  end

  def update
    @station = Station.find(params[:id])
    if @station.update_attributes(params[:station])
      flash[:notice] = 'Station was successfully updated.'
      redirect_to :action => 'show', :id => @station
    else
      render :action => 'edit'
    end
  end

  def destroy
    Station.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
