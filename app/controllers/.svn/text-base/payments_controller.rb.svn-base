class PaymentsController < ApplicationController
  layout 'standard'
  
  include ActiveMerchant::Billing
  
  def index
    @page = Page.display("payments")
  end

  #below are the methods for paypal payments
  def checkout
    setup_response = gateway.setup_purchase(300,
      :ip => request.remote_ip,
      :return_url => url_for(:action => 'confirm', :only_path => false),
      :cancel_return_url => url_for(:action => 'index', :only_path => false)
    )
    redirect_to gateway.redirect_url_for(setup_response.token)
  end

  def confirm
    @page = Page.display("payments")
    redirect_to :action => 'index' unless params[:token]
    
    details_response = gateway.details_for(params[:token])
    
    if !details_response.success?
      @message = details_response.message
      render :action => 'error'
      return
    end
    @page = Page.display("payment_confirmation")
    @address = details_response.address
  end

  def complete
    purchase = gateway.purchase(300,
      :ip => request.remote_ip,
      :payer_id => params[:payer_id],
      :token => params[:token]
    )
    
    if !purchase.success?
      @message = purchase.message
      render :action => 'error'
      return
    else
      #only want this to happen if the payment was completed
      usr = get_user
      usr.update_attribute(:authority, 1)
      email = UserMailer.deliver_payment_receipt(usr)
      logger.debug email
      redirect_to :controller => 'user', :action => 'index'
    end
  end
  
  def promotion
    if Promotion.vaildate_code(params[:promotion][:code])
      get_user.update_attribute(:authority, 1)
      redirect_to :controller => 'user', :action => 'index'
    else
      flash[:warning] = "Promotion code invalid"
      redirect_to :action => 'index'
    end
  end
    
  private
  def gateway
    if RAILS_ENV == "production"
      @gateway ||= PaypalExpressGateway.new(
        :login => 'admin_api1.londonflatmate.net',
        :password => 'KPS7LKVRFGEC9KG7',
        :signature => 'A7UKehcFxl.Bz95J2tj3ZFuo0TooA0.si52W2bY4qQp1MVUsWDtMasN7')
    else
      @gateway ||= PaypalExpressGateway.new(
        :login => 'oliver_1218302408_biz_api1.ntlworld.com',
        :password => '95X5HJ8WG2SRBPB2',
        :signature => 'AH1eOAAdxH9dz4bJ8jTBB9jd0rv7AUvGZZ3ZuXIXmV77iCPhPlGt9YM.')
    end
  end
end