require 'rspec'
require 'card'
require 'deck'
require 'hand'
require 'player'
require 'game'

describe "Card" do
  it "creates a card correctly" do
    card = Card.new(:hearts, :two)
    expect(card.suit).to eq(:hearts)
    expect(card.value).to eq(:two)
  end
end

describe "Deck" do
  let(:deck) { Deck.new }
  it "initializes with 52 card" do
    deck = Deck.new
    expect(deck.count).to eq(52)
  end

  it "initializes with 52 unique cards" do
    expect(deck.ary_of_cards.uniq.count).to eq(52)
  end

  it "shuffles cards" do
    deck2 = Deck.new
    deck2.shuffle
    expect(deck2.ary_of_cards).to_not eq(deck.ary_of_cards)
  end

  it "deals n cards from the deck" do
    cards = [
      Card.new(:hearts, :two),
      Card.new(:spades, :seven),
      Card.new(:spades, :six),
      Card.new(:diamonds, :king),
      Card.new(:clubs, :jack)
    ]
    allow(deck.ary_of_cards).to receive(:take).and_return(cards)
    expect(deck.deal_hand).to eq(cards)
  end

  it "returns cards to the bottom of the deck" do
    cards = [
      Card.new(:hearts, :two),
      Card.new(:spades, :seven),
      Card.new(:spades, :six),
    ]
    deck.deal_hand(3)
    deck.return_cards(cards)
    expect(deck.count).to eq(52)
  end
end

describe "Hand" do
  let(:deck) { Deck.new }
  let(:hand) { Hand.new }

  it "should hold cards" do
    cards = deck.deal_hand
    hand.receive_cards(cards)
    expect(hand.cards_in_hand).to eq(cards)
  end

  it "should not hold more than five cards" do
    cards = deck.deal_hand(6)
    expect do
      hand.receive_cards(cards)
    end.to raise_error("can only hold five cards")
  end

  it "recognizes itself as a flush" do
    cards = [
      Card.new(:spades, :king),
      Card.new(:spades, :four),
      Card.new(:spades, :five),
      Card.new(:spades, :eight),
      Card.new(:spades, :six),
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_flush?).to eq(true)
  end

  it "doesn't recognize itself as a flush" do
    cards = [
      Card.new(:spades, :king),
      Card.new(:hearts, :four),
      Card.new(:spades, :five),
      Card.new(:spades, :eight),
      Card.new(:spades, :six),
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_flush?).to eq(false)
  end

  it "recognizes itself as a straight" do
    cards = [
      Card.new(:hearts, :two),
      Card.new(:spades, :four),
      Card.new(:spades, :five),
      Card.new(:diamonds, :three),
      Card.new(:spades, :six),
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_straight?).to eq(true)
  end

  it "doesn't recognize itself as a straight" do
    cards = [
      Card.new(:hearts, :two),
      Card.new(:spades, :four),
      Card.new(:spades, :seven),
      Card.new(:diamonds, :three),
      Card.new(:spades, :six),
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_straight?).to eq(false)
  end

  it "recognizes itself as a straight flush" do
    cards = [
      Card.new(:spades, :two),
      Card.new(:spades, :four),
      Card.new(:spades, :five),
      Card.new(:spades, :three),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_straight_flush?).to eq(true)
  end

  it "doesn't recognize itself as a straight flush" do
    cards = [
      Card.new(:spades, :two),
      Card.new(:spades, :four),
      Card.new(:hearts, :five),
      Card.new(:spades, :three),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_straight_flush?).to eq(false)
  end

  it "recognizes itself as four of a kind" do
    cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :five),
      Card.new(:clubs, :five),
      Card.new(:hearts, :five),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_four_of_a_kind?).to eq(true)
  end

  it "doesn't recognize itself as four of a kind" do
    cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :five),
      Card.new(:clubs, :six),
      Card.new(:hearts, :five),
      Card.new(:spades, :seven)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_four_of_a_kind?).to eq(false)
  end

  it "recognizes itself as a full house" do
    cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :five),
      Card.new(:clubs, :six),
      Card.new(:hearts, :five),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_full_house?).to eq(true)
  end

  it "doesn't recognize itself as a full house" do
    cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :five),
      Card.new(:clubs, :three),
      Card.new(:hearts, :four),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_full_house?).to eq(false)
  end

  it "recognizes itself as a 3 of a kind" do
    cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :five),
      Card.new(:clubs, :four),
      Card.new(:hearts, :five),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_three_of_a_kind?).to eq(true)
  end

  it "doesn't recognize itself as a 3 of a kind" do
    cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :five),
      Card.new(:clubs, :three),
      Card.new(:hearts, :four),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_three_of_a_kind?).to eq(false)
  end

  it "recognizes itself as a two pair" do
    cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :five),
      Card.new(:clubs, :four),
      Card.new(:hearts, :four),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_two_pair?).to eq(true)
  end

  it "doesn't recognize itself as a two pair" do
    cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :five),
      Card.new(:clubs, :three),
      Card.new(:hearts, :four),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_two_pair?).to eq(false)
  end

  it "recognizes itself as one pair" do
    cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :five),
      Card.new(:clubs, :seven),
      Card.new(:hearts, :four),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_one_pair?).to eq(true)
  end

  it "doesn't recognize itself as one pair" do
    cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :seven),
      Card.new(:clubs, :three),
      Card.new(:hearts, :four),
      Card.new(:spades, :six)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.is_one_pair?).to eq(false)
  end

  it "recognizes what kind of hand it has" do
    cards = [
      Card.new(:hearts, :ace),
      Card.new(:hearts, :king),
      Card.new(:hearts, :queen),
      Card.new(:hearts, :jack),
      Card.new(:hearts, :ten)
    ]
    allow(hand).to receive(:cards_in_hand).and_return(cards)
    expect(hand.what_kind_of_hand).to eq(:straight_flush)
  end

  it "recognizes when it beats another hand" do
    self_hand = [
      Card.new(:hearts, :ace),
      Card.new(:hearts, :king),
      Card.new(:hearts, :queen),
      Card.new(:hearts, :jack),
      Card.new(:hearts, :ten)
    ]
    other_cards = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :seven),
      Card.new(:clubs, :three),
      Card.new(:hearts, :four),
      Card.new(:spades, :six)
    ]
    other_hand = Hand.new
    allow(hand).to receive(:cards_in_hand).and_return(self_hand)
    allow(other_hand).to receive(:cards_in_hand).and_return(other_cards)
    expect(hand.beats?(other_hand)).to eq(true)
  end

  it "recognizes when it doesn't beat another hand" do
    other_cards = [
      Card.new(:hearts, :ace),
      Card.new(:hearts, :king),
      Card.new(:hearts, :queen),
      Card.new(:hearts, :jack),
      Card.new(:hearts, :ten)
    ]
      self_hand = [
      Card.new(:diamonds, :five),
      Card.new(:spades, :seven),
      Card.new(:clubs, :three),
      Card.new(:hearts, :four),
      Card.new(:spades, :six)
    ]
    other_hand = Hand.new
    allow(hand).to receive(:cards_in_hand).and_return(self_hand)
    allow(other_hand).to receive(:cards_in_hand).and_return(other_cards)
    expect(hand.beats?(other_hand)).to eq(false)
  end
  # it "should compare which hand wins" do
  #
  # end
