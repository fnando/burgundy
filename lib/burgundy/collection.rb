# frozen_string_literal: true

module Burgundy
  class Collection
    def initialize(items, wrapping_class = nil, *args, **kwargs)
      @items = items
      @wrapping_class = wrapping_class
      @args = args
      @kwargs = kwargs
    end

    def method_missing(name, *, &) # rubocop:disable Style/MissingRespondToMissing
      to_ary.send(name, *, &)
    end

    def respond_to?(name, include_all = false) # rubocop:disable Style/OptionalBooleanParameter
      to_ary.respond_to?(name, include_all)
    end

    def to_ary
      @to_ary ||=
        if @wrapping_class
          @items.map {|item| @wrapping_class.new(item, *@args, **@kwargs) }
        else
          @items.to_a
        end
    end
    alias to_a to_ary
  end
end
