import Foundation
import Combine // For ObservableObject

class TaskManager: ObservableObject {
    @Published var tasks: [TaskItem] = [] {
        didSet {
            saveTasks() // Optional: for persistence
        }
    }

    init() {
        loadTasks() // Optional: for persistence
    }

    func addTask(title: String, description: String, dueDate: Date) {
        let newTask = TaskItem(title: title, description: description, dueDate: dueDate)
        tasks.append(newTask)
    }

    func toggleCompletion(for task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    func deleteTask(task: TaskItem) {
        tasks.removeAll { $0.id == task.id }
    }
    
    // --- Optional: Persistence with UserDefaults (simple example) ---
    private func tasksFileURL() -> URL? {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls.first?.appendingPathComponent("tasks.json")
    }

    private func saveTasks() {
        guard let url = tasksFileURL() else { return }
        do {
            let data = try JSONEncoder().encode(tasks)
            try data.write(to: url)
        } catch {
            print("Error saving tasks: \(error.localizedDescription)")
        }
    }

    private func loadTasks() {
        guard let url = tasksFileURL(), let data = try? Data(contentsOf: url) else { return }
        do {
            tasks = try JSONDecoder().decode([TaskItem].self, from: data)
        } catch {
            print("Error loading tasks: \(error.localizedDescription)")
        }
    }
}