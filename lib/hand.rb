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
    VALUES = {
        :ace => 0, :king => 1, :queen => 2, :jack => 3,
        :ten => 4, :nine => 5, :eight => 6, :seven => 7, :six => 8, 
        :five => 9, :four => 10, :three => 11, :two => 12
    }

    def straight_flush?
        straight? && flush?
    end

    def straight?
        hand_numbers = []
        hand.each { |card| hand_numbers << VALUES[card.value] }
        hand_numbers.sort!

        if hand_numbers.first == 0 && hand_numbers.last == 12
            hand_numbers.shift
            hand_numbers.push(13)
        end
        
        prev = hand_numbers.first
        hand_numbers[1..-1].each do |num|
            return false unless num == (prev + 1)
            prev = num
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
        hand.each { |card| count[card.value] += 1 }
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

# x = Hand.new([
#             Card.new(:club, :five),
#             Card.new(:diamond, :five),
#             Card.new(:heart, :five),
#             Card.new(:spade, :five),
#             Card.new(:diamond, :two)
#         ])
# print x.hand_rank