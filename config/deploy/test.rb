set :applicationdir, "/var/www/#{application}"
set :deploy_to, "/var/www/#{application}"

role :web, "test.openwolf.org"                          # Your HTTP server, Apache/etc
role :app, "test.openwolf.org"                          # This may be the same as your `Web` server
role :db,  "test.openwolf.org", :primary => true        # This is where Rails


# migrations will run
set :backup_dir, "/home/ubuntu/backups"

set :branch, "master"

set :deploy_env, 'staging'
set :rails_env, "staging"

set :bundle_exec, ""

set :rvm_ruby_string, '1.9.3'
set :rvm_bin_path, "/usr/local/rvm/bin"

set :repository, "git@github.com:jalvarezsamayoa/OpenWolf.git"

before "deploy:restart", "delayed_job:stop"
after "deploy:restart", "delayed_job:start"

after "deploy:stop",  "delayed_job:stop"
after "deploy:start", "delayed_job:start"

