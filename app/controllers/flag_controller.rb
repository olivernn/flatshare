class FlagController < ApplicationController
  
  def new_flag
    @flag = Flag.new()
    @flag_type = get_lookup_values("flag_type")
    @flag.user_id = get_user.id
    @flag.advert_id = params[:id]
    render :partial => 'shared/flag_form'
  end
  
  def add_flag
    unless params[:flag][:flag_comment].empty?
      @flag = Flag.new(params[:flag])
      if @flag.save
        flash.now[:notice] = "Flag successfully created"
      else
        flash.now[:warning] = "Cannot flag the same advert twice"
      end
    else
      flash.now[:warning] = "Please try again with a comment"
    end
  end  
end