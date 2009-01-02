# script will send an invitation to moveflat adverts
require 'rubygems'
require 'mechanize'
require 'open-uri'
advert_ids = Array.new
a = WWW::Mechanize.new { |agent| agent.user_agent_alias = 'Mac Safari'}
page = a.get("http://moveflat.com")
page.search("//a[@class='xu']").each do |link|
  advert_ids << link.attributes['href'].reverse.chop.chop.chop.reverse.chop.chop.chop.chop
end

advert_ids.each do |advert_id|
  puts advert_id
  mail_page = a.get("http://www.moveflat.co.uk/cgi-bin/abr.asp?FUN=email&ID=#{advert_id}")
  form = mail_page.form_with(:action => 'abr.asp')
  form.EM = "oliver@londonflatmate.net"
  form.TX = "I hope that your advert is a successful one and you are getting lots of genuine interest.  I know that when I was trying to use flatsharing websites when moving out of my previous flat it was a bit of a nightmare, so much so that I thought I would try and do something about it, which is why I set up http://LondonFlatmate.net

  http://LondonFlatmate.net is a new website which aims to make the whole process a lot easier, we are brand new and we really need people to come over and have a look, sign up and give us some feedback.

  The whole thing is completely free so why not come over to http://LondonFlatmate.net and create an advert, it can't hurt to have one more advert out there can it!

  Thanks,

  Oliver"
  form.submit
end
  
