set :ip, "192.168.1.87"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"