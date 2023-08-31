/*
2622. Cache With Time Limit (Medium)

https://leetcode.com/problems/cache-with-time-limit/description/

Write a class that allows getting and setting key-value pairs, however a time until expiration is associated with each key.

The class has three public methods:
set(key, value, duration): accepts an integer key, an integer value, and a duration in milliseconds. Once the duration has elapsed, the key should be inaccessible. The method should return true if the same un-expired key already exists and false otherwise. Both the value and duration should be overwritten if the key already exists.
get(key): if an un-expired key exists, it should return the associated value. Otherwise it should return -1.
count(): returns the count of un-expired keys.

Example 1:

  Input: 
  ["TimeLimitedCache", "set", "get", "count", "get"]
  [[], [1, 42, 100], [1], [], [1]]
  [0, 0, 50, 50, 150]

  Output: [null, false, 42, 1, -1]

  Explanation:
  At t=0, the cache is constructed.
  At t=0, a key-value pair (1: 42) is added with a time limit of 100ms. The value doesn't exist so false is returned.
  At t=50, key=1 is requested and the value of 42 is returned.
  At t=50, count() is called and there is one active key in the cache.
  At t=100, key=1 expires.
  At t=150, get(1) is called but -1 is returned because the cache is empty.

Example 2:

  Input: 
  ["TimeLimitedCache", "set", "set", "get", "get", "get", "count"]
  [[], [1, 42, 50], [1, 50, 100], [1], [1], [1], []]
  [0, 0, 40, 50, 120, 200, 250]

  Output: [null, false, true, 50, 50, -1, 0]

Explanation:

  At t=0, the cache is constructed.
  At t=0, a key-value pair (1: 42) is added with a time limit of 50ms. The value doesn't exist so false is returned.
  At t=40, a key-value pair (1: 50) is added with a time limit of 100ms. A non-expired value already existed so true is returned and the old value was overwritten.
  At t=50, get(1) is called which returned 50.
  At t=120, get(1) is called which returned 50.
  At t=140, key=1 expires.
  At t=200, get(1) is called but the cache is empty so -1 is returned.
  At t=250, count() returns 0 because the cache is empty.

Constraints:

    0 <= key <= 109
    0 <= value <= 109
    0 <= duration <= 1000
    total method calls will not exceed 100
*/

var TimeLimitedCache = function () {
  this.cache = {};

  this.key_exists = function (key) {
    return this.cache.hasOwnProperty(key);
  };

  this.key_expired = function (key) {
    return this.cache[key].expiration < Date.now();
  };

  this.delete_expired_keys = function () {
    for (let key in this.cache) {
      if (this.key_expired(key)) {
        console.log("deleting expired key", key);
        delete this.cache[key];
      }
    }
  };

  /**
   * @param {number} key
   * @param {number} value
   * @param {number} duration time until expiration in ms
   * @return {boolean} if un-expired key already existed
   */
  this.set = function (key, value, duration) {
    console.log("set", key, value, duration);

    this.delete_expired_keys();
    already_exists = this.key_exists(key);

    // add duration milliseconds to current time
    let expiration = Date.now() + duration;
    this.cache[key] = { value, expiration };
    return already_exists;
  };

  /**
   * @param {number} key
   * @return {number} value associated with key
   */
  this.get = function (key) {
    this.delete_expired_keys();

    // find the key in this.cache and return its value. if it doesn't exist return -1
    if (this.key_exists(key)) {
      return this.cache[key].value;
    }
    return -1;
  };

  /**
   * @return {number} count of non-expired keys
   */
  this.count = function () {
    this.delete_expired_keys();

    return Object.keys(this.cache).length;
  };
};

/**
 * Your TimeLimitedCache object will be instantiated and called as such:
 * var obj = new TimeLimitedCache()
 * obj.set(1, 42, 1000); // false
 * obj.get(1) // 42
 * obj.count() // 1
 */

let sleep = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

var obj = new TimeLimitedCache();
obj.set(1, 42, 100); // false
console.log("sleeping 50ms");
await sleep(50);
console.log("get(1)", obj.get(1)); // 42
console.log("count()", obj.count()); // 1
console.log("sleeping 100ms");
await sleep(100);
console.log("get(1)", obj.get(1)); // -1
