# use bundler
require "bundler/capistrano"

load 'deploy/assets'

set :application, "debris"
#set :repository,  "/Users/btm/develop/hackathon/spaceappchallenge2013/dearmydebris/.git"
set :repository,  "git://github.com/International-Space-Apps-Challenge-Tokyo/dearmydebris-server.git"
set :scm, 'git'

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "157.7.139.169"                          # Your HTTP server, Apache/etc
role :app, "157.7.139.169"                          # This may be the same as your `Web` server
role :db,  "157.7.139.169", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

set :user, "debris"

set :deploy_to, "/usr/local/apps/#{application}"
set :deploy_via, :copy
set :rails_env, "production"
set :copy_exclude, [".git/*"]
set :use_sudo, false
set :copy_cache, true

set :normalize_asset_timestamps, false
set :copy_remote_dir, "/home/#{user}/deploycache"

default_environment["RAILS_ENV"] = 'production'
#default_environment["RBENV_ROOT"] = '$HOME/.rbenv'
# default_environment["PATH"] = '/opt/local/bin:/usr/local/bin:/usr/bin:/bin:$HOME/.rbenv/shims:$HOME/.rbenv/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/pgsql-9.2/bin'

#before 'deploy:assets:precompile' do
#  run "cp /usr/local/apps/#{application}_config/database.yml #{release_path}/config/database.yml"
#  run "cp /usr/local/apps/#{application}_config/settings.local.yml #{release_path}/config/settings.local.yml"
#end

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

# after 'deploy:create_symlink', 'deploy:migrate'

namespace :deploy do
  task :start, :except => { :no_release => true } do
    run "cd #{current_path} ; BUNDLE_GEMFILE=#{current_path}/Gemfile bundle exec unicorn_rails -c config/unicorn.rb -D"
  end
 
  task :stop, :except => { :no_release => true } do
    run "kill -s QUIT `cat /tmp/#{application}_unicorn_production.pid`"
  end
  
  task :restart, :except => { :no_release => true } do
    run "kill -s USR2 `cat /tmp/#{application}_unicorn_production.pid`"
  end
end


