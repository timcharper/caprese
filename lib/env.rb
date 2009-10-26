require 'rubygems'
require 'appscript'
require 'yaml'
require 'pp'

require 'pathname'
APP_PATH = Pathname.new(File.expand_path("..", File.dirname(__FILE__)))
LIB_PATH = APP_PATH + "lib"
ACTIONS_PATH = APP_PATH + "actions"
CONFIG_PATH = APP_PATH + "config"

class String
  def classify
    gsub(/^[a-z]/) { |l| l.upcase}.gsub(/_[a-z]/) { |l| l[1..1].upcase}.gsub(/\b[a-z]/) {|l| l.upcase}.gsub("/", "::")
  end
end

class Time
  def to_short_time
    strftime('%I:%M %p').gsub(/^0/, '')
  end
end

(Dir[ACTIONS_PATH + "*"] + Dir[LIB_PATH + "*"]).each do |path|
  Object.autoload(File.basename(path, ".rb").classify.to_sym, path)
end
