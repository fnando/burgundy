# frozen_string_literal: true

module Burgundy
  class Item < SimpleDelegator
    attr_reader :item

    def self.inherited(child)
      child.attributes(attributes)
    end

    def self.wrap(collection, *args)
      Collection.new(collection, self, *args)
    end

    def self.map(collection)
      warn "Burgundy::Item.map is deprecated; use Burgundy::Item.wrap instead."
      wrap(collection)
    end

    def self.attributes(*args)
      @attributes ||= {}

      if args.any?
        @attributes = {}
        @attributes = args.pop if args.last.is_a?(Hash)
        @attributes.merge!(args.zip(args).to_h)
      end

      @attributes
    end

    def initialize(item)
      @item = item
      __setobj__(item)
    end

    def attributes
      self.class.attributes.each_with_object({}) do |(from, to), target|
        target[to] = send(from)
      end
    end

    def as_json(*)
      attributes
    end

    def to_json(*)
      as_json.to_json
    end

    alias to_hash attributes
    alias to_h attributes
  end
end
