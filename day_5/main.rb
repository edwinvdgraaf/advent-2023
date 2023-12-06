require 'pry'
require './seed_map'

seed_map = SeedMap.new(File.read('input.txt'))

# Part 1
p seed_map.seeds.map { |seed| seed_map.seed_location(seed) }.min

# Part 2
p seed_map.seed_locate_ranges(seed_map.seeds_as_range).min_by(&:begin).begin
