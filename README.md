## Retail Sales Analysis SQL Project

#**Project Overview**
**Project Title**: Retail Sales Analysis
**Database**: retail_data

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. 

##**Objectives**
1. Set up a retail sales database: Create and populate a retail sales database with the provided sales data.
2. Data Cleaning: Identify and remove any records with missing or null values.
3. Exploratory Data Analysis (EDA): Perform basic exploratory data analysis to understand the dataset.
4. Business Analysis: Use SQL to answer specific business questions and derive insights from the sales data.

##**Project Structure**
1. *Database Setup*
Database Creation: The project starts by creating a database named p1_retail_db.
Table Creation: A table named retail_sales is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE TABLE retail 
(transactions_id INT PRIMARY KEY,
  sale_date date,
  sale_time time, 
  customer_id INT,
  gender VARCHAR(15),
  age INT,
  category VARCHAR(15),
  quantity INT,
  price_per_unit FLOAT,
  cogs FLOAT,
  total_sale FLOAT
);
```

2. #Data Exploration & Cleaning
Record Count: Determine the total number of records in the dataset.
Customer Count: Find out how many unique customers are in the dataset.
Category Count: Identify all unique product categories in the dataset.
Null Value Check: Check for any null values in the dataset and delete records with missing data.

--Double checking the dataset
```sql
select * from retail;
select count(*) from retail; -- All 2000 rows have been loaded all well
```

---Data Cleaning
```sql
select *
from retail
where transactions_id is null;
```

--Checking for NULL Values 
```sql
select *
from retail
where transactions_id is null 
or
sale_date is null 
or
sale_time is null
or
gender is null 
or 
category is null
or
quantity is null
or 
cogs is null
or 
total_sale is null;``` ---3 null records 

--Let's delete
```sql
delete from retail 
where transactions_id is null 
or
sale_date is null 
or
sale_time is null
or
gender is null 
or 
category is null
or
quantity is null
or 
cogs is null
or 
total_sale is null;``` ----3 records deleted

---Data Exploration 

--1. How many sales do we have?
```sql
select count(*) as Total_Sales
from retail```;

--2. How many customers do we have?
```sql
select count(distinct customer_id) as Total_Customers
from retail```; 

--3. How many Categories do we have?
```sql
select count(distinct category) as Total_Category
from retail```;

3. ###**Data Analysis & Findings**
The following SQL queries were developed to answer specific business questions:

**1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'**

```sql
select *
from retail
where sale_date = '2022-11-05';
```
**--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the 
--quantity sold is equal or more than 4 in the month of Nov-2022**
```sql
select *
from retail
where (Category = 'Clothing')
and
(quantity >= 4)
and
(to_char(sale_date, 'YYYY-MM') ='2022-11');
```
**--3. Write a SQL query to calculate the total sales (total_sale) for each category**

```sql
select category, sum(total_sale) as Total_Sales
from retail
group by category;
```
**--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**

```sql
select Category, round(avg(age),2) as Average_Age
from retail
where category = 'Beauty'
group by Category;
```
**--5 Write a SQL query to find all transactions where the total_sale is greater than 1000**
```sql
select *
from retail 
where total_sale > 1000;
```
**--6 Write a SQL query to find the total number of transactions**
--(transaction_id) made by each gender in each category

```sql
select category, gender, count(*) as Total_Transactions
from retail
group by category, gender;
```
-**-7. Write a query to calculate the average sale for each month. Find out best selling month in each year**

```sql
select * from
(select extract(year from sale_date) as year,
extract(month from sale_date) as month, 
avg(total_sale) as Average_Sales,
rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail
group by year, month) as t1
where rank = 1;
```
-**-8. Write a SQL query to find the top 5 customers based on the highest total sales**

```sql
select customer_id, sum(total_sale) as Total_Sales
from retail
group by customer_id
order by Total_Sales desc
limit 5;
```
**--9. Write a SQL query to find the number of unique customers who purchased items from each category.**

```sql
select count(distinct customer_id) as Unique_Customers, category
from retail
group by category;
```

**--10. Write a SQL query to create each shift and number of orders**

```sql
With hourly_sales
as
(select *,
case
when extract(hour from sale_time) < 12  then 'Morning'
when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
else 'Evening'
end as Shift
from retail)
select shift, count(*) as total_orders
from 
hourly_sales
group by shift;
```
