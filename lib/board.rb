class Board 
  attr_reader :grid

  def self.start_chess
    board = self.new
    8.times do |c|
      board[[1, c]] = Pawn.new(board, [1, c], :black)
      board[[6, c]] = Pawn.new(board, [6, c], :white)
    end

    [
      Rook,
      Knight,
      Bishop,
      Queen,
      King,
      Bishop,
      Knight,
      Rook
    ].each_with_index do |piece_kalss, column|
      [[0, :black], [7, :white]].each do |(row, color)|
        location = [row, column]
        board[location] = piece_kalss.new(
          board,
          location,
          color
        )
      end
    end
      
    # [[0, :black], [7, :white]].each do |(r, color)|
    #   board[[r, 0]] = Rook.new(board, [r, 0], color)
    #   board[[r, 7]] = Rook.new(board, [r, 7], color)
    #   board[[r, 1]] = Knight.new(board, [r, 1], color)
    #   board[[r, 6]] = Knight.new(board, [r, 6], color)
    #   board[[r, 2]] = Bishop.new(board, [r, 2], color)
    #   board[[r, 5]] = Bishop.new(board, [r, 5], color)
    #   end
    #   board[[0, 3]] = King.new(board, [0, 3], :black)
    #   board[[0, 4]] = Queen.new(board, [0, 4], :black)
    #   board[[7, 3]] = King.new(board, [7, 3], :white)
    #   board[[7, 4]] = Queen.new(board, [7, 4], :white)

      board
  end

  def initialize
    @grid = Array.new(8) { Array.new(8, NullPiece.instance) }
  end

  def []=(location, piece)
    row, column = location
    grid[row][column] = piece    
  end

  def [](location)
    row, column = location
    grid[row][column]    
  end

  def in_bounds?(location)
    row, column = location

    row < grid.length && 
      column < grid.first.length &&
      row >= 0 &&
      column >= 0
  end

  def empty?(location)
    row, column = location
    grid[row][column] == NullPiece.instance
  end

  def in_check?(color)

    king = pieces.find {|p| p.color == color && p.is_a?(King)}
      
    if king.nil?
      raise 'No king found.'
    end

    king_pos = king.location

    # all the pieces of the opposite color
    pieces.select {|p| p.color != color }.each do |piece|

      if piece.available_moves.include?(king_pos)
        return true
      end
    end

    false
  end

  def checkmate?(color)
    return false if !in_check?(color)
    color_pieces = pieces.select {|p| p.color == color }
    color_pieces.all? {|piece| piece.safe_moves.empty? }
  end

  def pieces
    grid.flatten.reject {|piece| piece.is_a?(NullPiece) }
  end

  def move_piece(start_pos, end_pos)
    piece = self[start_pos]
    if !piece.safe_moves.include?(end_pos)
      raise InvalidMoveError.new(
        "End postion (#{end_pos}) not in available moves: #{piece.safe_moves}"
      ) 
    end
    if !in_bounds?(end_pos)
      raise InvalidMoveError.new(
        "End position not in bound"
      )
    end
    move_piece!(start_pos, end_pos)
  end

  def move_piece!(start_pos, end_pos)
    self[start_pos], self[end_pos] = NullPiece.instance, self[start_pos]
    self[end_pos].location = end_pos
  end

  def dup
    new_board = Board.new
    pieces.each do |piece|
      new_piece = piece.class.new(
        new_board, 
        piece.location, 
        piece.color
      )
      new_board[new_piece.location] = new_piece
    end
    new_board
  end
end
