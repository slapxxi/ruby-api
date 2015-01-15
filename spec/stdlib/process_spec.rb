RSpec.describe Process do
  it "has ID" do
    expect(Process.pid).to eq Process.pid
    expect(Process.pid).to be_a Fixnum
    expect($$).to eq Process.pid
    expect($$).to be_a Fixnum
  end

  it "has parent process ID" do
    expect(Process.ppid).not_to eq Process.pid
    expect(Process.ppid).to be_a Fixnum
  end

  it "has name" do
    expect($PROGRAM_NAME).to be $0
    expect($PROGRAM_NAME).to be =~ /rspec$/i

    $PROGRAM_NAME = 'custom name'
    expect($PROGRAM_NAME).to eq 'custom name'
  end

  it "has exit codes" do
    expect { exit 22 }.to be_exited
    expect { exit! 22 }.to be_exited
    expect { raise }.to raise_error
  end

  describe "forking" do
    it "creates a child process" do
      parent_id = Process.pid

      fork do
        expect(Process.pid).not_to eq parent_id
        expect(Process.ppid).to eq parent_id
      end
    end

    it "doesn't affect the parent process" do
      values = [1, 2]
      fork do
        values << 3
      end
      expect(values).to eq [1, 2]
    end
  end

  describe "piping" do
    it "is a two-way communication channel" do
      reader, writer = IO.pipe
      writer.write 'this goes into the pipe'
      writer.close

      expect(reader.read).to eq 'this goes into the pipe'
      expect {reader.write 'not possible with pipes'}.to raise_error
    end

    it "communicates between multiple processes" do
      reader, writer = IO.pipe
      fork do
        reader.close
        10.times { writer.putc '.' }
      end
      writer.close
      expect(reader.read).to eq '.'*10
    end
  end

  describe "daemon processes" do
  end

  describe "ARGV" do
    it "contains command-line arguments" do
      expect(ARGV).to be_an Array
    end
  end

  describe "ENV" do
    it "contains environment variables" do
      ENV['MSG'] = 'Hello, world!'
      expect(ENV['MSG']).to eq 'Hello, world!'
    end
  end

  describe "resource limits" do
    specify "getting the resource limit for opened files" do
      limits = Process.getrlimit :NOFILE

      expect(limits).to be_an Array
      expect(limits.first).to be_a Fixnum
      expect(limits.last).to be_a Bignum
    end

    specify "getting the resource limit for simultaneous processes" do
      limits = Process.getrlimit :NPROC

      expect(limits.first).to be_a Fixnum
      expect(limits.last).to be_a Fixnum
    end

    specify "getting the resource limit for the largest file" do
      limits = Process.getrlimit :FSIZE

      expect(limits.first).to be_a Bignum
      expect(limits.last).to be_a Bignum
    end

    specify "getting the resource limit for the largest stack segment" do
      limits = Process.getrlimit :STACK

      expect(limits.first).to be_a Fixnum
      expect(limits.last).to be_a Fixnum
    end

    specify "setting the resource limit" do
      Process.setrlimit(:NOFILE, 4096)
      limits = Process.getrlimit(:NOFILE)

      expect(limits.first).to eq 4096
      expect(limits.last).to eq 4096
    end
  end
end
