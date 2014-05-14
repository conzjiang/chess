class SlidingPiece < Piece
  def moves
    possible_moves = []
    
    move_dirs.each do |x, y|
      n = 1
      
      loop do
        possible_pos = [pos[0] + (x * n), pos[1] + (y * n)]
        possible_moves << possible_pos if valid_space?(possible_pos)
        
        break if !valid_space?(possible_pos) || !board.empty?(possible_pos)
        n += 1
      end
    end
    
    possible_moves
  end
end

class Rook < SlidingPiece
  def to_s
    "♜"
  end
  
  def move_dirs
    [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end

class Bishop < SlidingPiece
  def to_s
    "♝"
  end
  
  def move_dirs
    [[1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end

class Queen < SlidingPiece
  def to_s
    "♛"
  end
  
  def move_dirs
    [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end
