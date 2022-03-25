class Player
  attr_accessor :cards, :money
  attr_reader :name

  def initialize(name, money = 100)
    @cards = []
    @money = money
    @name = name
    validate_name!
  end

  def take_cards(cards)
    @cards.append(*cards)
  end

  def get_money(sum)
    @money += sum
  end

  def make_bet(sum)
    check_money!(sum)
    @money -= sum
  end

  def fold_cards!
    @cards = []
  end

  private

  def validate_name!
    raise 'Name must not be empty' if name == '' || name.nil?
  end

  def check_money!(sum)
    raise "There are no money on #{name}'s account" if money < sum
  end
end
