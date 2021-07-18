require './lib/board'
require './lib/ship'
require './lib/cell'
require './lib/random_placement_generator'
require './lib/custom_ship_generator'

class Game
  include RandomPlacementGenerator
  include CustomShipGenerator

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
    place_computer_ships
    place_player_ships

    loop do
      process_turns
      if winner
        puts winner
        break
      end
    end

    new_game
  end

  def assign_ships
    if custom_ships?
      ships = make_custom_ships(@dimensions.max)
    else
      ships = [Ship.new("cruiser", 3), Ship.new("submarine", 2)]
    end

    @player_ships = ships
    @computer_ships = ships
  end

  def custom_ships?
    puts "Default ships: Cruiser (3 squares), Submarine (2 squares)"
    puts "Would you like to create your own ships instead? (y/n)"
    print "> "

    response = gets.chomp

    while response != "y" && response != "n" do
       puts "Invalid input. Enter y or n:"
       print "> "
       response = gets.chomp
     end

     response == "y"
  end

  def make_boards
    @dimensions = get_board_dimensions
    @player_board = Board.new(@dimensions)
    @computer_board = Board.new(@dimensions)
    @available_shots = @computer_board.cells.keys
  end

  def get_board_dimensions
    puts "How many rows would you like on the board (between 4-26):"
    print "> "
    rows = gets.chomp.to_i

    while !(4..26).include?(rows)
      puts "Please enter valid row count between 4-26:"
      print "> "

      rows = gets.chomp.to_i
    end

    puts "How many columns would you like on the board (between 4-26):"
    print "> "
    columns = gets.chomp.to_i

    while !(4..26).include?(columns)
      puts "Please enter valid column count between 4-26:"
      print "> "

      columns = gets.chomp.to_i
    end

    [rows, columns]
  end

  def new_game
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

  def process_computer_shot
    computer_shot = get_computer_shot
    [computer_shot, fire_shot(computer_shot, :computer)]
  end

  def get_computer_shot
    shot = @available_shots.sample
    @available_shots.delete(shot)
  end

  def process_player_shot
    puts "Enter the coordinate for your shot:"
    print "> "

    player_shot = validate_player_shot
    [player_shot, fire_shot(player_shot, :player)]
  end

  def fire_shot(shot, person)
    firing = {
      :player => ->(shot) {
        @computer_board.cells[shot]
      },
      :computer => ->(shot) {
        @player_board.cells[shot]
      }
    }
    cell = firing[person].call(shot)
    cell.fire_upon
    cell.ship ? "hit" : "miss"
  end

  def validate_player_shot
    shot = gets.chomp

    shot = shot_on_board(shot)

    while @computer_board.cells[shot].fired_upon? do
      puts "You have already fired there."
      puts "Please enter a valid coordinate:"
      print "> "
      shot = gets.chomp
      shot = shot_on_board(shot)
    end

    shot
  end

  def shot_on_board(shot)
    while !@player_board.valid_coordinate?(shot) do
      puts "Please enter a valid coordinate:"
      print "> "
      shot = gets.chomp
    end

    shot
  end

  def display_boards
    [
      "=============COMPUTER BOARD=============",
      @computer_board.render(true),
      "==============PLAYER BOARD==============",
      @player_board.render(true)
    ].join("\n")
  end

  def place_player_ships
    puts player_instructions

    @player_ships.each do |ship|
      puts @player_board.render(true)
      placement = get_ship_placement(ship)

      @player_board.place(ship, placement)
    end
  end

  def get_ship_placement(ship)
    puts "Enter the squares (separated by spaces) for the #{ship.name} (#{ship.length} squares):"
    print "> "

    validate_player_coords(ship)
  end

  def validate_player_coords(ship)
    response = gets.chomp.split

    while !@player_board.valid_placement?(ship, response) do
      puts "Invalid coordinates. Please try again:"
      print "> "
      response = gets.chomp.split
    end

    response
  end

  def player_instructions
    [
      "I have laid out my ships on the grid.",
      "You now need to lay out your two ships.",
      "The Cruiser is three units long and the Submarine is two units long."
    ].join("\n")
  end

  def place_computer_ships
    @computer_ships.each do |ship|
      placement = make_ship_placement(ship, @dimensions)

      while !@computer_board.valid_placement?(ship, placement) do
        placement = make_ship_placement(ship, @dimensions)
      end

      @computer_board.place(ship, placement)
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

game = Game.new.start_game
