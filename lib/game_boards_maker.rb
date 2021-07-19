module GameBoardsMaker
  extend self

  def make_boards
    dimensions = get_board_dimensions

    {
      dimensions: dimensions,
      player_board: Board.new(dimensions),
      computer_board: Board.new(dimensions)
    }
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
end
