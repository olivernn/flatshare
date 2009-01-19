# this script will refresh the welcome page cache
# deliberate misspelling of the name to match the crontab
require 'open-uri'
puts Time.now.to_s + " - Refreshing page caches"

# constants throughout the script
FILEPATH = "/home/admin/public_html/londonflatmate.net/current/public/"
EXTENSION = ".html"
SERVER = "http://londonflatmate.net/"

# add the name of the cache to periodically expire to the array
caches_to_expire = Array[
  "index",
  "flatshare"]
  
# loop to refresh_page_cache
caches_to_expire.each do |cache|
  filename = FILEPATH + cache + EXTENSION
  File.delete(filename) if File.exists?(filename)
  open(SERVER + (cache == "index" ? "" : cache))
end