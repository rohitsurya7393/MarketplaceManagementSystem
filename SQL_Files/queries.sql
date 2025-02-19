
-- 1 Date Difference between ORDER DATE AND SHIP DATE
EXPLAIN
SELECT 
    order_ID,
    order_date,
    ship_date,
    (ship_date - order_date) AS days_between
FROM 
    order_to_ship;
	
-- 2 Transasctions with loss

SELECT
    Transaction_ID,
    Total_Cost_price,
    Total_Sale_price,
    Profit
FROM
    Price
WHERE
    Profit < 0;
-- there are no transactions with loss
	
-- 3 Number of customers ordering from each region
SELECT
    a.Region,
    COUNT(cd.Customer_ID) AS Number_of_Customers
FROM
    Address a
JOIN
    Customer_details cd ON a.Postal_Code = cd.Postal_Code
GROUP BY
    a.Region
ORDER BY
    Number_of_Customers DESC;
	
	
-- 4 Average transaction value for each product
SELECT c.Category,AVG(t.Final_price) AS Avg_Transaction_Value
FROM
    Categories c
JOIN
    Products p ON c.Category_ID = p.Category_ID
JOIN
    Transactions t ON p.Product_ID = t.Product_ID
GROUP BY
    c.Category;


-- 5 Calculating the spending rank for each customer based on the total amount spent by them 

WITH Customer_Sales AS (
    SELECT cd.Customer_ID, cd.Customer_Name, 
        SUM(t.Final_price) AS Total_Spent
    FROM Customer_details cd
    JOIN Transactions t ON cd.Customer_ID = t.Customer_ID
    GROUP BY cd.Customer_ID, cd.Customer_Name
),
Ranked_Customers AS (
    SELECT 
        Customer_Name,
        Total_Spent,
        RANK() OVER (ORDER BY Total_Spent DESC) AS Spending_Rank
    FROM Customer_Sales
)
SELECT Customer_Name, Total_Spent, Spending_Rank
FROM Ranked_Customers
WHERE Spending_Rank <= 10;


-- 6 Analysis on each month total sales and then comparing the sales with the previous month sales

WITH Monthly_Sales AS (
    SELECT 
        c.Category,
        EXTRACT(YEAR FROM o.Ship_Date) AS Sale_Year,
        EXTRACT(MONTH FROM o.Ship_Date) AS Sale_Month,
        SUM(t.Final_price) AS Total_Sales
    FROM Categories c
    JOIN Products p ON c.Category_ID = p.Category_ID
    JOIN Transactions t ON p.Product_ID = t.Product_ID
    JOIN Order_to_Ship o ON t.Order_ID = o.Order_ID
    GROUP BY c.Category, Sale_Year, Sale_Month
)
SELECT Category,Sale_Year,Sale_Month,Total_Sales,
    LAG(Total_Sales, 1) OVER (PARTITION BY Category ORDER BY Sale_Year, Sale_Month) AS Previous_Month_Sales
FROM Monthly_Sales
ORDER BY Category, Sale_Year, Sale_Month;


-- 7 Efficiancy of each Shipping mode compared to the average number of days it took to deliver

WITH Shipping_Duration AS (
    SELECT 
        s.Ship_Mode,
        AVG(s.Shipping_Charge) AS Avg_Shipping_Charge,
        AVG(o.ship_date - o.order_date) AS Average_Delivery_Days
    FROM Shipment s
    JOIN Transactions t ON s.Ship_Mode = t.Ship_Mode
    JOIN Order_to_Ship o ON t.Order_ID = o.Order_ID
    GROUP BY s.Ship_Mode
)
SELECT 
    Ship_Mode,
    Avg_Shipping_Charge,
    Average_Delivery_Days,
    RANK() OVER (ORDER BY Average_Delivery_Days, Avg_Shipping_Charge) AS Efficiency_Rank
FROM Shipping_Duration
ORDER BY Efficiency_Rank;


select t.customer_id,c.customer_name , count(*)  from transactions t join customer_details c 
on t.customer_id = c.customer_id
group by t.customer_id,c.customer_name
order by count(*) desc;

select * from customer_details;
