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
    expect($PROGRAM_NAME).to be =~ /rspec$/i
  end

  context ARGV do
    it "contains command-line arguments" do
      expect(ARGV).to be_an Array
    end
  end

  context ENV do
    it "contains environment variables" do
      ENV['MSG'] = 'Hello, world!'
      expect(ENV['MSG']).to eq 'Hello, world!'
    end
  end

  context "resource limits" do
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
