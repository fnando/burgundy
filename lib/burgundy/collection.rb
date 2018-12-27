module Burgundy
  class Collection
    def initialize(items, wrapping_class = nil, *args)
      @items = items
      @wrapping_class = wrapping_class
      @args = args
    end

    def method_missing(name, *args, &block)
      to_ary.send(name, *args, &block)
    end

    def respond_to?(name, include_all = false)
      to_ary.respond_to?(name, include_all)
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
