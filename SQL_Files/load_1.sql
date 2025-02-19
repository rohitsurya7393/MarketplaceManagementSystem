

-- Execute the following command in psql command line to copy data from csv to the mega_table
\copy mega_table FROM '/Users/rohithsurya/Documents/Lab/DMQL/Milestone2/output.csv' DELIMITER ',' CSV HEADER;



-- Data Transformations 

-- Adding Segment_ID column to uniquely identify customer segment
ALTER TABLE Mega_Table
ADD COLUMN Segment_ID integer;

UPDATE Mega_Table
SET Segment_id = 1
where segment = 'Consumer';

UPDATE Mega_Table
SET Segment_id = 2
where segment = 'Corporate';

UPDATE Mega_Table
SET Segment_id = 3
where segment = 'Home Office';

-- Deleting Duplicates from order_id and Product_id Columns

WITH RankedOrders AS (
  SELECT  transaction_id,order_id, product_id,
         ROW_NUMBER() OVER (PARTITION BY order_id, product_id order by transaction_id ) AS rnk
  FROM Mega_table
)
DELETE FROM Mega_table
WHERE transaction_id IN (
    SELECT transaction_id FROM RankedOrders WHERE rnk > 1
);

-- Deleting duplicates from product_id from mega_table

select product_id,category_id ,count(*) from mega_table
group by product_id,category_id having count(*) > 1;

-- Inserting into shipment table

insert into shipment select distinct ship_mode , shipping_charge , shipping_desc from mega_table;

--select * from shipment order by shipping_charge;


-- Inserting into Address table

insert into Address(postal_code) select distinct postal_code from Mega_Table;

UPDATE Address AS a
SET
    region = b.region,
    city = b.city,
    state = b.state,
	Country = b.Country
FROM mega_table AS b
WHERE a.postal_code = b.postal_code;

-- Inserting into Segments table

insert into Segments select distinct segment_id , segment , profit_percent from mega_table;

-- Inserting into Customer Details table
insert into Customer_details(Customer_ID) select distinct Customer_ID from mega_table;

UPDATE Customer_details AS a
SET
    Customer_Name = b.Customer_Name,
    Segment_ID = b.Segment_ID,
    Postal_Code = b.Postal_Code
	
FROM mega_table AS b
WHERE a.Customer_ID = b.Customer_ID;


-- Inserting into Orders table

insert into orders select order_id ,product_id , quantity from mega_table;

'''
-- Checking for duplicates in order_id and product_id Column
SELECT order_id, product_id, COUNT(*)
FROM Orders
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;
'''

-- Inserting into Price table

insert into Price(Transaction_id , Total_Cost_price ) select transaction_id , (price_per_item * Quantity) from mega_table;

UPDATE Price AS a
SET Total_Sale_price = a.Total_Cost_price * (1 + b.profit_percent / 100)
FROM mega_table AS b
WHERE a.Transaction_ID = b.Transaction_ID;

-- Inserting into Order to ship table

insert into Order_to_Ship select distinct Order_id , order_date , Ship_date from mega_table;

-- Inserting into Category table

insert into Categories(Category , Sub_Category) select distinct Category , Sub_Category from Mega_Table;


-- Transformations to Mega_table
-- Adding category ID to the mega table since it is a series type generated while creating Categories table 
ALTER TABLE MEGA_TABLE 
ADD COLUMN CATEGORY_ID INTEGER;

Update MEGA_TABLE as a
SET CATEGORY_ID = b.Category_ID
FROM categories as b
WHERE a.category = b.category
AND a.sub_category = b.sub_category;


-- Inserting into Products table

insert into Products(product_id,category_id,product_name) select distinct Product_ID , Category_ID , Product_Name from Mega_table;

UPDATE Products
SET price_per_item = FLOOR(RANDOM() * 100) + 1
WHERE price_per_item IS NULL;


-- Deleting DUplicates from products table
With duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY product_id ORDER BY product_id) AS row_num
    FROM products
)
DELETE FROM products
WHERE (product_id) IN (SELECT product_id FROM duplicates WHERE row_num > 1);


-- Adding primary Key Constraint to product table
ALTER TABLE products
ADD CONSTRAINT product_id_pk PRIMARY KEY (product_id);

-- Update the mega_table with the updated price 
UPDATE Mega_table AS a
SET
    price_per_item = b.price_per_item

FROM Products AS b
WHERE a.Product_id = b.Product_id;


-- Creating Transactions Table and inserting data to it
Create Table Transactions (
	Transaction_ID float PRIMARY KEY,
	Order_ID varchar(20),
	Customer_ID varchar(20) REFERENCES Customer_details(Customer_ID),
	Product_ID varchar(20) REFERENCES Products(Product_ID),
	Quantity float,
	Ship_Mode varchar(20) References Shipment(Ship_Mode),
	Final_price float
);
--Removing inconsistent data

delete from mega_table where
product_id in (select product_id from mega_table
where product_id not in (select product_id from products));

-- Inserting data into transactions table 
insert into Transactions(Transaction_ID,Order_ID,Customer_ID,Product_ID,Quantity,Ship_Mode)
select distinct Transaction_ID,Order_ID,Customer_ID,Product_ID,Quantity,Ship_Mode from mega_table;

-- Calculating final_price for transactions table
UPDATE transactions
SET final_price = (
    SELECT p.Total_Sale_price + s.shipping_charge
    FROM price p
    JOIN shipment s ON transactions.ship_mode = s.ship_mode
    WHERE transactions.Transaction_ID = p.Transaction_ID
);

--select * from transactions;




























