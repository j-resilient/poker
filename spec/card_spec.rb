require 'card'

describe 'Card' do
    subject(:heart_ace) { Card.new(:heart, :ace, "🂱")}

    describe "#initialize" do
        it "sets a suit" do
            expect(heart_ace.suit).to eq(:heart)
        end
        it "sets a value" do
            expect(heart_ace.value).to eq(:ace)
        end
        it "sets a face" do 
            expect(heart_ace.face).to eq("🂱")
        end
        it "sets revealed to false" do
            expect(heart_ace.revealed).to be false
        end
        it "sets back_of_card" do 
            expect(heart_ace.back_of_card).to eq("🂠")
        end
    end

    describe "#reveal" do
        it "sets revealed to true" do
            expect(heart_ace.revealed).to be false
            heart_ace.reveal
            expect(heart_ace.revealed).to be true
        end 
    end

    context "when revealed" do 
        before(:each) { heart_ace.reveal }
        describe "#display" do
            it "shows face" do
                expect(heart_ace.display).to eq("🂱")
            end
        end
    end

    context "when not revealed" do
        describe "#display" do
            it "shows face for back of card" do
                expect(heart_ace.display).to eq("\u{1F0A0}")
            end
        end
    end

    describe '#==' do
        let(:ace_spade) { Card.new(:spade, :ace, "🂡") }

        context 'when two cards are the same' do
            it 'returns true' do
                expect(heart_ace == heart_ace).to be true
            end
        end

        context 'when two cards are different' do
            it 'returns false' do
                expect(heart_ace == ace_spade).to be false
            end
        end
    end
end