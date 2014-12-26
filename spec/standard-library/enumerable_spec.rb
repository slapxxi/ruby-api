RSpec.describe Enumerable do
  let(:names) { %w[john paul patrik antony] }

  specify "Array includes Enumerable by default" do
    expect(Array).to include Enumerable
  end

  specify "grouping entries by some criteria" do
    result = names.group_by { |name| name.start_with? 'p' }

    expect(result).to eq({false => %w[john antony], true => %w[paul patrik]})
  end

  specify "chunking entries by some criteria" do
    result = (1..2).chunk { |n| n.even? }

    expect(result.entries.flatten).to eq [false, 1, true, 2]
  end

  specify "collecting aka mapping values into another values" do
    result = (1..3).map { |n| n**2 }
    collection = (1..3).collect { |n| n**2 }

    expect(result).to eq [1, 4, 9]
    expect(collection).to eq [1, 4, 9]
  end

  specify "collecting and concatenating values" do
    result = (1..3).collect_concat { |n| [n, n*2] }
    flat_map = (1..3).flat_map { |n| [n, n*2] }

    expect(result).to eq [1, 2, 2, 4, 3, 6]
    expect(flat_map).to eq [1, 2, 2, 4, 3, 6]
  end

  specify "counting the number of specific elements" do
    amount = (1..6).count &:even?

    expect(amount).to eq 3
  end

  specify "cycling through elements of the collection" do
    result = (1..3).cycle(2).map { |n| n*2 }

    expect(result).to eq [2, 4, 6, 2, 4, 6]
  end

  specify "detecting aka finding the first element matching the condition" do
    expect((39..100).detect &:even?).to eq 40
    expect((39..100).find &:even?).to eq 40
  end

  specify "finding index of the first element matching the condition" do
    expect((1..10).find_index &:even?).to eq 1
  end

  specify "finding all elements matching the pattern" do
    result = (1..100).grep 33..37

    expect(result).to eq [33, 34, 35, 36, 37]
  end

  specify "dropping first N elements from the collection" do
    result = (1..100).drop 97

    expect(result).to eq [98, 99, 100]
  end

  specify "dropping elements while matching a condition" do
    result = (1..10).drop_while { |n| n < 4 }

    expect(result).to eq [4, 5, 6, 7, 8, 9, 10]
  end

  specify "injecting aka reducing a collection" do
    expect((1..100).inject :+).to eq 5050
    expect((1..100).reduce :+).to eq 5050
  end

  specify "iterating over arrays of N consecutive elements" do
    result = (1..4).each_cons(2)

    expect(result.entries).to eq [[1,2], [2, 3], [3, 4]]
  end

  specify "iterating over each slice of N elements" do
    result = (1..10).each_slice(3)

    expect(result.entries).to eq [[1,2,3], [4,5,6], [7,8,9], [10]]
  end

  specify "iterating over a collection returning the given object" do
    result = (1..3).each_with_object([]) { |n, o| o << n }

    expect(result).to eq [1,2,3]
  end

  specify "getting the entries" do
    expect((1..3).entries).to eq [1,2,3]
  end

  specify "getting the max element" do
    expect((1..100).max).to eq 100
  end

  specify "getting the max element based on a criteria" do
    result = %w[me you him they].max_by &:length

    expect(result).to eq 'they'
  end

  specify "getting the min element" do
    expect((1..100).min).to eq 1
  end

  specify "getting the min element based on a criteria" do
    result = %w[me you him they].min_by &:length

    expect(result).to eq 'me'
  end

  specify "getting the min and the max elements" do
    expect((1..100).minmax).to eq [1, 100]
  end

  specify "getting the min and the max elements based on a criteria" do
    expect(%w[me you she they].minmax_by &:length).to eq %w[me they]
  end

  specify "selecting elements based on a criteria" do
    expect((1..10).select &:even?).to eq [2,4,6,8,10]
    expect((1..10).find_all &:even?).to eq [2,4,6,8,10]
  end

  specify "rejecting elements based on a criteria" do
    expect((1..10).reject &:even?).to eq [1,3,5,7,9]
  end
end
