document.addEventListener('DOMContentLoaded', () => {
    const addBookBtn = document.getElementById('addBookBtn');
    const bookListContainer = document.getElementById('bookListContainer');

    // Sample initial books (optional, for demonstration)
    const initialBooks = [
        { title: "The Great Gatsby", author: "F. Scott Fitzgerald", description: "A story of the Jazz Age and the American Dream." },
        { title: "To Kill a Mockingbird", author: "Harper Lee", description: "A novel about the serious issues of rape and racial inequality." },
        { title: "1984", author: "George Orwell", description: "A dystopian social science fiction novel and cautionary tale." }
    ];

    // Function to display a book
    function displayBook(title, author, description) {
        const bookCard = document.createElement('article');
        bookCard.classList.add('book-card');

        const bookTitle = document.createElement('h2');
        bookTitle.textContent = title;

        const bookAuthor = document.createElement('h3');
        bookAuthor.textContent = `By: ${author}`;

        const bookDescription = document.createElement('p');
        bookDescription.textContent = description;

        bookCard.appendChild(bookTitle);
        bookCard.appendChild(bookAuthor);
        bookCard.appendChild(bookDescription);

        bookListContainer.appendChild(bookCard);
    }

    // Load initial books
    initialBooks.forEach(book => displayBook(book.title, book.author, book.description));

    // Event listener for the Add Book button
    addBookBtn.addEventListener('click', () => {
        const title = prompt("Enter the book's title:");
        if (title === null || title.trim() === "") {
            alert("Title cannot be empty.");
            return;
        }

        const author = prompt("Enter the book's author:");
        if (author === null || author.trim() === "") {
            alert("Author cannot be empty.");
            return;
        }

        const description = prompt("Enter a short description for the book:");
        if (description === null || description.trim() === "") {
            alert("Description cannot be empty.");
            return;
        }

        displayBook(title.trim(), author.trim(), description.trim());
        // Optionally, save to localStorage if persistence is desired
    });
});