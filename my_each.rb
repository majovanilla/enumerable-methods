module Enumerable
  def my_each
    i = 0
    while i < self.length
      puts yield self[i]
      i += 1
    end
  end
end


[2, 4, 5, 6, 7, 4, 3, 7].my_each {|el| el * 2}