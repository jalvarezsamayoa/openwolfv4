set :applicationdir, "/home/transparencia/public_html/#{application}"
set :deploy_to, "/home/transparencia/public_html/#{application}"

role :web, "transparencia.gob.gt"                          # Your HTTP server, Apache/etc
role :app, "transparencia.gob.gt"                          # This may be the same as your `Web` server
role :db,  "transparencia.gob.gt", :primary => true # This is where
# Rails
role :solr, "transparencia.gob.gt"

# migrations will run
set :backup_dir, "#{deploy_to}/backups"

set :branch, "master"

set :deploy_env, 'production'
set :rails_env, "production"

set :bundle_exec, "bundle exec"

set :rvm_ruby_string, '1.8.7'
set :rvm_bin_path, "/usr/local/rvm/bin"
set :repository, "git://gitorious.org/openwolf/openwolf_v3.git"

set :user, "transparencia"

after "deploy:symlink", :symlink_gems

before "deploy:update_code", "solr:stop"
after "deploy:symlink", "solr:symlink"
after "solr:symlink", "solr:start"


before "deploy:restart", "solr:stop"
before "deploy:restart", "delayed_job:stop"

after "deploy:restart", "solr:start"
after "deploy:restart", "delayed_job:start"

after "deploy:stop", "solr:stop"
after "deploy:stop",  "delayed_job:stop"

after "deploy:start", "solr:start"
after "deploy:start", "delayed_job:start"


desc "Vincular directorio de gems"
task :symlink_gems, :roles => :app do
  puts "\n\n=== Vinculando Gems ===\n\n"
  run <<-CMD
    cd #{release_path} &&
    ln -nfs #{shared_path}/bundle #{current_path}/vendor/gems &&
    bundle install --path vendor/gems
  CMD
end

namespace :solr do
  desc "Link in solr directory"
  task :symlink, :roles => :solr do
    run <<-CMD
      cd #{release_path} &&
      ln -nfs #{shared_path}/solr #{release_path}/solr
    CMD
  end

  desc "Before update_code you want to stop SOLR in a specific environment"
  task :stop, :roles => :solr do


    run <<-CMD
      cd #{current_path} &&
      bundle exec rake sunspot:solr:stop RAILS_ENV=#{rails_env} ; true
    CMD


  end

  desc "After update_code you want to restart SOLR in a specific environment"
  task :start, :roles => :solr do
    run <<-CMD
      cd #{current_path} &&
      nohup bundle exec rake sunspot:solr:start RAILS_ENV=#{rails_env} > #{shared_path}/log/solr.log 2> #{shared_path}/log/solr.err.log
    CMD
  end

  desc "Reindexar solr"
  task :reindex, :roles => :solr do
    run <<-CMD
      cd #{current_path} &&
      bundle exec rake sunspot:solr:reindex RAILS_ENV=#{rails_env}
    CMD
  end
end

