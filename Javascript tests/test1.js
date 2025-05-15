function findPairsWithSum(nums1, nums2, k) {
    const resultPairs = [];
    if (!nums1 || !nums2 || nums1.length === 0 || nums1.length !== nums2.length) {
        return resultPairs; // Or throw an error for invalid input
    }

    // For efficient lookup, we can put elements of one array into a Set.
    // Let's put elements of nums2 into a Set.
    const setNums2 = new Set(nums2);

    for (let i = 0; i < nums1.length; i++) {
        const num1 = nums1[i];
        const complement = k - num1;

        if (setNums2.has(complement)) {
            resultPairs.push([num1, complement]);
        }
    }

    return resultPairs;
}

// --- Test Case ---
let nums1_test1 = [4, 5, 6, 7, 0, 1];
let nums2_test1 = [3, 9, 10, 11, 12, 19];
let k_test1 = 13;

console.log(`nums1: [${nums1_test1}]`);
console.log(`nums2: [${nums2_test1}]`);
console.log(`k: ${k_test1}`);
let pairs1 = findPairsWithSum(nums1_test1, nums2_test1, k_test1);
console.log("Pairs found:", JSON.stringify(pairs1)); // Expected: [[4,9], [1,12]]

let nums1_test1b = [11, 12, 13, 1, 2, 3];
let nums2_test1b = [7, 8, 9, 10, 0]; // Unequal length - should return empty
let k_test1b = 13;
console.log("\nTest with unequal length:");
let pairs1b = findPairsWithSum(nums1_test1b, nums2_test1b, k_test1b);
console.log("Pairs found:", JSON.stringify(pairs1b)); // Expected: []

let nums1_test1c = [1, 2, 3];
let nums2_test1c = [10, 11, 12];
let k_test1c = 13;
console.log("\nAnother test:");
console.log(`nums1: [${nums1_test1c}]`);
console.log(`nums2: [${nums2_test1c}]`);
console.log(`k: ${k_test1c}`);
let pairs1c = findPairsWithSum(nums1_test1c, nums2_test1c, k_test1c);
console.log("Pairs found:", JSON.stringify(pairs1c)); // Expected: [[1,12],[2,11],[3,10]]

let nums1_test1d = [4, 5, 6];
let nums2_test1d = [1, 2, 3];
let k_test1d = 100;
console.log("\nTest with no pairs:");
console.log(`nums1: [${nums1_test1d}]`);
console.log(`nums2: [${nums2_test1d}]`);
console.log(`k: ${k_test1d}`);
let pairs1d = findPairsWithSum(nums1_test1d, nums2_test1d, k_test1d);
console.log("Pairs found:", JSON.stringify(pairs1d)); // Expected: []