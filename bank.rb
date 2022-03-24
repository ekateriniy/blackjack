class Bank
  attr_reader :all_money

  def get_bet(bet, players)
    @all_money = players.size * bet
  end

  def give_money_to(player, part = 1)
    player.get_money(all_money / part)
    @all_money = 0
  end
end