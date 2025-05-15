CREATE TABLE books (
    Title TEXT NOT NULL,
    Author TEXT NOT NULL,
    ISBN TEXT UNIQUE NOT NULL PRIMARY KEY, -- Making ISBN the PRIMARY KEY also enforces UNIQUE and NOT NULL
    Genre TEXT,
    Publication_Year INTEGER, -- INTEGER is suitable for year
    Price REAL,               -- REAL is SQLite's floating-point type, good for prices
    Stock_Quantity INTEGER
);