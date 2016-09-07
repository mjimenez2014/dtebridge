set :ip, "45.33.125.40"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"