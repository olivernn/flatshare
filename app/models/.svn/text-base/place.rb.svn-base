class Place
  attr_accessor :name, :address, :rating, :description, :url, :category, :id
  
  def initialize(name, address, rating, description, url, category, id)
    @name = clean(name)
    @address = clean(address)
    @rating = clean(rating)
    @description = clean(description)
    @url = url
    @category = category
    @id = id
  end
  
  def reviews
    get_reviews(self.id)
  end
  
  private
  
  def clean(text)
    CGI.unescapeHTML(text)
  end
  
  def get_reviews(id)
    url = "http://trustedplaces.com/api/rest/place/reviews?place=#{id}&key=d4d1b39b8e2ccde70a054cfc32b374a8"
    begin
      response = open(url) { |f| Hpricot(f) }
      reviews = Array.new
      response.search("//body").each do |body|
        reviews << clean(body.inner_html)
      end
      reviews
    #this should catch a timeout error and stop everything blowing up
    rescue StandardError, Interrupt
      nil
    end
  end
end