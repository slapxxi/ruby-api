RSpec.describe Hash do
  let(:dictionary) { {word: 'definition', phrase: 'definition'} }

  specify "creating a hash" do
    hash = Hash.new
    hash_with_defaults = Hash.new(:default)

    expect(hash[:none]).to eq nil
    expect(hash_with_defaults[:none]).to eq :default

    hash.default = :default

    expect(hash.default).to eq :default
    expect(hash[:none]).to eq :default

    hash_with_default_block = Hash.new { :default_from_block }

    expect(hash_with_default_block[:nil]).to eq :default_from_block
    expect(hash_with_default_block.default_proc.call).to eq :default_from_block
  end

  specify "accessing elements" do
    expect(dictionary.key 'definition').to eq :word
    expect(dictionary.values).to eq ['definition', 'definition']
    expect(dictionary.values_at(:word, :phrase)).to eq ['definition', 'definition']

    expect {dictionary.fetch(:unknown)}.to raise_error
    expect(dictionary.fetch(:unknown, :default)).to eq :default
  end

  specify "selecting elements" do
    expect(dictionary.select { |key| key == :word}).to eq word: 'definition'
    expect(dictionary.reject { |key| key == :word}).to eq phrase: 'definition'
  end

  specify "replacing" do
    expect(dictionary.replace({})).to eq({})
  end

  specify "determining whether it contains elements" do
    expect(dictionary.empty?).to eq false

    expect(dictionary.include? :word).to eq true
    expect(dictionary.include? 'definition').to eq false

    expect(dictionary.key? :word).to eq true
    expect(dictionary.member? :word).to eq true
    expect(dictionary.has_key? :word).to eq true
    expect(dictionary.value? 'definition').to eq true
    expect(dictionary.has_value? 'definition').to eq true
  end

  specify "deleting elements" do
    dictionary.delete(:word)
    expect(dictionary).to eq({phrase: 'definition'})

    dictionary.delete_if {|key, value| value == 'empty'}
    expect(dictionary).to eq(phrase: 'definition')

    dictionary.keep_if {|key, value| value == 'definition'}
    expect(dictionary).to eq(phrase: 'definition')

    dictionary.shift
    expect(dictionary).to eq({})

    expect(dictionary.clear).to eq({})
  end

  specify "merging hashes" do
    expect({}.merge idiom: 'example').to eq idiom: 'example'
    expect({}.update idiom: 'example').to eq idiom: 'example'
  end

  specify "getting association" do
    expect(dictionary.assoc(:word)).to eq [:word, 'definition']
    expect(dictionary.assoc(:nil)).to eq nil

    expect(dictionary.rassoc('definition')).to eq [:word, 'definition']
  end

  specify "comparing by identity" do
    example = {'name' => 'slava'}

    expect(example['name']).to eq 'slava'
    expect(example.compare_by_identity?).to eq false

    example.compare_by_identity

    expect(example['name']).to eq nil
    expect(example.compare_by_identity?).to eq true
  end

  specify "storing elements" do
    dictionary.store(:word, 'def')
    expect(dictionary).to eq word: 'def', phrase: 'definition'
  end

  specify "flattening" do
    expect(dictionary.flatten).to eq [:word, 'definition', :phrase, 'definition']
  end

  specify "inverting" do
    # It inverts in a sorted way
    expect(dictionary.invert).to eq({'definition' => :phrase})
  end

  describe "Iteration" do
    specify "iterating over keys and values" do
      keys = []
      values = []
      dictionary.each { |key, value| keys << key; values << value }

      expect(keys).to eq [:word, :phrase]
      expect(values).to eq ['definition', 'definition']
    end

    specify "iterating over pairs" do
      result = []
      dictionary.each_pair {|pair| result << pair}

      expect(result).to eq [[:word, 'definition'], [:phrase, 'definition']]
    end

    specify "iterating over keys" do
      keys = []
      dictionary.each_key {|key| keys << key}

      expect(keys).to eq [:word, :phrase]
    end

    specify "iterating over values" do
      values = []
      dictionary.each_value {|value| values << value}

      expect(values).to eq ['definition', 'definition']
    end
  end
end
