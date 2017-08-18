set :ip, "104.200.18.151"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"