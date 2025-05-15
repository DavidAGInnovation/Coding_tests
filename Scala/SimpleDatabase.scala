import scala.collection.mutable

class SimpleDatabase[V] {

  // Use a mutable Map to store key-value pairs
  // Keys are Strings, Values are of generic type V
  private val data: mutable.Map[String, V] = mutable.Map.empty

  /**
   * Stores a key-value pair in the database.
   * If the key already exists, its value will be updated.
   *
   * @param key   The key (String) to store.
   * @param value The value (of type V) to associate with the key.
   */
  def put(key: String, value: V): Unit = {
    data(key) = value // Or data.put(key, value)
    // println(s"Stored: $key -> $value") // Optional: confirmation message
  }

  /**
   * Retrieves the value associated with a given key.
   *
   * @param key The key (String) whose value is to be retrieved.
   * @return The value as a String if the key exists, or an error message String if not.
   */
  def get(key: String): String = {
    data.get(key) match {
      case Some(value) => value.toString // Convert value to String for unified return type
      case None        => s"Error: Key '$key' not found."
    }
  }

  /**
   * Deletes a key-value pair from the database by its key.
   * Prints a message indicating whether the deletion was successful or if the key was not found.
   *
   * @param key The key (String) of the pair to delete.
   */
  def delete(key: String): Unit = {
    data.remove(key) match {
      case Some(removedValue) => println(s"Key '$key' (value: $removedValue) deleted successfully.")
      case None               => println(s"Error: Key '$key' not found for deletion.")
    }
  }

  /**
   * Displays all key-value pairs currently stored in the database.
   * If the database is empty, it prints an appropriate message.
   */
  def display(): Unit = {
    if (data.isEmpty) {
      println("Database is empty.")
    } else {
      println("Current Database Contents:")
      data.foreach { case (key, value) =>
        println(s"$key -> $value")
      }
    }
  }
}

// Example Usage:
object SimpleDatabaseApp {
  def main(args: Array[String]): Unit = {
    println("--- Test with String values ---")
    val dbString = new SimpleDatabase[String]()

    dbString.put("name", "John Doe")
    dbString.put("city", "New York")
    dbString.put("age", "30") // Example from prompt used String for age

    println(s"Get 'name': ${dbString.get("name")}")   // Output: John Doe
    println(s"Get 'country': ${dbString.get("country")}") // Output: Error: Key 'country' not found.

    dbString.display()
    // Expected output:
    // name -> John Doe
    // city -> New York
    // age -> 30 (or similar, order in Map is not guaranteed for mutable.Map by default)

    println("\nDeleting 'age'...")
    dbString.delete("age") // Output: Key 'age' (value: 30) deleted successfully.
    println("Deleting 'country' (non-existent)...")
    dbString.delete("country") // Output: Error: Key 'country' not found for deletion.

    println("\nDatabase after deletions:")
    dbString.display() // Expected: name -> John Doe, city -> New York

    println("\n--- Test with Int values ---")
    val dbInt = new SimpleDatabase[Int]()
    dbInt.put("apples", 5)
    dbInt.put("oranges", 10)
    dbInt.put("apples", 7) // Update value for "apples"

    println(s"Get 'apples': ${dbInt.get("apples")}") // Output: 7
    println(s"Get 'bananas': ${dbInt.get("bananas")}") // Output: Error: Key 'bananas' not found.

    dbInt.display()

    println("\nDeleting 'oranges'...")
    dbInt.delete("oranges")

    println("\nDatabase after deleting 'oranges':")
    dbInt.display()

    println("\n--- Test with an empty database ---")
    val dbEmpty = new SimpleDatabase[Double]()
    dbEmpty.display() // Output: Database is empty.
    println(s"Get 'anything': ${dbEmpty.get("anything")}")
    dbEmpty.delete("anything")

  }
}