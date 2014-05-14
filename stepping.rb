class SteppingPiece < Piece
  def moves
    possible_moves = Set.new([])
    
    move_dirs.each do |x, y|
      possible_pos = [pos[0] + x, pos[1] + y]
      possible_moves << possible_pos if valid_space?(possible_pos)
    end
    
    possible_moves
  end
end

class Knight < SteppingPiece
  def to_s
    "♞"
  end
  
  def move_dirs
    Set.new([[2, 1], [2, -1], [-2, 1], [-2, -1], [1, 2], [1, -2], [-1, 2], [-1, -2]])
  end
end

class King < SteppingPiece
  def to_s
    "♚"
  end
  
  def move_dirs
    Set.new([[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]])
  end
end
