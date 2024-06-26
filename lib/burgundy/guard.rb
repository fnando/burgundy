# frozen_string_literal: true

module Burgundy
  class Guard
    def initialize(item)
      @item = item
    end

    def method_missing(name, *)
      class_name = @item.class.name || @item.class.inspect
      error_message = %W[
        #{class_name} was initialized without a delegating object and
        didn't implement #{class_name}##{name}
      ].join(" ")

      raise ArgumentError, "#{error_message}\n#{caller(2..2).first}"
    end

    def respond_to_missing?(*)
      true
    end
  end
end
