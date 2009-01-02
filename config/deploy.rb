set :application, "londonflatmate.net"
set :user, "admin"
set :repository,  "http://onightin.svn.beanstalkapp.com/rails_projects/flatshare/"

set :runner, user
set :use_sudo, true

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

set :port, 30000
set :deploy_to, "/home/admin/public_html/#{application}"


#makes sure only the workstation can connect to the repository
set :deploy_via, :copy

#this points to the ssh key since we called it something different
ssh_options[:keys] = %w(~/.ssh/key)
ssh_options[:port] = 30000

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, application
role :web, application
role :db, application, :primary => true

desc "move pictures directory somewhere safe during deployment"
task :move_pictures_to_tmp do
  sudo "mv /home/admin/public_html/londonflatmate.net/current/public/pictures /home/admin/tmp/pictures"
end

desc "move pictures directory back into latest release"
task :move_pictures_to_current do
  sudo "mv /home/admin/tmp/pictures /home/admin/public_html/londonflatmate.net/current/public/pictures"
end

desc "Reload Nginx"
task :reload_nginx do
  sudo "/etc/init.d/nginx reload"
end
 
desc "Restart Thin"
task :restart_thin do
  sudo "/etc/init.d/thin restart"
end

desc "Backup the remote database and pictures to local"
namespace :backup do
  task :db do  
    filename = "flatshare_production_#{Time.now.to_s.gsub(/ /, "_")}.sql.gz"
    server_filename = "/home/admin/tmp/#{filename}"
    local_filename = "/Users/Oliver/Documents/rails_projects/LondonFlatmate.net/db_backups/#{filename}"

    on_rollback { run "rm #{server_filename}" }

    run "mysqldump -u flatshare -p flatshare_production | gzip > #{server_filename}" do |ch, stream, out|
      ch.send_data "computer\n" if out =~ /^Enter password:/
    end
    #system `rsync #{user}@#{application}:#{filename} /Users/Oliver/Documents/rails_projects/LondonFlatmate.net`
    get server_filename, local_filename
    sudo "rm #{server_filename}"
  end
  
  task :pictures do
    filename = "pictures_backup_#{Time.now.to_s.gsub(/ /, "_")}.tar.gz"
    
    server_filename = "/home/admin/tmp/#{filename}"
    local_filename = "/Users/Oliver/Documents/rails_projects/LondonFlatmate.net/picture_backups/#{filename}"
    
    on_rollback { run "rm #{server_filename}"}
    
    run "tar -zcvf #{server_filename} /home/admin/public_html/londonflatmate.net/current/public/pictures/"
    
    get server_filename, local_filename
    sudo "rm #{server_filename}"
  end
end

before "deploy", "move_pictures_to_tmp"
after "deploy", "move_pictures_to_current"
after "move_pictures_to_current", "deploy:cleanup"
after "deploy:cleanup", "reload_nginx"
after "reload_nginx", "restart_thin"