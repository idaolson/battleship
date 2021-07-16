require './lib/board'
require './lib/ship'
require './lib/cell'

class Game
  attr_reader :computer_board

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
    ships = [Ship.new("cruiser", 3), Ship.new("submarine", 2)]

    ships.each do |ship|
      placement = get_ship_placement(ship)

      while !@computer_board.valid_placement?(ship, placement) do
        placement = get_ship_placement(ship)
      end

      @computer_board.place(ship, placement)
    end
  end

  def get_ship_placement(ship)

    alignment = ["column", "row"].sample

    if alignment == "row"
      horizontal_placement(ship)
    else
      vertical_placement(ship)
    end

  end

  def horizontal_placement(ship)
    row = ("A".."D").to_a.sample

    [1, 2, 3, 4].each_cons(ship.length).map { |columns|
      columns.map do |column|
        row + column.to_s
      end
    }.sample
  end

  def vertical_placement(ship)
    column = (1..4).to_a.sample

    ("A".."D").each_cons(ship.length).map { |rows|
      rows.map do |row|
        row + column.to_s
      end
    }.sample
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

game = Game.new
game.place_computer_ships
puts game.computer_board.render(true)

# I have laid out my ships on the grid.
# You now need to lay out your #{two} ships.
# The Cruiser is #{three} units long and the Submarine is #{two} units long.
