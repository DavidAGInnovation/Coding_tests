import Foundation

struct TaskItem: Identifiable, Codable { // Codable for persistence (optional for this test)
    var id = UUID()
    var title: String
    var description: String
    var dueDate: Date
    var isCompleted: Bool = false
}