// LongestPalindromicSubstring.java
public class LongestPalindromicSubstring {

    public static String findLongestPalindrome(String s) {
        if (s == null || s.length() < 1) {
            return "";
        }

        int start = 0;
        int end = 0;

        for (int i = 0; i < s.length(); i++) {
            // Odd length palindromes (center is s[i])
            int len1 = expandAroundCenter(s, i, i);
            // Even length palindromes (center is between s[i] and s[i+1])
            int len2 = expandAroundCenter(s, i, i + 1);
            
            int len = Math.max(len1, len2);

            if (len > (end - start + 1)) { // +1 because end and start are inclusive indices
                // Calculate new start and end for the longest palindrome found so far
                start = i - (len - 1) / 2;
                end = i + len / 2;
            }
        }
        return s.substring(start, end + 1); // end + 1 because substring's second arg is exclusive
    }

    private static int expandAroundCenter(String s, int left, int right) {
        while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {
            left--;
            right++;
        }
        // The length of the palindrome is right - left - 1
        // Example: s="aba", left=-1, right=3. Length = 3 - (-1) - 1 = 3
        // Example: s="aa", left=-1, right=2. Length = 2 - (-1) - 1 = 2
        return right - left - 1;
    }

    public static void main(String[] args) {
        String s1 = "babad";
        System.out.println("Input: \"" + s1 + "\"");
        System.out.println("Output: \"" + findLongestPalindrome(s1) + "\""); // Expected: "bab" or "aba"

        String s2 = "cbbd";
        System.out.println("\nInput: \"" + s2 + "\"");
        System.out.println("Output: \"" + findLongestPalindrome(s2) + "\""); // Expected: "bb"

        String s3 = "a";
        System.out.println("\nInput: \"" + s3 + "\"");
        System.out.println("Output: \"" + findLongestPalindrome(s3) + "\""); // Expected: "a"

        String s4 = "racecar";
        System.out.println("\nInput: \"" + s4 + "\"");
        System.out.println("Output: \"" + findLongestPalindrome(s4) + "\""); // Expected: "racecar"
        
        String s5 = "";
        System.out.println("\nInput: \"" + s5 + "\"");
        System.out.println("Output: \"" + findLongestPalindrome(s5) + "\""); // Expected: ""

        String s6 = "abacdfgdcaba";
        System.out.println("\nInput: \"" + s6 + "\"");
        System.out.println("Output: \"" + findLongestPalindrome(s6) + "\""); // Expected: "abacdfgdcaba" -> "aba" (or "aca" or "dgd")

        String s7 = "bananas"; // "anana"
        System.out.println("\nInput: \"" + s7 + "\"");
        System.out.println("Output: \"" + findLongestPalindrome(s7) + "\""); // Expected: "anana"
    }
}