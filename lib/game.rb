require './lib/board'
require './lib/ship'
require './lib/cell'
require './lib/game_boards_maker'
require './lib/random_ship_placer'
require './lib/player_ship_placement'
require './lib/ship_generator'
require './lib/shot_processor'
require './lib/game_processor'

class Game
  include RandomShipPlacer
  include PlayerShipPlacement
  include ShipGenerator
  include GameProcessor
  include GameBoardsMaker
  include ShotProcessor

  def initialize
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
    assign_boards
    assign_ships
    place_ships(:computer)
    player_ship_placement
    game_loop
    start_game
  end

  def assign_boards
    data = make_boards
    @dimensions = data[:dimensions]
    @player_board = data[:player_board]
    @computer_board = data[:computer_board]
    @available_shots = data[:available_shots]
  end

  def assign_ships
    ships = make_ships
    @player_ships = ships
    @computer_ships = ships
  end

  def display_boards
    [
      "=============COMPUTER BOARD=============",
      @computer_board.render(true),
      "==============PLAYER BOARD==============",
      @player_board.render(true)
    ].join("\n")
  end

  def welcome
    [
      "Welcome to BATTLESHIP",
      "Enter p to play. Enter q to quit"
    ].join("\n")
  end

  def start?
    print "> "

    response = validate_start_response

    response == "p"
  end

  def validate_start_response
    response = gets.chomp

    while response != "p" && response != "q" do
      puts "Invalid input. " + welcome.split("\n").last
      print "> "
      response = gets.chomp
    end

    response
  end
end

game = Game.new.start_game
