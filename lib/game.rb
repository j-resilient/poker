require_relative 'deck'
require_relative 'player'
require_relative 'hand'

class Game
    attr_reader :deck, :pot, :players

    def initialize
        @deck = Deck.new
        @pot = 0
        @players = []
        @current_bet = 0
    end

    def play_round
        end_round = false
        until end_round || @players.one? { |player| player.folded? }
        end_round = true
            @players.each_with_index do |player, idx|
                next if player.folded?
                print_table(idx)
                print_round(idx)
                @current_bet = player.take_turn(idx, @current_bet)
                add_to_pot(@current_bet)
                end_round = false if player.folded?
            end
        end
    end

    def print_table(idx)
        system("clear")
        puts "Pot: $#{@pot}"
        players.each_with_index { |p, i| puts "Player #{i + 1} has $#{p.pot}" }
        puts "The bet is at #{@current_bet}"
        puts
    end

    def print_round(idx)
        puts "Current Player: #{idx + 1}"
        puts "Player #{idx + 1} has bet: $#{@players[idx].current_bet}"
        puts "Player #{idx + 1}'s hand: #{@players[idx].hand.print_cards}"
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
# game = Game.new
# game.add_players(3, 100)
# game.deal
# game.play_round