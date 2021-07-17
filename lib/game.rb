require './lib/board'
require './lib/ship'
require './lib/cell'

class Game

  def initialize
    @player_board = Board.new
    @computer_board = Board.new
    @available_shots = @computer_board.cells.keys
    @player_ships = [Ship.new("cruiser", 3), Ship.new("submarine", 2)]
    @computer_ships = [Ship.new("cruiser", 3), Ship.new("submarine", 2)]
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

  def new_game
    @player_board = Board.new
    @computer_board = Board.new
    @available_shots = @computer_board.cells.keys
    @player_ships = [Ship.new("cruiser", 3), Ship.new("submarine", 2)]
    @computer_ships = [Ship.new("cruiser", 3), Ship.new("submarine", 2)]

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
      placement = make_ship_placement(ship)

      while !@computer_board.valid_placement?(ship, placement) do
        placement = make_ship_placement(ship)
      end

      @computer_board.place(ship, placement)
    end
  end

  def make_ship_placement(ship)

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
