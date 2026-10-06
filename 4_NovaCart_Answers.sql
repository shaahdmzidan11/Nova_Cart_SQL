USE NovaCartDB;
GO

-- M1-Q1
SELECT *
FROM Customers;

-- M1-Q2
SELECT name, category, price
FROM Products;

-- M1-Q3
SELECT name, category, price
FROM Products
WHERE price > 5000;

-- M1-Q4
SELECT customer_id, full_name, join_date
FROM Customers
ORDER BY join_date DESC;

-- M1-Q5
SELECT COUNT(*) AS total_customers
FROM Customers;

-- M2-Q1
SELECT AVG(price) AS avg_price
FROM Products;

-- M2-Q2
SELECT MAX(price) AS highest_price,
       MIN(price) AS lowest_price
FROM Products;

-- M2-Q3
SELECT SUM(stock_quantity) AS total_stock
FROM Products;

-- M2-Q4
SELECT SUM(amount) AS total_payments
FROM Payments;

-- M2-Q5
SELECT status, COUNT(*) AS number_of_orders
FROM Orders
GROUP BY status;

-- M2-Q6
SELECT method, SUM(amount) AS total_amount
FROM Payments
GROUP BY method;

-- M3-Q1
SELECT od.order_id,
       SUM(od.quantity * od.unit_price) AS total_sales
FROM OrderDetails od
GROUP BY od.order_id
ORDER BY od.order_id;

-- M3-Q2
SELECT od.order_id,
       SUM(od.quantity * od.unit_price) AS total_sales
FROM OrderDetails od
GROUP BY od.order_id
HAVING SUM(od.quantity * od.unit_price) > 5000;

-- M3-Q3
SELECT o.order_id,
       c.full_name AS customer_name,
       o.order_date,
       o.status
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
ORDER BY o.order_id;

-- M3-Q4
SELECT o.order_id,
       p.name AS product_name,
       od.quantity,
       od.unit_price
FROM Orders o
JOIN OrderDetails od ON od.order_id = o.order_id
JOIN Products p      ON p.product_id = od.product_id
ORDER BY o.order_id, p.name;

-- M3-Q5
SELECT c.customer_id,
       c.full_name AS customer_name,
       SUM(pay.amount) AS total_spent
FROM Customers c
JOIN Orders o    ON o.customer_id = c.customer_id
JOIN Payments pay ON pay.order_id = o.order_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_spent DESC;

-- M4-Q1
SELECT p.product_id,
       p.name AS product_name,
       COUNT(r.review_id) AS number_of_reviews
FROM Products p
LEFT JOIN Reviews r ON r.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY p.product_id;

-- M4-Q2
SELECT r.review_id,
       c.full_name AS customer_name,
       p.name AS product_name,
       r.rating,
       r.comment,
       r.review_date
FROM Reviews r
JOIN Customers c ON c.customer_id = r.customer_id
JOIN Products p  ON p.product_id = r.product_id
ORDER BY r.review_date;

-- M4-Q3
SELECT c.customer_id, c.full_name
FROM Customers c
WHERE c.customer_id IN (SELECT o.customer_id FROM Orders o);

-- M4-Q4
SELECT p.product_id, p.name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM OrderDetails od
    WHERE od.product_id = p.product_id
);

-- M4-Q5
SELECT p.product_id, p.name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM Reviews r
    WHERE r.product_id = p.product_id
);

-- M4-Q6
SELECT c.customer_id,
       c.full_name AS customer_name,
       COUNT(o.order_id) AS number_of_orders
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY c.customer_id;

-- M5-Q1
SELECT c.customer_id,
       c.full_name AS customer_name,
       COUNT(o.order_id) AS number_of_orders
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(CAST(t.order_count AS DECIMAL(10,2)))
    FROM (
        SELECT COUNT(*) AS order_count
        FROM Orders
        GROUP BY customer_id
    ) t
);

-- M5-Q2
SELECT name, category, price
FROM Products
WHERE price > (SELECT AVG(price) FROM Products);

-- M5-Q3
SELECT c.customer_id,
       c.full_name AS customer_name,
       SUM(pay.amount) AS total_spent
