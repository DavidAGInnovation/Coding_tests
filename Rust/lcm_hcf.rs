use std::io::{self, Write}; // For input/output operations

// Function to calculate the Greatest Common Divisor (GCD) / Highest Common Factor (HCF)
// using the Euclidean algorithm.
fn gcd(mut a: u64, mut b: u64) -> u64 {
    while b != 0 {
        let temp = b;
        b = a % b;
        a = temp;
    }
    a
}

// Function to calculate the Lowest Common Multiple (LCM) of two numbers.
// LCM(a, b) = |a * b| / GCD(a, b)
// To avoid potential overflow from (a * b) before division,
// we can use: (a / GCD(a, b)) * b
fn lcm(a: u64, b: u64) -> u64 {
    if a == 0 || b == 0 {
        // This case is technically handled by the general logic if gcd(0, x) = x,
        // then (0 / x) * b = 0. And if gcd(a,0) = a, then (a/a)*0 = 0.
        // But being explicit about LCM with 0 is clear.
        return 0;
    }
    let common_divisor = gcd(a, b);
    if common_divisor == 0 { // Should not happen for non-zero a, b
        return 0; // Or handle as an error, though gcd of two non-zeros won't be 0.
    }
    (a / common_divisor) * b
}

fn main() {
    let mut numbers: Vec<u64> = Vec::new();
    let count = 5;

    println!("Please enter {} numbers:", count);

    for i in 0..count {
        loop {
            print!("Enter number {}: ", i + 1);
            io::stdout().flush().unwrap();

            let mut input = String::new();
            io::stdin()
                .read_line(&mut input)
                .expect("Failed to read line");

            match input.trim().parse::<u64>() {
                Ok(num) => {
                    numbers.push(num);
                    break;
                }
                Err(_) => {
                    println!("Invalid input. Please enter a valid non-negative integer.");
                }
            }
        }
    }

    if numbers.is_empty() { // Should not happen with the loop structure for a fixed count
        println!("No numbers were entered.");
        return;
    }
    if numbers.len() < 1 { // More robust check, though count=5 ensures length >= 5 if loop completes
        println!("Not enough numbers entered to calculate HCF/LCM.");
        return;
    }


    // Calculate HCF for the list of numbers
    let mut hcf_result = numbers[0];
    for i in 1..numbers.len() {
        hcf_result = gcd(hcf_result, numbers[i]);
    }

    // Calculate LCM for the list of numbers
    let mut lcm_result: u64; // Declare here

    if numbers.iter().any(|&x| x == 0) {
        // If any number in the set is 0, the LCM of the set is 0.
        lcm_result = 0;
    } else {
        // If no zeros, proceed normally. Initialize with the first number.
        lcm_result = numbers[0];
        for i in 1..numbers.len() {
            // No need to check for numbers[i] == 0 here,
            // as the outer `if` already confirmed no zeros in the `numbers` vector.
            lcm_result = lcm(lcm_result, numbers[i]);
        }
    }

    println!("\nThe numbers you entered are: {:?}", numbers);
    println!("Highest Common Factor (HCF): {}", hcf_result);
    println!("Lowest Common Multiple (LCM): {}", lcm_result);
}