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
        return :straight_flush if straight? && flush?
        return :four_kind if duplicates(4)
        return :full_house if duplicates(3) && duplicates(2)
        return :flush if flush?
        return :straight if straight?
        return :three_kind if duplicates(3)
        return :two_pair if same_card_count.values.count(2) == 2
        return :one_pair if duplicates(2)
        :high_card
    end

    def self.winner(hands)
        hands.max
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
            compare_straights(hand2)
        when :one_pair, :three_kind, :four_kind, :full_house
            compare_duplicates(hand2)
        when :two_pair
            compare_two_pair(hand2)
        when :high_card, :flush
            compare_high_cards(hand2)
        end
    end

    def same_card_count
        count = Hash.new(0)
        hand.each { |card| count[card.value] += 1 }
        count
    end

    def duplicates(count)
        same_card_count.has_value?(count)
    end

    def flush?
        hand.all? { |card| card.suit == hand[0].suit }
    end

    def map_points
        self.hand.sort!
        points = hand.map { |card| card.points }
        if points.include?(14) && !points.include?(13)
            points.pop
            points.unshift(1)
        end
        points
    end

    def mixed_high_low?(points)
        points.include?(14) && points.include?(13) && points.include?(2)
    end

    def straight?
        points = map_points

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

    def compare_straights(hand2)
        self.map_points.last <=> hand2.map_points.last
    end

    def compare_two_pair(hand2)
        self_pairs = self.get_pairs
        hand2_pairs = hand2.get_pairs

        until self_pairs.empty?
            eq = self_pairs.pop <=> hand2_pairs.pop
            return eq unless eq == 0
        end
        
        self.kicker <=> hand2.kicker
    end

    def get_pairs
        pairs = same_card_count.select { |val, count| count == 2 }.keys
        pairs.map! do |val| 
            hand.find { |card| card.value == val }
        end
        pairs.sort!
    end

    def kicker
        val = same_card_count.select { |card_val, count| count == 1 }.keys
        hand.find { |card| card.value == val.first }
    end

    def compare_duplicates(hand2)
        self_card_count = self.same_card_count.invert.sort_by { |k,v| -k }
        hand2_card_count = hand2.same_card_count.invert.sort_by { |k,v| -k }

        until self_card_count[0][0] == 1
            self_count, self_card_val = self_card_count.shift
            hand2_count, hand2_card_val = hand2_card_count.shift

            self_card = self.hand.find { |card| card.value == self_card_val }
            hand2_card = hand2.hand.find { |card| card.value == hand2_card_val }

            eq = self_card <=> hand2_card
            return eq unless eq == 0
        end

        new_self = Hand.new(hand.select { |card| self_card_count.flatten.include?(card.value) } )
        new_hand2 = Hand.new(hand2.hand.select { |card| hand2_card_count.flatten.include?(card.value) } )

        new_self.compare_high_cards(new_hand2)
    end

    def compare_high_cards(hand2)
        self_points = self.map_points.reverse
        hand2_points = hand2.map_points.reverse

        self_points.each_with_index do |curr_points, idx|
            eq = curr_points <=> hand2_points[idx]
            return eq unless eq == 0
        end

        return 0
    end
end
# x = Hand.new([
#         Card.new(:club, :jack),
#         Card.new(:spade, :jack),
#         Card.new(:heart, :three),
#         Card.new(:diamond, :three),
#         Card.new(:spade, :four)
#     ])
# y = Hand.new([
#         Card.new(:heart, :jack),
#         Card.new(:spade, :jack),
#         Card.new(:club, :three),
#         Card.new(:spade, :three),
#         Card.new(:heart, :two)
#     ])
# puts x <=> y