document.addEventListener('DOMContentLoaded', () => {
    const todoInput = document.getElementById('todo-input');
    const addTodoBtn = document.getElementById('add-todo-btn');
    const todoList = document.getElementById('todo-list');

    // Load todos from local storage
    loadTodos();

    addTodoBtn.addEventListener('click', addTodo);
    todoInput.addEventListener('keypress', function(event) {
        if (event.key === 'Enter') {
            addTodo();
        }
    });

    function addTodo() {
        const todoText = todoInput.value.trim();
        if (todoText === '') {
            alert('Please enter a todo item.');
            return;
        }
        createTodoItem(todoText);
        saveTodos();
        todoInput.value = '';
        todoInput.focus();
    }

    function createTodoItem(text, completed = false) {
        const li = document.createElement('li');
        if (completed) {
            li.classList.add('completed');
        }

        const todoTextSpan = document.createElement('span');
        todoTextSpan.textContent = text;
        todoTextSpan.addEventListener('click', () => {
            li.classList.toggle('completed');
            saveTodos();
        });

        const actionsDiv = document.createElement('div');
        actionsDiv.classList.add('actions');

        const editBtn = document.createElement('button');
        editBtn.classList.add('edit-btn');
        editBtn.innerHTML = '✎'; // Pencil icon
        editBtn.title = "Edit";
        editBtn.addEventListener('click', (e) => {
            e.stopPropagation(); // Prevent li click event
            editTodoItem(li, todoTextSpan);
        });

        const deleteBtn = document.createElement('button');
        deleteBtn.classList.add('delete-btn');
        deleteBtn.innerHTML = '✖'; // Cross icon
        deleteBtn.title = "Delete";
        deleteBtn.addEventListener('click', (e) => {
            e.stopPropagation(); // Prevent li click event
            if (confirm('Are you sure you want to delete this item?')) {
                todoList.removeChild(li);
                saveTodos();
            }
        });

        actionsDiv.appendChild(editBtn);
        actionsDiv.appendChild(deleteBtn);

        li.appendChild(todoTextSpan);
        li.appendChild(actionsDiv);
        todoList.appendChild(li);
    }

    function editTodoItem(li, span) {
        const currentText = span.textContent;
        const newText = prompt('Edit your todo item:', currentText);

        if (newText !== null && newText.trim() !== '') {
            span.textContent = newText.trim();
            saveTodos();
        } else if (newText !== null && newText.trim() === '') {
            alert('Todo item cannot be empty.');
        }
    }

    function saveTodos() {
        const todos = [];
        todoList.querySelectorAll('li').forEach(li => {
            todos.push({
                text: li.querySelector('span').textContent,
                completed: li.classList.contains('completed')
            });
        });
        localStorage.setItem('todos', JSON.stringify(todos));
    }

    function loadTodos() {
        const todos = JSON.parse(localStorage.getItem('todos'));
        if (todos) {
            todos.forEach(todo => createTodoItem(todo.text, todo.completed));
        }
    }
});