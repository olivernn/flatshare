class LookupsController < ApplicationController
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
    @lookup_pages, @lookups = paginate :lookups, :per_page => 10
  end

  def show
    @lookup = Lookup.find(params[:id])
  end

  def new
    @lookup = Lookup.new
  end

  def create
    @lookup = Lookup.new(params[:lookup])
    if @lookup.save
      flash[:notice] = 'Lookup was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @lookup = Lookup.find(params[:id])
  end

  def update
    @lookup = Lookup.find(params[:id])
    if @lookup.update_attributes(params[:lookup])
      flash[:notice] = 'Lookup was successfully updated.'
      redirect_to :action => 'show', :id => @lookup
    else
      render :action => 'edit'
    end
  end

  def destroy
    Lookup.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
