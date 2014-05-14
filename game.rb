#!/usr/bin/env ruby

require "./piece.rb"
require "./board.rb"

class Game
  attr_accessor :winner
  
  def initialize(player1, player2)
    @board = Board.new
    
    @player1 = player1
    @player1.color = :white
    @player2 = player2
    @player2.color = :black
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
    current_player = @player1
    
    until won?
      @board.display
    
      current_player.play_turn(@board)
      
      current_player = current_player == @player1 ? @player2 : @player1
    end
    
    @board.display
    puts "Winner = #{winner}"
  end

end

class HumanPlayer
  attr_accessor :color
  
  def parse_input(input)
    raise "Invalid move!" unless input =~ /[a-h][1-8]/
    
    translation = {}
    
    i = 0
    ("a" .. "h").each do |letter|
      translation[letter] = i
      i += 1
    end
    
    j = 7
    ("1" .. "8").each do |num|
      translation[num] = j
      j -= 1
    end
    
    [translation[input[1]], translation[input[0]]]
  end
  
  def initialize

  end
  
  def play_turn(board)
    begin
      puts "Start position? (ex. a4)"
      start_pos = parse_input(gets.chomp)
      
      puts "End position? (ex. e7)"
      end_pos = parse_input(gets.chomp)
    
      board.move(start_pos, end_pos, color)
    rescue
      puts "Invalid move!"
      retry
    end
  end
end


if $PROGRAM_NAME == __FILE__
  player1 = HumanPlayer.new
  player2 = HumanPlayer.new
  game = Game.new(player1, player2)
  game.play
  
end