# frozen_string_literal: true

module Burgundy
  module UrlMethods
    def default_url_options
      action_mailer_default_url_options ||
        Rails.application.routes.default_url_options
    end

    def action_mailer_default_url_options
      return unless Rails.configuration.respond_to?(:action_mailer)

      Rails.configuration.action_mailer.default_url_options
    end
  end

  module Helpers
    extend ActiveSupport::Concern

    included do
      delegate :translate, :t, :localize, :l, to: :helpers
    end

    def helpers
      ApplicationController.helpers
    end
    alias h helpers
  end

  module RouteHelpers
    extend ActiveSupport::Concern

    module ClassMethods
      def routes_module
        @routes_module ||= Module.new do
          include Rails.application.routes.url_helpers
          include UrlMethods
        end
      end

      def routes
        @routes ||= Object.new.extend(routes_module)
      end
    end

    def to_param
      item.to_param
    end

    def eql?(other)
      other == self || item.eql?(other)
    end

    def routes
      self.class.routes
    end
    alias r routes
  end

  class Item
    include Helpers
    include RouteHelpers
  end
end
