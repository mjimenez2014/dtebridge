set :ip, "198.58.96.218"
server "#{ip}", :web, :app, :db, primary: true
set :rails_env, 'production'
set :branch, "master"