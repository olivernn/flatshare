RAILS_ROOT = "/home/admin/public_html/londonflatmate.net/current"

%w{3000 3001 3002}.each do |port|
  God.watch do |w|
    w.name = "londonflatmate.net-thin-#{port}"
    w.interval = 60.seconds
    w.start = "thin --prefix #{RAILS_ROOT} 
                    --environment production 
                    --port #{port} 
                    --pid /home/admin/public_html/londonflatmate.net/shared/pids/thin.#{port}.pid
                    start"
                    
    w.stop = "thin --pid /home/admin/public_html/londonflatmate.net/shared/pids/thin.#{port}.pid
                   stop"
                   
    w.restart = "thin --pid /home/admin/public_html/londonflatmate.net/shared/pids/thin.#{port}.pid
                      restart"
    
    w.start_grace = 20.seconds
    w.restart_grace = 20.seconds
    w.pid_file = "/home/admin/public_html/londonflatmate.net/shared/pids/thin.#{port}.pid"
    
    w.behavior(:clean_pid_file)
    
    w.start_if do |start|
      start.condition(:process_running) do |c|
        c.interval = 5.seconds
        c.running = false
      end
    end
    
    w.restart_if do |restart|
      restart.condition(:memory_usage) do |c|
        c.above = 65.megabytes
        c.times = [3, 5] #restart if memory is above 65 MB 3 times out of 5 checks
        c.notify = "admin"
      end
      
      restart.condition(:cpu_usage) do |c|
        c.above = 50.percent
        c.times = 5
        c.notify = "admin"
      end
    end
    
    w.lifecycle do |on|
      on.condition(:flapping) do |c|
        c.to_state = [:start, :restart]
        c.times = 5
        c.within = 5.minute
        c.transition = :unmonitored
        c.retry_in = 10.minutes
        c.retry_times = 5
        c.retry_within = 2.hours
        c.notify = "admin"
      end
    end
  end
end

God::Contacts::Email.message_settings = {
  :from => 'app@londonflatmate.net'
}

God::Contacts::Email.server_settings = {
  :address => "smtp.gmail.com",
  :port => 587,
  :authentication => :plain,
  :user_name => "admin@londonflatmate.net",
  :password => 'computer'
}

God.contact(:email) do |c|
  c.name = "admin"
  c.email = "admin@londonflatmate.net"
end