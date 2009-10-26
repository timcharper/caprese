#!/usr/bin/env ruby
require File.dirname(__FILE__) + '/lib/env.rb'

action = ARGV.shift

case action
when "engage" then Pomodoro.engage(ARGV)
when "disengage" then Pomodoro.disengage
else
  puts "Unknown action #{action}"
end
