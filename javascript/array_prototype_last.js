/*
2619. Array Prototype Last (Easy)

https://leetcode.com/problems/array-prototype-last/

Write code that enhances all arrays such that you can call 
the array.last() method on any array and it will return the 
last element. If there are no elements in the array, it should 
return -1.

You may assume the array is the output of JSON.parse.

Example 1:

    Input: nums = [null, {}, 3]
    Output: 3
    Explanation: Calling nums.last() should return the last element: 3.

Example 2:
    
    Input: nums = []
    Output: -1
    Explanation: Because there are no elements, return -1.

Constraints:
    0 <= arr.length <= 1000
*/

Array.prototype.last = function () {
  if (this.length === 0) return -1;
  return this[this.length - 1];
};

test_inputs = [[], [1, 2, 3], [1]];
expected_outputs = [-1, 3, 1];

for (let i = 0; i < test_inputs.length; i++) {
  console.log(
    `Test ${i + 1} (${test_inputs[i]}): ${
      test_inputs[i].last() === expected_outputs[i]
    }`
  );
}
