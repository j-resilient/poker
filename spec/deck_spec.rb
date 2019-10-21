require 'deck'

describe 'Deck' do
    subject(:deck) { Deck.new }

    let(:small_deck) do
        [
            double("card", :suit => :heart, :value => :ace),
            double("card", :suit => :diamond, :value => :two),
            double("card", :suit => :club, :value => :three),
            double("card", :suit => :spade, :value => :four)
        ]
    end

    describe '#initialize' do
        it 'deck contains 52 cards' do
            expect(deck.deck.length).to eq(52)
        end
        it 'deck has no duplicates' do
            expect(deck.deck).to eq(deck.deck.uniq { |card| card.display })
        end
        it 'deck contains only card objects' do
            deck.deck.each do |card|
                expect(card).to be_a(Card)
            end
        end
        it 'can be initialized with an array of cards' do
            small = Deck.new(small_deck)
            expect(small.deck.length).to eq(small_deck.length)
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
    end

    describe '#deal' do
        let(:hand) { deck.deal }

        it 'returns five objects' do
            expect(hand.length).to eq(5)
        end
        it "won't let you take more cards when the deck is empty" do
            expect do
                52.times { deck.deal }
            end.to raise_error("Deck is empty.")
        end

        before(:each) { deck.deal }
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
                expect(deck.card_count).to eq(47)
            end
        end
    end

    describe '#draw' do
        let(:card) { deck.draw }
        it 'returns a card' do
            expect(card).to be_a(Card)
        end

        before(:each) { deck.draw}
        it 'removes one card from deck' do
            expect(deck.card_count).to eq(51)
        end
        it 'removes the returned card from deck' do
            expect(deck.deck).to_not include(card)
        end
        it "doesn't take more cards than are in the deck" do
            expect do
                53.times { deck.draw }
            end.to raise_error("Deck is empty.")
        end
    end

    describe '#return_cards' do
        before(:each) { deck.return(small_deck) }
        it 'returns the cards to the deck' do
            expect(deck.count).to eq(56)
        end
        it 'adds the cards to the bottom of the deck' do
            expect(deck.deck[-1]).to eq(small_deck[-1])
        end
    end
end