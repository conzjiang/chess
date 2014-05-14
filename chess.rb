#!/usr/bin/env ruby
# encoding: utf-8

require 'colorize'
require "./game.rb"
require "./board.rb"
require "./piece.rb"
require "./sliding.rb"
require "./stepping.rb"
require "./pawn.rb"

if $PROGRAM_NAME == __FILE__
  player1 = HumanPlayer.new
  player2 = HumanPlayer.new
  game = Game.new(player1, player2)
  game.play
  
end

