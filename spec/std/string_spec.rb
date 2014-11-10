RSpec.describe String do
  specify "concatenating" do
    expect('concatenated'+' string').to eq 'concatenated string'
  end

  specify "finding the regular expression" do
    text = "Lorem ipsum..."
    expect(text.scan /\w+/).to eq ['Lorem', 'ipsum']
  end

  specify "changing case" do
    expect('word'.upcase).to eq 'WORD'
    expect('WORD'.downcase).to eq 'word'
    expect('word'.capitalize).to eq 'Word'
  end
end
