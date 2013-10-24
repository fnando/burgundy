module Burgundy
  class Item < SimpleDelegator
    attr_reader :item

    def self.map(collection)
      collection.map {|item| new(item) }
    end

    def initialize(item)
      @item = item
      __setobj__(item)
    end
  end
end
