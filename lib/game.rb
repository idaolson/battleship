require './lib/board'
require './lib/ship'
require './lib/cell'
require './lib/game_boards_maker'
require './lib/random_ship_placer'
require './lib/player_ship_placement'
require './lib/ship_generator'
require './lib/shot_processor'

class Game
  include RandomShipPlacer
  include PlayerShipPlacement
  include ShipGenerator
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
    make_boards
    assign_ships
    place_ships(:computer)
    player_ship_placement

    loop do
      process_turns
      if winner
        puts winner
        break
      end
    end

    start_game
  end

  def winner
    return "You won!" if player_win?
    return "I won!" if computer_win?
  end

  def player_win?
    @computer_ships.all? { |ship| ship.sunk? }
  end

  def computer_win?
    @player_ships.all? { |ship| ship.sunk? }
  end

  def process_turns
    puts display_boards
    player_result = process_player_shot
    computer_result = process_computer_shot
    puts display_results(player_result, computer_result)
    sunken_ship
  end

  def display_results(player_result, computer_result)
    [
      "Your shot on #{player_result.first} was a #{player_result.last}.",
      "My shot on #{computer_result.first} was a #{computer_result.last}."
    ].join("\n")
  end

  def sunken_ship
    if computer_ship_sunk?
      puts "You sunk one of my ships!"
    end

    if player_ship_sunk?
      puts "I sunk one of your ships!"
    end
  end

  def player_ship_sunk?
    if @player_ships.any? { |ship| ship.sunk? }
      @player_ships.delete_if { |ship| ship.sunk? }
      return true
    end
  end

  def computer_ship_sunk?
    if @computer_ships.any? { |ship| ship.sunk? }
      @computer_ships.delete_if { |ship| ship.sunk? }
      return true
    end
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
