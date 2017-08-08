set :ip, "45.33.19.61"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"