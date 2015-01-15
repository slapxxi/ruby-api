RSpec.describe Proc do
  specify "creating a lambda" do
    l = lambda {|required| required}

    expect(l).to be_lambda
    expect { l.call }.to raise_error
    expect(l.call :required).to eq :required
  end

  specify "creating a proc" do
    p = proc {|not_required| not_required}

    expect(p).not_to be_lambda
    expect { p.call }.not_to raise_error
    expect(p.call).to be_nil
  end

  it "can be called with [] or .()" do
    p = proc { |param| param }

    expect( p[true] ).to be true
    expect( p.(true) ).to be true
  end

  it "can be used with `when`" do
    even = proc { |o| o.even? }
    odd = proc { |o| o.odd? }

    result = case 8
      when even then true
      when odd then false
    end

    expect(result).to be true
  end

  specify "using binding" do
    def closure
      variable = :closure
      proc {}
    end

    expect(eval 'variable', closure.binding).to eq :closure
  end

  specify "currying" do
    l = lambda {|one, two| one + two}
    c = l.curry
    c = c.call 2
    expect(c.call 2).to eq 4
  end

  specify "determining parameters information" do
    p = proc {|name, value| nil }
    l = -> (name, value) { nil }

    expect(p.parameters).to eq [[:opt, :name], [:opt, :value]]
    expect(l.parameters).to eq [[:req, :name], [:req, :value]]
  end

  specify "converting to procs" do
    Array.send :define_method, :to_proc do
      proc {|element, index| include? index}
    end

    expect(%w[one two three].select.with_index &[1, 2]).to eq %w[two three]
  end
end
