#!/usr/bin/env ruby
# The script goes in and out of a directory
# DIR=The directory
def within_folder dir_name, block
  Dir.chdir(dir_name) do |dir_name|
    # Pass the dir name back to the caller
    block.call dir_name
  end
end
