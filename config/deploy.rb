require "bundler/capistrano"
require 'capistrano/ext/multistage'
 
# Load recipes
load "config/recipes/base"
load "config/recipes/git"
load "config/recipes/make"
load "config/recipes/nginx"
load "config/recipes/unicorn"
load "config/recipes/postgresql"
load "config/recipes/nodejs"
load "config/recipes/rbenv"
load "config/recipes/check"
load "config/recipes/solr"
load "config/recipes/redis"
load "config/recipes/bundler"
load "config/recipes/sidekiq"
load "config/recipes/ruby_dev"
load "config/recipes/python"
load "config/recipes/libxslt"
load "config/recipes/imagemagick"
load "config/recipes/image_compression"

set :stages, %w( staging production elsultan )
set :default_stage, "production"

# Application info
set :user, "deployer"
set :application, "dtebridge"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false

# Repository info
set :scm, "git"
set :git_user, 'mjimenez2014'
set :repository, "git@github.com:#{git_user}/#{application}.git"


default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# Keep only the last 5 releases
# before "deploy:update_code", "sidekiq:quiet"
after "deploy", "deploy:cleanup" 
# after "deploy",    "sidekiq:stop"
after "deploy",   "sidekiq:start"
