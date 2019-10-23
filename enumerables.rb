# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    while i < size
      return to_enum unless block_given?

      if block_given?
        yield(self.to_a[i])
        i += 1
      end
    end
  end

  def my_each_with_index
    i = 0
    while i < size
      return to_enum unless block_given?

      if block_given?
        yield(self.to_a[i], i)
        i += 1
      end
    end
  end

  def my_select
    return to_enum unless block_given?

    if block_given?
      arr = []
      my_each do |i|
        arr << i if yield(i)
      end
    end
    arr
  end

  # works with arrays
  def my_all?
    all = true
    my_each do |i|
      return all = false unless yield(i) && block_given?

      all = false unless i
    end
    all
  end

  # works with arrays
  def my_any?
    any = false
    my_each do |i|
      return any = true if block_given? && yield(i)

      any = true unless block_given? && i
    end
    any
  end

  def my_none?
    none = true
    my_each do |i|
      if block_given?
        if yield(i)
          none = false
          break
        end
      elsif i
        none = false
      end
    end
    none
  end

  def my_count
    counter = 0
    my_each do |i|
      counter += 1 unless block_given? && i

      counter += 1 if block_given? && yield(i)
    end
    counter
  end

  def my_map
    arr = []
    my_each do |i|
      return to_enum unless block_given?

      arr << yield(i) || arr << proc.call(i) if block_given?
    end
    arr
  end

  def my_inject
    memo = nil
    my_each do |i|
      return to_enum unless block_given?

      if block_given?
        memo = if memo.nil?
                 i
               else
                 yield(memo, i)
               end
      end
    end
    memo
  end

  def multiply_els
    my_inject do |acc, e|
      acc * e
    end
  end
end