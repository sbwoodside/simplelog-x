require 'mongrel_cluster/recipes'

set :application, "deployed-semacode.com"
set :repository,  "https://ssl.semacode.com:8443/svn/web/website/trunk"
set :deploy_to, "/var/www/#{application}"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :use_sudo, false

role :app, "www-data@semacode.com"
role :web, "www-data@semacode.com"
role :db,  "www-data@semacode.com", :primary => true

ssh_options[:paranoid] = false 