end

describe "Player" do
  let(:player) { Player.new }

  it "has a pot" do
    expect(player.personal_pot).to eq(1000)
  end

  it "can discard one card" do
    card = Card.new(:hearts, :seven)
    allow(player.hand).to receive(:receive_cards) {card}
    player.discard_card(card)
    expect(player.hand.cards_in_hand).not_to include(card)
  end


  it "can discard any number of cards" do
    cards = [
      Card.new(:hearts, :seven),
      Card.new(:spades, :five)
    ]
    allow(player.hand).to receive(:receive_cards) {cards}
    player.discard_card(cards)
    expect(player.hand.cards_in_hand).not_to include(cards)
  end

  it "takes pot" do
    winnings = 200
    player.receive_winning(winnings)

    expect(player.personal_pot).to eq(1200)
  end
end

describe "game" do
  let(:game) { Game.new }

  it "starts with no players" do
    expect(game.players).to eq([])
  end

  it "starts with an empty pot" do
    expect(game.pot).to eq(0)
  end

  it "keeps track of the total pot" do
    game.receive_bet(200)
    expect(game.pot).to eq(200)
  end

  it "pays out winnings" do
    player = Player.new
    amt = 200
    game.receive_bet(amt)
    game.pay_out(player, amt)
    expect(game.pot).to eq(0)
  end

  it "doesn't pay out more than is in the pot" do
    player = Player.new
    game.receive_bet(20)
    expect do
      game.pay_out(player, 20000)
    end.to raise_error("not enough money in pot")
  end

  it "can have players" do
    players = [Player.new, Player.new, Player.new]
    game.create_players(players)
    expect(game.players.length).to eq(3)
  end

  it "keeps track of current player" do
    # allow(game).to receive(:current_player).and_return('a')
    allow(game).to receive(:players).and_return(['a', 'b', 'c'])
    game.take_turn
    expect(game.current_player).to eq('b')
  end
end
