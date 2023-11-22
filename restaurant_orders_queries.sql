-- sum of revenue
select 
	sum(price) as 'sum_of_revenue' 
from 
data_to_analyze dta 

-- ordered items
select 
	count(order_details_id) as 'number_of_ordered_items'
from 
data_to_analyze dta 

-- number of orders
select 
	count(distinct order_id) as 'number_of_orders'
from 
data_to_analyze dta 

-- average price per order
select 
	round(sum(price)/count(distinct order_id),2) as 'average_price_per_order'  
from 
data_to_analyze dta 

-- max price per order
select 
	order_id 
	,sum(if(order_id=order_id,price,0)) as 'price_per_order' 
from 
data_to_analyze dta 
group by 1
order by sum(if(order_id=order_id,price,0)) desc 

-- What were the least and most ordered items? What categories were they in?
select 
	item_name 
	,category 
	,count(item_name) as 'item_name' 
from 
data_to_analyze dta 
group by 1,2
having item_name is not null 
order by count(item_name) asc
limit 10

select 
	item_name 
	,category 
	,count(item_name) as 'item_name' 
from 
data_to_analyze dta 
group by 1,2
having item_name is not null 
order by count(item_name) desc 
limit 10

/*
What do the highest spend orders look like? 
Which items did they buy and how much did they spend?
*/

alter table data_to_analyze add column price_for_order float 

update data_to_analyze 
set price_for_order = (
select 
	sum(price)
from (
select 
	order_id 
	,price
from data_to_analyze
    ) as subquery
where subquery.order_id = data_to_analyze.order_id 
)
where price_for_order is null 

-- number of items by category in orders over 150$

select 
	category 
	,count(category) as 'number_of_items'
from 
data_to_analyze dta 
where price_for_order > 150
group by 1
order by count(category) desc 

-- number of items by item name in orders over 150$

select 
	item_name 
	,category 
	,count(item_name) as 'number_of_items'
from 
data_to_analyze dta 
where price_for_order > 150
group by 1,2
order by count(item_name) desc 

-- Were there certain times that had more or less orders?

alter table data_to_analyze add column order_hour decimal

update data_to_analyze 
set order_hour = hour(order_time)
where order_hour is null 

select 
	order_hour 
	,count( distinct (order_id)) as 'number_of_orders'
from 
data_to_analyze dta 
group by 1
order by count( distinct (order_id)) desc 

/* Which cuisines should we focus on developing more 
   menu items for based on the data? */

select 
	category 
	,count(category) as 'number_of_items'
	,sum(price) as 'revenue' 
from 
data_to_analyze dta 
group by 1
order by sum(price) desc 