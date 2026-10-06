# NovaCart - Reasoning Answers

## Design Reasoning
1. **Why an intermediate table?** Orders and Products are many-to-many (an order has many products and a product is in many orders). A relational table can't hold that directly, so OrderDetails stores one row per order-product pair.
2. **Why quantity in OrderDetails?** Quantity depends on both the order and the product together. If it was in Products it would be one value for the product everywhere.
3. **Why unit_price in OrderDetails?** Prices change. Storing the price at purchase time keeps old orders and revenue correct even if Products.price changes later.
4. **Why restrict status?** To keep data consistent (no typos like "Deliverd") and to match the business rules. A CHECK constraint does that.
5. **Why UNIQUE order_id in Payments?** The FK alone would allow many payments for one order. UNIQUE makes it one payment per order (1:1).
6. **Which rules are enforced by constraints?** PK/FK, NOT NULL, UNIQUE, CHECK for status, method, rating 1-5 and positive quantity. The rule "review only after purchase" needs other tables, so a CHECK can't do it. I used a trigger on Reviews that checks the customer has a Delivered order containing that product.

## SQL Reasoning
1. **GROUP BY:** M2-Q5, M2-Q6, M3-Q1, M3-Q2, M3-Q5, M4-Q1, M4-Q6, M5-Q1, M5-Q3, M6, M7-Q1, M7-Q2 and the views - anything with an aggregate per group.
2. **HAVING vs WHERE:** WHERE filters rows before grouping, HAVING filters groups after aggregation. In M3-Q2 the total per order only exists after GROUP BY, so `HAVING SUM(quantity * unit_price) > 5000` is needed.
3. **LEFT JOIN:** M4-Q1 (products with no reviews), M4-Q6 (customers with no orders), and vw_customer_summary.
4. **Duplicates from joins:** joining Customers -> Orders -> OrderDetails would repeat the payment amount for each order line and inflate SUM. I joined Payments directly through Orders (one payment per order) and used COUNT(DISTINCT order_id) in the customer summary view.
5. **Why OrderDetails.unit_price:** it is the price at purchase time. Products.price is the current price and would give wrong historical revenue.
6. **RANK vs DENSE_RANK:** with ties, RANK skips numbers after the tie (1,1,3) and DENSE_RANK doesn't (1,1,2). In my data customers Sara Ahmed Nabil and Karim Youssef Salem tie at 4500, and several products tie on quantity.
