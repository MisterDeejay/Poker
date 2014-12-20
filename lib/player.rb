require_relative 'deck'

class Player
  attr_reader :personal_pot, :hand

  def initialize(personal_pot = 1000)
    @personal_pot = personal_pot
    @hand = Hand.new
  end

  def make_bet(amount)
    raise "not enough money in your account" if amount > personal_pot
    @personal_pot -= amount
    amount
  end

  def discard_card(cards)
    if [cards].length == 1
      hand.return_card(cards)
    else
      [cards].each do |card|
        hand.return_card(card)
      end
    end
  end

  def ask_player
    puts "Would you like to (f)old, (s)ee or (r)aise?"
    gets.chomp
  end

  def receive_winning(amount)
    @personal_pot += amount
  end

end
