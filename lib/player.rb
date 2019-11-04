class Player
    attr_accessor :pot, :hand

    def self.buy_in(pot)
        Player.new(pot)
    end

    def initialize(initial_pot)
        @pot = initial_pot
        @hand = nil
        @folded = false
    end

    def set_hand(cards)
        @hand = cards
    end

    def bet(amt)
        raise "Cannot bet more than you have." if amt > @pot
        @pot -= amt
        amt
    end

    def add_winnings(winnings)
        @pot += winnings
    end

    def return_cards
        cards = @hand.cards
        @hand = nil
        cards
    end

    def folded?
        @folded
    end

    def fold
        @folded = true
    end

    def unfold
        @folded = false
    end
end