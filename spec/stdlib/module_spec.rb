RSpec.describe Module do
  module Example
    VERSION = '0.0.1'
    @@revision = 0

    def action
    end
  end

  specify "creating an anonymous module" do
    mod = Module.new do
      def action
      end
    end

    expect(Object.new.extend mod).to respond_to :action
  end

  specify "including modules" do
    String.include Example

    expect('string').to respond_to :action
    expect(String.included_modules).to eq [Example, Comparable, PP::ObjectMixin, Kernel]
  end

  specify "comparing modules" do
    expect(String < Object).to eq true
    expect(Object > String).to eq true

    expect(String <= String).to eq true
    expect(String >= String).to eq true

    expect(String <=> Kernel).to eq -1
    expect(String <=> Fixnum).to be_nil

    expect(String === 'string').to eq true

    expect(String.include? Kernel).to eq true
  end

  specify "redefining const_missing" do
    def Example.const_missing(name)
      name
    end

    expect(Example::FOOBAR).to eq :FOOBAR
  end

  specify "getting a constant" do
    expect(Example.const_get :VERSION).to eq '0.0.1'
  end

  specify "setting a constant" do
    Example.const_set :REVISION, 0

    expect(Example.const_get :REVISION).to eq 0
  end

  specify "getting constants" do
    expect(Example.constants).to eq [:VERSION, :REVISION]
  end

  specify "determining whether a constant defined" do
    expect(Example.const_defined? :VERSION).to eq true
  end

  specify "getting ancestors" do
    expect(Example.ancestors).to eq [Example]
  end

  specify "getting instance methods" do
    expect(Example.instance_methods).to eq [:action]
  end

  specify "getting a class variable" do
    expect(Example.class_variable_get :@@revision).to eq 0
  end

  specify "getting class variables" do
    expect(Example.class_variables).to eq [:@@revision]
  end

  specify "setting a class variable" do
    Example.class_variable_set :@@temporal, true

    expect(Example.class_variable_get :@@temporal).to eq true
  end

  specify "determining nesting in the current scope" do
    module A
      module B
        NESTING = Module.nesting
      end
    end

    expect(A::B::NESTING).to eq [A::B, A]
  end

  specify "evaluating in the context of module" do
    expect(Example.module_eval 'VERSION').to eq '0.0.1'
    expect(Example.class_eval 'VERSION').to eq '0.0.1'
  end

  specify "executing a block in the context of module" do
    Example.module_exec { def self.version; 0; end}

    expect(Example.version).to eq 0
  end

  specify "determining whether defined" do
    expect(Example.class_variable_defined? :@@revision).to eq true
    expect(Example.class_variable_defined? :@@foobar).to eq false
  end
end
