import SwiftUI

struct TaskDetailScreen: View {
    @State var task: TaskItem // Using @State to hold and potentially modify a copy
    @ObservedObject var taskManager: TaskManager
    @Environment(\.presentationMode) var presentationMode

    @State private var isEditing = false
    @State private var editableTitle: String
    @State private var editableDescription: String
    @State private var editableDueDate: Date

    init(task: TaskItem, taskManager: TaskManager) {
        _task = State(initialValue: task) // Initialize @State property correctly
        self.taskManager = taskManager
        // Initialize editable states with the initial task values
        _editableTitle = State(initialValue: task.title)
        _editableDescription = State(initialValue: task.description)
        _editableDueDate = State(initialValue: task.dueDate)
    }

    var body: some View {
        Form {
            if isEditing {
                Section(header: Text("Edit Task Details")) {
                    TextField("Title", text: $editableTitle)
                    TextField("Description", text: $editableDescription, axis: .vertical)
                        .lineLimit(5...)
                    DatePicker("Due Date", selection: $editableDueDate, displayedComponents: .date)
                }
                // The "Mark as Complete/Incomplete" button could also be in this section
                // or kept as a general action button below.
            } else {
                Section(header: Text("Task Details")) {
                    Text(task.title)
                        .font(.title2)
                    Text(task.description.isEmpty ? "No description." : task.description)
                        .foregroundColor(task.description.isEmpty ? .gray : .primary)
                    HStack {
                        Text("Due Date:")
                        Text(task.dueDate, style: .date)
                    }
                    HStack {
                        Text("Status:")
                        Text(task.isCompleted ? "Completed" : "Pending")
                            .foregroundColor(task.isCompleted ? .green : .orange)
                    }
                }
            }

            // Actions available in both view and edit mode
            Section {
                Button(task.isCompleted ? "Mark as Incomplete" : "Mark as Complete") {
                    taskManager.toggleCompletion(for: task)
                    // Update local task state to reflect change immediately in this view
                    // This ensures the button label and status text update
                    if let updatedTask = taskManager.tasks.first(where: { $0.id == task.id }) {
                        self.task = updatedTask // This updates the @State var task
                        // If editing, also update editable states if needed, though save handles it
                        if isEditing {
                            // editableTitle = updatedTask.title // Not usually changed by completion
                        }
                    }
                }
                if !isEditing { // Show delete button only in view mode for clarity
                    Button("Delete Task", role: .destructive) {
                        taskManager.deleteTask(task: task)
                        presentationMode.wrappedValue.dismiss() // Go back after delete
                    }
                }
            }
        }
        .navigationTitle(isEditing ? "Edit Task" : task.title) // Use task title in view mode
        .toolbar {
            ToolbarItem(placement: .confirmationAction) { // More idiomatic for "Save"/"Edit"
                Button(isEditing ? "Save" : "Edit") {
                    if isEditing {
                        // Save changes to the TaskManager
                        if let index = taskManager.tasks.firstIndex(where: { $0.id == task.id }) {
                            taskManager.tasks[index].title = editableTitle
                            taskManager.tasks[index].description = editableDescription
                            taskManager.tasks[index].dueDate = editableDueDate
                            // Update local task to reflect saved changes
                            self.task = taskManager.tasks[index]
                        }
                    } else {
                        // Before entering edit mode, ensure editable fields match current task state
                        editableTitle = task.title
                        editableDescription = task.description
                        editableDueDate = task.dueDate
                    }
                    isEditing.toggle()
                }
            }
        }
    }
}

struct TaskDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TaskDetailScreen(
                task: TaskItem(title: "Sample Task Preview", description: "This is a sample description for preview.", dueDate: Date()),
                taskManager: TaskManager()
            )
        }
    }
}