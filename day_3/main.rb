# Reflect the engine schematic
class Grid
  def initialize(grid)
    @grid = grid
  end

  def traverse_to_find_parts
    correct_parts = []
    x = 0
    y = 0

    while x < @grid.length
      part_start = nil
      while y < @grid[x].length
        pos = @grid[x][y]

        if pos =~ /\d/ && part_start.nil?
          part_start = [x, y]
        elsif !part_start.nil? && !pos.match?(/\d/)
          correct_parts.push(possible_part?(part_start, [x, y - 1]))
          part_start = nil
        end

        y += 1
      end
      y = 0
      part_start = nil
      x += 1
    end

    correct_parts
  end

  def find_gears
    gears = []
    parts = []

    (0..@grid.length - 1).each do |x|
      gear = (0..@grid[x].length - 1).select { |y| @grid[x][y] == '*' }.map { |y| [x, y] }

      part_start = nil

      (0..@grid[x].length - 1).each do |y|
        if @grid[x][y] =~ /\d/ && part_start.nil?
          part_start = [x, y]
        elsif !part_start.nil? && !@grid[x][y].match?(/\d/)
          parts.push(collect_part(part_start, [x, y - 1]))
          part_start = nil
        end
      end

      gears.push(gear) unless gear.empty?
    end

    correct_gears = gears.flatten(1).map do |gear|
      surrouding_coords = expand_coords(gear, gear)
      matching_parts = parts.filter { |part| part[:coords].intersect?(surrouding_coords) }

      matching_parts if matching_parts.length > 1
    end

    correct_gears.filter { |x| !x.nil? }
  end

  private

  def possible_part?(start, finish)
    search_coords = expand_coords(start, finish)

    if !search_coords.map { |x| @grid[x[0]][x[1]] }.all? { |x| x == '.' }
      @grid[start[0]][start[1]..finish[1]].join('').to_i
    else
      0
    end
  end

  def collect_part(start, finish)
    coords = (start[1]..finish[1]).map { |y| [start[0], y] }

    {
      part: @grid[start[0]][start[1]..finish[1]].join('').to_i,
      coords: coords
    }
  end

  def expand_coords(start, finish)
    coords = []
    top = [0, start[0] - 1].max
    right = [@grid[start[0]].length - 1, finish[1] + 1].min
    bottom = [@grid.length - 1, start[0] + 1].min
    left = [0, start[1] - 1].max

    # expand the coordinates to include all adjacent cells

    (top..bottom).each do |x|
      (left..right).each do |y|
        # use coord if its not between start and finish
        coords.push([x, y]) unless x == start[0] && y <= finish[1] && y >= start[1]
      end
    end

    coords
  end
end

grid = Grid.new(File.read('input.txt').split("\n").map { |x| x.split('') })

# Part 1
p grid.traverse_to_find_parts.sum

# Part 2
p grid.find_gears.map { |x| x[0][:part] * x[1][:part] }.sum
