names = ["John", "Jane", "Mark", "Bob", "Mary"];

for (foo in names) {
  console.log(names[foo]);
}

for (foo of names) {
  console.log(foo);
}

var map = function (arr, fn) {
  let result = [];

  // for (val of arr) {
  //   console.log(val, fn(val));
  //   result.push(fn(val));
  // }

  for (let i = 0; i < arr.length; i++) {
    console.log(arr[i], fn(arr[i], i));
    result.push(fn(arr[i], i));
  }

  return result;
};

let result = map([1, 2, 3], function (n) {
  return n * 2;
});

console.log(result);

let result2 = map([1, 2, 3], function plusI(n, i) {
  return n + i;
});

console.log(result2);
