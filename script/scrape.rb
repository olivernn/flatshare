# dirty script that will get email addresses from gumtree adverts

require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'cgi'

file = File.new("/users/oliver/documents/rails_projects/gumtree_20090118.txt", "w+")

[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].each do |page_number|
  doc = open("http://www.gumtree.com/london/2509_#{page_number}.html") { |f| Hpricot(f) }

  doc.search("//div[@class=posting_row1] a").each do |link|
    advert = open("http://www.gumtree.com#{link.attributes['href']}") { |f| Hpricot(f) }
    email = advert.search("//div[@id=contact_details] a").inner_html
    file.puts(CGI.unescapeHTML email) unless email.empty? || email == "Click here to reply to this ad"
  end
end