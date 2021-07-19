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
    rows = get_size("rows")
    columns = get_size("columns")
    [rows, columns]
  end

  def get_size(direction)
    puts "How many #{direction} would you like on the board (between 4-26):"
    print "> "

    input = gets.chomp.to_i
    while !(4..26).include?(input)
      puts "Please enter valid #{direction} count between 4-26:"
      print "> "

      input = gets.chomp.to_i
    end

    input
  end
end
