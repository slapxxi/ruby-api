RSpec.describe File do
  CURRENT_DIR = Dir.home + '/Projects/ruby-api/spec/standard-library/file_spec.rb'

  specify "getting the current file path" do
    expect(__FILE__).to eq CURRENT_DIR
    expect(__FILE__).to be_a String
  end

  describe "file descriptors" do
    specify "getting the file descriptor number" do
      expect(STDIN.fileno).to eq 0
      expect(STDOUT.fileno).to eq 1
      expect(STDERR.fileno).to eq 2
    end

    specify "freeing the file descriptor number" do
      file = File.open '/etc/passwd'
      descriptor = file.fileno
      file.close
      file = File.open '/etc/hosts'

      expect(file.fileno).to eq descriptor
    end
  end
end
