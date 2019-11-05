class Player
    attr_accessor :pot, :hand
    attr_reader :current_bet

    def self.buy_in(pot)
        Player.new(pot)
    end

    def initialize(initial_pot)
        @pot = initial_pot
        @hand = nil
        @folded = false
        @current_bet = 0
    end

    def take_turn(idx, table_bet)
        print "(c)all, (b)et, (d)iscard, or (f)old > "
        amt = 0
        case gets.chomp.downcase
        when 'f', 'fold'
            fold
        when 'c', 'call'
            bet(table_bet - @current_bet)
        when 'b', 'bet'
            amt = get_bet(idx, table_bet)
        # when 'd', 'discard'
        #     discard
        #     take_turn(idx, table_bet)
        else
            puts "must be (c)all, (b)et, (d)iscard, or (f)old"
            take_turn(idx, table_bet)
        end
        amt
    end

    def get_bet(idx, table_bet)
        print "Bet (bankroll: $#{@pot}) > "
        amt = gets.chomp.to_i
        if (amt + @current_bet) < table_bet
            puts "bet must at least match current bet"
            get_bet(idx, table_bet)
        else
            begin
                return bet(amt)
            rescue => exception
                puts exception
                get_bet(idx, table_bet)
            end
        end
    end

    def set_hand(cards)
        @hand = cards
    end

    def bet(amt)
        raise "Cannot bet more than you have." if amt > @pot
        @pot -= amt
        @current_bet += amt
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