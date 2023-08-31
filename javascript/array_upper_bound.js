/*
array prototype function named upperBound(target) that 
returns the last index in a sorted array where
the value is equal to target, or -1 if no such index exists.
*/
Array.prototype.upperBound = function (target) {
  let left = 0;
  let right = this.length - 1;
  let mid;
  let result = -1;

  while (left <= right) {
    mid = Math.floor((left + right) / 2);
    if (this[mid] === target) {
      result = mid;
      left = mid + 1;
    } else if (this[mid] > target) {
      right = mid - 1;
    } else {
      left = mid + 1;
    }
  }

  return result;
};

test_inputs = [
  [[3, 4, 5], 5],
  [[1, 4, 5], 2],
  [[3, 4, 6, 6, 6, 6, 7], 6],
];
expected_outputs = [2, -1, 5];

for (let i = 0; i < test_inputs.length; i++) {
  console.log(
    `Test ${i + 1} (${test_inputs[i]}): ${
      test_inputs[i][0].upperBound(test_inputs[i][1]) === expected_outputs[i]
    }`
  );
}
