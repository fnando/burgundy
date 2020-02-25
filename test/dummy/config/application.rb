# frozen_string_literal: true

require File.expand_path("boot", __dir__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "active_model/railtie"

Bundler.require(*Rails.groups)
require "burgundy"

module Dummy
  class Application < Rails::Application
  end
end
