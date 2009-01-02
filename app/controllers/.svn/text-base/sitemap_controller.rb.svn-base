class SitemapController < ApplicationController
  def sitemap
    @adverts = Advert.find(:all, :order => 'created_at DESC', :limit => 50000)
    @pages = Page.get_articles
    headers["Content-Type"] = "text/xml"
    headers["Last-Modified"] = @adverts.first.created_at.httpdate unless @adverts.empty?
  end
end
