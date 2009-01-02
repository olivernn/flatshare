#this script will remove all sessions greater than 30 mins old
require 'mysql'

#connect to mysql
m = Mysql.new("localhost", "flatshare", "computer")

#the time 30 mins ago, for use in the query below
t = Time.now - 1800

m.select_db("flatshare_production")
m.query("DELETE FROM sessions WHERE updated_at < '#{t.strftime('%Y-%m-%d %H:%M:%S')}'")
m.close