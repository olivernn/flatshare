class PromotionsController < ApplicationController
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
    @promotion_pages, @promotions = paginate :promotions, :per_page => 10
  end

  def show
    @promotion = Promotion.find(params[:id])
  end

  def new
    @promotion = Promotion.new
  end

  def create
    @promotion = Promotion.new(params[:promotions])
    if @promotion.save
      flash[:notice] = 'Promotion was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @promotion = Promotion.find(params[:id])
  end

  def update
    @promotion = Promotion.find(params[:id])
    if @promotion.update_attributes(params[:promotions])
      flash[:notice] = 'Promotion was successfully updated.'
      redirect_to :action => 'show', :id => @promotion
    else
      render :action => 'edit'
    end
  end

  def destroy
    Promotion.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
