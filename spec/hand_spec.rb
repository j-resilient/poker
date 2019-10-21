require 'hand'

describe 'Hand' do
    let(:garbage_cards) {[
        double("card", :suit => :heart, :value => :two),
        double("card", :suit => :diamond, :value => :four),
        double("card", :suit => :spade, :value => :five),
        double("card", :suit => :club, :value => :seven),
        double("card", :suit => :heart, :value => :nine)
        ]}
    subject(:garbage_hand) { Hand.new(garbage_cards) }

    describe '#initialize' do
        it 'sets hand to input' do
            expect(garbage_hand.hand).to eq(garbage_cards)
        end
        it 'sets hand_type to appropriate type' do
            expect(garbage_hand.type).to eq("high card")
        end
    end

    describe '#trade_cards' do
        before(:each) { garbage_hand.discard([garbage_cards[0], garbage_cards[1]]) }
        it 'removes expected cards from hand' do
            expect(garbage_hand.hand).to_not include(garbage_cards[0])
            expect(garbage_hand.hand).to_not include(garbage_cards[1])
        end
        it 'does not remove any other cards from hand' do
            garbage_cards[3..-1].each do |card|
                expect(garbage_hand.hand).to include(card)
            end
        end
        it 'adds new cards to hand' do
            expect(garbage_cards).to_not include(garbage_hand[-1])
            expect(garbage_cards).to_not include(garbage_hand[-2])
        end
        it 'does not discard cards that were never in hand' do
            expect{ garbage_hand.discard([double(:suit => sugar, :value => :zero)])}.to raise_error("Cannot discard card you don't have.")
        end
    end

    let (:straight_flush) { Hand.new([
        Card.new("card", :suit => club, :value => :jack),
        Card.new("card", :suit => club, :value => :ten),
        Card.new("card", :suit => club, :value => :nine),
        Card.new("card", :suit => club, :value => :eight),
        Card.new("card", :suit => club, :value => :seven)
    ])}

    let (:four_kind) { Hand.new([
        Card.new("card", :suit => :club, :value => :five),
        Card.new("card", :suit => :diamond, :value => :five),
        Card.new("card", :suit => :heart, :value => :five),
        Card.new("card", :suit => :spade, :value => :five),
        Card.new("card", :suit => :diamond, :value => :two)
    ])}

    let (:full_house) { Hand.new([
        Card.new("card", :suit => :spade, :value => :six),
        Card.new("card", :suit => :heart, :value => :six),
        Card.new("card", :suit => :diamond, :value => :six),
        Card.new("card", :suit => :club, :value => :king),
        Card.new("card", :suit => :heart, :value => :king)
    ])}

    let (:flush) { Hand.new([
        Card.new("card", :suit => :diamond, :value => :jack),
        Card.new("card", :suit => :diamond, :value => :nine),
        Card.new("card", :suit => :diamond, :value => :eight),
        Card.new("card", :suit => :diamond, :value => :four),
        Card.new("card", :suit => :diamond, :value => :three)
    ])}

    let (:straight) { Hand.new([
        Card.new("card", :suit => :diamond, :value => :ten),
        Card.new("card", :suit => :spade, :value => :nine),
        Card.new("card", :suit => :heart, :value => :eight),
        Card.new("card", :suit => :diamond, :value => :seven),
        Card.new("card", :suit => :club, :value => :six)
    ])}

    let (:three_kind) { Hand.new([
        Card.new("card", :suit => :club, :value => :queen),
        Card.new("card", :suit => :spade, :value => :queen),
        Card.new("card", :suit => :heart, :value => :queen),
        Card.new("card", :suit => :heart, :value => :nine),
        Card.new("card", :suit => :spade, :value => :two)
    ])}

    let (:two_pair) { Hand.new([
        Card.new("card", :suit => :heart, :value => :jack),
        Card.new("card", :suit => :spade, :value => :jack),
        Card.new("card", :suit => :club, :value => :three),
        Card.new("card", :suit => :spade, :value => :three),
        Card.new("card", :suit => :heart, :value => :two)
    ])}

    let (:one_pair) { Hand.new([
        Card.new("card", :suit => :spade, :value => :ten),
        Card.new("card", :suit => :heart, :value => :ten),
        Card.new("card", :suit => :spade, :value => :eight),
        Card.new("card", :suit => :heart, :value => :seven),
        Card.new("card", :suit => :club, :value => :four)
    ])}

    let (:high_card) { Hand.new([
        Card.new("card", :suit => :diamond, :value => :king),
        Card.new("card", :suit => :diamond, :value => :queen),
        Card.new("card", :suit => :spade, :value => :seven),
        Card.new("card", :suit => :spade, :value => :four),
        Card.new("card", :suit => :heart, :value => :three)
    ])}

    describe '#get_hand' do
        it 'identifies straight flush' do
            expect(straight_flush.get_hand).to eq(:straight_flush)
        end
        it 'identifies four of a kind' do
            expect(four_kind.get_hand).to eq(:four_kind)
        end
        it 'identifies full house' do
            expect(full_house.get_hand).to eq(:full_house)
        end
        it 'identifies flush' do
            expect(flush.get_hand).to eq(:flush)
        end
        it 'identifies straight' do
            expect(straight.get_hand).to eq(:straight)
        end
        it 'identifies three of a kind' do
            expect(three_kind.get_hand).to eq(:three_kind)
        end
        it 'identifies two pair' do
            expect(two_pair.get_hand).to eq(:two_pair)
        end
        it 'identifies one pair' do
            expect(one_pair.get_hand).to eq(:one_pair)
        end
        it 'identifies high card hand' do
            expect(high_card.get_hand).to eq(:high_card)
        end
    end
end