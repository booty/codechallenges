class ListNode
  attr_accessor :val, :next

  def initialize(val = 0, _next = nil)
    @val = val
    @next = _next
  end

  def self.from_array(ary)
    head = nil
    prev = nil
    ary.each do |x|
      curr = new(x)
      prev.next = curr if prev
      prev = curr
      head ||= curr
    end
    head
  end

  def length
    length = 1

    curr = self

    while curr.next
      length += 1
      curr = curr.next
    end

    length
  end

  def to_array
    result = [val]
    curr = self
    while curr.next
      curr = curr.next
      result << curr.val
    end

    result
  end

  def to_s
    "(" + to_array.join(") → (") + ")"
  end
end

