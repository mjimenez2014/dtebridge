set :ip, "45.33.117.5"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"