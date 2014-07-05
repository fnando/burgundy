module Burgundy
  class Collection
    include Enumerable

    def initialize(items, wrapping_class = nil)
      @items = items
      @wrapping_class = wrapping_class
    end

    def empty?
      !any?
    end

    def each(&block)
      to_ary.each(&block)
    end

    def to_ary
      @cache ||=  if @wrapping_class
                    @items.map {|item| @wrapping_class.new(item) }
                  else
                    @items.to_a
                  end
    end
    alias_method :to_a, :to_ary
  end
end
