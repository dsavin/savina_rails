set :stage, :production
set :deploy_to, '/var/www/savina_production'
set :env, 'production'
set :branch, 'master'
role :app, %w{deployer@37.139.8.137:10308}
role :web, %w{deployer@37.139.8.137:10308}
role :db,  %w{deployer@37.139.8.137:10308}

server '37.139.8.137', user: 'deployer', roles: %w{web app db}, port: 10308
set :nginx_server_name, 'savina.com.ua'