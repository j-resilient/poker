require_relative 'card'

class Deck
    attr_accessor :deck

    def initialize(deck = create_deck)
        @deck = deck
    end

    def shuffle!
        deck.shuffle!
    end

    def card_count
        deck.length
    end

    def deal
        deck.shift(5)
    end

    def draw
        deck.shift
    end

    private
    FACES = {
        :spade =>
            {
                :ace => "🂡", :king => "🂮", :queen => "🂭", :jack => "🂫", :ten => "🂪", :nine => "🂩",
                :eight => "🂨", :seven => "🂧", :six => "🂦", :five => "🂥", :four => "🂤", :three => "🂣", :two => "🂢"
            },
        :heart =>
            {
                :ace => "🂱", :king => "🂾", :queen => "🂽", :jack => "🂻", :ten => "🂺", :nine => "🂹",
                :eight => "🂸", :seven => "🂷", :six => "🂶", :five => "🂵", :four => "🂴", :three => "🂳", :two => "🂲"
            },
        :diamond =>
            {
                :ace => "🃁", :king => "🃎", :queen => "🃍", :jack => "🃋", :ten => "🃊", :nine => "🃉",
                :eight => "🃈", :seven => "🃇", :six => "🃆", :five => "🃅", :four => "🃄", :three => "🃃", :two => "🃂"
            },
        :club =>
            {
                :ace => "🃑", :king => "🃞", :queen => "🃝", :jack => "🃛", :ten => "🃚", :nine => "🃙",
                :eight => "🃘", :seven => "🃗", :six => "🃖", :five => "🃕", :four => "🃔", :three => "🃓", :two => "🃒"
            }
    }
    def create_deck
        cards = []
        FACES.each do |suit, suit_cards|
            suit_cards.each do |value, face|
                cards << Card.new(suit, value, face)
            end
        end
        cards
    end
end