#include <iostream>
#include <vector>

// Function to print a matrix
void printMatrix(const std::vector<std::vector<int>> &matrix, const std::string &label)
{
    std::cout << label << std::endl;
    if (matrix.empty())
    {
        std::cout << "(empty matrix)" << std::endl;
        return;
    }
    for (const auto &row : matrix)
    {
        for (size_t j = 0; j < row.size(); ++j)
        {
            std::cout << row[j] << (j == row.size() - 1 ? "" : " ");
        }
        std::cout << std::endl;
    }
}

// Function to transpose a matrix
std::vector<std::vector<int>> transposeMatrix(const std::vector<std::vector<int>> &matrix)
{
    if (matrix.empty() || matrix[0].empty())
    {
        return {}; // Return empty vector for an empty input matrix
    }

    int originalRows = matrix.size();
    int originalCols = matrix[0].size();

    // The transposed matrix will have originalCols rows and originalRows columns
    std::vector<std::vector<int>> transposed(originalCols, std::vector<int>(originalRows));

    for (int i = 0; i < originalRows; ++i)
    {
        for (int j = 0; j < originalCols; ++j)
        {
            transposed[j][i] = matrix[i][j];
        }
    }
    return transposed;
}

int main()
{
    int rows, cols;

    // Read matrix dimensions
    std::cout << "Enter number of rows: ";
    std::cin >> rows;
    std::cout << "Enter number of columns: ";
    std::cin >> cols;

    if (rows <= 0 || cols <= 0)
    {
        std::cerr << "Error: Rows and columns must be positive integers." << std::endl;
        return 1;
    }

    std::vector<std::vector<int>> originalMatrix(rows, std::vector<int>(cols));

    // Read matrix elements
    std::cout << "Enter the elements of the matrix (" << rows << "x" << cols << "):" << std::endl;
    for (int i = 0; i < rows; ++i)
    {
        std::cout << "Row " << i + 1 << ": ";
        for (int j = 0; j < cols; ++j)
        {
            if (!(std::cin >> originalMatrix[i][j]))
            {
                std::cerr << "Invalid input. Please enter integers only." << std::endl;
                return 1; // Exit on bad input
            }
        }
    }

    // Print original matrix
    printMatrix(originalMatrix, "\nOriginal matrix:");

    // Transpose the matrix
    std::vector<std::vector<int>> transposedMatrix = transposeMatrix(originalMatrix);

    // Print transposed matrix
    printMatrix(transposedMatrix, "\nTransposed matrix:");

    return 0;
}