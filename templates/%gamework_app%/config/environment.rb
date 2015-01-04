require 'rubygems'
require 'bundler/setup'
require 'gamework'
require File.expand_path('../config', __FILE__)

Dir[File.join(".", "actors", "**/*.rb")].each {|file| require file }
Dir[File.join(".", "scenes", "**/*.rb")].each {|file| require file }
