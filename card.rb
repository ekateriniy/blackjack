class Card
  def card_deck
    values = ['A', 'K', 'Q', 'J', 10, 9, 8, 7, 6, 5, 4, 3, 2]
    suits = ["\u2660", "\u2663", "\u2666", "\u2665"]
    @deck ||= values.product(suits)
    @deck.shuffle
  end

  def give_cards(n)
    card_deck.pop(n)
  end

  # подсчет количества очков, которое содержится в картах
  # если есть туз - число обрабатывается в соответствие с condition игры

  def score(cards, condition)
    score = 0
    cards.each do |card|
      if card[0] == 'A'
        condition.call(score) ? score += 11 : score += 1
      elsif card[0].is_a? String 
        score += 10
      else
        score += card[0]
      end
    end

    score
  end
end