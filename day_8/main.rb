class Node
  attr_accessor :left, :right

  def initialize(left, right)
    @left = left
    @right = right
  end
end

class Network
  def initialize(input)
    instructions_input, nodes_input = input.split("\n\n")

    @instructions = instructions_input.split('').cycle
    @nodes = nodes_input.split("\n").map do |x|
      tokens = x.split(' ')
      [tokens[0].to_sym, Node.new(tokens[2].sub('(', '').sub(',', '').to_sym, tokens[3].sub(')', '').to_sym)]
    end.to_h
  end

  def traverse_for_peeps
    current = :AAA
    steps = 0

    loop do
      steps += 1

      instruction = @instructions.next

      current = if instruction == 'L'
                  @nodes[current].left
                else
                  @nodes[current].right
                end

      break if current == :ZZZ
    end

    steps
  end

  def traverse_for_ghosts
    starts = @nodes.keys.select { |x| x.to_s.match?(/A$/) }

    starts.map do |current|
      steps = 0
      loop do
        steps += 1

        instruction = @instructions.next
        current = if instruction == 'L'
                    @nodes[current].left
                  else
                    @nodes[current].right
                  end

        break if current.to_s.match?(/Z$/)
      end

      steps
    end.inject(:lcm)
  end
end

input = File.read('input.txt')
network = Network.new(input)

# Part 1
p network.traverse_for_peeps

# Part 2
p network.traverse_for_ghosts
