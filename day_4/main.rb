# Scratch card
class Card
  attr_accessor :id, :winning_numbers, :card_numbers, :instances

  def initialize(input)
    match = input.match(/Card\s+(\d+): ([0123456789\s]*) \| ([0123456789\s]*)/)

    @id = match[1].to_i - 1 # 0-indexed for easier array access
    @winning_numbers = match[2].split(' ').map(&:to_i)
    @card_numbers = match[3].split(' ').map(&:to_i)
    @instances = 1
  end

  def points
    intersections = @winning_numbers.intersection(@card_numbers).length

    if intersections == 1
      1
    elsif intersections == 2
      2
    elsif intersections > 2
      doubled_intersections = intersections - 1
      2**doubled_intersections
    else
      0
    end
  end

  def add_instance
    @instances += 1
  end
end

# Card hoarder
class Hoarder
  def initialize(cards)
    @cards = cards
  end

  def process
    @cards.each do |card|
      extra_cards = card.winning_numbers.intersection(card.card_numbers).length
      next unless extra_cards.positive?

      (1..card.instances).each do |_j|
        (1..extra_cards).each do |i|
          next_card = card.id + i
          @cards[next_card].add_instance
        end
      end
    end
  end
end

cards = File.read('input.txt').split("\n").map { |x| Card.new(x) }

# Part 1
p("Part 1: #{cards.map(&:points).sum}")

# Part 2
p("Part 2: #{Hoarder.new(cards).process.map(&:instances).sum}")
