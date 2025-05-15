package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"math/rand"
	"os"
	"strconv"
	"strings"
	"time"
)

// Struct to hold the data from JSON
type WordLists struct {
	Nouns      []string  `json:"Nouns"`
	Numbers    []float64 `json:"Numbers"` // JSON numbers can be float or int, float64 is safer
	Adjectives []string  `json:"Adjectives"`
}

// getRandomIndex returns a random index from a slice of any type
func getRandomIndex(sliceLength int) int {
	if sliceLength <= 0 {
		return -1 // Or handle error appropriately
	}
	return rand.Intn(sliceLength)
}

func main() {
	// Seed the random number generator
	rand.Seed(time.Now().UnixNano())

	// --- 1. Read JSON file ---
	jsonFile, err := os.Open("words.json")
	if err != nil {
		fmt.Println("Error opening words.json:", err)
		return
	}
	defer jsonFile.Close()

	byteValue, err := ioutil.ReadAll(jsonFile)
	if err != nil {
		fmt.Println("Error reading words.json:", err)
		return
	}

	var lists WordLists
	err = json.Unmarshal(byteValue, &lists)
	if err != nil {
		fmt.Println("Error unmarshalling JSON:", err)
		return
	}

	// --- 2. Create specific lists (already done by unmarshalling into WordLists struct) ---
	nouns := lists.Nouns
	adjectives := lists.Adjectives
	numbers := lists.Numbers // This is []float64

	if len(nouns) == 0 || len(adjectives) == 0 || len(numbers) == 0 {
		fmt.Println("One or more word lists are empty. Please check words.json.")
		return
	}

	// --- 3. Read madlib.txt ---
	madlibBytes, err := ioutil.ReadFile("madlib.txt")
	if err != nil {
		fmt.Println("Error reading madlib.txt:", err)
		return
	}
	madlibTemplate := string(madlibBytes)

	// --- 4. Replace placeholders ---
	// We need to loop because placeholders might be used multiple times
	// and we want a *different* random word each time (mostly).
	// A simpler strings.NewReplacer would use the same random word for all occurrences of e.g. "(noun)".
	// So, we'll replace them one by one in a loop or use a more complex regex approach.
	// For simplicity, let's replace iteratively as long as placeholders exist.

	result := madlibTemplate

	// Replace nouns
	for strings.Contains(result, "(noun)") {
		randomIndex := getRandomIndex(len(nouns))
		randomNoun := nouns[randomIndex]
		result = strings.Replace(result, "(noun)", randomNoun, 1) // Replace only the first occurrence
	}

	// Replace adjectives
	for strings.Contains(result, "(adjective)") {
		randomIndex := getRandomIndex(len(adjectives))
		randomAdjective := adjectives[randomIndex]
		result = strings.Replace(result, "(adjective)", randomAdjective, 1)
	}

	// Replace numbers
	for strings.Contains(result, "(number)") {
		randomIndex := getRandomIndex(len(numbers))
		randomNumber := numbers[randomIndex]
		// Convert float64 to string. You might want to format it (e.g., remove trailing .0)
		// strconv.FormatFloat(randomNumber, 'f', -1, 64) is flexible
		// For simplicity, fmt.Sprintf might be okay or a custom logic
		var numStr string
		if randomNumber == float64(int(randomNumber)) { // Check if it's a whole number
			numStr = strconv.Itoa(int(randomNumber))
		} else {
			numStr = strconv.FormatFloat(randomNumber, 'f', 2, 64) // Format to 2 decimal places
		}
		result = strings.Replace(result, "(number)", numStr, 1)
	}

	// --- 5. Output the Madlib ---
	fmt.Println("\n--- Your Mad Lib ---")
	fmt.Println(result)
}