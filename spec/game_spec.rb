require 'game'

describe 'Game' do
    subject(:game) { Game.new }
    describe '#initialize' do
        it 'creates a new deck' do
            expect(game.deck).to be_a(Deck)
        end
        it 'creates an empty pot' do
            expect(game.pot).to eq(0)
        end
        it 'creates an empty array of players' do
            expect(game.players).to be_empty
        end
    end

    describe '#add_players' do
        before(:each) { game.add_players(3, 100) }
        it 'should create the specified number of players' do
            expect(game.players.length).to eq(3)
        end
        it 'should create players' do
            game.players.each do |player|
                expect(player).to be_a(Player)
            end
        end
    end

    describe '#deal' do
        before(:each) { game.add_players(3, 100) }
        it 'deals a hand to each player' do
            game.deal
            game.players.each do |player|
                expect(player.hand).to_not be_nil
            end
        end
        it 'does not give a hand to a player with no money' do
            game.players[0].pot = 0
            game.deal
            expect(game.players[0].hand).to be_nil
        end
    end

    describe '#game_over?' do
        it 'returns true when only one player still has money' do
            game.add_players(1, 100)
            game.add_players(1, 0)
            expect(game.game_over?).to be_true
        end
        it 'returns false when more than one player has money' do
            game.add_players(2, 100)
            expect(game.game_over?).to be_false
        end
    end

    describe '#add_to_pot' do
        before(:each) { game.add_to_pot(500) }
        it 'adds given amount to pot' do
            expect(game.pot).to eq(500)
        end
        it 'returns the amount added' do
            expect(game.add_to_pot(10)).to eq(10)
        end
    end
end