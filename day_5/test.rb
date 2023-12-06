require 'pry'
require 'test/unit'
require './seed_map'

class DayFiveTest < Test::Unit::TestCase
  def setup
    @input = SeedMap.new(File.read('example.txt'))
  end

  # def teardown
  # end

  def test_location_from_seed
    assert_equal @input.seed_location(79), 82
    assert_equal @input.seed_location(14), 43
    assert_equal @input.seed_location(55), 86
    assert_equal @input.seed_location(13), 35
  end

  def test_location_from_ranges
    assert_equal @input.seed_locate_ranges(@input.seeds_as_range).min_by(&:begin).begin, 46
  end
end
