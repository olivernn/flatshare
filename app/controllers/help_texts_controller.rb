class HelpTextsController < ApplicationController
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
    @help_text_pages, @help_texts = paginate :help_texts, :per_page => 10
  end

  def show
    @help_text = HelpText.find(params[:id])
  end

  def new
    @help_text = HelpText.new
  end

  def create
    @help_text = HelpText.new(params[:help_text])
    if @help_text.save
      flash[:notice] = 'HelpText was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @help_text = HelpText.find(params[:id])
  end

  def update
    @help_text = HelpText.find(params[:id])
    if @help_text.update_attributes(params[:help_text])
      flash[:notice] = 'HelpText was successfully updated.'
      redirect_to :action => 'show', :id => @help_text
    else
      render :action => 'edit'
    end
  end

  def destroy
    HelpText.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
