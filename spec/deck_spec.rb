require 'deck'

describe 'Deck' do
    subject(:deck) { Deck.new }

    describe '#initialize' do
        it 'deck contains 52 cards' do
            expect(deck.deck.length).to eq(52)
        end
        it 'deck has no duplicates' do
            expect(deck.deck).to eq(deck.deck.uniq { |card| card.face })
        end
        it 'deck contains card objects' do
            deck.deck.each do |card|
                expect(card).to be_a(Card)
            end
        end
    end

    describe '#shuffle!' do
        let(:cards) { Deck.new }
        before(:each) { deck.shuffle! }

        it 'shuffles the order of the deck' do
            expect(deck.deck).to_not eq(cards.deck)
        end
        it 'does not remove cards' do
            expect(deck.deck.length).to eq(52)
        end
        it 'does not change the contents of the deck' do
            expect(deck.deck).to match_array(cards.deck)
        end
    end

    describe '#deal' do
        let(:hand) { deck.deal }
        it 'returns five objects' do
            expect(hand.length).to eq(5)
        end
        it 'returns card objects' do
            hand.each { |card| expect(card).to be_a(Card) }
        end
        it 'removes five cards from deck' do
            expect(deck.deck.length).to eq(47)
        end
        it 'removes dealt cards from the deck' do
            hand.each { |card| expect(deck.deck).to_not include(card) }
        end
    end

    describe '#card_count' do
        context 'with all 52 cards' do
            it 'returns 52 cards left in the deck' do
                expect(deck.card_count).to eq(52)
            end
        end 

        context 'with five cards dealt' do
            before(:each) { deck.deal }
            it 'returns 47 cards' do
                expect(deal.card_count).to eq(47)
            end
        end
    end

    describe '#draw' do
        let(:card) { deck.draw }

        it 'returns a card' do
            expect(card).to be_a(Card)
        end
        it 'removes one card from deck' do
            expect(deck.card_count).to eq(51)
        end
        it 'removes the returned card from deck' do
            expect(deck.deck).to_not include(card)
        end
    end
end