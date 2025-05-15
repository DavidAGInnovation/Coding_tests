import SwiftUI

struct ContentView: View {
    @ObservedObject var taskManager = TaskManager()
    @State private var showingAddTaskScreen = false
    // No @State private var editMode needed for this approach on macOS

    var body: some View {
        NavigationView {
            List { // On macOS, selection is often the precursor to deletion
                ForEach(taskManager.tasks) { task in
                    NavigationLink(destination: TaskDetailScreen(task: task, taskManager: taskManager)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(task.title)
                                    .font(.headline)
                                    .strikethrough(task.isCompleted, color: .gray)
                                Text("Due: \(task.dueDate, style: .date)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if task.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                    }
                }
                .onDelete(perform: taskManager.deleteTask) // This enables deletion.
                                                            // On macOS, users can select a row
                                                            // and press the Delete key.
            }
            .navigationTitle("To-Do List")
            .toolbar {
                // No explicit "Edit" button needed for basic .onDelete on macOS
                // If you wanted an explicit "Remove Selected" button, you'd manage selection state.

                ToolbarItem(placement: .primaryAction) { // Or other appropriate macOS placement
                    Button {
                        showingAddTaskScreen = true
                    } label: {
                        Label("Add Task", systemImage: "plus.circle.fill")
                    }
                }
            }
            // .environment(\.editMode, $editMode) // REMOVE THIS LINE
            .sheet(isPresented: $showingAddTaskScreen) {
                AddTaskScreen(taskManager: taskManager)
            }
        }
        // For macOS, you might want to set a default frame size for the window
        // .frame(minWidth: 480, minHeight: 300, idealWidth: 600, idealHeight: 400) // Example
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}