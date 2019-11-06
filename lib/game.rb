require_relative 'deck'
require_relative 'player'
require_relative 'hand'
require 'byebug'

class Game
    attr_reader :deck, :pot, :players

    def initialize
        @deck = Deck.new
        @pot = 0
        @players = []
        @current_bet = 0
    end

    def play
        until game_over?
            play_round
        end
        winner = @players.find { |player| player.pot > 0 }
        puts "Player #{@players.index(winner) + 1} wins!"
    end

    def play_round
        start_round
        end_round_flag = false
        until end_round_flag
            end_round_flag = true

            @players.each_with_index do |player, idx|
                next if player.folded?

                print_table
                print_round(idx)

                bet = player.take_turn(idx, @current_bet)
                @current_bet = player.current_bet unless player.folded?
                add_to_pot(bet)

                end_round_flag = false if player.folded?
            end

            end_round_flag = false if @players.any? { |player| player.current_bet != @current_bet }
        end

        print_table
        declare_winner
    end

    def start_round
        @players.each do |player|
            deck.return_cards(player.return_cards) unless player.hand.nil?
        end
        deal
    end

    def declare_winner
        # debugger
        remaining_players = @players.reject { |player| player.folded? }
        hands = remaining_players.map { |player| player.hand }
        winning_hand = Hand.winner(hands)
        winner = players.find { |player| player.hand == winning_hand }
        @players.each_with_index { |player, idx| puts "Player #{idx + 1}: #{player.hand.print_cards}"}
        winner_idx = players.index(winner)
        @players[winner_idx].add_winnings(@pot)
        @pot = 0
        puts "Player #{winner_idx + 1} wins round!"
        sleep(2)
    end
    
    def print_table
        system("clear")
        puts "Pot: $#{@pot}"
        players.each_with_index { |p, i| puts "Player #{i + 1} has $#{p.pot}" }
        puts "The bet is at $#{@current_bet}"
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
game = Game.new
game.add_players(3, 100)
game.play