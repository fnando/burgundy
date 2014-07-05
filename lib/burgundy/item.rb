module Burgundy
  class Item < SimpleDelegator
    attr_reader :item

    def self.wrap(collection)
      Collection.new(collection, self)
    end

    def self.map(collection)
      warn 'Burgundy::Item.map is deprecated; use Burgundy::Item.wrap instead.'
      wrap(collection)
    end

    def initialize(item)
      @item = item
      __setobj__(item)
    end
  end
end
