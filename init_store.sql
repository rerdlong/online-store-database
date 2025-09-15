-- Drop existing tables
DROP TABLE IF EXISTS payments, order_items, orders, products, customers CASCADE;

-- Create tables
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    description TEXT,
    price NUMERIC(10,2),
    stock_quantity INT
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id) ON DELETE CASCADE,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INT REFERENCES products(product_id),
    quantity INT,
    price NUMERIC(10,2)
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id) ON DELETE CASCADE,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount NUMERIC(10,2),
    method VARCHAR(50)
);

-- Insert sample data
INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
('Alice', 'Martin', 'alice@example.com', '0612345678', '12 rue de Paris'),
('Bob', 'Durand', 'bob@example.com', '0698765432', '45 avenue de Lyon');

INSERT INTO products (name, description, price, stock_quantity) VALUES
('Laptop', 'Ordinateur portable 15 pouces', 899.99, 10),
('Smartphone', 'Téléphone Android 128Go', 499.99, 25),
('Casque Audio', 'Casque Bluetooth sans fil', 79.99, 50);

INSERT INTO orders (customer_id, status) VALUES
(1, 'Pending'),
(2, 'Shipped');

INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 899.99),
(1, 3, 2, 79.99),
(2, 2, 1, 499.99);

INSERT INTO payments (order_id, amount, method) VALUES
(1, 1059.97, 'Credit Card'),
(2, 499.99, 'PayPal');

-- Example queries
SELECT o.order_id, c.first_name, c.last_name FROM orders o JOIN customers c ON o.customer_id = c.customer_id;
SELECT name FROM products WHERE stock_quantity = 0;
SELECT p.name, oi.quantity FROM order_items oi JOIN products p ON oi.product_id = p.product_id WHERE oi.order_id = 1;
SELECT c.first_name, SUM(p.amount) FROM customers c JOIN orders o ON c.customer_id = o.customer_id JOIN payments p ON o.order_id = p.order_id GROUP BY c.first_name;
SELECT * FROM products WHERE name ILIKE '%phone%';
