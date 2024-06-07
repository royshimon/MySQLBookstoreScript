
SELECT * FROM Authors;
SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
SELECT * FROM OrderDetails;

/* 
Requirements
1. Retrieve the names of all authors born after January 1, 1980. 
2. Find the titles of all books that cost more than $20. 
3. List the names and emails of all customers who have placed an 
order. 
4. Get the total quantity of books ordered by each customer. 
*/

-- 1.
SELECT name
FROM Authors
WHERE birthdate > "1980-01-01";

-- 2.
SELECT title
FROM Books
WHERE price > 20.00;

-- 3. 
SELECT Customers.name, Customers.email
FROM Customers
JOIN Orders ON Customers.customer_id = Orders.customer_id
GROUP BY Customers.name, Customers.email;

-- 4. 
SELECT Customers.name, SUM(OrderDetails.quantity) AS total_quantity
FROM Customers
JOIN Orders ON Customers.customer_id = Orders.customer_id
JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
GROUP BY Customers.name;

-- Find the total number of books sold and the total revenue for each book. 
SELECT Books.title,
		COALESCE(SUM(OrderDetails.quantity), 0) AS total_quantity_sold,
        COALESCE(SUM(OrderDetails.quantity * Books.price), 0) AS total_revenue
FROM Books
LEFT JOIN OrderDetails ON Books.book_id = OrderDetails.book_id
GROUP BY Books.title;

-- List the order ID, customer name, and total amount for each order. 
SELECT Orders.order_id,
	   Customers.name AS customer_name,
       SUM(OrderDetails.quantity * Books.price) AS total_amount
FROM Orders
JOIN Customers ON Orders.customer_id = Customers.customer_id
JOIN OrderDetails ON Orders.order_id = OrderDetails.order_id
JOIN Books ON OrderDetails.book_id = Books.book_id
GROUP BY Orders.order_id, Customers.name;

-- Find the most popular author (the author whose books have been ordered the most). 
SELECT Authors.name, SUM(OrderDetails.quantity) AS total_books_sold
FROM Authors
JOIN Books ON Authors.author_id = Books.author_id
JOIN OrderDetails ON Books.book_id = OrderDetails.book_id
GROUP BY Authors.name
ORDER BY total_books_sold DESC
LIMIT 1;


CREATE TABLE Authors (
	author_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    birthdate DATE
);

INSERT INTO Authors (name, birthdate) VALUES
("John Smith", "1978-04-23"),
("Jane Doe", "1985-06-15"),
("Emily Johnson", "1973-01-04"),
("Haywood Highsmith", "1982-09-13"),
("Regina Trent", "1990-06-22"),
("Tony Wroten", "1979-07-28"),
("Oprah Winfrey", "1974-01-28"),
("Patricia Posit", "1979-12-17"),
("Terrence Tight", "1973-11-20"),
("Jamal Crawford", "1982-05-18"),
("Samantha Auker", "1974-04-17"),
("Wardell Curry", "1988-08-24");

CREATE TABLE Books (
	book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    author_id INT,
    published_date DATE,
    price DECIMAL(10, 2),
    FOREIGN KEY (author_id) REFERENCES Authors(author_id)
) AUTO_INCREMENT = 100;

INSERT INTO Books (title, author_id, published_date, price) VALUES
("Uncharted: Fortune", 1, "2000-01-01", 15.99),
("Uncharted 2: Deception", 1, "2002-05-23", 22.50),
("Uncharted 3: Thief's End", 1, "2003-11-30", 9.99),
("GoW", 2, "2002-05-22", 18.99),
("GoW Ragnorak", 2, "2005-08-30", 25.99),
("Forager", 3, "2001-06-09", 29.99),
("Hatchet", 4, "2001-01-20", 11.99),
("Vikings", 5, "2003-01-07", 7.99),
("Vikings: Valhalla", 5, "2003-11-20", 17.99),
("AC Brotherhood", 6, "1999-12-03", 9.99),
("AC Unity", 6, "2000-07-25", 32.99),
("AC Mirage", 6, "2004-01-22", 5.99),
("Events of WWII", 7, "2002-06-16", 16.99),
("Danuel House: Biography", 8, "2005-10-23", 16.99),
("American Psycho", 8, "2005-03-01", 33.99),
("Coach Carter", 9, "2000-04-17", 12.99),
("Rise of the Planet of the Apes", 10, "2001-06-09", 51.99),
("Dawn of the Planet of the Apes", 10, "2001-07-18", 11.99),
("War for the Planet of the Apes", 10, "2001-12-29", 15.99),
("The Rebound", 11, "2003-09-15", 13.99),
("Avatar", 12, "2004-08-13", 25.99),
("Avatar 2: Way of Water", 12, "2006-01-11", 13.99);

CREATE TABLE Customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL
) AUTO_INCREMENT = 200;

INSERT INTO Customers (name, email) VALUES
("Roy Shimon" , "rshimon2003@gmail.com"),
("Frank Belding" , "fbeld88@gmail.com"),
("Noah Lyles" , "noahlyles1@outlook.com"),
("Anne Orne" , "annorne2578@gmail.com"),
("Camille Holiday" , "camihol22@outlook.com"),
("Doc Rivers" , "milbucks@gmail.com"),
("Kamala Harris" , "kharris123@gmail.com"),
("Nicolas Kerr" , "nic_k38711@gmail.com"),
("Sophia Kelly" , "sophikellkell@outlook.com"),
("Madison Mash" , "madimash444@yahoo.com");

CREATE TABLE Orders(
	order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
) AUTO_INCREMENT = 500;

INSERT INTO Orders (customer_id, order_date) VALUES
(200 , "2024-02-02"),
(200 , "2024-02-26"),
-- (201 , "2024-01-15"),
(202 , "2024-01-13"),
(202 , "2024-04-16"),
(203 , "2024-05-05"),
(203 , "2024-05-04"),
-- (204 , "2024-01-29"),
(205 , "2024-03-30"),
(206 , "2024-04-07"),
(206 , "2024-04-07"),
-- (207 , "2024-03-22"),
(208 , "2024-05-18");
-- (209 , "2024-06-01");

CREATE TABLE OrderDetails(
	order_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    book_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
) AUTO_INCREMENT = 600;

INSERT INTO OrderDetails (order_id, book_id, quantity) VALUES
(500, 100, 1),
(500, 101, 3),
(501, 102, 1),
(502, 106, 2),
(502, 112, 1),
(503, 107, 1),
(504, 108, 1),
(505, 113, 2),
(506, 116, 3),
(506, 117, 1),
(506, 118, 1),
(507, 113, 3),
(508, 120, 2),
(508, 121, 1),
(509, 105, 2),
(509, 113, 1);
