require 'bundler/setup'
Bundler.setup

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../dummy/config/environment.rb',  __FILE__)
require 'rspec/rails'

require 'burgundy'
I18n.locale = :en

class ItemWithAdditionalArgs < Burgundy::Item
  attr_reader :args

  def initialize(target, *args)
    super(target)
    @args = args
  end
end
