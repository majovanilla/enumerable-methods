# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    while i < size
      return to_enum unless block_given?

      if block_given?
        yield(to_a[i])
        i += 1
      end
    end
  end

  def my_each_with_index
    i = 0
    while i < size
      if block_given?
        yield(to_a[i], i)
        i += 1
      else 
        return to_enum
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
  def my_all?(input = nil)
    my_each do |i|
      return false if block_given? && !yield(i)

      if !block_given? && input.nil?
        return false unless i
      elsif !block_given? && input
        return false unless check_input(i, input)
      end
    end
    true
  end

  # # works with arrays
  def my_any?(input = nil)
    my_each do |i|
      return true if block_given? && yield(i)

      if !block_given? && input.nil?
        return true if i
      elsif !block_given? && input
        return true if check_input(i, input)
      end
    end
    false
  end

  def my_none?(input = nil)
    my_each do |i|
      return false if block_given? && yield(i)

      if !block_given? && input.nil?
        return false if i
      elsif !block_given? && input
        return false if check_input(i, input)
      end
    end
    true
  end

  def my_count(input = nil)
    counter = 0
    my_each do |i|
      if block_given?
        counter += 1 if yield(i)
      elsif i && input.nil?
        counter += 1 unless block_given?
      elsif check_input(i, input)
        counter += 1 unless block_given?
      end
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

  def my_inject(memo = nil)
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

  def check_input(item, input)
    if input.class == Regexp
      return true if item.to_s.match(input)
    elsif input.class == Class
      return true if item.instance_of? input
    elsif input.class == String || input.class == Integer
      return true if item == input
    end
  end
end
