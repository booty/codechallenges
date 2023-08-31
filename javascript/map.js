/*
2635. Apply Transform Over Each Element in Array (Easy)

https://leetcode.com/problems/apply-transform-over-each-element-in-array/description/

Given an integer array arr and a mapping function fn, 
return a new array with a transformation applied to each element.

The returned array should be created such that returnedArray[i] = fn(arr[i], i).

Please solve it without the built-in Array.map method.

Example 1:

  Input: arr = [1,2,3], fn = function plusone(n) { return n + 1; }
  Output: [2,3,4]
  Explanation:
  const newArray = map(arr, plusone); // [2,3,4]
  The function increases each value in the array by one. 

Example 2:

  Input: arr = [1,2,3], fn = function plusI(n, i) { return n + i; }
  Output: [1,3,5]
  Explanation: The function increases each value by the index it resides in.

Example 3:

  Input: arr = [10,20,30], fn = function constant() { return 42; }
  Output: [42,42,42]
  Explanation: The function always returns 42.
*/

var map = function (arr, fn) {
  result = [];

  for (let i = 0; i < arr.length; i++) {
    result.push(fn(arr[i], i));
  }

  return result;
};

test_cases = [
  {
    arr: [1, 2, 3],
    fn: function plusone(n) {
      return n + 1;
    },
    expected_output: [2, 3, 4],
  },
  {
    arr: [1, 2, 3],
    fn: function plusI(n, i) {
      return n + i;
    },
    expected_output: [1, 3, 5],
  },
];

for (test_case of test_cases) {
  console.log(
    `Test case (${test_case.arr}, ${test_case.fn}): ${
      map(test_case.arr, test_case.fn).toString() ===
      test_case.expected_output.toString()
    }`
  );
}
