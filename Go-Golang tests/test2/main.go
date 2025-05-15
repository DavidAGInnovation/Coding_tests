package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// --- 1. Contact Struct (not class, Go uses structs and methods) ---
type Contact struct {
	ID    int // Unique ID for easier updates/deletes
	Name  string
	Phone string
	Email string
}

// --- 2. ContactsManager Struct ---
type ContactsManager struct {
	contacts   []Contact
	nextID     int // To generate unique IDs
	inputReader *bufio.Reader
}

// NewContactsManager creates and returns a new ContactsManager
func NewContactsManager() *ContactsManager {
	return &ContactsManager{
		contacts:   make([]Contact, 0),
		nextID:     1,
		inputReader: bufio.NewReader(os.Stdin),
	}
}

// --- 3. Methods for ContactsManager ---

// AddContact adds a new contact to the manager
func (cm *ContactsManager) AddContact() {
	fmt.Println("\n--- Add New Contact ---")
	fmt.Print("Enter Name: ")
	name, _ := cm.inputReader.ReadString('\n')
	name = strings.TrimSpace(name)

	fmt.Print("Enter Phone Number: ")
	phone, _ := cm.inputReader.ReadString('\n')
	phone = strings.TrimSpace(phone)

	fmt.Print("Enter Email: ")
	email, _ := cm.inputReader.ReadString('\n')
	email = strings.TrimSpace(email)

	if name == "" || phone == "" || email == "" {
		fmt.Println("Name, Phone, and Email cannot be empty. Contact not added.")
		return
	}

	contact := Contact{
		ID:    cm.nextID,
		Name:  name,
		Phone: phone,
		Email: email,
	}
	cm.contacts = append(cm.contacts, contact)
	cm.nextID++
	fmt.Println("Contact added successfully!")
}

// ViewContacts displays all contacts
func (cm *ContactsManager) ViewContacts() {
	fmt.Println("\n--- Contact List ---")
	if len(cm.contacts) == 0 {
		fmt.Println("No contacts to display.")
		return
	}
	for _, contact := range cm.contacts {
		fmt.Printf("ID: %d, Name: %s, Phone: %s, Email: %s\n",
			contact.ID, contact.Name, contact.Phone, contact.Email)
	}
}

// findContactByID finds a contact by ID and returns its index and the contact
func (cm *ContactsManager) findContactByID(id int) (int, *Contact) {
	for i, contact := range cm.contacts {
		if contact.ID == id {
			return i, &cm.contacts[i] // Return pointer to allow modification
		}
	}
	return -1, nil
}

// UpdateContact updates an existing contact
func (cm *ContactsManager) UpdateContact() {
	fmt.Println("\n--- Update Contact ---")
	if len(cm.contacts) == 0 {
		fmt.Println("No contacts to update.")
		return
	}
	cm.ViewContacts() // Show contacts to help user choose
	fmt.Print("Enter ID of contact to update: ")
	idStr, _ := cm.inputReader.ReadString('\n')
	id, err := strconv.Atoi(strings.TrimSpace(idStr))
	if err != nil {
		fmt.Println("Invalid ID format.")
		return
	}

	_, contactToUpdate := cm.findContactByID(id) // Use _ for index
	if contactToUpdate == nil {
		fmt.Println("Contact not found.")
		return
	}

	fmt.Printf("Updating contact: %s (Leave blank to keep current value)\n", contactToUpdate.Name)

	fmt.Printf("Enter new Name (current: %s): ", contactToUpdate.Name)
	newName, _ := cm.inputReader.ReadString('\n')
	newName = strings.TrimSpace(newName)
	if newName != "" {
		contactToUpdate.Name = newName
	}

	fmt.Printf("Enter new Phone (current: %s): ", contactToUpdate.Phone)
	newPhone, _ := cm.inputReader.ReadString('\n')
	newPhone = strings.TrimSpace(newPhone)
	if newPhone != "" {
		contactToUpdate.Phone = newPhone
	}

	fmt.Printf("Enter new Email (current: %s): ", contactToUpdate.Email)
	newEmail, _ := cm.inputReader.ReadString('\n')
	newEmail = strings.TrimSpace(newEmail)
	if newEmail != "" {
		contactToUpdate.Email = newEmail
	}

	// No need to cm.contacts[index] = *contactToUpdate because contactToUpdate is a pointer
	fmt.Println("Contact updated successfully!")
}

// DeleteContact removes a contact
func (cm *ContactsManager) DeleteContact() {
	fmt.Println("\n--- Delete Contact ---")
	if len(cm.contacts) == 0 {
		fmt.Println("No contacts to delete.")
		return
	}
	cm.ViewContacts() // Show contacts to help user choose
	fmt.Print("Enter ID of contact to delete: ")
	idStr, _ := cm.inputReader.ReadString('\n')
	id, err := strconv.Atoi(strings.TrimSpace(idStr))
	if err != nil {
		fmt.Println("Invalid ID format.")
		return
	}

	index, contactToDelete := cm.findContactByID(id)
	if contactToDelete == nil {
		fmt.Println("Contact not found.")
		return
	}

	// Remove the contact by slicing
	cm.contacts = append(cm.contacts[:index], cm.contacts[index+1:]...)
	fmt.Println("Contact deleted successfully!")
}

func main() {
	manager := NewContactsManager()

	for {
		fmt.Println("\n===== Contacts Management System =====")
		fmt.Println("1. Add Contact")
		fmt.Println("2. View Contacts")
		fmt.Println("3. Update Contact")
		fmt.Println("4. Delete Contact")
		fmt.Println("5. Exit")
		fmt.Print("Choose an option: ")

		choiceStr, _ := manager.inputReader.ReadString('\n')
		choice, err := strconv.Atoi(strings.TrimSpace(choiceStr))

		if err != nil {
			fmt.Println("Invalid option. Please enter a number.")
			continue
		}

		switch choice {
		case 1:
			manager.AddContact()
		case 2:
			manager.ViewContacts()
		case 3:
			manager.UpdateContact()
		case 4:
			manager.DeleteContact()
		case 5:
			fmt.Println("Exiting program. Goodbye!")
			return
		default:
			fmt.Println("Invalid option. Please try again.")
		}
	}
}