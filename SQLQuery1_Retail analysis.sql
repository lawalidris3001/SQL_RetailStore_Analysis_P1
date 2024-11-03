-- SQL Retail analysis
-- Step 1 Create a database


Create Database Retail_Db;

-- step 2 Create a table

Use Retail_Db;



Create Table Sales_Transaction(
transactions_id	Int Primary key,
sale_date	Date,
sale_time time,
customer_id int,
gender Varchar(10),
age  int,
category Varchar(50),
quantity int,
price_per_unit  Money,
cogs  Money,
total_sale money
)


Select * From Sales_Transaction where quantity is null


--Data Cleaning


-- finding the columns with nulls
Select 
	Sum(Case when transactions_id is null then 1 else 0	End) as transactionID,
	Sum(Case when sale_date is null then 1 else 0	End) as Sale_date,
	Sum(Case when sale_time is null then 1 else 0	End) as sale_time,
	Sum(Case when customer_id is null then 1 else 0	End) as customer_id,
	Sum(Case when gender is null then 1 else 0	End) as gender,
	Sum(Case when age is null then 1 else 0	End) as age,
	Sum(Case when category is null then 1 else 0	End) as category,
	Sum(Case when quantity is null then 1 else 0	End) as quantity,
	Sum(Case when price_per_unit is null then 1 else 0	End) as price_per_unit,
	Sum(Case when cogs is null then 1 else 0	End) as cogs,
	Sum(Case when total_sale is null then 1 else 0	End) as total_sale
From 
	Sales_Transaction

-- Replace nulls
--1.age column

-- Replacing the null age with Average avge

Update Sales_Transaction set Age = (Select Avg(Age) From Sales_Transaction)
Where Age is null

-- Remove rows where Quantity is null

Delete From Sales_Transaction where quantity is null



-- EXPLORATORY DATA ANALYSIS

-- 1. how many sales do we have

Select distinct count(Transactions_id) Total_Transactions
From 
Sales_Transaction


--2 How many unique customer do we have

Select  count(distinct(customer_id)) Total_customers
From 
Sales_Transaction

--3 How many catergories do we have

Select distinct  category from 
Sales_Transaction


-- Main Data analysis and business key problem

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

select * From Sales_Transaction
Where sale_date = '2022-11-05'


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

Select * From Sales_Transaction
Where category = 'Clothing' and quantity >= 4
and FORMAT(sale_date, 'yyyy-MM') = '2022-11'
Order by sale_date

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

Select Category, Sum(Total_sale) Total_Sales, Count(*) total_orders
From Sales_Transaction
Group by category


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

Select Avg(Age) Avg_age From Sales_Transaction
Where category = 'Beauty'

--Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

Select * From Sales_Transaction
Where total_sale > 1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

Select Category,Gender, Count(transactions_id) Transactions
From Sales_Transaction
Group by Category,gender
Order by category

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

Select * From 
(
		Select YEAR(sale_date) as [Year],Datename(Month,Sale_date) as [Month], Avg(Total_sale) Avg_sales,
		RANK()OVER(Partition By YEAR(sale_date) order by Avg(Total_sale) desc ) Sales_Ranking
		From  Sales_Transaction
		Group by YEAR(sale_date),Datename(Month,Sale_date)
) as t1
where Sales_Ranking = 1


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

Select Top 5 customer_id, Sum(total_sale) Total_sales
From Sales_Transaction
Group by customer_id
ORder by Total_sales Desc


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

Select  Category, Count( distinct Customer_Id) Unique_customers
From Sales_transaction
Group by category
Order by Unique_customers 

--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

Select [Shift], Count(*) as Total_Orders From
(
	Select  *,
		Case when Datepart(hour,sale_time )<= '12' then 'Morning' 
			when Datepart(hour,sale_time ) Between '12' and '17' then 'Afternoon'
			Else 'Evening' end as [shift]
	From Sales_Transaction
) as S1
Group by [shift]