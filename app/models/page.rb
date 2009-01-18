class Page < ActiveRecord::Base
  require 'hpricot'
  acts_as_textiled :content
  
  #this overrides the way rails creates the url, we're adding the permalink in here
  def to_param
    "#{id}-#{permalink}"
  end
  
  def self.list(page)
    paginate(:per_page => 10, :page => page)
  end
  
  def self.display(name)
    find_by_name(name)
  end
  
  def self.get_articles
    find(:all, :conditions => ["help_page = 1"])
  end
  
  def self.get_footer
    find(:all, :conditions => ["footer_page = 1"])
  end
  
  def snippet
    wordcount = 35
    (self.content.split[0..(wordcount-1)].join(" ") + (self.content.split.size > wordcount ? "..." : "")).gsub(/<\/?[^>]*>/,  "")
  end
  
  def paragraphs
    arr = Array.new
    html = Hpricot.parse(self.content)
    (html/:p).each do |p|
      arr << p.to_html
    end
    arr
  end
end
