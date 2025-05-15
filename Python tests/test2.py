import re
from collections import Counter

def word_frequency_test2(text: str):
    """
    Reads a string of text, counts the frequency of each word,
    and then displays the words in descending order of their frequency.
    Punctuation is removed and words are converted to lowercase.
    """
    # Normalize text: lowercase and remove punctuation
    # Replace punctuation with spaces to handle cases like "word.word" -> "word word"
    # This regex keeps alphanumeric characters and whitespace, removes others.
    cleaned_text = text.lower()
    cleaned_text = re.sub(r'[^\w\s]', '', cleaned_text) # Removes punctuation effectively

    # Split into words
    words = cleaned_text.split()

    if not words:
        print("Word Frequencies:")
        print("(No words found)")
        return

    # Count word frequencies
    word_counts = Counter(words)

    # Sort words by frequency (descending).
    # For ties in frequency, sort alphabetically (ascending) for consistent output.
    # `word_counts.items()` gives (word, count) pairs.
    # We sort by count (descending, so -item[1]) then by word (ascending, item[0]).
    sorted_word_counts = sorted(word_counts.items(), key=lambda item: (-item[1], item[0]))

    print("Word Frequencies:")
    for word, count in sorted_word_counts:
        print(f"{word}: {count}")

# --- Test Case for Test 2 ---
print("\n--- Test 2 Results ---")
example_input_test2 = "Hello world! This is a test. Hello, this test is only a test."
print(f"Input text: \"{example_input_test2}\"")
word_frequency_test2(example_input_test2)

print("\nAnother Test 2 Example:")
another_text = "Apple apple Banana; apple, Orange.. banana!"
print(f"Input text: \"{another_text}\"")
word_frequency_test2(another_text)

print("\nEmpty string test:")
word_frequency_test2("")

print("\nString with only punctuation:")
word_frequency_test2("!@#$.... ,,, ???")