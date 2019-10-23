# frozen_string_literal: true

module Enumerable
  def my_each
    i = 0
    while i < self.length
      if block_given?
        yield(self[i])
        i += 1
      else
        self
        break
      end
    end
  end

  def my_each_with_index
    i = 0
    while i < self.length
      if block_given?
        yield(self[i], i)
        i += 1
      else 
        self
        break
      end
    end
  end

  def my_select
    if block_given?
      arr = []
      self.my_each do |i|
        arr << i if yield(i)
      end
      arr
    else
      self
    end
  end

  def my_all?
    all = true
    self.my_each do |i|
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
    self.my_each do |i|
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

array = [2, 4, 5, 6, nil, 4, 3, 7]
puts array.my_any?
