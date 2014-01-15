require 'rspec'
require 'pry'
require 'simplecov'
SimpleCov.start

GAMEWORK_ENV = 'test'
require File.expand_path('../../lib/gamework.rb', __FILE__)