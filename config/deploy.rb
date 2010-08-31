# Capistrano deploy settings for Passenger & Git

# Application
set :application, "deployed-swc-weblog"
set :deploy_to, "/home/simon/#{application}"

# Version control
set :repository,  "git://github.com/sbwoodside/simplelog-x.git"
set :scm, "git"
set :git_enable_submodules, 1

set :user, "simon"
set :ssh_options, { :forward_agent => true }
role :app, "simonwoodside.com"
role :web, "simonwoodside.com"
role :db,  "simonwoodside.com", :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end
