require_relative './lib/invalid_move_error.rb'
require_relative './lib/pieces.rb'
require_relative './lib/board_renderer_text.rb'
require_relative './lib/board.rb'
require_relative './lib/player.rb'
require_relative './lib/game.rb'

b = Board.start_chess

# dup_board =b.dup
# BoardRendererText.new(dup_board).render
# dup_board.move_piece([1, 1], [2, 1])
# puts "dup"

# BoardRendererText.new(dup_board).render
# puts "original"
# BoardRendererText.new(b).render



# b = Board.new
# b[[1, 1]] = King.new(b, [1, 1], :black)
# b[[6, 6]] = King.new(b, [6, 6], :white)

# b[[3, 2]] = Rook.new(b, [3, 2], :white)
# b[[4, 2]] = Rook.new(b, [4, 2], :white)


# puts b.in_check?(:white)


g = Game.new(
    b, 
    Player.new(:black), 
    Player.new(:white),
    BoardRendererText
)
g.play
