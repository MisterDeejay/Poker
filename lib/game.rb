require 'player'

class Game
  attr_accessor :current_player
  attr_reader :players, :pot, :deck

  def initialize
    @players = []
    @pot = 0
    @deck = Deck.new
    @current_player = nil
  end

  def play
    until game_over?
      deal_cards # => take turn
      take_bets # => Take turn inside
      exchange_cards
      take_bets
      compare_hands
      pay_out_winnings
    end
  end

  def take_turn
    index = (self.players.index(self.current_player) + 1) % self.players.length
    self.current_player = self.players[index]
  end

  def create_players(new_players)
    new_players.each do |new_player|
      self.players << new_player
    end
  end

  def receive_bet(amount)
    @pot += amount
  end

  def pay_out(player, amount)
    raise "not enough money in pot" if amount > pot
    @pot -= amount
    player.receive_winning(amount)
  end
end
