set :application, "skykids"
set :domain, "74.63.8.222"
set :user, "skykids"
set :repository,  "svn+ssh://mockupi@mockupit.com/home/mockupi/svn/skykids/trunk"

set :use_sudo, false
set :deploy_to, "/home/#{user}/apps/#{application}"
set :deploy_via, :checkout
set :chmod755, "app config db lib public vendor script script/* public/disp*"
set :mongrel_port, "4016"
set :mongre_nodes, "1"

default_run_options[:pty] = true
ssh_options[:keys]= %w(~/.ssh/id_rsa)

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion

role :app, domain
role :web, domain
role :db,  domain, :primary => true