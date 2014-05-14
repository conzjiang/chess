class Pawn < Piece
  def to_s
    "♟"
  end
  
  def moves
    
    possible_moves = Set.new([])

    if self.color == :black
      left_black_diag = [pos[0] + 1, pos[1] - 1]
      right_black_diag = [pos[0] + 1, pos[1] + 1]
      forward = [pos[0] + 1, pos[1]]
      
      if self.pos[0] == 1
        two_spaces_forward = [pos[0] + 2, pos[1]]
        possible_moves << two_spaces_forward if board.empty?(two_spaces_forward)
      end
      
      if board.empty?(forward)
        possible_moves << forward
      end
      
      if !board.empty?(left_black_diag) && board[left_black_diag].color != self.color
        possible_moves << left_black_diag
      end
      
      if !board.empty?(right_black_diag) && board[right_black_diag].color != self.color
        possible_moves << right_black_diag
      end
    else # white pieces
      left_white_diag = [pos[0] - 1, pos[1] - 1]
      right_white_diag = [pos[0] - 1, pos[1] + 1]
      forward = [pos[0] - 1, pos[1]]
      
      if self.pos[0] == 6
        two_spaces_forward = [pos[0] - 2, pos[1]]
        possible_moves << two_spaces_forward if board.empty?(two_spaces_forward)
      end
      
      if board.empty?(forward)
        possible_moves << forward
      end
      
      if board[left_white_diag] && board[left_white_diag].color != self.color
        possible_moves << left_white_diag
      end
      
      if !board.empty?(right_white_diag) && board[right_white_diag].color != self.color
        possible_moves << right_white_diag
      end
    end
    
    possible_moves
  end
end