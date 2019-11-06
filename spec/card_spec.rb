require 'card'

describe 'Card' do
    subject(:heart_ace) { Card.new(:heart, :ace)}

    describe "#initialize" do
        it "sets a suit" do
            expect(heart_ace.suit).to eq(:heart)
        end
        it 'raises an error with an invalid suit' do
            expect{ Card.new(:sugar, :ace) }.to raise_error(ArgumentError)
        end
        it "sets a value" do
            expect(heart_ace.value).to eq(:ace)
        end
        it 'raises an error with an invalid value' do 
            expect{ Card.new(:heart, :sugar) }.to raise_error(ArgumentError)
        end
    end
    
    describe '#display' do
        it 'displays face of card' do 
            expect(heart_ace.display).to eq("🂱  ")
        end
    end

    describe '#<=>' do
        it 'returns 1 if first card is greater than the second' do
            expect(Card.new(:heart, :king) <=> Card.new(:spade, :jack)).to eq(1)
        end
        it 'returns 0 if the cards are of equal value' do
            expect(Card.new(:club, :ten) <=> Card.new(:spade, :ten)).to eq(0)
        end
        it 'returns -1 if the second card is greater than the first' do
            expect(Card.new(:diamond, :two) <=> Card.new(:heart, :ten)).to eq(-1)
        end
    end
end