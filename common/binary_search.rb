# frozen_string_literal: true

def binary_search(nums, target)
  left = 0
  right = nums.length - 1

  while left <= right
    i = ((left + right) / 2).floor
    if nums[i] < target
      left = i + 1
    elsif nums[i] > target
      right = i - 1
    else
      return i
    end
  end
  nil
end
