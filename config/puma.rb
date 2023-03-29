# frozen_string_literal: true

max_threads_count = ENV.fetch('RAILS_MAX_THREADS', 5)
min_threads_count = ENV.fetch('RAILS_MIN_THREADS', max_threads_count)
threads min_threads_count, max_threads_count

port ENV.fetch('PORT', 3000)

rails_env = ENV.fetch('RAILS_ENV', 'development')
environment rails_env

app_dir = File.expand_path('..', __dir__)
pidfile "#{app_dir}/tmp/pids/puma.pid"

daemonize rails_env != 'development'

if rails_env != 'development'
  workers ENV.fetch('WEB_CONCURRENCY', 1)
  tag "MYAPP #{rails_env.upcase} WORKER"
end

plugin :tmp_restart
