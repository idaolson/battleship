module ShotProcessor
  def process_computer_shot
    computer_shot = @computer_brain.shot_choosing
    [computer_shot, fire_shot(computer_shot, :computer)]
  end

  def process_player_shot
    puts "Enter the coordinate for your shot:"
    print "> "

    player_shot = validate_player_shot
    [player_shot, fire_shot(player_shot, :player)]
  end

  def fire_shot(shot, person)
    firing = {
      :player => @computer_board.cells[shot],
      :computer => @player_board.cells[shot]
    }

    cell = firing[person]
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
end
