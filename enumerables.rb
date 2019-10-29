# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength,
module Enumerable
  # rubocop:disable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
  def my_each
    i = 0
    return to_enum unless block_given?

    while i < size
      yield(to_a[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    i = 0
    return to_enum unless block_given?

    while i < size
      yield(to_a[i], i)
      i += 1
    end
    self
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

  def my_all?(input = nil)
    my_each do |i|
      return false if block_given? && !yield(i)

      if !block_given? && input.nil?
        return false unless i
      elsif input
        return false unless check_input(i, input)
      end
    end
    true
  end

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

  def my_inject(start = nil, symbol = nil)
    if block_given?
      memo = start if start
      if start.nil?
        memo = to_a[0]
        to_a.shift
        my_each do |i|
          memo = yield(memo, i)
        end
      end

    elsif !block_given?
      return to_enum if start.nil?

      if start && symbol.nil?
        memo = self[0]
        shift
        my_each do |i|
          memo = memo.send(start, i)
        end
      elsif start && symbol
        memo = start
        my_each do |i|
          memo = memo.send(symbol, i)
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

# rubocop:enable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
# rubocop:enable Metrics/ModuleLength,
