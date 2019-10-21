require_relative 'card'

class Deck
    attr_accessor :deck

    def initialize(deck = create_deck)
        @deck = deck
    end

    def shuffle!
        deck.shuffle!
    end

    def card_count
        deck.length
    end

    def deal
        deck.shift(5)
    end

    def draw
        deck.shift
    end

    private
    SUITS = [:heart, :diamond, :spade, :club]
    VALUES = [
        :ace, :king, :queen, :jack, :ten, :nine, :eight,
        :seven, :six, :five, :four, :three, :two]
    def create_deck
        cards = []
        SUITS.each do |suit|
            VALUES.each { |value| cards << Card.new(suit, value) }
        end
        cards
    end
end