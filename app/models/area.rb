class Area < ActiveRecord::Base
  require 'hpricot'
  def self.interpret(input_string)
    # try and find by the name of the area e.g. "Battersea"
    area &&= self.find_by_name(input_string).name
    unless area
      # try and find by the postcode area, e.g. SW11
      area = self.create_name_string(self.find(:all, :conditions => ['postcode_area =?', input_string]))
      unless area
        # try and find by borough e.g. "Wandsworth"
        area = self.create_name_string(self.find(:all, :conditions => ['borough like ?', "%" + input_string+ "%"]))
        unless area
          # can't find the area, ignore this parameter
          area = nil
        end
      end
    end
    area
  end
  
  def self.get_areas(input_string)
    if input_string
      find(:all, :conditions => ['name LIKE ?', '%' + input_string + '%'], :order => 'name ASC')
    end
  end
  
  def self.get_description
    areas = Area.find(:all)
    areas.each do |a|
      puts a.name
      begin
        doc = open("http://www.net-lettings.co.uk/London-Area-Guides/#{a.name.gsub(' ', '-')}.html") { |f| Hpricot(f) }
        a.description = CGI.unescapeHTML(doc.search("//div[@class=infoWindowContentPadded]").first.inner_html)
        a.save
      rescue
        puts a.name + " no description"
      end
    end
  end
  
  def self.create_name_string(areas)
    arr = Array.new
    unless areas.empty?
      areas.each do |a|
        arr << a.name
      end
      arr.join("")
    else
      nil
    end
  end
end
