-- Create the ecommerce database
CREATE DATABASE ecommerce;
USE ecommerce;

-- Create customers table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address TEXT NOT NULL
);

-- Create products table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

-- Create orders table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Insert sample customers
INSERT INTO customers (name, email, address) VALUES
('John Doe', 'john@example.com', '123 Main St, Anytown'),
('Jane Smith', 'jane@example.com', '456 Oak Ave, Somewhere'),
('Bob Johnson', 'bob@example.com', '789 Pine Rd, Nowhere');

-- Insert sample products
INSERT INTO products (name, price, description) VALUES
('Product A', 29.99, 'High-quality product A'),
('Product B', 39.99, 'Premium product B'),
('Product C', 49.99, 'Deluxe product C'),
('Product D', 19.99, 'Basic product D');

-- Insert sample orders
INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2023-05-15', 89.97),
(2, '2023-05-20', 119.96),
(1, '2023-06-01', 49.99),
(3, '2023-06-10', 159.96);

-- 1. Retrieve all customers who have placed an order in the last 30 days
SELECT DISTINCT c.* 
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- 2. Get the total amount of all orders placed by each customer
SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id
GROUP BY c.id, c.name;

-- 3. Update the price of Product C to 45.00
UPDATE products
SET price = 45.00
WHERE name = 'Product C';

-- 4. Add a new column discount to the products table
ALTER TABLE products
ADD COLUMN discount DECIMAL(5, 2) DEFAULT 0.00;

-- 5. Retrieve the top 3 products with the highest price
SELECT *
FROM products
ORDER BY price DESC
LIMIT 3;

-- 6. Get the names of customers who have ordered Product A
SELECT DISTINCT c.name
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';

-- 7. Join the orders and customers tables to retrieve customer's name and order date
SELECT c.name, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.id;

-- 8. Retrieve the orders with a total amount greater than 150.00
SELECT *
FROM orders
WHERE total_amount > 150.00;

-- 9. Normalize the database by creating order_items table and updating orders table
CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES
(1, 1, 1, 29.99), (1, 2, 1, 39.99), (1, 3, 1, 49.99),
(2, 1, 2, 29.99), (2, 2, 1, 39.99), (2, 4, 1, 19.99),
(3, 3, 1, 49.99),
(4, 2, 2, 39.99), (4, 3, 1, 49.99), (4, 4, 1, 19.99);


-- 10. Retrieve the average total of all orders
SELECT AVG(total_amount) AS average_order_total
FROM orders;