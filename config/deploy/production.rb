set :ip, "173.255.204.241"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"