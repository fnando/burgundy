require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require "bundler/setup"
Bundler.setup

require "minitest/utils"
require "minitest/autorun"

ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb", __FILE__)

require "burgundy"
I18n.locale = :en

class ItemWithAdditionalArgs < Burgundy::Item
  attr_reader :args

  def initialize(target, *args)
    super(target)
    @args = args
  end
end
