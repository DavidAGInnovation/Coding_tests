import 'dart:io';

// Class to represent a Task
class Task {
  String description;
  String status; // "Pending" or "Completed"

  Task(this.description, {this.status = "Pending"});

  @override
  String toString() {
    return "[${status == 'Completed' ? 'X' : ' '}] $description";
  }
}

void main() {
  List<Task> tasks = [];
  bool running = true;

  print("Welcome to the To-Do List Manager!");

  while (running) {
    print("\nChoose an operation:");
    print("1. Add Task");
    print("2. Remove Task");
    print("3. View All Tasks");
    print("4. Mark Task as Completed");
    print("5. Exit");
    stdout.write("Enter your choice (1-5): ");

    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        addTask(tasks);
        break;
      case '2':
        removeTask(tasks);
        break;
      case '3':
        viewTasks(tasks);
        break;
      case '4':
        markTaskCompleted(tasks);
        break;
      case '5':
        running = false;
        print("Exiting To-Do List Manager. Goodbye!");
        break;
      default:
        print("Invalid choice. Please enter a number between 1 and 5.");
    }
  }
}

void addTask(List<Task> tasks) {
  stdout.write("Enter task description: ");
  String? description = stdin.readLineSync();
  if (description != null && description.trim().isNotEmpty) {
    tasks.add(Task(description.trim()));
    print("Task added: '${description.trim()}'");
  } else {
    print("Task description cannot be empty.");
  }
}

void viewTasks(List<Task> tasks) {
  if (tasks.isEmpty) {
    print("\nYour to-do list is empty.");
    return;
  }
  print("\n--- Your To-Do List ---");
  for (int i = 0; i < tasks.length; i++) {
    print("${i + 1}. ${tasks[i]}");
  }
  print("-----------------------");
}

void removeTask(List<Task> tasks) {
  if (tasks.isEmpty) {
    print("No tasks to remove. The list is empty.");
    return;
  }
  viewTasks(tasks); // Show tasks so user can pick a number
  stdout.write("Enter the number of the task to remove: ");
  String? taskNumberStr = stdin.readLineSync();

  if (taskNumberStr != null) {
    int? taskNumber = int.tryParse(taskNumberStr);
    if (taskNumber != null && taskNumber > 0 && taskNumber <= tasks.length) {
      Task removedTask = tasks.removeAt(taskNumber - 1); // Adjust for 0-based index
      print("Task removed: '${removedTask.description}'");
    } else {
      print("Invalid task number. Please enter a valid number from the list.");
    }
  } else {
    print("No input provided for task number.");
  }
}

void markTaskCompleted(List<Task> tasks) {
  if (tasks.isEmpty) {
    print("No tasks to mark. The list is empty.");
    return;
  }
  viewTasks(tasks); // Show tasks so user can pick a number
  stdout.write("Enter the number of the task to mark as completed: ");
  String? taskNumberStr = stdin.readLineSync();

  if (taskNumberStr != null) {
    int? taskNumber = int.tryParse(taskNumberStr);
    if (taskNumber != null && taskNumber > 0 && taskNumber <= tasks.length) {
      if (tasks[taskNumber - 1].status == "Completed") {
        print("Task '${tasks[taskNumber - 1].description}' is already marked as completed.");
      } else {
        tasks[taskNumber - 1].status = "Completed";
        print("Task marked as completed: '${tasks[taskNumber - 1].description}'");
      }
    } else {
      print("Invalid task number. Please enter a valid number from the list.");
    }
  } else {
    print("No input provided for task number.");
  }
}