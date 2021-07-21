module ShipGenerator
  extend self

  def make_ships
    if custom_ships?
      ships = make_custom_ships(@dimensions.min)
    else
      ships = [["cruiser", 3], ["submarine", 2]]
    end

    ships
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
    ships_available = max_dimension > 6 ? max_dimension / 2 : max_dimension
    puts "You have up to #{ships_available} ships available to make."

    ships = []
    loop do
      ships << create_ship(max_dimension)
      ships_available -= 1
      break if ships_available == 0 || no_more_ships?(ships_available)
    end

    ships
  end

  def no_more_ships?(ships_available)
    puts "You have up to #{ships_available} ships available to make."
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

  def create_ship(max_dimension)
    [get_name, get_length(max_dimension)]
  end

  def get_name
    puts "Enter ship name:"
    print "> "

    name = gets.chomp
    while name == ""
      "Enter ship name:"
      print "> "
      name = gets.chomp
    end

    name
  end

  def get_length(max_dimension)
    max_length = max_dimension > 6 ? max_dimension / 2 : max_dimension
    puts "Enter ship length (between 2 and #{max_length}):"
    print "> "

    length = gets.chomp.to_i
    while !(2..max_length).include?(length) do
      puts "Invalid input. Enter ship length (between 2 and #{max_length}):"
      print "> "
      length = gets.chomp.to_i
    end

    length
  end
end
