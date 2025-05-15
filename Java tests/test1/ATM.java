// ATM.java
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

public class ATM {
    private final Map<String, Account> accounts;

    public ATM() {
        this.accounts = new HashMap<>();
        addSampleAccounts();
    }

    private void addSampleAccounts() {
        accounts.put("12345", new Account("12345", "Alice Smith", 1000.00));
        accounts.put("67890", new Account("67890", "Bob Johnson", 500.00));
    }

    public void createAccount(Scanner scanner) {
        System.out.println("\n--- Create New Account ---");
        System.out.print("Enter new account number: ");
        String accNum = scanner.nextLine();
        if (accounts.containsKey(accNum)) {
            System.out.println("Account number already exists. Please try a different one.");
            return;
        }
        System.out.print("Enter account holder name: ");
        String holderName = scanner.nextLine();
        double initialDeposit = 0;
        boolean validInput = false;
        while(!validInput) {
            System.out.print("Enter initial deposit amount (e.g., 50.00): $");
            if (scanner.hasNextDouble()) {
                initialDeposit = scanner.nextDouble();
                if (initialDeposit >= 0) {
                    validInput = true;
                } else {
                    System.out.println("Initial deposit cannot be negative.");
                }
            } else {
                System.out.println("Invalid input. Please enter a number.");
            }
            scanner.nextLine(); // consume newline
        }


        Account newAccount = new Account(accNum, holderName, initialDeposit);
        accounts.put(accNum, newAccount);
        System.out.println("Account created successfully for " + holderName + " with account number " + accNum);
    }


    public Account login(Scanner scanner) {
        System.out.print("Enter your account number: ");
        String accNum = scanner.nextLine();
        if (accounts.containsKey(accNum)) {
            System.out.println("Login successful. Welcome, " + accounts.get(accNum).getAccountHolderName() + "!");
            return accounts.get(accNum);
        } else {
            System.out.println("Account not found. Please check the account number or create a new account.");
            return null;
        }
    }

    public void start() {
        try (Scanner scanner = new Scanner(System.in)) {
            boolean running = true;
            while (running) {
                System.out.println("\n===== ATM Menu =====");
                System.out.println("1. Login to Existing Account");
                System.out.println("2. Create New Account");
                System.out.println("3. Exit");
                System.out.print("Choose an option: ");

                String choice = scanner.nextLine();

                switch (choice) {
                    case "1" -> {
                        Account currentAccount = login(scanner);
                        if (currentAccount != null) {
                            performTransactions(currentAccount, scanner);
                        }
                    }
                    case "2" -> createAccount(scanner);
                    case "3" -> {
                        running = false;
                        System.out.println("Thank you for using the ATM. Goodbye!");
                    }
                    default -> System.out.println("Invalid option. Please try again.");
                }
            }
        }
    }

    private void performTransactions(Account account, Scanner scanner) {
        boolean loggedIn = true;
        while (loggedIn) {
            System.out.println("\n--- Account Operations for " + account.getAccountHolderName() + " (" + account.getAccountNumber() + ") ---");
            System.out.println("1. Check Balance");
            System.out.println("2. Deposit Money");
            System.out.println("3. Withdraw Money");
            System.out.println("4. View Account Details");
            System.out.println("5. Logout");
            System.out.print("Choose an option: ");

            String choice = scanner.nextLine();
            double amount;

            switch (choice) {
                case "1" -> System.out.println("Current Balance: $" + String.format("%.2f", account.getBalance()));
                case "2" -> {
                    System.out.print("Enter amount to deposit: $");
                    if (scanner.hasNextDouble()) {
                        amount = scanner.nextDouble();
                        account.deposit(amount);
                    } else {
                        System.out.println("Invalid amount format.");
                    }
                    scanner.nextLine(); // consume newline
                }
                case "3" -> {
                    System.out.print("Enter amount to withdraw: $");
                    if (scanner.hasNextDouble()) {
                        amount = scanner.nextDouble();
                        account.withdraw(amount);
                    } else {
                        System.out.println("Invalid amount format.");
                    }
                    scanner.nextLine(); // consume newline
                }
                case "4" -> account.displayAccountDetails();
                case "5" -> {
                    loggedIn = false;
                    System.out.println("Logged out successfully.");
                }
                default -> System.out.println("Invalid option. Please try again.");
            }
        }
    }
}