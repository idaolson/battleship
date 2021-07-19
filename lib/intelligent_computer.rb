class IntelligentComputer

  def initialize(player_board, dimensions)
    @board = player_board
    @rows = ("A".."Z").take(dimensions.first)
    @available_shots = @board.cells.keys
    @hit_count = 0
    @last_shot = nil
    @last_shot_hit = false
  end

  def make_target(cell)
    @target = {
      up: cell,
      down: one_below(cell),
      left: one_left(cell),
      right: one_right(cell)
    }
  end

  def smart_shooting(cell)
    make_target(cell) if @hit_count == 1

    update_direction = {
      :up => ->(cell) {
        @target[:up] = one_above(cell)
        stay_on_board(:up)
      },
      :down => ->(cell) {
        @target[:down] = one_below(cell)
        stay_on_board(:down)
      },
      :left => ->(cell) {
        @target[:left] = one_left(cell)
        stay_on_board(:left)
      },
      :right => ->(cell) {
        @target[:right] = one_right(cell)
        stay_on_board(:right)
      }
    }

    update_direction[@target.keys.first].call(@target.values.first)

    next_shot_location
  end

  def stay_on_board(direction)
    next_shot = @target[direction]
    if next_shot == nil
      @target.delete(@target.keys.first)
    end
  end

  def shot_choosing
      if @last_shot_hit
      @hit_count += 1
      smart_shooting(@last_shot)
    else
      if @hit_count == 0
        shot = @available_shots.sample
        @available_shots.delete(shot)
        @last_shot = shot
      else
        @target.delete(@target.keys.first)
        next_shot_location
      end
    end
    p @available_shots
    @last_shot
  end

  def next_shot_location
    shot = @target.values.first
    while !@available_shots.include?(shot)
      @target.delete(@target.keys.first)
      shot = @target.values.first
    end
    @available_shots.delete(shot)
    @last_shot = shot
  end

  def one_above(cell)
    cell = cell.chars
    row_num = @rows.index(cell.first)
    row_num -= 1
    return nil if row_num < 0
    cell[0] = @rows[row_num]
    cell.join
  end

  def one_below(cell)
    cell = cell.chars
    row_num = @rows.index(cell.first)
    row_num += 1
    cell[0] = @rows[row_num]
    cell.join
  end

  def one_left(cell)
    letter, number = cell.scan(/(\w)(\d+)/).first
    number = number.to_i
    number -= 1
    letter + number.to_s
  end

  def one_right(cell)
    letter, number = cell.scan(/(\w)(\d+)/).first
    number = number.to_i
    number += 1
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
