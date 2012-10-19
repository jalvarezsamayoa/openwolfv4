set :stages, %w(production staging testing)
set :default_stage, "testing"

require 'bundler/capistrano'
require 'delayed/recipes'
require 'capistrano/ext/multistage'

# $:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'
set :rvm_type, :system

set :rails_root, "#{File.dirname(__FILE__)}/.."
require "#{rails_root}/config/capistrano_database_yml.rb"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano"

default_run_options[:pty] = true

set :scm, "git"

set :deploy_via, :remote_cache
set :use_sudo, false

#set :git_enable_submodules, 1

task :uname do
  run "uname -a"
end


namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end



namespace :openwolf do
  namespace :db do

    desc "Genera un backup del servidor de produccion y lo restaura en local"
    task :backup, :roles => :db, :only => { :primary => true } do
      puts "Remove old backups"
      run <<-CMD
     cd #{backup_dir} &&
     rm *.bz2; true
  CMD

      timestamp = Time.now.to_f
      filename = "#{application}.dump.#{timestamp}.sql.bz2"
      clean_filename = "#{application}.dump.#{timestamp}.sql"
      file_path = "#{backup_dir}/" + filename
      text = capture "cat #{deploy_to}/current/config/database.yml"
      yaml = YAML::load(text)

      on_rollback { run "rm #{file_path}" }

      puts "Backup database..."
      run "pg_dump --clean --no-owner --no-privileges -U#{yaml['production']['username']} -h#{yaml['production']['host']} #{yaml['production']['database']} | bzip2 > #{file_path}" do |ch, stream, out|
        ch.send_data "#{yaml['production']['password']}\n" if out =~ /^Password:/
        puts out
      end

      puts "Downloading file..."
      download(file_path, "/home/javier/Backup/#{filename}")

      puts "Extracting file"
      system("bunzip2 /home/javier/Backup/#{filename}")
      system("psql -h localhost -p 5432 -U openwolf -W -d openwolf_development < /home/javier/Backup/#{clean_filename}")

    end

    desc "Restaura backup de base de datos a servidor de produccion o staging"
    task :restore, :roles => :db, :only => { :primary => true } do

      timestamp = Time.now.to_f
      filename = "#{application}.dump.#{timestamp}.sql.bz2"
      clean_filename = "#{application}.dump.#{timestamp}.sql"
      file_path = "#{File.dirname(__FILE__)}/../tmp/" + filename
      #      text = capture "cat ../config/database.yml"
      text = File.open("#{File.dirname(__FILE__)}/../config/database.yml",'r')
      yaml = YAML::load(text.read)
      text.close

      puts "Backup database..."
      # system "pg_dump --clean --no-owner --no-privileges -U#{yaml['development']['username']} -h#{yaml['development']['host']} #{yaml['development']['database']} | bzip2 > #{file_path}" do |ch, stream, out|
      #   ch.send_data "#{yaml['development']['password']}\n" if out =~ /^Password:/
      #   puts out
      # end
      system "pg_dump --clean --no-owner --no-privileges -U#{yaml['development']['username']} -h#{yaml['development']['host']} #{yaml['development']['database']} | bzip2 > #{file_path}"

      backup_file = "/tmp/#{filename}"

      puts "Uploading file: #{file_path} to #{backup_file}"
#      system("scp -C #{file_path} transparencia@transparencia.gob.gt://#{backup_file}")
      system("scp -i ~/.ssh/openwolf.pem -C #{file_path} ubuntu@test.openwolf.org:/#{backup_file}")

      puts "Extracting file #{backup_file}"
      run "bunzip2 #{backup_file}"

      puts "Restoring Backup"
      #user_name = yaml[rails_env]['username']
      #db_name = yaml[rails_env]['database']
      
#      pwd = yaml[rails_env]['password']
      user_name = "openwolf"
      db_name = "openwolf"

      # run "psql -h localhost -p 5432 -U #{user_name} -W -d #{db_name} < #{backup_dir}/#{clean_filename}" do |ch, stream, out|
      #   ch.send_data "#{pwd}\n" if out =~ /^Password for user #{user_name}:/
      #   puts out
      # end
      run "psql -U #{user_name} -d #{db_name} < /tmp/#{clean_filename}"


    end

  end
end


Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require './config/boot'
require 'airbrake/capistrano'
