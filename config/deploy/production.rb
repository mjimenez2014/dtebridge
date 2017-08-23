set :ip, "45.33.14.90"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"