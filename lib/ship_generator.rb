module ShipGenerator
  extend self

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

  def make_custom_ships(max_dimension)
    ships_available = max_dimension / 2

    ships = []
    while ships_available > 0
      ships << create_ship(ships_available, max_dimension)
      ships_available -= 1
      break if no_more_ships?
    end

    ships
  end

  def no_more_ships?
    puts "Make another ship? (y/n)"
    print "> "

    response = gets.chomp

    while response != "y" && response != "n" do
       puts "Invalid input. Enter y or n:"
       print "> "
       response = gets.chomp
     end

     response == "n"
  end

  def create_ship(ships_available, max_dimension)
    puts "You have up to #{ships_available} ships available to make."
    puts "Enter ship name:"
    print "> "

    name = gets.chomp

    while name == ""
      "Enter ship name:"
      print "> "

      name = gets.chomp
    end

    puts "Enter ship length (between 2 and #{max_dimension}):"
    print "> "

    length = gets.chomp.to_i

    while !(2..max_dimension).include?(length) do
      puts "Invalid input. Enter ship length (between 2 and #{max_dimension}):"
      print "> "

      length = gets.chomp.to_i
    end

    Ship.new(name, length)
  end
end
