def binary(nums, target)
  jump = nums.length / 2
  i = jump

  loop do
    n = nums[i]
    puts "i:#{i} nums[i]:#{n}"

    return i if n == target
    return nil unless n
    return nil if i < 0
    return nil if n > target && nums[i - 1] < target

    jump = jump / 2
    jump = 1 if jump < 1

    if n > target
      i -= jump
    else
      i += jump
    end
  end
end
