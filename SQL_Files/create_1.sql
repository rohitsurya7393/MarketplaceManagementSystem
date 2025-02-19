
drop table Mega_Table;

CREATE TABLE Mega_Table (
    Transaction_ID float,
    Order_ID varchar(20),
    Order_Date text,           
    Ship_Date text,            
    Ship_Mode varchar(20),
    Customer_ID varchar(20),x
    Customer_Name varchar(50),
    Segment varchar(20),
    Country varchar(20),
    City varchar(20),
    State varchar(20),
    Postal_Code float,
    Region varchar(20),
    Product_ID varchar(20),
    Category varchar(20),
    Sub_Category varchar(20),
    Product_Name varchar(200),
    Quantity float,
    Shipping_Charge float,
    Shipping_Desc varchar(50),
    Price_per_Item float,
    Profit_percent float,
    Total_Cost_price float,
    Total_Sale_price float,
    Final_price float
);

select * from mega_table;

-- Transforming Date Columns After Importing data from csv file

UPDATE Mega_Table
SET Order_Date = TO_DATE(Order_Date, 'MM/DD/YYYY'),
    Ship_Date = TO_DATE(Ship_Date, 'MM/DD/YYYY');
	
ALTER TABLE Mega_Table
ALTER COLUMN Order_Date TYPE date USING Order_Date::date,
ALTER COLUMN Ship_Date TYPE date USING Ship_Date::date;

ALTER TABLE Order_to_ship
ALTER COLUMN Order_Date TYPE date USING Order_Date::date,
ALTER COLUMN Ship_Date TYPE date USING Ship_Date::date;

UPDATE Order_to_ship
SET Order_Date = TO_DATE(Order_Date, 'MM/DD/YYYY'),
    Ship_Date = TO_DATE(Ship_Date, 'MM/DD/YYYY');
	




-- Creating Tables

-- Create Shipment Table
CREATE TABLE Shipment (
	Ship_Mode varchar(20) PRIMARY KEY,
	Shipping_Charge float,
    Shipping_Desc varchar(50)
);


-- Create Address Table
CREATE TABLE Address (
    Postal_Code float PRIMARY KEY,
    Region varchar(20),
	City varchar(20),
	State varchar(20),
	Country varchar(20)
);

-- Create Segments Table 
Create TABLE Segments (
	Segment_ID varchar(20) PRIMARY KEY,
	Segment varchar(50),
	Profit_percent integer
);

-- Create Customer Details Table
CREATE TABLE Customer_details (
    
    Customer_ID varchar(20) PRIMARY KEY,
    Customer_Name varchar(50),
    Segment_ID varchar(20) REFERENCES Segments(Segment_ID) ON DELETE CASCADE ,
    Postal_Code float REFERENCES Address(Postal_Code) ON DELETE CASCADE
);

-- Create Orders table
CREATE TABLE Orders (
	Order_ID varchar(20),
	Product_ID varchar(20),
	Quantity integer,
	PRIMARY KEY(ORDER_ID , PRODUCT_ID)
);

-- Create Price Table 
CREATE TABLE Price (
    Transaction_ID float PRIMARY KEY,
    Total_Cost_price float,
    Total_Sale_price float,
    Profit numeric GENERATED ALWAYS AS (Total_Sale_price - Total_Cost_price) Stored
);

-- Create Order to ship table
CREATE TABLE Order_to_Ship(
	--Transaction_ID float,
    Order_ID varchar(20) Primary Key,
    Order_Date text,           
    Ship_Date text   
	
);

-- Create Category Table

CREATE TABLE Categories (
	Category_ID SERIAL PRIMARY KEY,
    Category varchar(20) ,
    Sub_Category varchar(20)    
);

-- Create Product Table

CREATE TABLE Products (
    
    Product_ID varchar(20),
    Category_ID integer REFERENCES Categories(Category_ID) ON DELETE CASCADE,
    Product_Name varchar(200),
    Price_per_Item float
);


--Create Transactions Table
-- Create and load the following table after loading data into the products table

'''
Create Table Transactions (
	Transaction_ID float PRIMARY KEY,
	Order_ID varchar(20),
	Customer_ID varchar(20) REFERENCES Customer_details(Customer_ID),
	Product_ID varchar(20) REFERENCES Products(Product_ID),
	Quantity float,
	Ship_Mode varchar(20) References Shipment(Ship_Mode),
	Final_price float
);
'''



CREATE INDEX trans_idx  ON transactions USING HASH (transaction_id);

SELECT * FROM pg_indexes
WHERE indexname = 'trans_idx';


CREATE INDEX order_product  ON Orders(Order_ID , Product_ID);

SELECT * FROM pg_indexes
WHERE indexname = 'order_product';


















