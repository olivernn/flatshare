# dirty script that will get email addresses from gumtree adverts

require 'rubygems'
require 'hpricot'
require 'mechanize'
require 'open-uri'
require 'cgi'

a = WWW::Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari'}

file = File.new("/users/oliver/documents/rails_projects/gumtree_20081130.txt", "w+")

[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].each do |page_number|
  doc = open("http://www.gumtree.com/london/5046_#{page_number}.html") { |f| Hpricot(f) }
  doc = a.get("http://www.gumtree.com/london/5046_#{page_number}.html")

  doc.search("//div[@class=posting_row1] a").each do |link|
    ad_page = a.click(link)
    email_page = a.click(ad_page.search("//div[@id=contact_details] a"))
    form = email_page.form_with(:name => "email_friend")
    form.from_email = "oliver@londonflatmate.net"
    form.message = "I hope that your advert is a successful one and you are getting lots of genuine interest.  I know that when I was trying to use flatsharing websites when moving out of my previous flat it was a bit of a nightmare, so much so that I thought I would try and do something about it, which is why I set up http://LondonFlatmate.net

    http://LondonFlatmate.net is a new website which aims to make the whole process a lot easier, we are brand new and we really need people to come over and have a look, sign up and give us some feedback.

    The whole thing is completely free so why not come over to http://LondonFlatmate.net and create an advert, it can't hurt to have one more advert out there can it!

    Thanks,

    Oliver"
    
    
    
    
    advert = open("http://www.gumtree.com#{link.attributes['href']}") { |f| Hpricot(f) }
    email = advert.search("//div[@id=contact_details] a").inner_html
    file.puts(CGI.unescapeHTML email) unless email.empty? || email == "Click here to reply to this ad"
  end
end