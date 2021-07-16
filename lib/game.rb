require './lib/board'
require './lib/ship'
require './lib/cell'

class Game
  def initialize
    @player_board = Board.new
    @computer_board = Board.new
  end

  def start_game
    puts welcome

    if start?
      run_game
    else
      puts "Goodbye!"
    end
  end

  def run_game
    place_computer_ships



  end

  def place_computer_ships
    alignment = ["column", "row"].sample

    if alignment == "row"
      row = ("A".."D").to_a.sample

      columns = [1, 2, 3, 4].each_cons(3).sample



    end
  end

  def welcome
    [
      "Welcome to BATTLESHIP",
      "Enter p to play. Enter q to quit"
    ].join("\n")
  end

  def start?
    print "> "

    response = validate_start_response(response)

    response == "p"
  end

  def validate_start_response(response)
    response = gets.chomp

    while response != "p" || response != "q" do
      puts "Invalid input. " + welcome.split("\n").last
      print "> "
      response = gets.chomp
    end
  end
end


# I have laid out my ships on the grid.
# You now need to lay out your #{two} ships.
# The Cruiser is #{three} units long and the Submarine is #{two} units long.
