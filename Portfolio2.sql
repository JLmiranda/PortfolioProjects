-- Selecting all data 

SELECT * FROM portfolio.customers;
SELECT * FROM portfolio.order_items;
SELECT * FROM portfolio.orders;
SELECT * FROM portfolio.product;
SELECT * FROM portfolio.products;
SELECT * FROM portfolio.staffs;
SELECT * FROM portfolio.stores;


-- Full group
SET GLOBAL sql_mode=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));


##############################################################################################################
-- Total Sales per Branch
SELECT 
    store_name, COUNT(order_id) AS Sales
FROM
    portfolio.stores
        JOIN
    portfolio.orders ON portfolio.stores.store_id = portfolio.orders.store_id
GROUP BY store_name
ORDER BY Sales DESC;


###############################################################################################################
-- Full Price before discount

SELECT 
    order_id,
    list_price,
    discount,
    CAST(list_price + discount AS DECIMAL (10 , 2 )) AS Full_price
FROM
    order_items;

###############################################################################################################
-- Most to least product sales

SELECT order_items.product_id, product_name, COUNT(order_items.product_id) AS Product_sales
FROM order_items
JOIN products
ON order_items.product_id=products.product_id
GROUP BY order_items.product_id
ORDER BY 3 DESC;

##############################################################################################################
-- Sales per Product
SELECT 
    product_name,
    quantity * order_items.list_price AS total_sales
FROM
    portfolio.products
        JOIN
    portfolio.order_items
        JOIN
    portfolio.orders ON portfolio.products.product_id = portfolio.order_items.product_id = portfolio.orders.order_id
GROUP BY products.product_name
ORDER BY total_sales DESC;

##############################################################################################################

-- Sales per State
SELECT 
    State, COUNT(state) AS Sales_State
FROM
    portfolio.orders
        JOIN
    portfolio.customers ON portfolio.orders.customer_id = portfolio.customers.customer_id
GROUP BY State
ORDER BY Sales_State DESC;

###############################################################################################################

-- Ship date 
SELECT 
    order_id,
    shipped_date,
    required_date,
    CASE
        WHEN shipped_date = required_date THEN 'Shipped exact date'
        WHEN shipped_date > required_date THEN 'Arrived Late'
        WHEN shipped_date < required_date THEN 'Arrived early'
        WHEN shipped_date IS NULL THEN 'Cancelled Order'
    END AS 'Arrival Status'
FROM
    portfolio.orders; 


#############################################################################################################
-- Repeat orders from Customers

SELECT 
    portfolio.orders.customer_id,
    CONCAT(first_name, ' ', last_name) AS full_Name,
    COUNT(portfolio.orders.customer_id) AS order_count,
    CASE
        WHEN COUNT(portfolio.customers.customer_id) > 1 THEN 'Repeat order'
        ELSE 'One time Order'
    END AS 'Order Status'
FROM
    portfolio.customers
        JOIN
    portfolio.orders ON portfolio.customers.customer_id = portfolio.orders.customer_id
GROUP BY portfolio.orders.customer_id
ORDER BY portfolio.orders.customer_id
;

##############################################################################################################
-- Prices Range

SELECT 
    product_id,
    product_name,
    list_price,
    CASE
        WHEN list_price < 600 THEN 'Affordable'
        WHEN list_price BETWEEN 600 AND 900 THEN 'Less Affordable'
        WHEN list_price BETWEEN 900 AND 2000 THEN 'Min Price'
        WHEN list_price BETWEEN 2001 AND 12000 THEN 'Expensive'
    END AS 'Price Range'
FROM
    portfolio.products
ORDER BY list_price;


############################################################################################################
-- sales per Staff

SELECT staffs.staff_id, staffs.first_name, staffs.last_name,COUNT(orders.staff_id) AS Total_sales
FROM staffs
JOIN orders
ON staffs.staff_id=orders.staff_id
GROUP BY orders.staff_id
ORDER BY 4 DESC;

###########################################################################################################

-- Stock 

SELECT stocks.product_id,store_id, product_name, quantity,
CASE 
	WHEN quantity=0 THEN 'No stocks please replenish'
    WHEN quantity BETWEEN 1 AND 10 THEN 'Low in stock'
    WHEN quantity BETWEEN 11 AND 25 THEN 'Still in stock'
    WHEN quantity>25 THEN 'High in stock needs sales'
END AS Stock_per_Product
FROM stocks
JOIN products
ON stocks.product_id=products.product_id
;

############################################################################################################
-- Store Profit

WITH Total_Profit_Per_Store (store_id, product_name, Exact_Price) AS
(
SELECT store_id, product_name, quantity*order_items.list_price AS Exact_Price
FROM order_items
JOIN orders
JOIN products
ON order_items.order_id=orders.order_id=products.product_id
)
Select store_id, Exact_Price, CAST(SUM(Exact_Price) OVER(PARTITION BY store_id)AS DECIMAL(10,2)) AS Total_Profit
FROM Total_Profit_Per_Store;






























































