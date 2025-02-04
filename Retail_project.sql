CREATE DATABASE Retail_project;
use Retail_project;

SELECT*from retail_sales;

-- Checking for Null values

SELECT* from retail_sales
Where
	ï»¿transactions_id is null
    or sale_date is null
	or sale_time is null
	or customer_id is null
    or gender is null
    or  age is null
    or category is null
    or quantiy is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null;
    
    
    -- Data Exploration
    -- How many records we have'
    
    SELECT count(*) as total_sales from retail_sales;
    
    -- Total Number of customers
    
    SELECT count(distinct customer_id) as total_cust from retail_sales;
    
-- Data Ananlysis and Business Key Problems.
-- Q1. Write a SQL query to retrieve all coluns for sales made on '2022-11-05'.

SELECT*FROM retail_sales 
where sale_date= '2022-11-05';

-- Q2 Write a SQL query to retieve all transactons where category is 'clothing' and quantity sold is more than 4 in the month of Nov-2022.

SELECT  * from retail_sales 
where  category='clothing' and
month(sale_date)=11
and 
year(sale_date)= 2022;


-- date_format(sale_date,"%Y-%m") = '2022-11';

SELECT *  
FROM retail_sales 
WHERE category = 'Clothing'  
and quantiy >=4
AND date_format(sale_date,"%Y-%m") = '2022-11';

-- Q3 Write a sql query to calculate the total sales for each category

SELECT 
	category,
    sum(total_sale) net_sale,
    count(*) as total_orders
FROM 
	retail_sales
GROUP BY
	category
ORDER BY 
	sum(total_sale) desc;
    
-- Q4 Write a SQL query to calculate the Average Age of customers who purchased items from the 'Beauty" Category.

SELECT*from retail_sales;
SELECT avg(age) as avg_age, category
from retail_sales
GROUP BY category
having
category = 'Beauty';

-- Q5 Write a SQl query to find all transactions where total_sale is greater than 1000.

SELECT * from retail_sales
where total_sale>1000;

-- Q6 Write a SQL query to find the totla number of transactions made by each gender in each category.

SELECT category,gender,count(*) as total_transactions 
from retail_sales 
GROUP BY 1,2
ORDER BY 1;

-- Write a SQL query  to calculate the average sale for each month. Find out the best selling month in each year.
SELECT*from(

SELECT date_format(sale_date, "%Y") as Years, date_format(sale_date, "%M") as Months, avg(total_sale) Avg_sale_each_Months,
RANK()over(PARTITION BY date_format(sale_date, "%Y")  ORDER BY avg(total_sale) desc) rnk from retail_sales
GROUP BY 1,2
ORDER BY 1,3 desc)temp2
where rnk=1;

-- Write a sql query to find the top 5 customers based on the highest total sales

SELECT * from retail_sales;
with new_retail_sales as (
SELECT  customer_id, sum(total_sale) as total_sale_by_each_customer,
DENSE_RANK()over(ORDER BY sum(total_sale) desc) drnk from retail_sales
GROUP BY customer_id)
SELECT * FROM new_retail_sales
where drnk<=5;

-- Write a SQL query to find the number of unique customers who purchased items from each category.

select count(DISTINCT customer_id), category from retail_sales
GROUP BY category;

-- Write a SQL query to create each shift and number of orders ( example morning <=12, Afternoon between 12 and 17, Evening >17)
SELECT shift , count(*) as total_orders from (
SELECT* ,
case when hour(sale_time) <= 12 then "Morning"
when hour(sale_time) BETWEEN 12 and 17 then "Afternoon"
else 'Evening' end as shift
from retail_sales)temp
GROUP BY shift;
