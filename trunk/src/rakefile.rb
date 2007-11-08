# Dependencies:
# Gems: net-ssh, capistrano, escape

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

namespace :svn do
  # Params: NAME, HOST, USER
  desc 'Create Subversion repository using ssh svnadmin.'
  task :create do
    require 'escape'
    ['NAME', 'HOST', 'USER'].each do |env_name|
      raise "Requires #{env_name}" unless ENV[env_name]
    end
    svnadmin_cmd = Escape.shell_command(["svnadmin", "create", "/media/data/server/svn/#{ENV['NAME']}"])
    sh Escape.shell_command(["cap", "invoke", "SUDO=1", "HOSTS=#{ENV['HOST']}",
        "COMMAND=#{svnadmin_cmd}"])
    chown_cmd = Escape.shell_command(['chown', '-R', 'www-data:www-data', "/media/data/server/svn/#{ENV['NAME']}"])
    sh Escape.shell_command(["cap", "invoke", "SUDO=1", "HOSTS=#{ENV['HOST']}",
        "COMMAND=#{chown_cmd}"])
  end

  # Params: NAME, HOST (svn server)
  desc 'Shows project info using Subversion.'
  task :info do
    require 'escape'
    ['NAME', 'HOST'].each do |env_name|
      raise "Requires #{env_name}" unless ENV[env_name]
    end
    sh Escape.shell_command(["svn", "info", "http://#{ENV['HOST']}/#{ENV['NAME']}"])
  end

  # Params: NAME, HOST (svn server)
  desc 'Lists project folder using Subversion.'
  task :ls do
    require 'escape'
    ['NAME', 'HOST'].each do |env_name|
      raise "Requires #{env_name}" unless ENV[env_name]
    end
    sh Escape.shell_command(["svn", "ls", "-v", "http://#{ENV['HOST']}/#{ENV['NAME']}"])
  end

  namespace :module do
    # Params: URL (svn repos including project name), MODULE
    desc 'Prepares a module project inside a Subversion repository.'
    task :create do
      require 'escape'
      ['URL', 'MODULE'].each do |env_name|
        raise "Requires #{env_name}" unless ENV[env_name]
      end
      sh Escape.shell_command(["svn", "mkdir",
          "#{ENV['URL']}/#{ENV['MODULE']}", '-m', "Created top-level folder for module project '#{ENV['MODULE']}'"])
      sh Escape.shell_command(["svn", "mkdir",
          "#{ENV['URL']}/#{ENV['MODULE']}/trunk", '-m', "Created trunk folder for module project '#{ENV['MODULE']}'"])
      sh Escape.shell_command(["svn", "mkdir",
          "#{ENV['URL']}/#{ENV['MODULE']}/tags", '-m', "Created tags folder for module project '#{ENV['MODULE']}'"])
      sh Escape.shell_command(["svn", "mkdir",
          "#{ENV['URL']}/#{ENV['MODULE']}/branches", '-m', "Created branches folder for module project '#{ENV['MODULE']}'"])
    end
  end
  
  # Params: NAME, HOST, USER
  desc 'Delete Subversion repository using ssh.'
  task :destroy do
    require 'escape'
    ['NAME', 'HOST', 'USER'].each do |env_name|
      raise "Requires #{env_name}" unless ENV[env_name]
    end
    [Escape.shell_command(["cap", "invoke", "SUDO=1",
          "HOSTS=#{ENV['HOST']}",
          "COMMAND="+ Escape.shell_command(["rm", "-rf", "/media/data/server/svn/#{ENV['NAME']}"])
        ])
    ].each do |cmd|
      $stderr.puts "Executing: #{cmd}..."
      system cmd
    end
  end
  
  desc 'Provides soft importing of projects.'
  namespace :import do
    
    # Params: PATH, URL (will be imported at THIS folder, it won't create a subfolder)
    #   OUTPUT (project will be checked out here, left uncommitted)
    desc 'Imports a Rails project as a new checkout, not yet committed.'
    task :rails do
      require 'escape'
      %w{ PATH URL OUTPUT }.each do |env_name|
        raise "Requires #{env_name}" unless ENV[env_name]
      end
      sh Escape.shell_command(["svn", "checkout", ENV['URL'], ENV['OUTPUT']])
    end
    
  end
  
end
