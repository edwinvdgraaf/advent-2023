class SeedMap
  attr_accessor :seeds, :mapping

  def initialize(input)
    match = input.match(/seeds: ([\d\s\n]*)seed-to-soil map:([\d\s\n]*)soil-to-fertilizer map:([\d\s\n]*)fertilizer-to-water map:([\d\s\n]*)water-to-light map:([\d\s\n]*)light-to-temperature map:([\d\s\n]*)temperature-to-humidity map:([\d\s\n]*)humidity-to-location map:([\d\s\n]*)/)

    @seeds = match[1].split(' ').map(&:to_i)

    @seed_to_soil = split_block match[2]
    @soil_to_fertilizer = split_block match[3]
    @fertilizer_to_water = split_block match[4]
    @water_to_light = split_block match[5]
    @light_to_temperature = split_block match[6]
    @temperature_to_humidity = split_block match[7]
    @humidity_to_location = split_block match[8]

    @mapping = [@seed_to_soil, @soil_to_fertilizer,
                @fertilizer_to_water,
                @water_to_light,
                @light_to_temperature,
                @temperature_to_humidity,
                @humidity_to_location].map do |group|
      map = {}

      group.each do |line|
        dest, source, length = line
        range = source..(source + length)
        offset = dest - source

        map[range] = offset
      end

      map
    end
  end

  def seed_location(index)
    @mapping.reduce(index) do |source, map|
      range, offset = map.find do |range, _offset|
        range.include?(source)
      end

      source += offset if range
      source
    end
  end

  def seed_locate_ranges(ranges)
    @mapping
      .reduce(ranges) do |sources, map|
      sources.flat_map do |source_range|
        matches = []

        curr = source_range.begin

        map
          .sort_by { |range, _offset| range.begin }
          .each do |range, offset|
            match = fits(range, source_range)

            next unless match

            matches << (curr..(match.begin - 1)) if match.begin != curr

            matches << (
              (match.begin + offset)..(match.end + offset)
            )
            curr = match.end + 1
          end

        matches << (curr..source_range.end) if curr < source_range.end

        matches
      end
    end
  end

  def seeds_as_range
    @seeds.each_slice(2).map do |pair|
      (pair[0]..pair[0] + pair[1])
    end
  end

  private

  def split_block(input)
    input.split("\n").filter { |line| !line.empty? }.map { |line| line.split.map(&:to_i) }
  end

  def fits(a, b)
    return unless b.begin <= a.end && a.begin <= b.end

    [a.begin, b.begin].max..[a.end, b.end].min
  end
end
