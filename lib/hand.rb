class Hand

  attr_reader :cards_in_hand

  HAND_VALUES = {
    :straight_flush => 8,
    :four_of_a_kind => 7,
    :full_house => 6,
    :flush => 5,
    :straight => 4,
    :three_of_a_kind => 3,
    :two_pair => 2,
    :one_pair => 1,
    :high_card => 0
  }

  def initialize
    @cards_in_hand = []
  end

  def receive_cards(cards)
    raise "can only hold five cards" if cards.length + cards_in_hand.length > 5
    cards.each do |card|
      @cards_in_hand << card
    end
  end

  def return_card(card)
    @cards_in_hand.delete(card)
    card
  end

  def beats?(other_hand)
    case HAND_VALUES[self.what_kind_of_hand] <=> HAND_VALUES[other_hand.what_kind_of_hand]
    when -1
      false
    when 0
      # do more
    when 1
      true
    end
  end

  def what_kind_of_hand
    return :straight_flush if self.is_straight_flush?
    return :four_of_a_kind if self.is_four_of_a_kind?
    return :full_house if self.is_full_house?
    return :flush if self.is_flush?
    return :straight if self.is_straight?
    return :three_of_a_kind if self.is_three_of_a_kind?
    return :two_pair if self.is_two_pair?
    return :one_pair if self.is_one_pair?
    :high_card
  end

  def is_straight_flush?
    is_straight? && is_flush?
  end

  def is_flush?
    suit = cards_in_hand[0].suit
    cards_in_hand.all? { |card| card.suit == suit }
  end

  def is_straight?
    sorted_hand = self.sort_hand
    0.upto(sorted_hand.length - 2) do |i|
      return false if sorted_hand[i] != sorted_hand[i + 1] - 1
    end
    true
  end

  def is_four_of_a_kind?
    kind_hash = Hash.new { |h, k| h[k] = 0 }
    cards_in_hand.each do |card|
      kind_hash[card.value] += 1
    end

    kind_hash.any? { |_key, value| value == 4 }
  end

  def is_full_house?
    kind_hash = Hash.new { |h, k| h[k] = 0 }
    cards_in_hand.each do |card|
      kind_hash[card.value] += 1
    end

    kind_hash.any? { |_key, value| value == 3 } && kind_hash.any? { |_key, value| value == 2 }
  end

  def is_three_of_a_kind?
    kind_hash = Hash.new { |h, k| h[k] = 0 }
    cards_in_hand.each do |card|
      kind_hash[card.value] += 1
    end

    kind_hash.any? { |_key, value| value == 3 }
  end

  def is_two_pair?
    num_pairs = 0
    kind_hash = Hash.new { |h, k| h[k] = 0 }
    cards_in_hand.each do |card|
      kind_hash[card.value] += 1
    end

    kind_hash.each do |key, value|
      num_pairs += 1 if value == 2
    end

    num_pairs == 2
  end

  def is_one_pair?
    num_pairs = 0
    kind_hash = Hash.new { |h, k| h[k] = 0 }
    cards_in_hand.each do |card|
      kind_hash[card.value] += 1
    end

    kind_hash.each do |key, value|
      num_pairs += 1 if value == 2
    end

    num_pairs == 1
  end

  def sort_hand
    cards_in_hand.map { |card| Card::VALUES_HASH[card.value] }.sort
  end
end
