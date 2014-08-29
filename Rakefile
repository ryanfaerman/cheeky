require 'rubygems'
require 'bundler/setup'

task :console do
  require 'pry'
  require 'cheeky'
  ARGV.clear
  Pry.start
end

task :default => :console