module Burgundy
  class Collection
    include Enumerable

    def initialize(items, wrapping_class)
      @items = items
      @wrapping_class = wrapping_class
    end

    def each(&block)
      to_ary.each(&block)
    end

    def to_ary
      @cache ||= @wrapping_class.map(@items.to_a)
    end
    alias_method :to_a, :to_ary
  end
end
