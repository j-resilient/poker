require_relative 'card'

class Deck
    attr_accessor :deck

    def initialize(deck = create_deck)
        @deck = deck
    end

    def shuffle!
        deck.shuffle!
    end

    private
    SUITS = ["heart", "diamond", "spade", "club"]
    VALUES = [
        "ace", "king", "queen", "jack", "10", 
        "9", "8", "7", "6", "5", "4", "3", "2"
    ]
    FACES = {
        "spade" =>
            {
                "ace" => "🂡", "king" => "🂮", "queen" => "🂭", "jack" => "🂫", "10" => "🂪", "9" => "🂩",
                "8" => "🂨", "7" => "🂧", "6" => "🂦", "5" => "🂥", "4" => "🂤", "3" => "🂣", "2" => "🂢"
            },
        "heart" =>
            {
                "ace" => "🂱", "king" => "🂾", "queen" => "🂽", "jack" => "🂻", "10" => "🂺", "9" => "🂹",
                "8" => "🂸", "7" => "🂷", "6" => "🂶", "5" => "🂵", "4" => "🂴", "3" => "🂳", "2" => "🂲"
            },
        "diamond" =>
            {
                "ace" => "🃁", "king" => "🃎", "queen" => "🃍", "jack" => "🃋", "10" => "🃊", "9" => "🃉",
                "8" => "🃈", "7" => "🃇", "6" => "🃆", "5" => "🃅", "4" => "🃄", "3" => "🃃", "2" => "🃂"
            },
        "club" =>
            {
                "ace" => "🃑", "king" => "🃞", "queen" => "🃝", "jack" => "🃛", "10" => "🃚", "9" => "🃙",
                "8" => "🃘", "7" => "🃗", "6" => "🃖", "5" => "🃕", "4" => "🃔", "3" => " 	🃓", "2" => "🃒 "
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

d = Deck.new
d.deck.each { |card| print "#{card.display} " }
puts
d.deck.shuffle!
d.deck.each { |card| print "#{card.display} " }