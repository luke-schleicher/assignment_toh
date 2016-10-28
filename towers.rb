#!/usr/bin/ruby

require 'pry'

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

  attr_accessor(:board, :number_of_moves, :minimum_number_of_moves)
  attr_reader :tower_height

  def initialize
    @number_of_moves = 0
  end

  def play
    instructions
    take_turns
  end

  def instructions
    puts "Welcome to Tower of Hanoi!"
    puts "Type any key to continue"
    gets
    @tower_height = 0
    until tower_height > 2 && tower_height < 10 
      puts "How high would you like your tower to be? Choose a number between 3 and 10."
      @tower_height = gets.chomp.to_i
    end
    @minimum_number_of_moves = (2**@tower_height) - 1
    create_board

    render_board

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

    puts "If you get tired of playing, type 'q' to quit. Good luck!\n\n"

  end

  def take_turns
    until victory? == true
      render_board
      move = player_choice
      @number_of_moves += 1
      move_ring(move)
    end
    victory_message
  end

  def player_choice
    move = []
    while
      move_from = select
      break if input_valid?(move_from) == true && move_from_valid?(move_from) == true
    end
    while
      move_to = target
      break if input_valid?(move_to) == true && move_to_valid?(move_from, move_to) == true
    end
    move.push(move_from, move_to)
    return move
  end

  def select
    puts "Where would you like to move from?"
    move_from = gets.chomp
      if move_from.strip.downcase == 'q'
        exit
      else
        move_from = move_from.to_i
      end
    return move_from
  end

  def target
    puts "Where would you like to move to?"
    move_to = gets.chomp
      if move_to.strip.downcase == 'q'
        exit
      else
        move_to = move_to.to_i
      end
    return move_to
  end

  def create_board
    tower = []
    @tower_height.downto(1) do |layer|
      tower << layer
    end
    @board = [tower, [], []]
  end

  def render_board

    #rearrange the @board array so that I can easily pop off lines and print to the terminal
    # so I'm converting from something like this --> [[4,3,2,1],[],[]]
    # to something like this --> [[1,2,3],[4,0,0],[3,0,0],[2,0,0],[1,0,0]]
    # to something like this --> [[1,nil,nil],[2,nil,nil],[3,nil,nil],[4,nil,nil]]

    new_board = []
    print_board = []
    largest_array_size = 0

    @board.each do |location|
      if location.length > largest_array_size
        largest_array_size = location.length
      end
    end

    @board.each do |location|
      new_location = location.dup
      until new_location.length == largest_array_size
        new_location << nil
      end
      new_board << new_location
    end

    largest_array_size.times do |i|
      new_line = []
      new_board.each do |array|
        ring = array.pop
        new_line.push(ring)
      end
      print_board.push(new_line)
    end

    print "\n"
    print_board.each do |line|
      # print the board
      line.each do |amount|
        if amount == nil
          print_value = ""
        else
          print_value = "o" * amount
        end
        print "#{print_value} \t"
      end
      print "\n"
    end

    puts "1 \t\t 2 \t\t 3 \t\n\n"

  end

  def input_valid?(num)
    if num >= 1 && num <= 3
      return true
    else
      return false
    end
  end

  def move_from_valid?(move_from)
    move_from -= 1
    if @board[move_from].empty?
      puts "You can't move from there"
      return false
    else
      return true
    end
  end

  def move_to_valid?(move_from, move_to)
    move_from -= 1
    move_to -= 1
    if @board[move_to].empty?
      return true
    elsif @board[move_from].last > @board[move_to].last
      puts "You can't move there"
      return false
    else
      return true
    end
  end

  def move_ring(move)
    move_from = move[0] - 1
    move_to = move[1] - 1
    ring_moving = @board[move_from].pop
    @board[move_to].push(ring_moving)
  end

  def victory? 
    if @board[1].length == @tower_height || @board[2].length == @tower_height
      return true
    else
      return false
    end
  end

  def victory_message
    puts "Congratulations, you won!"
    render_board
    gets
    puts "You solved it in #{@number_of_moves} moves"
    puts "The minimum number of moves was #{@minimum_number_of_moves}"
    exit
  end

end

t = TowerOfHanoi.new
t.play