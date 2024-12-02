class Piece
    attr_reader :color,:board
    attr_accessor :location

    def initialize(board, location, color)
        @board =board
        @location = location
        @color = color
    end

    def safe_moves
        moves = []

        available_moves.each do |move|
           
            new_board = board.dup
            new_board.move_piece!(location, move)
           
            if !new_board.in_check?(color)
                moves << move
            end
        end
        moves
    end

    def enemy?(location)
        board.in_bounds?(location) && board[location].color != color
    end

    def current_r
        location.first
    end

    def current_c
        location.last
    end
end
