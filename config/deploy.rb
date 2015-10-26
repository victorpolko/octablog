# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'gulp_on_rails'
set :repo_url, 'REPO_URL'

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/rails/gulp_on_rails'

# capistrano/rvm
set :rvm_type, :user # Defaults to: :auto
set :rvm_ruby_version, File.read('.ruby-version').strip
set :rvm_custom_path, '~/.rvm'  # only needed if not detected

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :rails_env, 'production'

set :deploy_via,    :remote_cache
set :ssh_options,   { forward_agent: true }
set :use_sudo,      false
set :default_stage, 'staging'

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'pids', 'tmp/cache', 'tmp/pids',  'sockets', 'vendor/bundle', 'public/system', 'private/invoices')

# Default value for default_env is {}
set :default_env, { path: "/opt/ruby/bin:$PATH" }

set :sidekiq_pid, -> { File.join(shared_path, 'pids', 'sidekiq.pid') }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  desc 'Start unicorn'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cd #{ current_path }; ~/.rvm/bin/rvm #{ fetch :rvm_ruby_version } do bundle exec unicorn -c config/unicorn.rb -E #{ fetch :rails_env } -D"
    end
  end

  desc 'Stop unicorn'
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute "kill -s QUIT `cat #{ shared_path }/pids/unicorn.pid`"
    end
  end

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "kill -s USR2 `cat #{ shared_path }/pids/unicorn.pid`"
    end
  end

  desc 'install assets dependencies with bower'
  task :prepare_assets_dependencies do
    on roles(:web) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bower, :install
        end
      end
    end
  end
  before 'deploy:updated', 'deploy:prepare_assets_dependencies'

  # and run 'cap production deploy:seed' to seed your database
  desc 'Runs rake db:seed'
  task seed: [:set_rails_env] do
    on primary fetch(:migration_role) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  after :normalize_assets, :gzip_assets do
    on release_roles(fetch(:assets_roles)) do
      assets_path = release_path.join('public', fetch(:assets_prefix))
      within assets_path do
        execute :find, ". \\( -name '*.js' -o -name '*.css' \\) -exec test ! -e {}.gz \\; -print0 | xargs -r -P8 -0 gzip --best --quiet"
      end
    end
  end
end
