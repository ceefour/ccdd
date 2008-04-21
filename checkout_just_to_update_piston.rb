#!/usr/bin/env ruby
# The script checks out a Rails project just to update its piston packages.
# URL=Subversion path to trunk
require 'universal'

uni_import :within_folder

within_folder("#{ENV['HOME']}/tmp", lambda { |dir|
    puts 'Checking out...'
#    svn co x y
#    cd x
#    bash maintenance/update_piston.sh
#    cd ..
#    read -n 1 -p 'Press key to remove checkout folder for X...'
#    rm -rf x
})

