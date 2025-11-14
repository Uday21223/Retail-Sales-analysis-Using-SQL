create database myproject;          #database creation

use myproject;          # using the created database

CREATE TABLE retailsales (            #Table creation
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);


# we have a CSV file that contains  all the table data , steps to import that file
# step 1-->from left bar in your desktop right click on table under tour database name.
# step 2-->select table data import wizard
# step 3-->paste the address of your file and click next
# step 4--> use exixting table and click next and finish



select * from retailsales;           # checking structure of table


select count(*) from retailsales;            # number of frows (2000)



 #checking for null values
select count(*)   from retailsales     
WHERE 
    transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR
    cogs IS NULL OR
    total_sale IS NULL;
    
    
    
SELECT  COUNT(DISTINCT customer_id)    # total nmber of unique customers
AS unique_customer_count
FROM retailsales;



SELECT  COUNT(DISTINCT category)    # total nmber of unique categories
AS unique_customer_count
FROM retailsales;



# 1)Write a SQL query to retrieve all columns for sales made on '2022-11-05
# aANS-->  total 11 columns

select * from retailsales where  sale_date="2022-11-05";   

# 2)query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**
# ANS-->null value because no sales in that period

select * from retailsales 
where category="clothing" and quantity>4 and sale_date between "2022-11-01" and "2022-11-31";      



# 3)category wise sum of total sale

select sum(total_sale) as Category_wise_total_sales,category 
from retailsales 
group by category;         



 # 4) avg age of customer who parchased items from beauty category
 
select avg(age), category 
from retailsales 
group  by category;              



# 5)  total sale>1000

select * from retailsales 
where total_sale>1000;   


      
# 6)  count of transactions  made by each gender in each category

select count(transactions_id),gender 
from retailsales 
group by gender;    




 # 7) average sale for each month and out best selling month in each year
 
 with monthlysales as              
 ( SELECT YEAR(sale_date) AS Sale_Year,
        MONTH(sale_date) AS Sale_Month,
        AVG(total_sale) AS Average_monthly_sale,
        SUM(total_sale) AS Total_monthly_sale
    FROM 
        retailsales
    GROUP BY 
        YEAR(sale_date), 
        MONTH(sale_date)
	)
    select sale_year,sale_month,Average_monthly_sale,Total_monthly_sale 
    from monthlysales
    where total_monthly_sale=(
    select  max(total_monthly_sale)  from monthlysales as MS
    where MS.sale_year=monthlysales.sale_year
    )
ORDER BY 
    sale_year, 
    sale_month;
    
    
    
# 8) top 5 customers based on the highest total sales

select customer_id,sum(total_sale) as total_sales   
from retailsales
group by customer_id
order by total_sale
limit 5;



# 9) unique customers who purchased items from each category

select count(distinct customer_id) as Unique_customer_ID,category             
from retailsales 
group by category;



# 10)query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

select                                
case 
when hour(sale_time) < 12 then "Morning"
when hour(sale_time) between 12 and 17 then "afternoon"
else "evening"
end as Shift,
count(*)  as total_orders
from retailsales
group by shift;
