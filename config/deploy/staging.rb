set :ip, "45.33.10.89"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'staging'
set :branch, "master"