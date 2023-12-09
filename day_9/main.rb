def extrapolate_next_history(history)
  history = [history.split(' ').map(&:to_i)]

  while history.last[0] != 0 || history.last.last != 0
    diff_seq = []
    (1..history.last.length - 1).each do |i|
      diff_seq << history.last[i].to_i - history.last[i - 1].to_i
    end
    history.push(diff_seq)
  end

  i = history.length - 1
  while i > -1
    history[i] << if i == history.length - 1
                    history[i].last
                  else
                    history[i].last + history[i + 1].last
                  end
    i -= 1
  end

  history.first.last
end

def extrapolate_prev_history(history)
  history = [history.split(' ').map(&:to_i)]

  while history.last[0] != 0 || history.last.last != 0
    diff_seq = []
    (1..history.last.length - 1).each do |i|
      diff_seq << history.last[i].to_i - history.last[i - 1].to_i
    end
    history.push(diff_seq)
  end

  i = history.length - 1
  while i > -1

    if i == history.length - 1
      history[i].unshift history[i].first
    else
      history[i].unshift(history[i].first - history[i + 1].first)
    end
    i -= 1
  end

  history.first.first
end

# Part 1
p(File.read('input.txt').split("\n").map { |line| extrapolate_next_history(line) }.sum)

# Part 2
p(File.read('input.txt').split("\n").map { |line| extrapolate_prev_history(line) }.sum)
