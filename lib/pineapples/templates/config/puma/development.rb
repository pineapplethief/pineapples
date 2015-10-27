workers Integer(ENV.fetch('WEB_CONCURRENCY', 1))
threads_count = Integer(ENV.fetch('MAX_THREADS', 3))
threads(threads_count, threads_count)
daemonize false

# !Important: Puma can't bind to sockets created in VirtualBox shared folders
bind "unix:///tmp/sockets/#{app_name}-puma.sock"
pidfile 'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

preload_app!

rackup DefaultRackup
environment 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
  # puts 'Reconnecting Rails.cache'
  # Rails.cache.reconnect
end
