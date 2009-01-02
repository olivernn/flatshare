class RichAttriubteController < ApplicationController
  auto_complete_for :rich_attribute, :name
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @rich_attribute_pages, @rich_attributes = paginate :rich_attributes, :per_page => 10
  end

  def show
    @rich_attribute = RichAttribute.find(params[:id])
  end

  def new
    @rich_attribute = RichAttribute.new
  end

  def create
    @rich_attribute = RichAttribute.new(params[:rich_attribute])
    if @rich_attribute.save
      flash[:notice] = 'RichAttribute was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @rich_attribute = RichAttribute.find(params[:id])
  end

  def update
    @rich_attribute = RichAttribute.find(params[:id])
    if @rich_attribute.update_attributes(params[:rich_attribute])
      flash[:notice] = 'RichAttribute was successfully updated.'
      redirect_to :action => 'show', :id => @rich_attribute
    else
      render :action => 'edit'
    end
  end

  def destroy
    RichAttribute.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
