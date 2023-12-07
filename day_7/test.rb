require 'pry'
require 'test/unit'
require './card'

class DaySevenTest < Test::Unit::TestCase
  def test_card_type
    assert_equal Hand.new('QQQJA 483').type, :three_of_a_kind
    assert_equal Hand.new('QQQJA 483').value, 12

    assert_equal Hand.new('KTJJT 220').type, :four_of_a_kind
  end

  def test_compare_hand
    assert_equal Hand.new('32T3K 765') <=> Hand.new('QQQJA 483'), -1
    assert_equal Hand.new('QQQJA 483') <=> Hand.new('QQQJA 482'), 0

    assert_equal Hand.new('KK677 28') <=> Hand.new('KTJJT 220'), 1
  end

  def test_apply_joker
    assert_equal Hand.new('JJ99J 483').type, :five_of_a_kind
  end
end
