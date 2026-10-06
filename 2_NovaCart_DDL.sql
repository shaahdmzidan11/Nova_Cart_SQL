IF DB_ID(N'NovaCartDB') IS NULL
    CREATE DATABASE NovaCartDB;
GO

USE NovaCartDB;
GO

DROP TABLE IF EXISTS Reviews;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS OrderDetails;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
GO

CREATE TABLE Customers (
    customer_id INT IDENTITY(1,1) NOT NULL,
    full_name   NVARCHAR(100)     NOT NULL,
    email       NVARCHAR(150)     NOT NULL,
    phone       VARCHAR(20)       NOT NULL,
    address     NVARCHAR(250)     NOT NULL,
    join_date   DATE              NOT NULL,
    CONSTRAINT PK_Customers PRIMARY KEY (customer_id),
    CONSTRAINT UQ_Customers_email UNIQUE (email),
    CONSTRAINT CK_Customers_email CHECK (email LIKE '%_@_%._%')
);
GO

CREATE TABLE Products (
    product_id     INT IDENTITY(1,1) NOT NULL,
    name           NVARCHAR(120)     NOT NULL,
    category       NVARCHAR(60)      NOT NULL,
    price          DECIMAL(10,2)     NOT NULL,
    stock_quantity INT               NOT NULL,
    CONSTRAINT PK_Products PRIMARY KEY (product_id),
    CONSTRAINT CK_Products_price CHECK (price >= 0),
    CONSTRAINT CK_Products_stock CHECK (stock_quantity >= 0)
);
GO

CREATE TABLE Orders (
    order_id    INT IDENTITY(1,1) NOT NULL,
    customer_id INT               NOT NULL,
    order_date  DATE              NOT NULL,
    status      VARCHAR(20)       NOT NULL,
    CONSTRAINT PK_Orders PRIMARY KEY (order_id),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    CONSTRAINT CK_Orders_status CHECK (status IN ('Pending', 'Shipped', 'Delivered', 'Cancelled'))
);
GO

CREATE TABLE OrderDetails (
    order_id   INT           NOT NULL,
    product_id INT           NOT NULL,
    quantity   INT           NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT PK_OrderDetails PRIMARY KEY (order_id, product_id),
    CONSTRAINT FK_OrderDetails_Orders FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    CONSTRAINT FK_OrderDetails_Products FOREIGN KEY (product_id)
        REFERENCES Products(product_id),
    CONSTRAINT CK_OrderDetails_quantity CHECK (quantity > 0),
    CONSTRAINT CK_OrderDetails_unit_price CHECK (unit_price >= 0)
);
GO

CREATE TABLE Payments (
    payment_id   INT IDENTITY(1,1) NOT NULL,
    order_id     INT               NOT NULL,
    payment_date DATE              NOT NULL,
    amount       DECIMAL(10,2)     NOT NULL,
    method       VARCHAR(20)       NOT NULL,
    CONSTRAINT PK_Payments PRIMARY KEY (payment_id),
    CONSTRAINT UQ_Payments_order UNIQUE (order_id),
    CONSTRAINT FK_Payments_Orders FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),
    CONSTRAINT CK_Payments_amount CHECK (amount > 0),
    CONSTRAINT CK_Payments_method CHECK (method IN ('Credit Card', 'PayPal', 'Cash on Delivery'))
);
GO

CREATE TABLE Reviews (
    review_id   INT IDENTITY(1,1) NOT NULL,
    customer_id INT               NOT NULL,
    product_id  INT               NOT NULL,
    rating      INT               NOT NULL,
    comment     NVARCHAR(500)     NULL,
    review_date DATE              NOT NULL,
    CONSTRAINT PK_Reviews PRIMARY KEY (review_id),
    CONSTRAINT FK_Reviews_Customers FOREIGN KEY (customer_id)
        REFERENCES Customers(customer_id),
    CONSTRAINT FK_Reviews_Products FOREIGN KEY (product_id)
        REFERENCES Products(product_id),
    CONSTRAINT CK_Reviews_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT UQ_Reviews_customer_product UNIQUE (customer_id, product_id)
);
GO

CREATE TRIGGER trg_Reviews_PurchaseCheck
ON Reviews
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (
        SELECT 1
        FROM inserted i
        WHERE NOT EXISTS (
            SELECT 1
            FROM Orders o
            JOIN OrderDetails od ON od.order_id = o.order_id
            WHERE o.customer_id = i.customer_id
              AND od.product_id = i.product_id
              AND o.status = 'Delivered'
        )
    )
    BEGIN
        ROLLBACK TRANSACTION;
        THROW 50001, 'A customer can only review a product from one of their Delivered orders.', 1;
    END
END;
GO
