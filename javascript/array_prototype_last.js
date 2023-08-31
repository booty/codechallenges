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
