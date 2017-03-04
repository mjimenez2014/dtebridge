set :ip, "200.72.145.75"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"