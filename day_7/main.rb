require './card'

input = File.read('input.txt')
out = input.split("\n").map { |x| Hand.new(x) }.sort
p out.map(&:bid).each_with_index.map { |x, i| x * (i + 1) }.sum
