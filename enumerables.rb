# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    while i < length
      return to_enum unless block_given?

      if block_given?
        yield(self[i])
        i += 1
      end
    end
  end

  def my_each_with_index
    i = 0
    while i < length
      return to_enum unless block_given?

      if block_given?
        yield(self[i], i)
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

  def my_all?
    all = true
    my_each do |i|
      if block_given?
        unless yield(i)
          all = false
          break
        end
      else
        all = false unless i
      end
    end
    all
  end

  def my_any?
    any = false
    my_each do |i|
      if block_given?
        if yield(i)
          any = true
          break
        end
      elsif i
        any = true
      end
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
      if block_given? && yield(i)
        counter += 1
      elsif i
        counter += 1
      end
    end
    counter
  end

  def my_map
    arr = []
    my_each do |i|
      return to_enum unless block_given?

      arr << yield(i) if block_given?
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
end

array = [202, 4, 5, 6, 4, 3, 7]
puts array.my_inject { |acc, e| acc - e }
