# encoding: utf-8

require './piece'
require 'set'
require 'colorize'

class Board
  attr_accessor :board_array
  
  
  def self.new_board
    Array.new(8) { Array.new(8) }
  end
  
  def initialize(board = Board.new_board)
    @board_array = board
    @turn = :white
    
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
    black_king = King.new(self, [0, 4], :black)
    white_king = King.new(self, [7, 4], :white)
    board[0][4] = black_king
    board[7][4] = white_king
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
    king = nil
    
    pieces.each do |piece|
      if piece.class == King && piece.color == color
        king = piece
        break
      end
    end
    
    return false unless self.in_check?(color)
  
    king.valid_moves.empty?
  end
  
  def in_check?(color)

    king = nil
    
    pieces.each do |piece|
      if piece.class == King && piece.color == color
        king = piece
        break
      end
    end

    pieces.any? do |piece|
      piece.color != king.color &&
      piece.moves.include?(king.pos)
    end
  end
  
  def move(start_pos, end_pos)
    piece = self[start_pos]
    
    raise "No piece at start position!" if empty?(start_pos)
    raise "Invalid move!" unless piece.moves.include?(end_pos)
    raise "That's not your piece!" if piece.color != @turn
    
    piece.pos = end_pos
    self[end_pos] = piece
    self[start_pos] = nil
    
    @turn = @turn == :white ? :black : :white
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
      print "#{row_i + 1} "
      
      row.each do |piece|
          
        to_print = ""
        
        if turn == 1 
          if piece.nil?
            to_print = "   "
          elsif piece.is_a?(King)
            to_print = " ♚ ".colorize(piece.color)
          elsif piece.is_a?(Queen)
            to_print = " ♛ ".colorize(piece.color)
          elsif piece.is_a?(Pawn)
            to_print = " ♟ ".colorize(piece.color)
          elsif piece.is_a?(Bishop)
            to_print = " ♝ ".colorize(piece.color)
          elsif piece.is_a?(Rook)
            to_print = " ♜ ".colorize(piece.color)
          else
            to_print = " ♞ ".colorize(piece.color)
          end
          
          to_print = to_print.colorize( :background => :red)
        else
          if piece.nil?
            to_print = "   "
          elsif piece.is_a?(King)
            to_print = " ♚ ".colorize(piece.color)
          elsif piece.is_a?(Queen)
            to_print = " ♛ ".colorize(piece.color)
          elsif piece.is_a?(Pawn)
            to_print = " ♟ ".colorize(piece.color)
          elsif piece.is_a?(Bishop)
            to_print = " ♝ ".colorize(piece.color)
          elsif piece.is_a?(Rook)
            to_print = " ♜ ".colorize(piece.color)
          else
            to_print = " ♞ ".colorize(piece.color)
          end
          
          to_print = to_print.colorize( :background => :cyan)
        end
        
        print to_print
        
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