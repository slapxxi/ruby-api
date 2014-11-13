RSpec.describe Kernel do
  specify "terminating execution" do
    at_exit { 'This will be executed after at exiting' }

    expect { abort 'Abort message' }.to raise_error SystemExit
    expect { exit }.to raise_error SystemExit
    expect { fail }.to raise_error RuntimeError
  end

  specify "autoloading" do
    autoload :Mutex, 'mutex'

    expect(autoload? :Mutex).to eq 'mutex'
    expect(Mutex).to be_a Module
  end

  specify "binding local environment" do
    def get_binding(**options)
      binding
    end
    status = eval 'options[:status]', get_binding(status: :progress)

    expect(status).to eq :progress
  end

  specify "determining whether a block given" do
    expect(block_given?).to eq false
  end

  specify "determining the caller stack" do
    expect(caller.size).to be > 0
    expect(caller_locations.size).to be > 0
  end

  specify "getting a list of global variables" do
    expect(global_variables.size).to be > 0
  end

  specify "getting a list of local variables" do
    first, second = nil
    expect(local_variables).to eq [:first, :second]
  end

  specify "executing external commands" do
    expect(`ls`).to be_a String
  end

  specify "generating a random number" do
    expect(rand(100)).to be < 101
  end
end
