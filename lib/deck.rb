require_relative 'card'

class Deck

  attr_accessor :ary_of_cards
  def initialize
      @ary_of_cards = Deck.create_deck
  end

  def count
    ary_of_cards.count
  end

  def shuffle
    ary_of_cards.shuffle!
  end

  def deal_hand(number = 5)
    new_cards = ary_of_cards.take(number)
    self.ary_of_cards = ary_of_cards.drop(number)
    new_cards
  end

  def return_cards(cards)
    cards.each do |card|
      ary_of_cards << card
    end
  end

  private

  def self.create_deck
    temp_deck = []
    Card::SUITS.each do |suit|
      Card::VALUES_HASH.each_key do |value|
        temp_deck << Card.new(suit, value)
      end
    end

    temp_deck
  end
end

d = Deck.new
a = d.deal_hand
p "Before returning cards, there are #{d.count} in the deck"
d.return_cards(a)

p "After returning cards, there are #{d.count} in the deck"
