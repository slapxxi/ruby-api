module Money
  class Currency
    attr_reader :amount

    def initialize(amount)
      @amount = amount
    end

    def +(currency)
      self.class.new amount + currency.amount if currency.respond_to? :amount
    end
  end

  USD = Class.new(Currency)
  RUB = Class.new(Currency)
  EURO = Class.new(Currency)

  module DSL
    %i(RUB USD EURO).each do |currency|
      define_method(currency) do |amount|
        RUB.new amount
      end
    end

    USD = Money::USD
    RUB = Money::RUB
  end
end


include Money::DSL


my_account = USD(100) + RUB(100)
my_account = RUB(100) + USD(100)
p my_account
