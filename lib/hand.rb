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

    def <=>(hand2)
        unless self.hand_rank == hand2.hand_rank
            return HAND_POINTS[self.hand_rank] <=> HAND_POINTS[hand2.hand_rank]
        end

        # nil is falsy: everything else is truthy
        return 0 if self.hand.all? do |card|
            hand2.hand.find { |card2| (card <=> card2) == 0 }
        end

        case self.hand_rank
        when :straight_flush, :straight
            return compare_straights(hand2)
        when :four_kind
            return compare_four_kind(hand2)
        end
    end

    def same_card_count
        count = Hash.new(0)
        hand.each { |card| count[card.value] += 1 }
        count
    end

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

    def sort!
        hand.sort!
    end

    def straight_flush?
        straight? && flush?
    end

    def get_points
        self.sort!
        points = hand.map { |card| card.points }
        if points.include?(14) && !points.include?(13)
            points.pop
            points.unshift(1)
        end
        points
    end

    def straight?
        points = get_points

        if mixed_high_low?(points)
            remaining_points = points.reject { |point| [2, 14, 13].include?(point) }
            return false unless [[3,4], [3, 12], [11, 12]].include?(remaining_points)
        else
            prev = points.first
            points[1..-1].each do |point|
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
        same_card_count.has_value?(4)
    end

    def full_house?
        three_kind? && one_pair?
    end

    def three_kind?
        same_card_count.has_value?(3)
    end

    def two_pair?
        same_card_count.values.count(2) == 2
    end

    def one_pair?
        same_card_count.has_value?(2)
    end

    def compare_straights(hand2)
        self.get_points.last <=> hand2.get_points.last
    end

    def compare_four_kind(hand2)
        self_card_count = self.same_card_count.invert
        hand2_card_count = hand2.same_card_count.invert

        self_four_card = self.hand.find { |card| card.value == self_card_count[4] }
        hand2_four_card = hand2.hand.find { |card| card.value == hand2_card_count[4] }

        equality = self_four_card <=> hand2_four_card
        return equality unless equality == 0

        self_kicker = self.hand.find { |card| card.value == self_card_count[1] }
        hand2_kicker = hand2.hand.find { |card| card.value == hand2_card_count[1] }

        self_kicker <=> hand2_kicker
    end
end
# x = Hand.new([
#     Card.new(:diamond, :king),
#     Card.new(:diamond, :jack),
#     Card.new(:diamond, :ace),
#     Card.new(:diamond, :queen),
#     Card.new(:diamond, :ten)
# ])
# x.hand.each { |card| print "#{card.display} "}
# puts
# x.sort!
# x.hand.each { |card| print "#{card.display} "}
