set :ip, "104.237.136.12"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"