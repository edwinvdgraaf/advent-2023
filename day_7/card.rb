TYPE_VALUES = {
  five_of_a_kind: 5,
  four_of_a_kind: 4,
  full_house: 3,
  three_of_a_kind: 2,
  two_pair: 1,
  one_pair: 0,
  high_card: -1
}.freeze

LABEL_VALUES = {
  'A' => 14,
  'K' => 13,
  'Q' => 12,
  'J' => 1, # Joker
  'T' => 10,
  '9' => 9,
  '8' => 8,
  '7' => 7,
  '6' => 6,
  '5' => 5,
  '4' => 4,
  '3' => 3,
  '2' => 2
}.freeze

class Hand
  attr_accessor :type, :value, :bid, :cards

  def initialize(input)
    cards, bid = input.split(' ')

    @cards = cards
    @bid = bid.to_i
    @type = determine_type(cards)
    @value = determine_value(cards)
  end

  def <=>(other)
    if @type == other.type
      out = nil
      6.times do |i|
        out = LABEL_VALUES[@cards[i]] <=> LABEL_VALUES[other.cards[i]]
        break if out != 0
      end

      return out
    end

    TYPE_VALUES[@type] <=> TYPE_VALUES[other.type]
  end

  private

  def determine_value(cards)
    LABEL_VALUES[cards[0]]
  end

  def determine_type(cards)
    counts = Hash.new(0)

    cards.each_char do |c|
      counts[c] += 1
    end

    if counts['J'].positive? && counts['J'] < 5
      keys = counts.sort_by { |_key, value| value }.reverse
      if keys[0][0] == 'J'
        counts[keys[1][0]] += counts['J']
      else
        counts[keys[0][0]] += counts['J']
      end
      counts.delete('J')
    end

    case counts.values.sort
    when [5]
      :five_of_a_kind
    when [1, 4]
      :four_of_a_kind
    when [2, 3]
      :full_house
    when [1, 1, 3]
      :three_of_a_kind
    when [1, 2, 2]
      :two_pair
    when [1, 1, 1, 2]
      :one_pair
    when [1, 1, 1, 1, 1]
      :high_card
    else
      raise "Unknown hand type #{counts.values.sort}"
    end
  end
end
