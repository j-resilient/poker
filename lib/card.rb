class Card
    attr_reader :suit, :value

    def initialize(suit, value)
        raise ArgumentError unless FACES.has_key?(suit)
        raise ArgumentError unless FACES[suit].has_key?(value)
        @suit, @value = suit, value
    end

    def display
        FACES[suit][value]
    end

    def <=>(card2)
        self.points <=> card2.points
    end

    def points
        get_points    
    end

    private
    def get_points
        case self.value
        when :two
            2
        when :three
            3
        when :four
            4
        when :five
            5
        when :six
            6
        when :seven
            7
        when :eight
            8
        when :nine
            9
        when :ten
            10
        when :jack
            11
        when :queen
            12
        when :king
            13
        when :ace
            14
        else
            1
        end
    end
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