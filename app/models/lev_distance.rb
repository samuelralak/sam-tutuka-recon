class LevDistance
  def self.distance(a, b)
    a_len = a.length
    b_len = b.length
    d = Array.new(a_len + 1).map! do
      Array.new(b_len + 1).map! do
        0
      end
    end
    (a_len + 1).times { |i| d[i][0] = i }
    (b_len + 1).times { |i| d[0][i] = i }

    (1..a_len).each do |i|
      (1..b_len).each do |j|
        cost = a[i - 1] == b[j - 1] ? 0 : 1
        d[i][j] = [d[i - 1][j] + 1, d[i][j - 1] + 1, d[i - 1][j - 1] + cost].min
      end
    end
    d[-1][-1]
  end
end