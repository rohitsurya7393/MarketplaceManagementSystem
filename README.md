# 🛒 Marketplace Management System

## 📌 Project Description
The **Marketplace Management System** is designed to help businesses **analyze sales patterns, manage inventory efficiently, and enhance customer experience**. By leveraging **data analytics and powerful algorithms**, this system enables companies to make informed decisions about marketing, inventory optimization, and sales strategy.

## 🎯 Key Features
- **Real-time Sales Tracking**: Monitor customer purchase trends dynamically.
- **Customer Segmentation**: Categorize customers based on buying behavior.
- **Logistics Optimization**: Improve delivery efficiency by analyzing shipping data.
- **Inventory Management**: Predict demand and prevent stock shortages.
- **SQL Query Interface**: Execute queries for real-time data insights.
- **Flask Web Application**: A user-friendly interface for business insights.

---

## 🛠️ How to Run the Code

### 🔹 Prerequisites
Ensure you have the following installed:
- Python 3.x
- Flask
- PostgreSQL with **pgAdmin**
- Pandas, NumPy
- `psycopg2-binary` (for PostgreSQL connectivity)

 **Input dataset : https://www.kaggle.com/datasets/vivek468/superstore-dataset-final**

**Data Preprocessing**
 - The input dataset is imported into Jupyter notebook (Transformation.ipnyb) and the preprocessing is done.

 - Unnecessary columns are removed and Dummy Data is added in the first stage of Data Transformation.

 - After completing the transformation the output is stored in a csv format and saved in UTF encoding


**Importing Dataset into PGAdmin**
 - Connect to PG Admin using psql terminal

 - Execute the following command in psql command line to copy data from csv to the mega_table
   \copy mega_table FROM '/Users/rohithsurya/Documents/Lab/DMQL/Milestone2/output.csv' DELIMITER   ',' CSV HEADER;

 - Make sure that the create.sql code is executed before importing the .csv file as the sql file creates the mega table to which the csv file will be imported .

**Loading Data into tables**
 - The load.sql file has minor transformations in it which adjust the data for the relationships.
 - The insert into commands along with the filter conditions inserts the tuples from the mega table to the necessary sub tables.
 - Indexes are created in the create.sql file on two different tables

**How to Run Website**

 - Execute the following commands in terminal
 	pip install flask
	pip install psycopg2-binary

 - navigate to the website directory and open App.py file
 - Modify the local database details in the code
 - Run the App.py file using command python3 App.py
 - The live website starts running in localhost:5000
   
 Note : If the port is not free then we can use a different port by changing the value of port in line 32

- Once the website is running enter various queries and we get the necessary output
