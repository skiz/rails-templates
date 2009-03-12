
# Configure Dependencies
gem 'aslakhellesoy-cucumber',  :lib => 'cucumber',      :source => 'http://gems.github.com'
gem 'thoughtbot-shoulda',      :lib => 'shoulda',       :source => 'http://gems.github.com'
gem 'thoughtbot-factory_girl', :lib => 'factory_girl',  :source => 'http://gems.github.com'
gem 'thoughtbot-clearance',    :lib => 'clearance',     :source => 'http://gems.github.com'
gem 'mislav-will_paginate',    :lib => 'will_paginate', :source => 'http://gems.github.com'
rake 'gems:unpack:dependencies'
rake 'gems:build'
rake 'rails:freeze:gems'

# Generate some voodoo
generate :controller => 'pages index'
#generate :cucumber #provided by clearance_features
generate :clearance
run "echo \"\nHOST = 'localhost'\" >> config/environments/test.rb"
run "echo \"\nHOST = 'localhost'\" >> config/environments/development.rb"
run "echo \"\nDO_NOT_REPLY = 'donotreply@example.com'\" >> config/environment.rb"
generate :clearance_features

# Initialize git subsystem
git :init
file ".gitignore", <<-END
.DS_Store
log/*.log
config/database.yml
db/*.sqlite3
END
run "cp config/database.yml config/database.example.yml"
run "touch tmp/.gitignore log/.gitignore vendor/.gitignore"

# Database setup
rake 'db:migrate'
rake 'db:test:prepare'

# Housekeeping
run 'echo TODO > README'
run "rm public/index.html"
route "map.root :controller => 'pages'"

# Project Ready!
git :add => '.'
git :commit => "-m 'initial rails setup'"

# Test First!
rake :test
rake :features