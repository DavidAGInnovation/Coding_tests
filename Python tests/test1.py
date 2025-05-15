import re

def validate_string_test1(s: str) -> bool:
    """
    Checks if a passed-in string is valid based on several criteria:
    1. At least 6 characters long.
    2. At least 2 but no more than 3 numbers (digits).
    3. At least 1 non-numerical character between each number.
    """
    # 1. Length check
    if len(s) < 6:
        return False

    # Find all digits and their indices
    digit_indices = []
    for i, char in enumerate(s):
        if char.isdigit():
            digit_indices.append(i)

    num_digits = len(digit_indices)

    # 2. Number of digits check
    if not (2 <= num_digits <= 3):
        return False

    # 3. Non-numerical character between each number
    # This condition only applies if there are 2 or 3 digits.
    # The previous check already ensures num_digits is 2 or 3.

    for i in range(len(digit_indices) - 1):
        idx_digit1 = digit_indices[i]
        idx_digit2 = digit_indices[i+1]

        # Substring between the current digit and the next one
        substring_between = s[idx_digit1 + 1 : idx_digit2]

        # There must be at least one character between them
        if not substring_between:
            return False

        # That character (or one of them) must be non-numerical
        has_non_digit = False
        for char_between in substring_between:
            if not char_between.isdigit():
                has_non_digit = True
                break
        
        if not has_non_digit:
            return False
            
    return True

# --- Test Cases for Test 1 ---
print("--- Test 1 Results ---")
test_cases_1 = {
    "a1b2c": False,         # Too short
    "abc123xyz": False,     # Digits are adjacent (123)
    "ab1c2d3ef": True,      # Valid: 3 digits, separated
    "a1b2c": False,         # Too short (len 5)
    "test1ng": False,       # Only 1 digit
    "t1e2s3t4": False,      # 4 digits
    "1a2b3c": True,         # Valid
    "12a3b": False,         # 1 and 2 are adjacent
    "a12b3c": False,        # 1 and 2 are adjacent
    "ab1c23d": False,       # 2 and 3 are adjacent
    "abc1d2ef": True,       # Valid: 2 digits, separated
    "1a2": False,           # Too short
    "1a2b3": False,         # Too short
    "no_digits_long_enough": False, # No digits
    "one1two22three": False, # 2 and 2 adjacent in "two22three"
    "x1y2z3w": True,        # Valid
    "x1yz2w": True,         # Valid
    "1a23b": False,         # 2 and 3 are adjacent
    "1aa23bb4": False,      # 4 digits
}

for s, expected in test_cases_1.items():
    result = validate_string_test1(s)
    print(f"String: '{s}', Valid: {result}, Expected: {expected}, Match: {result == expected}")