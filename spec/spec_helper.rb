require 'rspec'
require 'pry'
require 'simplecov'
SimpleCov.start

require File.expand_path('../../lib/gamework.rb', __FILE__)

Gamework::ENV = 'test'