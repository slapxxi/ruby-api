RSpec.describe Proc do
  specify "creating a lambda" do
    l = lambda {|required| :called}

    expect(l).to be_lambda
    expect { l.call }.to raise_error
    expect(l.call :require).to eq :called
  end

  specify "creating a proc" do
    p = proc {|not_required| :called}

    expect(p).not_to be_lambda
    expect(p.call).to eq :called
  end

  specify "calling with []" do
    p = proc {:called}

    expect(p[]).to eq :called
  end

  specify "using proc with case statement" do
    even = proc { |o| o.even? }
    odd = proc { |o| o.odd? }

    case 2
    when even then result = true
    when odd then result = false
    end

    expect(result).to eq true
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
