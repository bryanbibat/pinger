require "bundler/capistrano"
require "delayed/recipes"

set :deploy_via, :remote_cache
set :application, "pinger"
set :repository, "git://github.com/bryanbibat/pinger.git"
set :deploy_to, "/home/bry/capistrano/pinger"

set :scm, :git

default_run_options[:pty] = true

server "bryanbibat.net", :app, :web, :db, :primary => true
set :user, "bry"
set :use_sudo, false

depend :remote, :gem, "bundler"

set :rails_env, :production


namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after "deploy:stop",    "delayed_job:stop"
after "deploy:start",   "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

before "deploy:finalize_update", :copy_production_database_configuration, :copy_secret_token

task :copy_production_database_configuration do
  run "cp #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

task :copy_secret_token do
  run "cp #{shared_path}/config/secret_token.rb #{release_path}/config/initializers/secret_token.rb"
end
