class Card
    attr_reader :suit, :value, :face, :revealed, :back_of_card

    def initialize(suit, value, face)
        @suit, @value, @face = suit, value, face
        @revealed = false
        @back_of_card = "🂠"
    end

    def reveal
        @revealed = true
    end

    def display
        revealed ? face : back_of_card
    end
end