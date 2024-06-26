# frozen_string_literal: true

require "simplecov"
SimpleCov.start do
  add_filter "/test/"
end

require "bundler/setup"
Bundler.setup

require "minitest/utils"
require "minitest/autorun"
require "ostruct"

ENV["RAILS_ENV"] = "test"

require File.expand_path("dummy/config/environment.rb", __dir__)

require "burgundy"
I18n.locale = :en

class ItemWithAdditionalArgs < Burgundy::Item
  attr_reader :args

  def initialize(target, *args)
    super(target)
    @args = args
  end
end

class ItemWithKeywordArgs < Burgundy::Item
  attr_reader :kwargs, :a, :b

  def initialize(target, a:, b:)
    super(target)
    @a = a
    @b = b
  end
end
