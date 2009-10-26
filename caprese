#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/lib/env.rb'

action = ARGV.shift

case action
when "start" then Pomodoro.start
when "stop" then Pomodoro.stop
else
  puts "Unknown action #{action}"
end
