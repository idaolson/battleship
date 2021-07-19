class IntelligentComputer

  def initialize(player_board, dimensions)
    @board = player_board
    @rows = ("A".."Z").take(dimensions.first)
    @available_shots = @board.cells.keys
    @hit_count = 0
    @last_shot_hit = false
  end

  def make_target
    @target = {
      up: @last_shot,
      down: one_below,
      left: one_left,
      right: one_right
    }
  end

  def smart_shooting
    make_target if @hit_count == 1

    update_direction = {
      :up => -> {
        @target[:up] = one_above
        stay_on_board(:up)
      },
      :down => -> {
        @target[:down] = one_below
        stay_on_board(:down)
      },
      :left => -> {
        @target[:left] = one_left
        stay_on_board(:left)
      },
      :right => -> {
        @target[:right] = one_right
      }
    }
    update_direction[@target.keys.first].call

    next_shot_location
  end

  def change_direction
    @target.delete(@target.keys.first)
  end

  def stay_on_board(direction)
    next_shot = @target[direction]
    change_direction if next_shot == nil
  end

  def shot_choosing
    if @last_shot_hit
      @hit_count += 1
      smart_shooting
    else
      if @hit_count == 0
        @last_shot = @available_shots.sample
        @available_shots.delete(@last_shot)
      else
        change_direction
        next_shot_location
      end
    end
    @last_shot
  end

  def next_shot_location
    shot = @target.values.first
    while !@available_shots.include?(shot)
      change_direction
      shot = @target.values.first
    end
    @last_shot = @available_shots.delete(shot)
  end

  def one_above
    cell = @last_shot.chars
    row_num = @rows.index(cell.first) - 1
    return nil if row_num < 0
    @rows[row_num] + cell[1..].join
  end

  def one_below
    cell = @last_shot.chars
    row_num = @rows.index(cell.first) + 1
    @rows[row_num] + cell[1..].join
  end

  def one_left
    letter, number = @last_shot.scan(/(\w)(\d+)/).first
    number = number.to_i - 1
    letter + number.to_s
  end

  def one_right
    letter, number = @last_shot.scan(/(\w)(\d+)/).first
    number = number.to_i + 1
    letter + number.to_s
  end

  def in_available_shots?(cell)
    @available_shots.include?(cell)
  end

  def hit_ship(result)
    @last_shot_hit = result == "hit"
  end

  def sunk_target
    @last_shot_hit = false
    @hit_count = 0
  end
end
