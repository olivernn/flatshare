class PagesController < ApplicationController
  layout 'standard'
  before_filter :is_admin, :except => [:welcome, :show_picture, :article_list, :ajax_show_article, :show_article, :terms_and_conditions, :contact_us]
  
  caches_page :article_list, :welcome, :terms_and_conditions
  caches_page :show_article, :ajax_show_article
  
  cache_sweeper :page_sweeper
  
  def index
    list
    render :action => 'list'
  end

  def welcome
    @page = Page.display('welcome')
    @featured_adverts = Advert.featurable
    @mapping_adverts = Page.display('mapping_adverts')
    @local_search = Page.display('local_search')
    @local_reviews = Page.display('local_reviews')
    @local_stations = Page.display('local_stations')
    @travel_search = Page.display('travel_search')
    @sign_up = Page.display('sign_up')
  end

  def show_picture
    @picture = Picture.find(params[:id])
    send_data(@picture.data, :filename => @picture.name, :type => @picture.content_type, :disposition => "inline")
  end
  
  def terms_and_conditions
    @article = Page.find_by_permalink("terms-and-conditions")
  end
  
  def contact_us
    @page = Page.find_by_permalink('contact_us')
    if request.post?
      UserMailer.deliver_contact_mail(params[:contact_us][:message], params[:contact_us][:email])
      flash[:notice] = "Thank you for you message"
      redirect_to(session[:referer_uri] || {:controller => 'page', :action => 'welcome'})
    else
      session[:referer_uri] = request.env["HTTP_REFERER"]
    end
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @pages = Page.list(params[:page])
    #@page_pages, @pages = paginate :pages, :per_page => 10
  end
  
  def article_list
    @page = Page.display("Articles")
    @articles = Page.get_articles
  end
  
  # slightly dodgy hack to get around weird problem with the caching and showing articles with and without ajax
  def show_article
    @article = Page.find(params[:id])
  end
  
  # slightly dodgy hack to get around weird problem with the caching and showing articles with and without ajax
  def ajax_show_article
    @article = Page.find(params[:id])
    render :partial => 'article'
  end

  def show
    @page = Page.find(params[:id])
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])
    if @page.save
      flash[:notice] = 'Page was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @page = Page.find(params[:id])
  end

  def update
    @page = Page.find(params[:id])
    if @page.update_attributes(params[:page])
      flash[:notice] = 'Page was successfully updated.'
      redirect_to :action => 'show', :id => @page
    else
      render :action => 'edit'
    end
  end

  def destroy
    Page.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
