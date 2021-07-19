require './lib/board'
require './lib/cell'
require './lib/ship_generator'
require './lib/shot_processor'
require './lib/intelligent_computer'

module GameProcessor
  include ShipGenerator
  include ShotProcessor

  extend self

  def game_loop
    loop do
      process_turns
      if winner
        puts display_boards
        puts winner
        break
      end
    end
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
    @computer_brain.hit_ship(computer_result.last)
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
      @computer_brain.sunk_target
      true
    end
  end

  def computer_ship_sunk?
    if @computer_ships.any? { |ship| ship.sunk? }
      @computer_ships.delete_if { |ship| ship.sunk? }
      true
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
end
