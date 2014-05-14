require './piece'
require 'set'

class Board
  attr_accessor :board_array
  
  attr_reader :black_king, :white_king
  
  def self.new_board
    Array.new(8) { Array.new(8) }
  end
  
  def initialize(board = Board.new_board)
    @board_array = board
    
    # pawns
    (0..7).each do |col|
      board[1][col] = Pawn.new(self, [1, col], :black)
      board[6][col] = Pawn.new(self, [6, col], :white)
    end
    
    # rooks
    board[0][0] = Rook.new(self, [0, 0], :black)
    board[0][7] = Rook.new(self, [0, 7], :black)
    board[7][0] = Rook.new(self, [7, 0], :white)
    board[7][7] = Rook.new(self, [7, 7], :white)
    
    # knights
    board[0][1] = Knight.new(self, [0, 1], :black)
    board[0][6] = Knight.new(self, [0, 6], :black)
    board[7][1] = Knight.new(self, [7, 1], :white)
    board[7][6] = Knight.new(self, [7, 6], :white)
    
    # bishops
    board[0][2] = Bishop.new(self, [0, 2], :black)
    board[0][5] = Bishop.new(self, [0, 5], :black)
    board[7][2] = Bishop.new(self, [7, 2], :white)
    board[7][5] = Bishop.new(self, [7, 5], :white)
    
    #queen
    board[0][3] = Queen.new(self, [0, 3], :black)
    board[7][3] = Queen.new(self, [7, 3], :white)    
    
    #king
    @black_king = King.new(self, [0, 4], :black)
    @white_king = King.new(self, [7, 4], :white)
    board[0][4] = @black_king
    board[7][4] = @white_king
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
  
  def checkmate?(color)
    puts "entered checkmate"
    king = color == :white ? @white_king : @black_king
    
    return false unless in_check?(color)
  
    king.valid_moves.empty?
 
  end
  
  def in_check?(color)
    king = color == :white ? @white_king : @black_king
    
    
    pieces.any? do |piece|
      next if piece.color == color
      
      puts "#{piece.class}"
      puts "#{piece.pos}"
      piece.moves.include?(king.pos)
      puts "Finished piece"
    end
  end
  
  def move(start_pos, end_pos)
    piece = self[start_pos]
    
    raise "No piece at start position!" if empty?(start_pos)
    raise "Invalid move!" unless piece.moves.include?(end_pos)
    
    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = nil
  end
  
  def move!(start_pos, end_pos)
    piece = self[start_pos]

    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = nil
  end
  
  def display
    board_array.each do |row|
      row.each do |piece|
        if piece.nil?
          print "[___]"
        elsif piece.is_a?(King)
          print "[_K_]"
        elsif piece.is_a?(Queen)
          print "[_Q_]"
        elsif piece.is_a?(Pawn)
          print "[_p_]"
        elsif piece.is_a?(Bishop)
          print "[_B_]"
        elsif piece.is_a?(Rook)
          print "[_R_]"
        else
          print "[_kn]"
        end
      end
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




if __FILE__ == $PROGRAM_NAME
  b = Board.new
  r = Rook.new(b, [0,0], :black)

  b[[2,0]] = Rook.new(b, [2,0], :black)
  b[[0,2]] = Rook.new(b, [0,2], :white)
  
  k = Knight.new(b, [0,1], :black)

  p = Pawn.new(b, [3,1], :white)

end