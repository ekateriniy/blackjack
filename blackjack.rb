class BlackJack
  attr_accessor :players, :score
  attr_reader :bank, :card_deck

  def initialize 
    @players = {user: nil, computer: nil}
    @score = {}
  end

  def greeting
    puts 'Игра в блекджек в немного укороченной форме'
    puts 'Введите свое имя'
    username = gets.chomp
    self.players[:user] = UserPlayer.new(username)
    self.players[:computer] = ComputerPlayer.new('Дилер')
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def game_start
    loop do
      puts 'Если хотите закончить игру - введите 0'
      action = gets.chomp
      break if action == '0'

      puts 'Размер ставки на одну игру - 10$.' 
      make_bets
      puts "Ваш баланс: #{players[:user].money}"

      initialize_card_deck
      initialize_players

      user_action
    end
  end

  def user_action
    score_counter

    show_computers_cards(true)
    puts 
    show_users_cards

    puts "Нажмите 1, чтобы пропустить ход.\n" \
    "Нажмите 2, чтобы взять еще одну карту.\n" \
    "Нажмите Enter, чтобы открыть карты."

    action = gets.to_i

    case action
    when 1
      computer_action
    when 2
      player_take_card(players[:user])
      show_users_cards
      puts "Ваше количество очков: #{score[:user]}"
      computer_action
    end
    
      show_users_cards
      show_computers_cards
      score_counter

      puts "Ваше количество очков: #{score[:user]}\n" \
      "Количество очков у дилера: #{score[:computer]}\n" \
      "Победитель: #{decide_the_winner}"

      clear_game
  end

  def computer_action
    if score[:computer] >= 17
      puts 'Дилер пропускает ход'
    else
      player_take_card(players[:computer])
      puts 'Дилер берет еще одну карту'
    end
  end

  def initialize_players
    players.each_value do |player|
        player.take_cards(card_deck.give_cards(2))
    end
  end

  def initialize_card_deck
    @card_deck = Card.new
  end

  def make_bets
    @bank ||= Bank.new
    players.each_value { |player| player.make_bet(10) }
    @bank.get_bet(10, players)
  rescue RuntimeError => e
    puts e.message
    puts "Игра окончена"
    exit
  end

  def show_computers_cards(hiden = nil)
    if hiden
      cards = '*' * players[:computer].cards.size 
    else
      cards = players[:computer].cards.join(' ')
    end

    puts "Карты дилера:\n#{cards}"
  end

  def show_users_cards
    puts 'Ваши карты:'
    puts "#{players[:user].cards.join(' ')}"
  end

  def player_take_card(player)
    player.take_cards(card_deck.give_cards(1))
  end

  # подсчет текущего кол-ва очков
  def score_counter
    players.each do |player_name, player| 
      score[player_name] = card_deck.score(player.cards, lambda { |score| score + 11 <= 21 })
    end
  end

  # определение победителя, в соответствии с условиями игры
  def decide_the_winner
    if score[:user] == score[:computer] 
      players.each_value { |player| bank.give_money_to(player, 2) }
      return winner = 'не определен. Ничья.'
    elsif score.values.max > 21
      score.select { |player, result| winner = player if result < 21 }
    else
      score.select { |player, result| winner = player if result <= 21 && result == score.values.max }
    end

      bank.give_money_to(players[winner])
      winner = players[winner].name
  end

  # сброс карт и очков пользователей
  def clear_game
    players.each_value(&:fold_cards!)
    @score &&= {}
  end
end
