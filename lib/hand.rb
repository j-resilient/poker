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

    # def <=>(hand2)
    #     unless self.hand_rank == hand2.hand_rank
    #         return HAND_POINTS[self.hand_rank] <=> HAND_POINTS[hand2.hand_rank]
    #     end

    #     # nil is falsy: everything else is truthy
    #     return 0 if self.hand.all? do |card|
    #         hand2.hand.find { |card2| card.suit == card2.suit && card.value == card2.value }
    #     end

    #     case self.hand_rank
    #     when :straight_flush, :straight
    #         return compare_straights
    #     end
    #     nil
    # end

    private
    HAND_POINTS = {
        :straight_flush => 8,
        :four_kind => 7,
        :full_house => 6,
        :flush => 5,
        :straight => 4,
        :three_kind => 3,
        :two_pair => 2,
        :one_pair => 1,
        :high_card => 0
    }
    CARD_POINTS = {
        :ace => 14,
        :king => 13,
        :queen => 12,
        :jack => 11,
        :ten => 10,
        :nine => 9,
        :eight => 8,
        :seven => 7,
        :six => 6,
        :five => 5,
        :four => 4,
        :three => 3,
        :two => 2,
        :ace_low => 1
    }

    def get_sorted_points(hand)
        points = []
        hand.each do |card| 
            if card.value == :ace && hand.none? { |card| card.value == :king }
                points << CARD_POINTS[:ace_low]
            else
                points << CARD_POINTS[card.value]
            end
        end
        points.sort!
    end

    def straight_flush?
        straight? && flush?
    end

    def straight?
        hand_points = get_sorted_points(self.hand)

        if mixed_high_low?(hand_points)
            remaining_points = hand_points.reject { |point| [2, 14, 13].include?(point) }
            return false unless [[3,4], [3, 12], [11, 12]].include?(remaining_points)
        else
            prev = hand_points.first
            hand_points[1..-1].each do |point|
                return false unless point == (prev + 1)
                prev = point
            end
        end
        true
    end

    def mixed_high_low?(points)
        points.include?(14) && points.include?(13) && points.include?(2)
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

    # def compare_straights(hand2)
    #     # find high cards
    #     # compare high cards
    #     self_high_card = find_high_card(self.hand)
    #     hand2_high_card = find_high_card(hand2)

    #     self_points = CARD_POINTS[self_high_card] 
    #     hand2_points = CARD_POINTS[hand2_high_card]

    #     # if self_high_card == :ace && self.hand.any? { |card| card.value == :two }
    #     #     self_points
    #     # end
    # end
end

