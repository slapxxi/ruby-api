require "ruby/blocks"

RSpec.describe "Ruby Blocks" do
  describe "Creating blocks" do
    specify "creating a lambda block" do
      block = lambda {}

      expect(block).to be_lambda
    end

    specify "creating a lambda block with a rocket" do
      block = -> {}
      expect(block).to be_lambda
    end

    specify "creating a proc block" do
      block = proc {}
      expect(block).to be_a Proc
    end

    specify "creating a proc block with `Proc`" do
      block = Proc.new { :block }
      expect(block).to be_a Proc
    end
  end

  describe "Invoking blocks" do
    context "with a wrong number of arguments" do
      specify "lambda raises an error" do
        block = ->(x, y, z) {}

        expect { block.call 1, 2 }.to raise_error ArgumentError
        expect { block.call 1, 2, 3 }.not_to raise_error
      end

      specify "proc doesn't raise an error" do
        block = proc { |x, y, z| }

        expect { block.call 1, 2 }.not_to raise_error
        expect { block.call 1, 2, 3 }.not_to raise_error
        expect { block.call 1, 2, 3, 4 }.not_to raise_error
      end
    end
  end

  describe "Using methods that accept blocks" do
    specify "accepting a block" do
      result = 0
      Ruby::Blocks.repeat(2) { result += 10 }

      expect(result).to eq 20
      expect { Ruby::Blocks.repeat(2) }.to raise_error ArgumentError
    end

    specify "passing arguments to a block" do
      result = 0
      Ruby::Blocks.repeat(1) { |n| result = n }

      expect(result).to eq 1
    end

    specify "by default methods don't raise errors if block is not expected" do
      expect { puts { "else" } }.not_to raise_error
    end

    specify "binding a block argument to a variable" do
      x = 10
      block = Ruby::Blocks.to_block { x }

      expect(block.call).to eq 10
    end

    specify "by default a block argument variable is optional" do
      expect(Ruby::Blocks.to_block).to be_nil
    end
  end
end
