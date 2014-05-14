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
  
  TRANSLATION = {
    "a" => 0,
    "b" => 1,
    "c" => 2,
    "d" => 3,
    "e" => 4,
    "f" => 5,
    "g" => 6,
    "h" => 7,
    "1" => 7,
    "2" => 6,
    "3" => 5,
    "4" => 4,
    "5" => 3,
    "6" => 2,
    "7" => 1,
    "8" => 0
  }
  
  def parse_input(input)
    raise "Invalid move!" unless input =~ /[a-h][1-8]/
    
    input.strip! #remove leading whitespace
    [TRANSLATION[input[1]], TRANSLATION[input[0]]]
  end
  
  def play_turn(board)
    begin
      puts "Start position? (e.g. a2)"
      start_pos = parse_input(gets.chomp.downcase)
      
      puts "End position? (e.g. a4)"
      end_pos = parse_input(gets.chomp.downcase)
    
      board.move(start_pos, end_pos, color)
    rescue
      puts "Invalid move!"
      retry
    end
  end
end


