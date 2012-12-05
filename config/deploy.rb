require 'capistrano'

set :user, "gabelavon"
set :domain, "letsplaylol.com"
set :project, "letsplaylol"
set :application, "letsplaylol.com"
set :applicationdir, "/home/gabelavon/letsplaylol"

set :scm, "git"
set :repository,  "git@bitbucket.org:mackmm145/letsplaylol.git"
set :scm_user, "mackmm145"
set :scm_password, "ghorse2"
set :scm_passphrase, "ghorse2"
#set :deploy_via, :remote_cache
set :deploy_to, applicationdir
set :git_enable_submodules, 1
set :branch, "master"
set :git_shallow_clone, 1
set :scm_verbose, true

# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "letsplaylol.com"                          # Your HTTP server, Apache/etc
role :app, "letsplaylol.com"                          # This may be the same as your `Web` server
role :db,  "letsplaylol.com", :primary => true # This is where Rails migrations will run

# additional settings
default_run_options[:pty] = true  # Forgo errors when deploying from windows
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false
set :rake, 'bundle exec rake' #important! it overrides whatever global version of rake system is running to my version
set :default_environment, {  #important! adds my PATH and GEM_HOME/GEM_PATH to capistrano - it ignores bash_profile
	'PATH' => "~/bin:~/.gems/bin:$PATH",
	'RUBY_VERSION' => 'ruby 1.8.7',
	'GEM_HOME'     => '~/.gems',
	'GEM_PATH'     => '~/.gems:~/.gems/gems:/usr/lib/ruby/gems/1.8',
	'BUNDLE_PATH'  => '$GEM_PATH'
	}
	
namespace :deploy do

  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  task :start do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end
end



# set :application, "set your application name here"
# set :repository,  "set your repository location here"

# set :scm, :subversion
# # Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

# role :web, "your web-server here"                          # Your HTTP server, Apache/etc
# role :app, "your app-server here"                          # This may be the same as your `Web` server
# role :db,  "your primary db-server here", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

# # if you want to clean up old releases on each deploy uncomment this:
# # after "deploy:restart", "deploy:cleanup"

# # if you're still using the script/reaper helper you will need
# # these http://github.com/rails/irs_process_scripts

# # If you are using Passenger mod_rails uncomment this:
# # namespace :deploy do
# #   task :start do ; end
# #   task :stop do ; end
# #   task :restart, :roles => :app, :except => { :no_release => true } do
# #     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
# #   end
# # end