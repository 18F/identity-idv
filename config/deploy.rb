set :application, 'upaya-idv'
# set branch based on env var or ask with the default set to the current local branch
set :branch,  ENV['branch'] || ENV['BRANCH'] || ask(:branch, `git branch`.match(/\* (\S+)\s/m)[1])
set :bundle_without, 'deploy development doc test'
set :deploy_via, :remote_cache
set :keep_releases, 5
set :passenger_restart_with_touch, true
set :rbenv_ruby, '2.3.0'
set :rbenv_type, :user # or :system, depends on your rbenv setup
set :repo_url, 'https://github.com/18F/identity-idv.git'
set :ssh_options,  forward_agent: false
set :user, :ubuntu

#########
# TASKS
#########
namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end
