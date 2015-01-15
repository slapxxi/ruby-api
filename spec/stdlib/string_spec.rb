RSpec.describe String do
  let(:string) { 'Example string' }

  it "has length" do
    expect('abc'.length).to eq 3
    expect('abc'.size).to eq 3
    expect('abc'.bytesize).to eq 3
  end

  specify "adding strings" do
    expect('concatenated'+' string').to eq 'concatenated string'

    expect('abc'.insert 1, 'zyx').to eq 'azyxbc'
    expect('world'.prepend 'Hello, ').to eq 'Hello, world'

    expect(''.concat('name')).to eq 'name'
    expect(''.concat(97)).to eq 'a'
  end

  specify "deleting characters" do
    expect("abc\n\n".chomp).to eq "abc\n"
    expect('abc'.chop).to eq 'ab'

    expect('  abc  '.strip).to eq 'abc'
    expect('   abc'.lstrip).to eq 'abc'
    expect('abc   '.rstrip).to eq 'abc'

    expect('aabbcc something'.delete 'abc ').to eq 'something'

    expect('abc'.clear).to eq ''
  end

  specify "escaping characters" do
    expect("A\n 'string'".dump).to eq '"A\n \'string\'"'
  end

  specify "counting characters" do
    expect(string.count 'l').to eq 1
    expect(string.count('a-zA-Z ')).to eq string.length
  end

  specify "finding substrings" do
    text = "Lorem ipsum lorem."

    expect(text.chr).to eq 'L'

    expect(text.slice(0, 5)).to eq 'Lorem'

    expect(text.index /lorem/i).to eq 0
    expect(text.rindex /lorem/i).to eq 12

    expect(text.scan /\w+/).to eq ['Lorem', 'ipsum', 'lorem']

    expect(text.match /lorem/i).to be_a MatchData

    expect(text.partition /lorem/i).to eq ['', 'Lorem', ' ipsum lorem.']
  end

  specify "comparing" do
    expect('abc' == 'abc').to eq true
    expect('String'.casecmp 'string').to eq 0
  end

  specify "converting" do
    expect('string'.b).to eq 'string'
    expect('string'.intern).to eq :string

    expect('a'.ord). to eq 97

    expect('010'.oct). to eq 8
    expect('0x10'.hex). to eq 16
  end

  specify "aligning" do
    expect('*'.center(5)).to eq '  *  '
    expect('*'.center(5, '_')).to eq '__*__'

    expect('four'.ljust 8).to eq 'four    '
    expect('four'.rjust 8).to eq '    four'
  end

  specify "determining what characters it contains" do
    expect(''.empty?).to eq true

    expect('abc'.include? 'ab').to eq true
    expect('abc'.end_with? 'xy', 'bc').to eq true
    expect('abc'.start_with? 'xy', 'ab').to eq true

    expect('string'.ascii_only?).to eq true
  end


  specify "changing case" do
    expect('word'.upcase).to eq 'WORD'
    expect('WORD'.downcase).to eq 'word'
    expect('word'.swapcase).to eq 'WORD'
    expect('word'.capitalize).to eq 'Word'
  end

  specify "replacing substrings" do
    expect('string'.gsub /str/, 'br').to eq 'bring'

    expect('string'.gsub(/s/) {|sub| sub.bytes.first}).to eq '115tring'

    expect('string'.gsub /([slri])/, '_\1').to eq '_st_r_ing'
    expect('string'.gsub /(?<foo>[slri])/, '_\k<foo>').to eq '_st_r_ing'

    expect('string string'.sub /string/, 'batman').to eq 'batman string'

    expect('world'.replace('hello')).to eq 'hello'
  end

  specify "squeezing" do
    expect('HHellllllo  woorrld.'.squeeze).to eq 'Helo world.'
  end

  describe "Iteration" do
    specify "iterating over bytes" do
      result = []
      'abc'.bytes {|b| result << b}

      expect(result).to eq [97, 98, 99]
    end

    specify "iterating over chars" do
      result = []
      'abc'.each_char {|c| result << c}

      expect(result).to eq ['a', 'b', 'c']
      expect('abc'.chars).to eq result
    end

    specify "iterating over codepoints" do
      result = []
      'abc'.each_codepoint {|cp| result << cp}

      expect(result).to eq [97, 98, 99]
      expect('abc'.codepoints).to eq [97, 98, 99]
    end

    specify "iterating over lines" do
      lines = []
      "two \nlines".each_line {|l| lines << l}

      expect(lines).to eq ["two \n", 'lines']
      expect("two \nlines".lines).to eq lines
    end
  end
end
