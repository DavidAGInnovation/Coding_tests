import Foundation // For String trimming, etc.

// 1. Contact Class
class Contact {
    // Using static var for class-level unique ID generation
    private static var nextId = 1
    
    let id: Int
    var name: String
    var phoneNumber: String
    var email: String

    init(name: String, phoneNumber: String, email: String) {
        self.id = Contact.nextId
        Contact.nextId += 1
        self.name = name
        self.phoneNumber = phoneNumber
        self.email = email
    }

    func display() {
        print("ID: \(id), Name: \(name), Phone: \(phoneNumber), Email: \(email)")
    }
}

// 2. ContactsManager Class
class ContactsManager {
    private var contacts: [Contact] = []

    // 3. Methods for ContactsManager
    func addContact() {
        print("\n--- Add New Contact ---")
        print("Enter Name: ", terminator: "")
        guard let name = readLine(), !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Name cannot be empty. Contact not added.")
            return
        }

        print("Enter Phone Number: ", terminator: "")
        guard let phone = readLine(), !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Phone number cannot be empty. Contact not added.")
            return
        }

        print("Enter Email: ", terminator: "")
        guard let email = readLine(), !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("Email cannot be empty. Contact not added.")
            return
        }

        let newContact = Contact(name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                                 phoneNumber: phone.trimmingCharacters(in: .whitespacesAndNewlines),
                                 email: email.trimmingCharacters(in: .whitespacesAndNewlines))
        contacts.append(newContact)
        print("Contact added successfully!")
    }

    func viewContacts() {
        print("\n--- Contact List ---")
        if contacts.isEmpty {
            print("No contacts to display.")
            return
        }
        for contact in contacts {
            contact.display()
        }
    }

    private func findContactIndexById(id: Int) -> Int? {
        return contacts.firstIndex { $0.id == id }
    }

    func updateContact() {
        print("\n--- Update Contact ---")
        if contacts.isEmpty {
            print("No contacts to update.")
            return
        }
        viewContacts() // Show contacts to help user choose
        print("Enter ID of contact to update: ", terminator: "")
        guard let idStr = readLine(), let id = Int(idStr.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            print("Invalid ID format.")
            return
        }

        guard let index = findContactIndexById(id: id) else {
            print("Contact not found with ID \(id).")
            return
        }
        
        let contactToUpdate = contacts[index]
        print("Updating contact: \(contactToUpdate.name) (Press Enter to keep current value)")

        print("Enter new Name (current: \(contactToUpdate.name)): ", terminator: "")
        if let newName = readLine(), !newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contactToUpdate.name = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        print("Enter new Phone Number (current: \(contactToUpdate.phoneNumber)): ", terminator: "")
        if let newPhone = readLine(), !newPhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contactToUpdate.phoneNumber = newPhone.trimmingCharacters(in: .whitespacesAndNewlines)
        }

        print("Enter new Email (current: \(contactToUpdate.email)): ", terminator: "")
        if let newEmail = readLine(), !newEmail.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contactToUpdate.email = newEmail.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        print("Contact updated successfully!")
    }

    func deleteContact() {
        print("\n--- Delete Contact ---")
        if contacts.isEmpty {
            print("No contacts to delete.")
            return
        }
        viewContacts() // Show contacts to help user choose
        print("Enter ID of contact to delete: ", terminator: "")
        guard let idStr = readLine(), let id = Int(idStr.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            print("Invalid ID format.")
            return
        }

        guard let index = findContactIndexById(id: id) else {
            print("Contact not found with ID \(id).")
            return
        }
        
        contacts.remove(at: index)
        print("Contact deleted successfully!")
    }
}

// 4. Console-based User Interface
func mainLoop() {
    let manager = ContactsManager()
    var running = true

    while running {
        print("\n===== Contacts Management System (Swift) =====")
        print("1. Add Contact")
        print("2. View Contacts")
        print("3. Update Contact")
        print("4. Delete Contact")
        print("5. Exit")
        print("Choose an option: ", terminator: "")

        if let choiceStr = readLine(), let choice = Int(choiceStr.trimmingCharacters(in: .whitespacesAndNewlines)) {
            switch choice {
            case 1:
                manager.addContact()
            case 2:
                manager.viewContacts()
            case 3:
                manager.updateContact()
            case 4:
                manager.deleteContact()
            case 5:
                running = false
                print("Exiting program. Goodbye!")
            default:
                print("Invalid option. Please try again.")
            }
        } else {
            print("Invalid input. Please enter a number.")
        }
    }
}

// Start the application
mainLoop()
