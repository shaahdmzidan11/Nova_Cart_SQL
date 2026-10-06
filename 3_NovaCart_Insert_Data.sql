USE NovaCartDB;
GO

INSERT INTO Customers (full_name, email, phone, address, join_date) VALUES
('Shahd Ahmed Hassan', 'shahd.hassan@mail.com',   '01012345601', '12 Tahrir St, Cairo',          '2024-11-05'),
('Mazen Ayman Fouad', 'mazen.fouad@mail.com',   '01123456702', '5 Corniche Rd, Alexandria',    '2024-12-01'),
('Youssef Karim Adel', 'youssef.adel@mail.com',    '01234567803', '30 El Haram St, Giza',         '2025-01-03'),
('Sara Ahmed Nabil', 'sara.nabil@mail.com',       '01545678904', '8 Nasr City, Cairo',           '2025-01-15'),
('Reem Ayman Saad', 'reem.saad@mail.com','01056789005', '21 Gamal Abdel Nasser, Faiyum','2025-02-02'),
('Karim Youssef Salem', 'karim.salem@mail.com',      '01167890106', '14 El Mahalla Rd, Gharbia',    '2025-02-10'),
('Ahmed Mazen Ezzat', 'ahmed.ezzat@mail.com',   '01278901207', '3 Port Said St, Mansoura',     '2025-02-28'),
('Ayman Karim Zaki', 'ayman.zaki@mail.com',    '01589012308', '9 Sheikh Zayed, Giza',         '2025-03-09'),
('Reem Sara Hegazy', 'reem.hegazy@mail.com',    '01090123409', '17 Stanley, Alexandria',       '2025-03-20'),
('Mazen Youssef Ragab', 'mazen.ragab@mail.com',   '01101234510', '6 El Salam St, Tanta',         '2025-04-11'),
('Sara Karim Mourad', 'sara.mourad@mail.com',     '01212345611', '25 Maadi, Cairo',              '2025-05-02'),
('Youssef Ahmed Gamal', 'youssef.gamal@mail.com',    '01523456712', '11 Hurghada Rd, Red Sea',      '2025-05-18');

INSERT INTO Products (name, category, price, stock_quantity) VALUES
('Samsung Galaxy A54',      'Electronics',      12500.00,  40),
('Wireless Headphones',     'Electronics',       1800.00, 120),
('Lenovo IdeaPad Laptop',   'Electronics',      18500.00,  15),
('Men Denim Jacket',        'Fashion',           1200.00,  60),
('Women Summer Dress',      'Fashion',            850.00,  80),
('Air Fryer',               'Home Appliances',   3200.00,  35),
('Electric Kettle',         'Home Appliances',    650.00,  70),
('SQL Fundamentals Book',   'Books',              420.00, 100),
('Leather Wallet',          'Accessories',        380.00, 150),
('Smart Watch',             'Accessories',       4500.00,  25),
('Kitchen Blender',         'Home Appliances',   2400.00,  30),
('Data Science Handbook',   'Books',              550.00,  45);

INSERT INTO Orders (customer_id, order_date, status) VALUES
(1, '2025-01-10', 'Delivered'),
(2, '2025-01-18', 'Delivered'),
(3, '2025-02-05', 'Delivered'),
(1, '2025-02-14', 'Delivered'),
(4, '2025-02-20', 'Shipped'),
(5, '2025-03-03', 'Delivered'),
(6, '2025-03-12', 'Cancelled'),
(2, '2025-03-25', 'Delivered'),
(7, '2025-04-02', 'Pending'),
(8, '2025-04-15', 'Delivered'),
(1, '2025-04-28', 'Shipped'),
(3, '2025-05-06', 'Delivered'),
(9, '2025-05-19', 'Delivered'),
(5, '2025-06-01', 'Pending');

INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 12000.00),
(1, 2, 1,  1800.00),
(2, 5, 2,   800.00),
(2, 9, 1,   380.00),
(3, 3, 1, 18000.00),
(4, 8, 3,   400.00),
(4, 2, 1,  1800.00),
(5, 6, 1,  3200.00),
(5, 7, 2,   650.00),
(6, 4, 1,  1150.00),
(6, 5, 1,   850.00),
(7, 10, 1, 4500.00),
(8, 6, 1,  3000.00),
(8, 9, 2,   360.00),
(9, 1, 1, 12500.00),
(10, 12, 2,  550.00),
(10, 8, 1,   420.00),
(11, 10, 1, 4500.00),
(11, 2, 2,  1750.00),
(12, 7, 1,   650.00),
(12, 4, 2,  1200.00),
(13, 9, 3,   380.00),
(13, 12, 1,  550.00),
(14, 7, 1,   650.00),
(14, 8, 1,   420.00);

INSERT INTO Payments (order_id, payment_date, amount, method) VALUES
(1,  '2025-01-10', 13800.00, 'Credit Card'),
(2,  '2025-01-19',  1980.00, 'Cash on Delivery'),
(3,  '2025-02-05', 18000.00, 'Credit Card'),
(4,  '2025-02-15',  3000.00, 'PayPal'),
(5,  '2025-02-20',  4500.00, 'Credit Card'),
(6,  '2025-03-05',  2000.00, 'Cash on Delivery'),
(7,  '2025-03-12',  4500.00, 'PayPal'),
(8,  '2025-03-26',  3720.00, 'Cash on Delivery'),
(9,  '2025-04-02', 12500.00, 'Credit Card'),
(10, '2025-04-16',  1520.00, 'PayPal'),
(11, '2025-04-28',  8000.00, 'Credit Card'),
(12, '2025-05-07',  3050.00, 'Cash on Delivery'),
(13, '2025-05-19',  1690.00, 'PayPal'),
(14, '2025-06-01',  1070.00, 'Cash on Delivery');

INSERT INTO Reviews (customer_id, product_id, rating, comment, review_date) VALUES
(1, 1, 5, 'Great phone, fast delivery',            '2025-01-20'),
(1, 2, 4, 'Good sound quality',                    '2025-01-22'),
(2, 5, 2, 'Fabric was thinner than expected',      '2025-01-28'),
(2, 9, 5, 'Good quality for the price',            '2025-01-30'),
(3, 3, 5, 'Excellent laptop for study',            '2025-02-15'),
(1, 8, 5, 'Clear explanations',                    '2025-02-25'),
(5, 5, 4, 'Nice fit',                              '2025-03-14'),
(5, 4, 3, NULL,                                    '2025-03-15'),
(2, 6, 4, 'Works well',                            '2025-04-05'),
(8, 8, 4, 'Useful for the course',                 '2025-04-25'),
(3, 7, 1, 'Stopped working after a week',          '2025-05-20'),
(9, 9, 3, NULL,                                    '2025-05-30');
GO
