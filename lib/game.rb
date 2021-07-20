require './lib/game_boards_maker'
require './lib/game_processor'
require './lib/placement_validator'
require './lib/player_ship_placement'
require './lib/random_ship_placer'

class Game
  include GameProcessor
  include GameBoardsMaker
  include PlacementValidator
  include PlayerShipPlacement
  include RandomShipPlacer

  def initialize
    @player_ships = []
    @computer_ships = []
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
    new_game
  end

  def new_game
    @computer_ships.clear
    @player_ships.clear
    start_game
  end

  def assign_boards
    data = make_boards
    @dimensions = data[:dimensions]
    @player_board = data[:player_board]
    @computer_board = data[:computer_board]
    @computer_brain = IntelligentComputer.new(@player_board, @dimensions)
  end

  def assign_ships
    make_ships.each do |name, length|
      @player_ships << Ship.new(name, length)
      @computer_ships << Ship.new(name, length)
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
