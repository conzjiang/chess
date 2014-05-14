class Board
  attr_accessor :board_array
  
  def self.empty_grid
    Array.new(8) { Array.new(8) }
  end
  
  def initialize(board = Board.empty_grid)
    @board_array = board
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
    board_array[pos[0]][pos[1]]
  end
  
  def []=(pos, piece)
    board_array[pos[0]][pos[1]] = piece
  end
  
  def empty?(pos)
    self[pos].nil?
  end
  
  def pieces
    Set.new(board_array.flatten.compact)
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
      piece.color != king.color &&
      piece.moves.include?(king.pos)
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
    
    board_array.each_with_index do |row, row_i|
      print "#{8 - row_i} "
      
      row.each do |piece|
        bg_color = turn == 1 ? :red : :cyan
        
        if piece.nil?
          print "   ".colorize( :background => bg_color)
        else
          print " #{piece} ".colorize(piece.color).colorize( :background => bg_color)
        end
        
        turn = turn == 1 ? 2 : 1
      end
      
      turn = turn == 1 ? 2 : 1
      puts
    end
  end
  
  def dup
    b = Board.new
    
    pieces.each do |piece|
      b[piece.pos] = piece.class.new(b, piece.pos.dup, piece.color)
    end
    
    b
  end
end