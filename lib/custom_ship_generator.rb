module CustomShipGenerator
  extend self

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
