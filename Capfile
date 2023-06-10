# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

require 'capistrano/rails'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano/bundler'
require 'capistrano/rvm'

require 'capistrano/secrets_yml'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/puma'
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Systemd

# Depending on your server, you may need a different plugin
# For a Digital Ocean deploy, 'Daemon' will work
# Documentation: https://github.com/seuros/capistrano-puma
# From the documentation: "If you using puma daemonized (not supported in Puma 5+)""
install_plugin Capistrano::Puma::Daemon

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }