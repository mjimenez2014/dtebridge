set :ip, "45.79.2.65"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"