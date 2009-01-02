class ImageController < ApplicationController
  def new
    @image = Image.new
    render :partial => 'get_picture'
  end
  
  def create
    @advert = get_user.get_advert
    @image = @advert.images.create(params[:image]) unless @advert.images.size > 5
    if @image.save
      flash[:notice] = "Image succesfully added"
      redirect_to :controller => 'user', :action => 'show_advert'
    else
      flash[:warning] = "Please choose an image to upload"
      render :partial => 'get_picture'
    end
  end
  
  def destroy
    image = Image.find(params[:id])
    image.destroy
    if request.xhr?
      render :partial => 'edit_pictures', :locals => {:images => Image.find(:all, :conditions => ['advert_id =?', image.advert_id])}
    else
      render :action => 'edit_advert'
    end
  end
end
