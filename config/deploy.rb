set :application, 'savina_rails'
set :repo_url, 'git@github.com:dsavin/savina_rails.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }


set :scm, :git

set :format, :pretty
set :log_level, :debug
set :pty, true

set :rvm_ruby_version, '2.1.5'
# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'cache:clear'
      end
    end
  end

  after :finishing, 'deploy:cleanup'

end

namespace :figaro do
  desc 'SCP transfer figaro configuration to the shared folder'
  task :setup do
    on roles(:app) do
      upload! 'config/application.yml', "#{shared_path}/application.yml", via: :scp
    end
  end

  desc 'Symlink application.yml to the release path'
  task :symlink do
    on roles(:app) do
      execute "ln -sf #{shared_path}/application.yml #{release_path}/config/application.yml"
    end
  end
end
after 'deploy:started', 'figaro:setup'
after 'deploy:updating', 'figaro:symlink'
