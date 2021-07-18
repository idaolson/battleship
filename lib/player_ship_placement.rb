module PlayerShipPlacement
  extend self

  def player_ship_placement
    puts "Would you like to manually place your ships or have them placed at random?"
    puts "Enter m for manual or r for random:"
    print "> "
    response = gets.chomp

    while response != "m" && response != "r" do
      puts "Invalid input. Enter m for manual or r for random:"
      print "> "
      response = gets.chomp
    end

    if response == "m"
      place_player_ships
    else
      place_ships(:player)
    end
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
      "Now you need to lay out your ships.",
    ].join("\n")
  end


end
