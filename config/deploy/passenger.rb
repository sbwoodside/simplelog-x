#
# = Capistrano Passenger deploy tasks
#
# Provides tasks for deploying a Rails application with Passenger (aka mod_rails).
#
# Category::    Capistrano
# Package::     Passenger
# Author::      Simone Carletti
# Copyright::   2007-2008 The Authors
# License::     MIT License
# Link::        http://www.simonecarletti.com/
# Source::      http://gist.github.com/2769
#
#

unless Capistrano::Configuration.respond_to?(:instance)
  abort "This extension requires Capistrano 2"
end

Capistrano::Configuration.instance.load do

  namespace :passenger do

    desc <<-DESC
      Restarts your application. \
      This works by creating an empty `restart.txt` file in the `tmp` folder
      as requested by Passenger server.
    DESC
    task :restart, :roles => :app, :except => { :no_release => true } do
      run "touch #{current_path}/tmp/restart.txt"
    end

    desc <<-DESC
      Starts the application servers. \
      Please note that this task is not supported by Passenger server.
    DESC
    task :start, :roles => :app do
      logger.info ":start task not supported by Passenger server"
    end

    desc <<-DESC
      Stops the application servers. \
      Please note that this task is not supported by Passenger server.
    DESC
    task :stop, :roles => :app do
      logger.info ":stop task not supported by Passenger server"
    end

  end

  namespace :deploy do

    desc <<-DESC
      Restarts your application. \
      Overwrites default :restart task for Passenger server.
    DESC
    task :restart, :roles => :app, :except => { :no_release => true } do
      passenger.restart
    end

    desc <<-DESC
      Starts the application servers. \
      Overwrites default :start task for Passenger server.
    DESC
    task :start, :roles => :app do
      passenger.start
    end

    desc <<-DESC
      Stops the application servers. \
      Overwrites default :start task for Passenger server.
    DESC
    task :stop, :roles => :app do
      passenger.stop
    end

  end

end