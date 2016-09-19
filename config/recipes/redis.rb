namespace :redis do
  set_default(:redis_port, 6379)
  desc "Install redis"
  task :install do
    run "cd /tmp && wget https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/redis/redis-2.6.14.tar.gz"
    
    run "cd /tmp && tar xzf redis-2.6.14.tar.gz"
    run "cd /tmp/redis-2.6.14 && make" 
  end

  task :setup do
    # Copy files to a proper place
    run "#{sudo} cp /tmp/redis-2.6.14/src/redis-benchmark /usr/local/bin/"
    run "#{sudo} cp /tmp/redis-2.6.14/src/redis-cli /usr/local/bin/"
    run "#{sudo} cp /tmp/redis-2.6.14/src/redis-server /usr/local/bin/"
    run "#{sudo} cp /tmp/redis-2.6.14/redis.conf #{shared_path}/config/redis.conf"
    # Modify redis.conf
    run "#{sudo} sed -i 's/daemonize no/daemonize yes/' #{shared_path}/config/redis.conf"
    run "#{sudo} sed -i 's/redis.pid/redis_6379.pid/' #{shared_path}/config/redis.conf"
  end
  after "deploy:setup", "redis:setup"

  desc "Start the Redis server"
  task :start do
    run "redis-server &"
  end

  desc "Stop the Redis server"
  task :stop do
    run 'redis-cli shutdown'
  end
end