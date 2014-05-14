#!/usr/bin/env ruby

require "./piece.rb"
require "./board.rb"

class Game
  attr_accessor :winner
  
  def initialize(player1, player2)
    @board = Board.new
    
    @player1 = player1
    
    @player2 = player2

  end
  
  def won?
    @board.checkmate?(:white) || @board.checkmate?(:black)
  end
  
  def winner
    if @board.checkmate?(:white)
      :black
    elsif @board.checkmate?(:black)
      :white
    else
      nil
    end
  end

  def play
    until won?
      @board.display
    
      @player1.play_turn(@board)
      break if won?
      
      @board.display

      @player2.play_turn(@board)
    end
    
    puts "Winner = #{winner}"
  end

end

class HumanPlayer
  attr_reader :color
  
  def define_translation
    @translation = {}
    i = 0
    ("a" .. "h").each do |letter|
      @translation[letter] = i
      i += 1
    end
    j = 7
    ("1" .. "8").each do |num|
      @translation[num] = j
      j -= 1
    end
  end
  
  def initialize
    define_translation
  end
  
  def play_turn(board)
    puts "Start position? (ex. a4)"
    start_pos = parse_input(gets.chomp)
    puts "End position? (ex. e7)"
    end_pos = parse_input(gets.chomp)
    board.move(start_pos, end_pos)
  end
  
  def parse_input(input)
    output = []
    output << @translation[input[1]]
    output << @translation[input[0]]
    
  end
  
end


if $PROGRAM_NAME == __FILE__
  player1= HumanPlayer.new
  player2 = HumanPlayer.new
  game = Game.new(player1, player2)
  game.play
  
end