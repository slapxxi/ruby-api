class String
  alias_method :orig_upcase, :upcase

  def upcase
    puts '__new upcase__:'
    orig_upcase
  end
end

module Extension
  define_method(:action) do
    @status
  end

  module_function def configure
    puts "Configuring..."
  end

  def self.included(m)
    puts "Including #{m}..."
  end

  def self.extended(m)
    puts "Extending #{m}..."
  end
end

class Person
  include Extension

  def self.method_added(name)
    puts "Adding '#{name}' method..."
  end

  def self.method_removed(name)
    puts "Removing '#{name}' method..."
  end

  def initialize
    @status = :passive
  end

  remove_method def garbage
  end
end

Extension.configure
person = Person.new
p person.action
