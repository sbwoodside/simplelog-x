# This software is licensed under GPL v2 or later. See doc/LICENSE and doc/CONTRIBUTORS for details.

require 'mongrel_cluster/recipes'

# This is for capistrano
# DEPLOY: You must change these settings for your own repository/server settings

set :application, "deployed-swc-weblog"
set :repository,  "git://github.com/sbwoodside/simplelog-x.git"
set :scm, "git"
set :deploy_to, "/home/simon/#{application}"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
set :use_sudo, false

role :app, "simon@simonwoodside.com"
role :web, "simon@simonwoodside.com"
role :db,  "simon@simonwoodside.com", :primary => true

ssh_options[:paranoid] = false 
