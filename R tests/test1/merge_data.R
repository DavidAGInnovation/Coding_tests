# R Test 1: Merging Login Data

# --- Create the first set of data (as a data frame) ---
userData <- data.frame(
  ID = as.character(c("1", "2", "3", "4")), # Keep ID as character for merging
  Name = c("Alice", "Bob", "Charlie", "David"),
  VerificationStatus = c(TRUE, FALSE, TRUE, FALSE),
  stringsAsFactors = FALSE # Good practice
)

print("--- User Data (Set 1) ---")
print(userData)
cat("\n")

# --- Create the second set of data (as a matrix, then convert to data frame) ---
# Matrix form: ID, Password
passwordDataMatrix <- matrix(
  c("1", "09122018",
    "2", "18122022",
    "3", "01012023",
    "5", "15072024"), # ID 5 has a password but no user data yet
  ncol = 2,
  byrow = TRUE
)

# Convert matrix to data frame and name columns
passwordData <- as.data.frame(passwordDataMatrix, stringsAsFactors = FALSE)
colnames(passwordData) <- c("ID", "Password")

print("--- Password Data (Set 2) ---")
print(passwordData)
cat("\n")

# --- Merge the two sets of data ---
# We want to merge based on the 'ID' column.
# We'll use a left merge by default from userData if we want to keep all users
# and add passwords if they exist.
# Or an inner merge if we only want users present in both.
# The problem implies we want all user info combined, so let's consider
# how to handle users in one but not the other.

# Option 1: Inner Join (only users present in both userData and passwordData)
# mergedDataInner <- merge(userData, passwordData, by = "ID")
# print("--- Merged Data (Inner Join) ---")
# print(mergedDataInner)
# cat("\n")

# Option 2: Left Join (keep all users from userData, add passwords if available)
# This seems more aligned with "keeping the verification status information as well"
# for all users initially described.
mergedDataLeft <- merge(userData, passwordData, by = "ID", all.x = TRUE)
# all.x = TRUE means all rows from x (userData) are kept.
# If an ID from userData is not in passwordData, Password will be NA.

print("--- Merged Data (Left Join: All users from Set 1, with passwords if available) ---")
print(mergedDataLeft)
cat("\n")

# Option 3: Full Outer Join (keep all users and all passwords, match where possible)
# This would show ID 5 from passwordData as well.
mergedDataFull <- merge(userData, passwordData, by = "ID", all = TRUE)
# all = TRUE means all rows from both x and y are kept.

print("--- Merged Data (Full Outer Join: All users and all passwords) ---")
print(mergedDataFull)
cat("\n")

# The prompt "merge these two sets of data so that each person's ID, name,
# and password are in one table, keeping the verification status information as well"
# suggests that we want to see the user information (Name, VerificationStatus)
# alongside their password if it exists. A full outer join seems most comprehensive
# for showing all available pieces of information combined.

# Let's assume the most comprehensive view (Full Outer Join) is desired.
# If the requirement was strictly "for each *person's* ID" from the first set,
# then a left join (mergedDataLeft) would be more appropriate.
# Given the example of ID "5" having a password but no initial user data,
# a full join shows this information.

# Final chosen output based on comprehensive data view:
print("--- Final Merged Table (Comprehensive View - Full Outer Join) ---")
print(mergedDataFull)

# If we want to only include entries for which we have a name:
# mergedDataForKnownUsers <- merge(userData, passwordData, by = "ID", all.x = TRUE)
# print("--- Merged Table (For known users from Set 1 - Left Join) ---")
# print(mergedDataForKnownUsers)

print("--- Primary Answer: Merged Data for existing persons (Left Join) ---")
print(mergedDataLeft)