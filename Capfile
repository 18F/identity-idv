# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

# support for bundler, rails/assets and rails/migrations
require "capistrano/bundler"

# support for passenger
require "capistrano/passenger"

# support for rbenv
require 'capistrano/rbenv'

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
