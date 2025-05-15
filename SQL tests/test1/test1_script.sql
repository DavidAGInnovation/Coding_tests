-- 0. Good practice: Drop the table if it exists for repeatable tests
DROP TABLE IF EXISTS customers;

-- 1. Create the table to hold customer data
CREATE TABLE customers (
    first_name TEXT,
    last_name TEXT,
    company TEXT,
    country TEXT,
    subscription_start_date TEXT -- Store dates as TEXT in YYYY-MM-DD format
);

-- 2. Import the CSV data
.mode csv
.import customers.csv customers

-- 3. The query to find the company
SELECT company
FROM customers
WHERE country = 'Latvia'
  AND first_name LIKE 'X%'
  AND subscription_start_date < date('now');