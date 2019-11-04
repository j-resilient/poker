require 'player'

describe 'Player' do
    describe '::buy_in' do
        it 'creates a player' do
            expect(Player.buy_in(100)).to be_a(Player)
        end

        it 'sets pot' do
            expect(Player.buy_in(100).pot).to eq(100)
        end
    end

    subject(:player_one) { Player.buy_in(100) }

    describe '#set_hand' do
        let(:hand) { double ('hand') }
        it 'sets the players hand' do
            player_one.set_hand(hand)
            expect(player_one.hand).to eq(hand)
        end
    end

    describe '#bet' do
        it 'decrements the pot by correct amount' do
            expect { player_one.bet(50) }.to change { player_one.pot }.by(-50)
        end
        it 'raises an error if bet is more than the pot' do
            expect { player_one.bet(200) }.to raise_error("Cannot bet more than you have.")
        end
        it 'returns the bet amount' do
            expect(player_one.bet(50)).to eq(50)
        end
    end

    describe '#add_winnings' do
        it 'adds winnings to pot' do
            expect { player_one.add_winnings(100) }.to change { player_one.pot }.by(100)
        end
    end

    describe '#return cards' do
        let(:cards) { double('cards') }
        let(:hand) { double('Hand', :cards => cards) }
        before(:each) { player_one.set_hand(hand) }
        it 'returns cards' do
            expect(player_one.return_cards).to eq(cards)
        end
        it 'sets hand to nil' do
            player_one.return_cards
            expect(player_one.hand).to eq(nil)
        end
    end

    describe '#fold' do
        it 'sets folded? to true' do
            player_one.fold
            expect(player_one).to be_folded
        end
    end

    describe '#unfold' do
        it 'sets folded? to false' do
            player_one.fold
            player_one.unfold
            expect(player_one).to_not be_folded
        end
    end
end