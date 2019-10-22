require_relative 'card'

class Hand
    attr_accessor :hand

    def initialize(hand)
        @hand = hand
    end

    def trade_cards(discard, new_cards)
        raise "Cannot discard card you don't have." unless discard.all? { |card| hand.include?(card) }
        hand.delete_if { |card| discard.include?(card) }
        hand.concat(new_cards)
    end
end