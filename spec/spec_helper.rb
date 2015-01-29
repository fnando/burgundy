require 'bundler/setup'
Bundler.setup

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rspec/rails'

require 'burgundy'
I18n.locale = :en
