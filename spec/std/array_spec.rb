RSpec.describe Array do
  let(:numbers) { (1..10).to_a }

  specify "creating" do
    expect((1..3).to_a).to eq [1, 2, 3]

    expect(Array.new).to eq []
    expect(Array.new(3)).to eq [nil, nil, nil]

    # Default value is the same object
    expect(Array.new(2, true)).to eq [true, true]

    # Default value is a different object
    expect(Array.new(2) {Hash.new}).to eq [{}, {}]
  end

  specify "converting" do
    expect(Array 10).to eq [10]
    expect(Array key: 'value').to eq [[:key, 'value']]
  end

  specify "accessing elements" do
    expect(numbers.first).to eq 1
    expect(numbers.last).to eq 10
    expect(numbers.take(3)).to eq [1, 2, 3]
    expect(numbers.drop(8)).to eq [9, 10]

    expect(numbers.take_while {|n| n<4}).to eq [1, 2, 3]

    # Getting random elements
    expect(numbers).to include numbers.sample
    expect(numbers).to include numbers.sample(2).first, numbers.sample(2).first

    # Accessing with indexes
    expect(numbers[0]).to eq 1
    expect(numbers[-1]).to eq 10

    # Accessing with #at
    expect(numbers.at(0)).to eq 1
    expect(numbers.at(-1)).to eq 10

    expect(numbers[100]).to eq nil

    expect(numbers.fetch(100, :novalue)).to eq :novalue
    expect {numbers.fetch 100}.to raise_error

    expect(numbers[0, 3]).to eq [1, 2, 3]
    expect(numbers.slice(0, 3)).to eq [1, 2, 3]

    expect(numbers[0...3]).to eq [1, 2, 3]
    expect(numbers[0..3]).to eq [1, 2, 3, 4]
  end

  specify "finding items" do
    example = [0,0,0,9]

    expect(example.find_index(9)).to eq 3
    expect(example.index(9)).to eq 3

    expect(example.find_index(9)).to eq 3
    expect(example.index {|n| n==9}).to eq 3

    expect(example.rindex(0)).to eq 2
    expect(example.rindex {|n| n==0}).to eq 2
  end

  specify "determining size" do
    expect(numbers.count).to eq 10
    expect(numbers.size).to eq 10
    expect(numbers.length).to eq 10
  end

  specify "determining whether it contains specified items" do
    expect(numbers.empty?).to eq false

    expect(numbers.any?).to eq true
    expect(numbers.any? {|n| n >5 }).to eq true

    expect(numbers.include? 10).to eq true
  end

  specify "adding items" do
    example = []

    example.push 1
    example << 2
    expect(example).to eq [1, 2]

    example.insert(1, 1.5, 1.7)
    expect(example).to eq [1, 1.5, 1.7, 2]

    example.unshift 0
    expect(example).to eq [0, 1, 1.5, 1.7, 2]
  end

  specify "filling with items" do
    result = []
    result.fill 'x', 2, 2

    expect(result).to eq [nil, nil, 'x', 'x']
    result.clear

    result.fill(0, 4) {|i| i*2}

    expect(result).to eq [0, 2, 4, 6]
  end

  specify "concatenating" do
    expect([1].concat [2, 3]).to eq [1,2,3]
  end

  specify "replacing" do
    expect([1,2,3,4,5].replace [1,2,3]).to eq [1,2,3]
  end

  specify "rotating" do
    expect([5, 6, 7, 8].rotate(1)).to eq [6,7,8,5]
    expect([5, 6, 7, 8].rotate(-2)).to eq [7,8,5,6]
  end

  specify "shuffle items randomly" do
    expect([1,2,3].shuffle).to include 1, 2, 3
  end

  specify "deleting items" do
    example = [1, 2, 3, 4, 5, 6]

    expect(example.pop).to eq 6
    expect(example).to eq [1, 2, 3, 4, 5]

    expect(example.shift).to eq 1
    expect(example).to eq [2, 3, 4, 5]

    example.delete_at 0
    expect(example).to eq [3, 4, 5]

    example.delete(5)
    expect(example).to eq [3, 4]

    example.delete_if {|n| n>3}
    expect(example).to eq [3]

    example.keep_if {|n| n>5}
    expect(example).to eq []

    # Remove all items
    expect((1..100).to_a.clear).to eq []
  end

  specify "removing nils" do
    example = [nil, nil, 1, 2, 3, nil, nil]

    expect(example.compact).to eq [1, 2, 3]

    example.compact!
    expect(example).to eq [1, 2, 3]
  end

  specify "removing duplicated items" do
    example = [1, 1, 2, 2, 3, 4, 4, 5]

    expect(example.uniq).to eq [1, 2, 3, 4, 5]

    example.uniq!
    expect(example).to eq [1, 2, 3, 4, 5]
  end

  specify "collecting items" do
    example = [1, 2, 3]

    expect(example.map {|n| n**2}).to eq [1, 4, 9]
    expect(example.collect {|n| n**2}).to eq [1, 4, 9]
  end

  specify "selecting items" do
    expect(numbers.select {|n| n > 5}).to eq [6, 7, 8, 9, 10]
  end

  specify "filtering items" do
    expect(numbers.reject {|n| n > 5}).to eq [1, 2, 3, 4, 5]
    expect(numbers.drop_while {|n| n < 5}).to eq [5, 6, 7, 8, 9, 10]
  end

  specify "sorting items" do
    expect(numbers.shuffle.sort).to eq numbers
    expect([-4,-1,2,3,5].sort_by {|n| n.abs}).to eq [-1,2,3,-4,5]
  end

  specify "combining items" do
    result = []
    [1,2,3].combination(2) { |c| result << c }

    expect(result).to include [1, 2]
    expect(result).to include [1, 3]
    expect(result).to include [2, 3]
    result.clear

    [1,2,3].permutation(2) { |c| result << c }

    expect(result).to include [1, 2]
    expect(result).to include [1, 3]
    expect(result).to include [2, 3]

    expect([1,2].product [4, 5]).to eq [[1,4], [1,5], [2,4], [2,5]]
  end

  specify "joining items" do
    expect([1,2,3].join).to eq '123'
    expect([1,2,3].join(':')).to eq '1:2:3'
  end

  specify "flattening" do
    expect([1,[2,3, [4]]].flatten).to eq [1,2,3,4]
  end

  describe "Associative" do
    specify "finding a first matching inner array" do
      example = [[1,2,3], [3,2,1]]

      expect(example.assoc(3)).to eq [3, 2, 1]
      expect(example.rassoc(2)).to eq [1, 2, 3]
    end
  end

  describe "Iteration" do
    specify "iterating over each item" do
      sum = 0
      [1, 2, 3].each { |n| sum += n }

      expect(sum).to eq 1+2+3
    end

    specify "iterating over reversed items" do
      result = []
      [1, 2, 3].reverse_each { |n| result << n }

      expect(result).to eq [3, 2, 1]
    end

    specify "cycling over items n times" do
      result = []
      [1,2,3].cycle(2) {|n| result << n }

      expect(result).to eq [1,2,3,1,2,3]
    end

    specify "iterating over indices" do
      result = []
      [4,4,4].each_index {|i| result << i}

      expect(result).to eq [0, 1, 2]
    end
  end
end
