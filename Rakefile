require 'rubygems'
require 'bundler/setup'

task :console do
  require 'pry'
  require 'cheeky'
  ARGV.clear
  Pry.start
end

task :environment do
  require 'cheeky'
end

namespace :display do
  desc 'Write text to the display'
  task :write, [:message] => :environment do |t, args|
    Cheeky.write(args[:message], hold: 0.05)
  end

  desc 'Show the current Time'
  task :time => :environment do
    Cheeky.write(Time.now.strftime("%A, %B %e"), hold: 0.05)
    Cheeky.write(Time.now.strftime("%H:%M"), hold: 0.05)
    Cheeky.write(Time.now.strftime("%l:%M%p"), hold: 0.05)

  end

  task :clock => :environment do
    loop do
      time = Time.now.strftime("%H:%M")
      Cheeky.write(time, hold: 0.05)
      puts time
      sleep 5

      Cheeky.write(time, hold: 0.05, scroll: :right)
      sleep 5
    end
  end
end
task :display, [:message] => 'display:write'

task :default => :console