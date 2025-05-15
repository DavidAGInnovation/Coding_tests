# R Test 2: Generating Pascal's Triangle

generatePascalsTriangle <- function(numRows) {
  if (!is.numeric(numRows) || numRows < 1 || floor(numRows) != numRows) {
    stop("Number of rows must be a positive integer.")
  }

  triangle <- list()

  for (i in 0:(numRows - 1)) {
    row <- numeric(i + 1) # Each row i has i+1 elements
    
    # First and last element of each row is 1
    row[1] <- 1
    if (i > 0) { # For rows after the first one
      row[i + 1] <- 1
    }
    
    # Calculate intermediate elements
    if (i >= 2) { # For rows with 3 or more elements (index 2 onwards)
      previousRow <- triangle[[i]] # Get the (i-1)th row (0-indexed list)
      for (j in 2:i) { # j goes from 2nd element to second-to-last
        row[j] <- previousRow[j - 1] + previousRow[j]
      }
    }
    triangle[[i + 1]] <- row # Add the current row to the list
  }
  return(triangle)
}

printPascalsTriangle <- function(triangle) {
  if (length(triangle) == 0) {
    print("Empty triangle.")
    return()
  }
  
  # Determine max width for pretty printing (optional, but nice)
  # Max number of digits in the largest number
  # This can be complex; for simplicity, we'll just space based on number of elements
  numRows <- length(triangle)
  maxWidthOfLastRow <- length(triangle[[numRows]])
  
  for (i in 1:numRows) {
    currentRow <- triangle[[i]]
    # Calculate leading spaces for centering
    # Each number takes up some space, plus spaces between them
    # This is a simple approximation for console alignment
    padding <- (maxWidthOfLastRow - length(currentRow)) * 2 # Adjust multiplier for better spacing
    cat(rep(" ", padding), sep = "")
    
    for (j in 1:length(currentRow)) {
      cat(sprintf("%-4s", currentRow[j])) # Print each number, left-aligned in 4 spaces
    }
    cat("\n")
  }
}

# --- Test the function ---
numRowsToGenerate <- 5
cat(paste("--- Pascal's Triangle for", numRowsToGenerate, "rows ---"), "\n")
pascalTriangle5 <- generatePascalsTriangle(numRowsToGenerate)
printPascalsTriangle(pascalTriangle5)
cat("\n")

numRowsToGenerate <- 7
cat(paste("--- Pascal's Triangle for", numRowsToGenerate, "rows ---"), "\n")
pascalTriangle7 <- generatePascalsTriangle(numRowsToGenerate)
printPascalsTriangle(pascalTriangle7)
cat("\n")

numRowsToGenerate <- 1
cat(paste("--- Pascal's Triangle for", numRowsToGenerate, "rows ---"), "\n")
pascalTriangle1 <- generatePascalsTriangle(numRowsToGenerate)
printPascalsTriangle(pascalTriangle1)
cat("\n")

# Test with invalid input
cat("--- Testing with invalid input (0 rows) ---", "\n")
tryCatch({
  generatePascalsTriangle(0)
}, error = function(e) {
  print(e)
})