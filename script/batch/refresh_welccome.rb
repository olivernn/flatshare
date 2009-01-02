#this script will refresh the welcome page cache
require 'open-uri'

filename = "/home/admin/public_html/londonflatmate.net/current/public/index.html"
File.delete(filename) if File.exists?(filename)

#uncomment the line below when live to regenerate the cache
open("http://londonflatmate.net")