# frozen_string_literal: true

require_relative "binary_search"
require_relative "testable"

class TestBinarySearch
  include Testable

  def ary_with_target_7_items
    ary = [0, 1, 2, 3, 4, 5, 7]
    assert_equal(
      0,
      binary_search(ary, 0),
      "7-item list (target 0)",
    )
    assert_equal(
      3,
      binary_search(ary, 3),
      "7-item list (target 3)",
    )
    assert_equal(
      6,
      binary_search(ary, 7),
      "7-item list (target 7)",
    )
    assert_equal(
      nil,
      binary_search(ary, -1),
      "7-item list (missing target hi)",
    )
    assert_equal(
      nil,
      binary_search(ary, 8),
      "7-item list (missing target lo)",
    )
    assert_equal(
      nil,
      binary_search(ary, 6),
      "7-item list (missing target mid)",
    )
  end

  def empty_array
    assert_equal(
      nil,
      binary_search([], 42),
      "empty array",
    )
  end

  def one_item_array
    assert_equal(
      0,
      binary_search([1], 1),
      "found",
    )
    assert_equal(
      nil,
      binary_search([1], 2),
      "not found hi",
    )
    assert_equal(
      nil,
      binary_search([1], -1),
      "not found lo",
    )
  end
end

TestBinarySearch.new.test
