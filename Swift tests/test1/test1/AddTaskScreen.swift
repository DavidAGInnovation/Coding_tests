import SwiftUI

struct AddTaskScreen: View {
    @ObservedObject var taskManager: TaskManager
    @Environment(\.presentationMode) var presentationMode // To dismiss the sheet

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = Date() // Defaults to today

    var body: some View {
        NavigationView { // NavigationView is good practice for sheets that have their own toolbar
            Form {
                TextField("Task Title", text: $title)
                TextField("Description (Optional)", text: $description, axis: .vertical)
                    .lineLimit(5...) // Allow multiple lines for description
                DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)

                Button("Save Task") {
                    if !title.isEmpty {
                        taskManager.addTask(title: title, description: description, dueDate: dueDate)
                        presentationMode.wrappedValue.dismiss() // Dismiss the sheet
                    } else {
                        // Optionally show an alert if title is empty
                        // For simplicity, this example relies on the button's disabled state
                        print("Title cannot be empty - button should be disabled.")
                    }
                }
                .disabled(title.isEmpty) // Disable button if title is empty
            }
            .navigationTitle("Add New Task")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { // More idiomatic for "Cancel"
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                // No explicit "Save" button in toolbar here, main button is in the Form.
                // If you wanted a toolbar save, it would be .confirmationAction
            }
        }
    }
}

struct AddTaskScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskScreen(taskManager: TaskManager()) // Provide a dummy TaskManager for preview
    }
}