FROM Customers c
JOIN Orders o     ON o.customer_id = c.customer_id
JOIN Payments pay ON pay.order_id = o.order_id
GROUP BY c.customer_id, c.full_name
HAVING SUM(pay.amount) > (
    SELECT AVG(t.total_spent)
    FROM (
        SELECT SUM(pay2.amount) AS total_spent
        FROM Orders o2
        JOIN Payments pay2 ON pay2.order_id = o2.order_id
        GROUP BY o2.customer_id
    ) t
);

-- M6-Q1
WITH MonthlyRevenue AS (
    SELECT DATEFROMPARTS(YEAR(payment_date), MONTH(payment_date), 1) AS revenue_month,
           SUM(amount) AS total_revenue
    FROM Payments
    GROUP BY DATEFROMPARTS(YEAR(payment_date), MONTH(payment_date), 1)
)
SELECT revenue_month, total_revenue
FROM MonthlyRevenue
ORDER BY revenue_month;

-- M6-Q2
WITH CustomerSpending AS (
    SELECT c.customer_id,
           c.full_name AS customer_name,
           SUM(pay.amount) AS total_spent
    FROM Customers c
    JOIN Orders o     ON o.customer_id = c.customer_id
    JOIN Payments pay ON pay.order_id = o.order_id
    GROUP BY c.customer_id, c.full_name
)
SELECT customer_id, customer_name, total_spent
FROM CustomerSpending
WHERE total_spent > 10000
ORDER BY total_spent DESC;

-- M7-Q1
SELECT c.customer_id,
       c.full_name AS customer_name,
       SUM(pay.amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(pay.amount) DESC) AS spending_rank
FROM Customers c
JOIN Orders o     ON o.customer_id = c.customer_id
JOIN Payments pay ON pay.order_id = o.order_id
GROUP BY c.customer_id, c.full_name
ORDER BY spending_rank, c.customer_id;

-- M7-Q2
SELECT p.product_id,
       p.name AS product_name,
       SUM(od.quantity) AS total_quantity,
       DENSE_RANK() OVER (ORDER BY SUM(od.quantity) DESC) AS quantity_rank
FROM Products p
JOIN OrderDetails od ON od.product_id = p.product_id
GROUP BY p.product_id, p.name
ORDER BY quantity_rank, p.product_id;

-- M7-Q3
SELECT payment_id,
       payment_date,
       amount,
       LAG(amount) OVER (ORDER BY payment_date, payment_id) AS previous_amount
FROM Payments
ORDER BY payment_date, payment_id;

-- M7-Q4
SELECT payment_id,
       payment_date,
       amount,
       SUM(amount) OVER (ORDER BY payment_date, payment_id
                         ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM Payments
ORDER BY payment_date, payment_id;
GO

-- M8-Q1
CREATE OR ALTER VIEW vw_revenue_by_month AS
SELECT DATEFROMPARTS(YEAR(payment_date), MONTH(payment_date), 1) AS revenue_month,
       SUM(amount) AS total_revenue
FROM Payments
GROUP BY DATEFROMPARTS(YEAR(payment_date), MONTH(payment_date), 1);
GO

-- M8-Q2
CREATE OR ALTER VIEW vw_best_selling_products AS
SELECT p.name AS product_name,
       SUM(od.quantity) AS total_quantity_sold,
       SUM(od.quantity * od.unit_price) AS total_revenue
FROM Products p
JOIN OrderDetails od ON od.product_id = p.product_id
GROUP BY p.product_id, p.name;
GO

-- M8-Q3
CREATE OR ALTER VIEW vw_customer_summary AS
SELECT c.full_name AS customer_name,
       COUNT(DISTINCT o.order_id) AS number_of_orders,
       ISNULL(SUM(p.amount), 0) AS total_amount_spent
FROM Customers c
LEFT JOIN Orders o   ON o.customer_id = c.customer_id
LEFT JOIN Payments p ON p.order_id = o.order_id
GROUP BY c.customer_id, c.full_name;
GO

SELECT * FROM vw_revenue_by_month ORDER BY revenue_month;
SELECT * FROM vw_best_selling_products ORDER BY total_quantity_sold DESC;
SELECT * FROM vw_customer_summary ORDER BY total_amount_spent DESC;
GO
