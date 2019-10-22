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

    def hand_rank
        return :straight_flush if straight_flush?
        return :four_kind if four_kind?
        return :full_house if full_house?
        return :flush if flush?
        return :straight if straight?
        return :three_kind if three_kind?
        return :two_pair if two_pair?
        return :one_pair if one_pair?
        :high_card
    end

    private
    VALUES = [
        :king, :queen, :jack, :ten, :nine,
        :eight, :seven, :six, :five, :four,
        :three, :two
    ]

    def straight_flush?
        straight? && flush?
    end

    def straight?
        idx = VALUES.index(hand[0])
        hand.each do |card|
            return false unless VALUES[idx] == card.value
            idx = (idx + 1) >= VALUES.length ? 0 : idx + 1 
        end
        true
    end

    def flush?
        hand.all? { |card| card.suit == hand[0].suit }
    end

    def four_kind?
        same_card_count.include?(4)
    end

    def same_card_count
        count = Hash.new(0)
        hand.each { |card| count[card] += 1 }
        count.values
    end

    def full_house?
        three_kind? && one_pair?
    end

    def three_kind?
        same_card_count.include?(3)
    end

    def two_pair?
        same_card_count.count(2) == 2
    end

    def one_pair?
        same_card_count.include?(2)
    end
end