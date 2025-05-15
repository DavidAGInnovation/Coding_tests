#include <iostream>
#include <vector>
#include <string>
#include <numeric> // For std::accumulate (optional, can do manual sum)

std::vector<std::string> formatText(const std::vector<std::string> &words, int maxWidth)
{
    std::vector<std::string> resultLines;
    if (words.empty() || maxWidth <= 0)
    {
        return resultLines;
    }

    int currentWordIndex = 0;
    while (currentWordIndex < words.size())
    {
        std::string currentLine = "";
        int currentLineWidth = 0;
        int wordsInLine = 0;

        // Handle a single word longer than maxWidth
        if (words[currentWordIndex].length() > maxWidth)
        {
            // If there's already something on a potential previous line, add it
            // This scenario is unlikely with the "start with first word" rule
            // but good to be mindful of edge cases if logic changes.
            // For this problem, a single long word goes on its own line.
            resultLines.push_back(words[currentWordIndex]);
            currentWordIndex++;
            continue;
        }

        // Try to pack words into the current line
        while (currentWordIndex < words.size())
        {
            const std::string &word = words[currentWordIndex];
            int wordLen = word.length();
            int potentialWidth;

            if (wordsInLine == 0)
            { // First word on the line
                potentialWidth = wordLen;
            }
            else
            {                                                    // Subsequent words need a space prefix
                potentialWidth = currentLineWidth + 1 + wordLen; // +1 for the space
            }

            if (potentialWidth <= maxWidth)
            {
                if (wordsInLine > 0)
                {
                    currentLine += " ";
                    currentLineWidth += 1;
                }
                currentLine += word;
                currentLineWidth += wordLen;
                wordsInLine++;
                currentWordIndex++;
            }
            else
            {
                // Cannot fit the current word, so the line is complete
                break;
            }
        }

        if (!currentLine.empty())
        {
            resultLines.push_back(currentLine);
        }
    }
    return resultLines;
}

int main()
{
    std::vector<std::string> words1 = {"This", "is", "an", "example", "of", "text", "justification."};
    int maxWidth1 = 10;
    std::cout << "Input words: ";
    for (const auto &w : words1)
        std::cout << "\"" << w << "\" ";
    std::cout << "\nmaxWidth: " << maxWidth1 << std::endl;
    std::vector<std::string> output1 = formatText(words1, maxWidth1);
    std::cout << "Output:" << std::endl;
    for (const std::string &line : output1)
    {
        std::cout << line << std::endl;
    }
    /* Expected:
    This is an
    example of
    text
    justification.
    */
    // Note: The example output in the prompt was "this is an" (lowercase)
    // My code preserves original casing. If lowercase is required, words should be lowercased first.
    // The prompt example also shows "justification" instead of "justification.".
    // My code includes the period as it's part of the input word.

    std::cout << "\n--- Test Case 2 ---" << std::endl;
    std::vector<std::string> words2 = {"What", "must", "be", "acknowledgment", "shall", "be"};
    int maxWidth2 = 16;
    std::cout << "Input words: ";
    for (const auto &w : words2)
        std::cout << "\"" << w << "\" ";
    std::cout << "\nmaxWidth: " << maxWidth2 << std::endl;
    std::vector<std::string> output2 = formatText(words2, maxWidth2);
    std::cout << "Output:" << std::endl;
    for (const std::string &line : output2)
    {
        std::cout << line << std::endl;
    }
    /* Expected:
    What must be
    acknowledgment
    shall be
    */

    std::cout << "\n--- Test Case 3 (long word) ---" << std::endl;
    std::vector<std::string> words3 = {"A", "verylongwordthatiswaytoolong", "B"};
    int maxWidth3 = 10;
    std::cout << "Input words: ";
    for (const auto &w : words3)
        std::cout << "\"" << w << "\" ";
    std::cout << "\nmaxWidth: " << maxWidth3 << std::endl;
    std::vector<std::string> output3 = formatText(words3, maxWidth3);
    std::cout << "Output:" << std::endl;
    for (const std::string &line : output3)
    {
        std::cout << line << std::endl;
    }
    /* Expected:
    A
    verylongwordthatiswaytoolong
    B
    */

    std::cout << "\n--- Test Case 4 (empty words) ---" << std::endl;
    std::vector<std::string> words4 = {};
    int maxWidth4 = 10;
    std::vector<std::string> output4 = formatText(words4, maxWidth4);
    std::cout << "Output (should be empty):" << std::endl;
    for (const std::string &line : output4)
    {
        std::cout << line << std::endl;
    }
    std::cout << (output4.empty() ? "Correctly empty" : "Incorrect, not empty") << std::endl;

    std::cout << "\n--- Test Case 5 (words fit perfectly) ---" << std::endl;
    std::vector<std::string> words5 = {"Hello", "World"};
    int maxWidth5 = 11; // "Hello World" is 11 chars
    std::vector<std::string> output5 = formatText(words5, maxWidth5);
    std::cout << "Output:" << std::endl;
    for (const std::string &line : output5)
    {
        std::cout << line << std::endl;
    }
    /* Expected:
    Hello World
    */

    return 0;
}