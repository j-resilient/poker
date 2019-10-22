require 'hand'

describe 'Hand' do
    let(:garbage_cards) do
        [
            Card.new(:heart, :two),
            Card.new(:diamond, :four),
            Card.new(:spade, :five),
            Card.new(:club, :seven),
            Card.new(:heart, :nine)
        ]
    end
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

    let(:hands) do [
        straight_flush,
        four_kind,
        full_house,
        flush,
        straight,
        three_kind,
        two_pair,
        one_pair,
        high_card
    ]
    end

    let(:hand_ranks) do [
        :straight_flush,
        :four_kind,
        :full_house,
        :flush,
        :straight,
        :three_kind,
        :two_pair,
        :one_pair,
        :high_card
    ]
    end

    describe "#get_hand" do
        it 'returns the correct hand rank of the hand' do
            hands.each_with_index do |hand, idx|
                expect(hand.hand_rank).to eq(hand_ranks[i])
            end
        end
    end

    describe '#<=>' do
        it 'returns 1 when first hand is greater' do
            expect(straight_flush <=> four_kind).to eq(1)
        end
        it 'returns 0 when hands are of equal rank' do
            expect(four_kind <=> four_kind).to eq(0)
        end
        it 'returns -1 when second hand is greater' do
            expect(flush <=> two_pair).to eq(-1)
        end

        context 'when comparing two hands of equal rank' do
            describe 'straight flush' do
                let(:high_card_straight_flush) do
                    Hand.new([
                        Card.new(:queen, :diamond),
                        Card.new(:jack, :diamond),
                        Card.new(:ten, :diamond),
                        Card.new(:nine, :diamond),
                        Card.new(:eight, :diamond)
                    ])
                end
                let(:diamond_straight_flush) do
                    Hand.new([
                        Card.new(:jack, :diamond),
                        Card.new(:ten, :diamond),
                        Card.new(:nine, :diamond),
                        Card.new(:eight, :diamond),
                        Card.new(:seven, :diamond)
                    ])
                end
                let(:ace_low_straight_flush) do
                    Hand.new([
                        Card.new(:five, :diamond),
                        Card.new(:four, :diamond),
                        Card.new(:three, :diamond),
                        Card.new(:two, :diamond),
                        Card.new(:ace, :diamond)
                    ])
                end
                let(:low_straight_flush) do
                    Hand.new([
                        Card.new(:five, :diamond),
                        Card.new(:four, :diamond),
                        Card.new(:three, :diamond),
                        Card.new(:two, :diamond),
                        Card.new(:six, :diamond)
                    ])
                end
                it 'returns high card hand' do
                    expect(straight_flush <=> high_card_straight_flush).to eq(-1)
                end
                it 'returns a tie when hands only differ by suit' do
                    expect(straight_flush <=> diamond_straight_flush).to eq(0)
                end
                it 'handles ace-low' do
                    expect(low_straight_flush <=> ace_low_straight_flush).to eq(1)
                end
            end
            describe 'four of a kind' do
                let(:four_sixes) do
                    Hand.new([
                        Card.new(:club, :six),
                        Card.new(:diamond, :six),
                        Card.new(:heart, :six),
                        Card.new(:spade, :six),
                        Card.new(:diamond, :four)
                    ])
                end
                let(:four_fives) do
                    Hand.new([
                        Card.new(:club, :five),
                        Card.new(:diamond, :five),
                        Card.new(:heart, :five),
                        Card.new(:spade, :five),
                        Card.new(:diamond, :four)
                    ])
                end
                it 'returns the higher-ranked four' do
                    expect(four_sixes <=> four_kind).to eq(1)
                end
                it 'returns the higher kicker' do
                    expect(four_fives <=> four_kind).to eq(1)
                end
            end
            describe 'full house' do
                let(:king_full_house) do 
                    Hand.new([
                        Card.new(:spade, :queen),
                        Card.new(:heart, :queen),
                        Card.new(:diamond, :queen),
                        Card.new(:heart, :seven),
                        Card.new(:spade, :seven)
                    ])
                end
                let(:six_full_house) do 
                    Hand.new([
                        Card.new(:spade, :six),
                        Card.new(:heart, :six),
                        Card.new(:diamond, :six),
                        Card.new(:heart, :seven),
                        Card.new(:spade, :seven)
                    ])
                end
                it 'returns the higher triplet' do
                    expect(king_full_house <=> full_house).to eq(1)
                end
                context 'when triplets are equal' do
                    it 'returns the higher pair' do
                        expect(full_house <=> six_full_house).to eq(1)
                    end
                end
            end
            describe 'flush' do
                let(:higher_flush) do 
                    Hand.new([
                        Card.new(:club, :jack),
                        Card.new(:club, :nine),
                        Card.new(:club, :eight),
                        Card.new(:club, :five),
                        Card.new(:club, :four)
                    ])
                end
                let(:heart_flush) do 
                    Hand.new([
                        Card.new(:heart, :jack),
                        Card.new(:heart, :nine),
                        Card.new(:heart, :eight),
                        Card.new(:heart, :three),
                        Card.new(:heart, :four)
                    ])
                end
                it 'returns the higher ranked card' do
                    expect(higher_flush <=> flush).to eq(1)
                end
                it 'returns a tie when hands only differ by suits' do
                    expect(heart_flush <=> flush).to eq(0)
                end
            end
            describe 'straight' do
                let(:jack_straight) do
                    Hand.new([
                        Card.new(:heart, :jack),
                        Card.new(:spade, :ten),
                        Card.new(:diamond, :nine),
                        Card.new(:club, :eight),
                        Card.new(:heart, :seven)
                    ])
                end
                let(:eq_straight) do
                    Hand.new([
                        Card.new(:heart, :six),
                        Card.new(:spade, :ten),
                        Card.new(:diamond, :nine),
                        Card.new(:club, :eight),
                        Card.new(:heart, :seven)
                    ])
                end
                let(:ace_low_straight) do
                    Hand.new([
                        Card.new(:heart, :ace),
                        Card.new(:spade, :two),
                        Card.new(:diamond, :three),
                        Card.new(:club, :four),
                        Card.new(:heart, :five)
                    ])
                end
                let(:low_straight) do
                    Hand.new([
                        Card.new(:spade, :six),
                        Card.new(:heart, :two),
                        Card.new(:club, :three),
                        Card.new(:diamond, :four),
                        Card.new(:heart, :five)
                    ])
                end
                it 'returns high card hand' do
                    expect(jack_straight <=> striaght).to eq(1)
                end
                it 'returns tie when hands only differ by suit' do
                    expect(eq_straight <=> straight).to eq(0)
                end
                it 'handles ace-low' do
                    expect(low_straight <=> ace_low_straight).to eq(1)
                end
            end
            describe 'three of a kind' do
                let(:king_three_kind) do 
                    Hand.new([
                        Card.new(:spade, :king),
                        Card.new(:heart, :king),
                        Card.new(:diamond, :king),
                        Card.new(:heart, :nine),
                        Card.new(:spade, :two)
                    ])
                end
                let(:kicker_three_kind) do 
                    Hand.new([
                        Card.new(:spade, :queen),
                        Card.new(:heart, :queen),
                        Card.new(:diamond, :queen),
                        Card.new(:heart, :ten),
                        Card.new(:spade, :two)
                    ])
                end
                it 'returns higher triplet' do
                    expect(king_three_kind <=> three_kind).to eq(1)
                end
                it 'returns higher kicker' do
                    expect(kicker_three_kind <=> three_kind).to eq(1)
                end
            end
            describe 'two pair' do
                let(:higher_two_pair) do
                    Hand.new([
                        Card.new(:club, :queen),
                        Card.new(:spade, :queen),
                        Card.new(:heart, :three),
                        Card.new(:diamond, :three),
                        Card.new(:spade, :two)
                    ])
                end
                let(:kicker_two_pair) do
                    Hand.new([
                        Card.new(:club, :jack),
                        Card.new(:spade, :jack),
                        Card.new(:heart, :three),
                        Card.new(:diamond, :three),
                        Card.new(:spade, :four)
                    ])
                end
                it 'returns hand with highest pair' do
                    expect(higher_two_pair <=> two_pair).to eq(1)
                end
                it 'returns the higher kicker' do
                    expect(kicker_two_pair <=> two_pair).to eq(1)
                end
            end
            describe 'one pair' do
                let(:higher_one_pair) do
                    Hand.new([
                        Card.new(:spade, :jack),
                        Card.new(:diamond, :jack),
                        Card.new(:diamond, :eight),
                        Card.new(:spade, :seven),
                        Card.new(:heart, :four)
                    ])
                end
                let(:kicker_one_pair) do
                    Hand.new([
                        Card.new(:spade, :ten),
                        Card.new(:diamond, :ten),
                        Card.new(:diamond, :nine),
                        Card.new(:spade, :seven),
                        Card.new(:heart, :four)
                    ])
                end
                it 'returns the higher pair' do
                    expect(higher_one_pair <=> one_pair).to eq(1)
                end
                it 'returns the kicker' do
                    expect(kicker_one_pair <=> one_pair).to eq(1)
                end
            end
            describe 'high card' do
                let(:higher_card) do
                    Hand.new([
                        Card.new(:heart, :three),
                        Card.new(:diamond, :four),
                        Card.new(:spade, :five),
                        Card.new(:club, :seven),
                        Card.new(:heart, :nine)
                    ])
                end
                it 'returns the higher card hand' do
                    expect(higher_card <=> garbage_hand).to eq(1)
                end
            end
        end
    end
end