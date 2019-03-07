require 'git'
require 'json'

class Gitsync

  def initialize (dir = Dir.pwd)
    @cwd = dir
    @config = JSON.parse(File.read("#{@cwd}/.gitsync"))
  end

  def init_repos
      @config.each do |c|
      name = c['name']
      remote = c['ssh_url_to_repo']
      puts "cloning #{remote} into #{name}"
      g = Git.clone(remote, name)
    end
  end
  
  def usage
    puts "usage: gitsync [action]"
    puts "where action can be :"
    puts "init \t  -- initialize repositories"
    puts "sync \t  -- synchronize all repositories using git pull"
  end

  def sync
    @config.each do |c|
      name = c['name']
      g = Git.open("#{@cwd}/#{name}") #:log => Logger.new(STDOUT))
      puts "updating repository #{name}"
      g.checkout("master")
      g.pull("origin","master")
    end
  end
end

case ARGV[0]
when "init"
  Gitsync.new.init_repos
when "sync"
  Gitsync.new.sync
else
  Gitsync.new.usage
end
