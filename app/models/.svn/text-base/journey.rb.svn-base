class Journey < ActiveRecord::Base
  require 'mechanize'
  attr_accessor :duration, :legs, :origin, :destination, :success
  
  validates_as_uk_postcode :origin, :destination
  
  def initialize(origin, destination)
    @origin = origin
    @destination = destination
    @success = true
    self.calculate unless destination.empty?
  end
  
  def calculate
    a = new_browser
    begin
      page = a.get('http://tfl.gov.uk/')
      search_result = page.form_with(:name => 'jpForm') do |search_form|
        search_form.name_origin = @origin
        search_form.fields.name('type_origin').options[1].select
        search_form.name_destination = @destination
        search_form.fields.name('type_destination').options[1].select
      end.submit
    #this should catch a timeout error and stop everything blowing up
    rescue StandardError, Interrupt
      @success = false
      search_result = nil
    end
    
    @legs = Array.new
    if search_sucessful(search_result)
      begin
        details_page = a.click(search_result.links.text(/View/)[0])
        details_page.search("//table[@class='routedetails'] tr").each do |step|
          if step.search("//th").empty?
            @legs << step.search("//td")[1].inner_html.gsub(/<a\/?[^>]*>/,  "")
          end
        end
        @duration = search_result.search("//td[@class='duration']").first.inner_html
      #this should catch a timeout error and stop everything blowing up
      rescue StandardError, Interrupt
        #do nothing, we handle there being no results in the view
        @success = false
      end
    end
  end
  
  private
  def new_browser
    WWW::Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari'}
  end
  
  def search_sucessful(result)
    if result
      !result.search("//p[@class='routealert-red-full']").inner_html.include?("Journey Planner has no record of those locations. Please check your spelling or enter more information")
    end
  end
end