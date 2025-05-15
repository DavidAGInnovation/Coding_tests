using System;
using System.Collections.Generic;
using System.Linq; // For FirstOrDefault

// 1. Contact Class
public class Contact
{
    public int Id { get; set; } // Unique ID for easier updates/deletes
    public string Name { get; set; }
    public string PhoneNumber { get; set; }
    public string Email { get; set; }

    public Contact(int id, string name, string phoneNumber, string email)
    {
        Id = id;
        Name = name;
        PhoneNumber = phoneNumber;
        Email = email;
    }

    public override string ToString()
    {
        return $"ID: {Id}, Name: {Name}, Phone: {PhoneNumber}, Email: {Email}";
    }
}

// 2. ContactsManager Class
public class ContactsManager
{
    private List<Contact> contacts;
    private int nextId = 1; // To generate unique IDs

    public ContactsManager()
    {
        contacts = new List<Contact>();
    }

    // 3. Methods for ContactsManager

    public void AddContact()
    {
        Console.WriteLine("\n--- Add New Contact ---");
        Console.Write("Enter Name: ");
        string name = Console.ReadLine() ?? ""; // Handle possible null

        Console.Write("Enter Phone Number: ");
        string phone = Console.ReadLine() ?? "";

        Console.Write("Enter Email: ");
        string email = Console.ReadLine() ?? "";

        if (string.IsNullOrWhiteSpace(name) || string.IsNullOrWhiteSpace(phone) || string.IsNullOrWhiteSpace(email))
        {
            Console.WriteLine("Name, Phone, and Email cannot be empty. Contact not added.");
            return;
        }

        Contact newContact = new Contact(nextId, name, phone, email);
        contacts.Add(newContact);
        nextId++;
        Console.WriteLine("Contact added successfully!");
    }

    public void ViewContacts()
    {
        Console.WriteLine("\n--- Contact List ---");
        if (!contacts.Any()) // Or contacts.Count == 0
        {
            Console.WriteLine("No contacts to display.");
            return;
        }
        foreach (var contact in contacts)
        {
            Console.WriteLine(contact.ToString());
        }
    }

    private Contact? FindContactById(int id)
    {
        return contacts.FirstOrDefault(c => c.Id == id);
    }

    public void UpdateContact()
    {
        Console.WriteLine("\n--- Update Contact ---");
        if (!contacts.Any())
        {
            Console.WriteLine("No contacts to update.");
            return;
        }

        ViewContacts(); // Show contacts to help user choose
        Console.Write("Enter ID of contact to update: ");
        string? idStr = Console.ReadLine();
        if (int.TryParse(idStr, out int id))
        {
            Contact? contactToUpdate = FindContactById(id);
            if (contactToUpdate != null)
            {
                Console.WriteLine($"Updating contact: {contactToUpdate.Name} (Leave blank to keep current value)");

                Console.Write($"Enter new Name (current: {contactToUpdate.Name}): ");
                string? newName = Console.ReadLine();
                if (!string.IsNullOrWhiteSpace(newName))
                {
                    contactToUpdate.Name = newName;
                }

                Console.Write($"Enter new Phone Number (current: {contactToUpdate.PhoneNumber}): ");
                string? newPhone = Console.ReadLine();
                if (!string.IsNullOrWhiteSpace(newPhone))
                {
                    contactToUpdate.PhoneNumber = newPhone;
                }

                Console.Write($"Enter new Email (current: {contactToUpdate.Email}): ");
                string? newEmail = Console.ReadLine();
                if (!string.IsNullOrWhiteSpace(newEmail))
                {
                    contactToUpdate.Email = newEmail;
                }
                Console.WriteLine("Contact updated successfully!");
            }
            else
            {
                Console.WriteLine("Contact not found with that ID.");
            }
        }
        else
        {
            Console.WriteLine("Invalid ID format.");
        }
    }

    public void DeleteContact()
    {
        Console.WriteLine("\n--- Delete Contact ---");
        if (!contacts.Any())
        {
            Console.WriteLine("No contacts to delete.");
            return;
        }
        ViewContacts(); // Show contacts to help user choose
        Console.Write("Enter ID of contact to delete: ");
        string? idStr = Console.ReadLine();
        if (int.TryParse(idStr, out int id))
        {
            Contact? contactToDelete = FindContactById(id);
            if (contactToDelete != null)
            {
                contacts.Remove(contactToDelete);
                Console.WriteLine("Contact deleted successfully!");
            }
            else
            {
                Console.WriteLine("Contact not found with that ID.");
            }
        }
        else
        {
            Console.WriteLine("Invalid ID format.");
        }
    }
}

// 4. Console-based User Interface
public class Program
{
    public static void Main(string[] args)
    {
        ContactsManager manager = new ContactsManager();
        bool running = true;

        while (running)
        {
            Console.WriteLine("\n===== Contacts Management System (C#) =====");
            Console.WriteLine("1. Add Contact");
            Console.WriteLine("2. View Contacts");
            Console.WriteLine("3. Update Contact");
            Console.WriteLine("4. Delete Contact");
            Console.WriteLine("5. Exit");
            Console.Write("Choose an option: ");

            string? choice = Console.ReadLine();

            switch (choice)
            {
                case "1":
                    manager.AddContact();
                    break;
                case "2":
                    manager.ViewContacts();
                    break;
                case "3":
                    manager.UpdateContact();
                    break;
                case "4":
                    manager.DeleteContact();
                    break;
                case "5":
                    running = false;
                    Console.WriteLine("Exiting program. Goodbye!");
                    break;
                default:
                    Console.WriteLine("Invalid option. Please try again.");
                    break;
            }
        }
    }
}