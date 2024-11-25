--- SQL Retail Sales Analysis

--Creating Table - Retail
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

--Double checking the dataset
select * from retail;
select count(*) from retail; -- All 2000 rows have been loaded all well

---Data Cleaning
select *
from retail
where transactions_id is null;

--Checking for NULL Values 
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
total_sale is null; ---3 null records 

--Let's delete
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
total_sale is null; ----3 records deleted

---Data Exploration 

--1. How many sales do we have?
select count(*) as Total_Sales
from retail;

--2. How many customers do we have?
select count(distinct customer_id) as Total_Customers
from retail; 

--3. How many Categories do we have?
select count(distinct category) as Total_Category
from retail;

--BUSINESS PROBLEMS/ DATA ANALYSIS and SOLUTIONS

--1. Write a SQL query to retrieve all columns for sales made on '2022-11-05

select *
from retail
where sale_date = '2022-11-05';

--2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the 
--quantity sold is equal or more than 4 in the month of Nov-2022
select *
from retail
where (Category = 'Clothing')
and
(quantity >= 4)
and
(to_char(sale_date, 'YYYY-MM') ='2022-11');

--3. Write a SQL query to calculate the total sales (total_sale) for each category

select category, sum(total_sale) as Total_Sales
from retail
group by category;

--4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

select Category, round(avg(age),2) as Average_Age
from retail
where category = 'Beauty'
group by Category;

--5 Write a SQL query to find all transactions where the total_sale is greater than 1000
select *
from retail 
where total_sale > 1000;

--6 Write a SQL query to find the total number of transactions 
--(transaction_id) made by each gender in each category

select category, gender, count(*) as Total_Transactions
from retail
group by category, gender;

--7. Write a query to calculate the average sale for each month. Find out best selling month in each year

select * from
(select extract(year from sale_date) as year,
extract(month from sale_date) as month, 
avg(total_sale) as Average_Sales,
rank() over (partition by extract(year from sale_date) order by avg(total_sale) desc) as rank
from retail
group by year, month) as t1
where rank = 1;

--8. Write a SQL query to find the top 5 customers based on the highest total sales

select customer_id, sum(total_sale) as Total_Sales
from retail
group by customer_id
order by Total_Sales desc
limit 5;

--9. Write a SQL query to find the number of unique customers who purchased items from each category.

select count(distinct customer_id) as Unique_Customers, category
from retail
group by category;


--10. Write a SQL query to create each shift and number of orders 

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

--End of Project