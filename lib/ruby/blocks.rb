module Ruby
  module Blocks
    class << self
      def repeat(n)
        raise ArgumentError.new 'I need a block!' unless block_given?

        n.times { |i| yield i+1 }
      end

      def to_block(&block)
        block
      end
    end
  end
end
