module Burgundy
  class Collection < SimpleDelegator
    include Enumerable

    def initialize(items, wrapping_class = nil, *args)
      @items = items
      @wrapping_class = wrapping_class
      @args = args
      __setobj__(@items)
    end

    def each(&block)
      to_ary.each(&block)
    end

    def to_ary
      @to_ary ||= if @wrapping_class
                    @items.map {|item| @wrapping_class.new(item, *@args) }
                  else
                    @items.to_a
                  end
    end
    alias_method :to_a, :to_ary
  end
end
