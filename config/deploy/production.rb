set :ip, "45.56.66.85"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"