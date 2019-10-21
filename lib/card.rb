class Card
    attr_reader :suit, :value

    def initialize(suit, value)
        @suit, @value = suit, value
    end

    def display
        FACES[suit][value]
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
end