class Board
  attr_accessor :grid
  
  def self.empty_grid
    Array.new(8) { Array.new(8) }
  end
  
  def initialize(grid = Board.empty_grid)
    @grid = grid
    @turn = :white
    populate
  end
  
  def populate
    piece_classes = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    
    piece_classes.each_with_index do |piece_class, i|
      piece_class.new(self, [0, i], :black)      
      piece_class.new(self, [7, i], :white)
    end
    
    # pawns
    (0..7).each do |col|
      Pawn.new(self, [1, col], :black)
      Pawn.new(self, [6, col], :white)
    end
  end
  
  def [](pos)
    grid[pos[0]][pos[1]]
  end
  
  def []=(pos, piece)
    grid[pos[0]][pos[1]] = piece
  end
  
  def empty?(pos)
    self[pos].nil?
  end
  
  def pieces
    grid.flatten.compact
  end
  
  def find_king(color)
    pieces.find do |piece|
      piece.is_a?(King) && piece.color == color
    end
  end
  
  def checkmate?(color) 
    return false unless self.in_check?(color)
  
    find_king(color).valid_moves.empty?
  end
  
  def in_check?(color)
    king = find_king(color)
    
    pieces.any? do |piece|
      piece.color != king.color && piece.moves.include?(king.pos)
    end
  end
  
  def move(start_pos, end_pos, color)
    piece = self[start_pos]
    
    raise "No piece at start position!" if empty?(start_pos)
    raise "Invalid move!" unless piece.moves.include?(end_pos)
    raise "That's not your piece!" if piece.color != color
    
    move!(start_pos, end_pos)
  end
  
  def move!(start_pos, end_pos)
    piece = self[start_pos]

    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = nil
  end
  
  def display
    turn = 1
    
    puts "   a  b  c  d  e  f  g  h "
    
    grid.each_with_index do |row, row_i|
      print "#{8 - row_i} "
      
      row.each do |piece|
        bg_color = turn == 1 ? :red : :cyan
        
        grid_space = piece.nil? ?  "   " : " #{piece} ".colorize(piece.color)
        print grid_space.colorize(:background => bg_color)
        
        turn = turn == 1 ? 2 : 1 #toggle background after each element
      end
      
      turn = turn == 1 ? 2 : 1 #toggle background after each row
      puts
    end
  end
  
  def dup
    board_dup = Board.new
    
    pieces.each do |piece|
      board_dup[piece.pos] = piece.class.new(board_dup, piece.pos.dup, piece.color)
    end
    
    board_dup
  end
end