#!/usr/bin/ruby
# TASKS
# Welcome player + give instructions
# print board (render method)
# ask for user input with gets
# take user input and validate
# if invalid or illegal move, ask for correct input type
# if valid, change data to reflect move user requested
# print board
# ask for user input with gets
# ...
# if user quits, quit program
# if player wins, issue victory message and exit program

# the tricky part of creating this game will be figuring out how to assemble the data that represents the game and modify the data when a user enters their input
# perhaps the best way to model this in data would be to create an array of array. The outer array represents the peg number, the inner array represents the rings on the pegs. Each number in the inner arrays corresponds to the size of the ring
# so 1 would represent the smallest ring, 5 would represent the largest ring in a 5 ring game

class TowerOfHanoi

  attr_accessor :board

  def play
    instructions
    take_turns
  end

  def instructions
    puts "Welcome to Tower of Hanoi!"
    puts "Type any key to continue"
    gets
    tower_height = 0
    until tower_height > 2 && tower_height < 10 
      puts "How high would you like your tower to be? Choose a number between 3 and 10."
      tower_height = gets.chomp.to_i
    end
    create_board(tower_height)
    render_board
=begin
    puts "Great! here's your board. Type any key..."
    gets
    puts "The goal of the game is to move the entire tower of 'o's to another location."
    gets
    puts "You can only move the top layer of a tower."
    gets
    puts "And you can only move one layer at a time."
    gets
    puts "Finally, you cannot put a bigger layer onto a smaller layer of 'o's."
    gets
    puts "Enter your move by typing the locations you want to move from and to (1, 2, or 3)"
    gets
=end
    puts "If you get tired of playing, type 'q' to quit. Here's your board again. Good Luck!"
    gets

  end

  def take_turns
    until victory? == true
      render_board
      move = player_choice
      move_ring(move)
    end
    victory_message
  end

  def player_choice
    move = []
    while
      move_from = select
      break if input_valid?(move_from) == true
    end
    while
      move_to = target
      break if input_valid?(move_to) == true
    end
    move.push(move_from,move_to)
    return move
  end

  def select
    puts "Where would you like to move from?"
    move_from = gets.chomp.to_i
    return move_from
  end

  def target
    puts "And where would you like to move to?"
    move_to = gets.chomp.to_i
    return move_to
  end

  def create_board(tower_height)
    tower = []
    tower_height.downto(1) do |layer|
      tower << layer
    end
    @board = [tower, [], []]
  end

  def render_board
    p @board
  end

  def input_valid?(num)
    if num >= 1 && num <= 3
      return true
    else
      return false
    end
  end

  def move_ring(move)
    move_from = move[0] - 1
    move_to = move[1] - 1
    ring_moving = @board[move_from].pop
    @board[move_to].push(ring_moving)
  end

  def victory?
    return false
  end

  def victory_message
    puts "Congratulations, you won!"
    render_board
    gets
    exit
  end

end

t = TowerOfHanoi.new
t.play