RSpec.describe File do
  before { File.new 'tmp/testfile.tmp', 'w+' }
  after { File.delete 'tmp/testfile.tmp' }

  describe "file descriptors" do
    specify "getting the file descriptor" do
      expect(STDIN.fileno).to eq 0
      expect(STDOUT.fileno).to eq 1
      expect(STDERR.fileno).to eq 2
    end

    specify "freeing the file descriptor" do
      file = File.open '/etc/passwd'
      descriptor = file.fileno
      file.close
      file = File.open '/etc/hosts'

      expect(file.fileno).to eq descriptor
    end
  end

  describe "editing files" do
    specify "opening a file" do
      file = File.open 'tmp/testfile.tmp'

      expect(file).to be_a File
      expect(file).not_to be_closed
    end

    specify "closing a file" do
      file = File.open 'tmp/testfile.tmp'

      file.close
      expect(file).to be_closed
    end

    specify "opening a file, editing and automatically closing it" do
      File.open 'tmp/testfile.tmp', 'w+' do |f|
        f.puts "Test string"
        expect(f.tap(&:rewind).read).to eq "Test string\n"
      end
    end
  end

  describe "working with paths" do
    specify "joining paths according to the system" do
      path = File.join 'root', 'dir', 'file.md'
      expect(path).to eq 'root/dir/file.md'
    end

    specify "getting a full path from a relative path" do
      path = File.expand_path './spec/../'
      expect(path).to eq File.expand_path '~/Projects/ruby-api'
    end
  end
end
