require_relative 'deck'
require_relative 'player'

class Game
    attr_reader :deck, :pot, :players

    def initialize
        @deck = Deck.new
        @pot = 0
        @players = []
    end

    def add_players(count, buy_in)
        count.times { @players << Player.new(buy_in) }
    end

    def deal
        @players.each { |player| player.hand = Hand.new(@deck.deal) unless player.pot == 0 }
    end

    def game_over?
        @players.one? { |player| player.pot > 0 }
    end

    def add_to_pot(amt)
        @pot += amt
        amt
    end
end