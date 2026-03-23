/* Facts table creation and value insertion
*/

create table fact_sales(
	
	order_item_id varchar not null,
	order_id varchar not null,
	customer_id varchar not null,
	product_id varchar not null,
	seller_id varchar not null,
	order_purchase_timestamp timestamp,
	order_approved_at timestamp,
	order_delivered_carrier_date timestamp,
	order_delivered_customer_date timestamp,
	order_estimated_delivery_date timestamp,
	price float not null,
	freight_value float,
	payment_value float,
	order_year int,
	order_month int,
	
	primary key (order_id, order_item_id)
);

insert into fact_sales (
	order_item_id,
	order_id,
	customer_id,
	product_id,
	seller_id,
	order_purchase_timestamp,
	order_approved_at,
	order_delivered_carrier_date,
	order_delivered_customer_date,
	order_estimated_delivery_date,
	order_year,
	order_month,
	price,
	freight_value,
	payment_value
)
select 
    oi.order_item_id,
    oi.order_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    o.order_year,
    o.order_month,
    oi.price,
    oi.freight_value,
    p.total_payment 
from order_items oi 
join orders o
	on oi.order_id = o.order_id
left join(
	select order_id,
	sum(payment_value) as total_payment
	from payments
	group by order_id
) p
	on oi.order_id = p.order_id;


select count(*) from fact_sales;

select count(*) from order_items;


select order_id, order_item_id, count(*)
from fact_sales t 
group by order_id, order_item_id 
having count(*) > 1;


select sum(price) from order_items;

select sum(price) from fact_sales;


select * from fact_sales t 
limit 10;



/* 
 * Dimension tables creation
 */

-- Customers table

create table dim_customer(
	customer_unique_id varchar primary key,
	customer_zip_code_prefix int,
	customer_city varchar,
	customer_state varchar
);

insert into dim_customer(
	customer_unique_id,
	customer_zip_code_prefix,
	customer_city,
	customer_state
)
select  
	customer_unique_id,
	min(customer_zip_code_prefix) as customer_zip_code_prefix,
	min(customer_city) as customer_city,
	min(customer_state) as customer_state
from customers
group by customer_unique_id;


select * from dim_customer


-- Products table

create table dim_product(
	product_id varchar primary key,
	product_category_name_english varchar,
	product_weight_g float,
	product_length_cm float,
	product_height_cm float,
	product_width_cm float
)

-- handle nulls in category_name in products table
-- translate the category names into english 

insert into dim_product(
	product_id,
	product_category_name_english,
	product_weight_g,
	product_length_cm,
	product_height_cm,
	product_width_cm
)
select 
	p.product_id,
	coalesce(t.product_category_name_english, 'unknown') as product_category_name_english,
	p.product_weight_g,
	p.product_length_cm,
	p.product_height_cm,
	p.product_width_cm
from products p
left join product_category_name_translation t
	on p.product_category_name = t.product_category_name

-- validating data count
	
select count(*) from dim_product;

select count(*) from products;

-- checking for duplicates

SELECT product_id, COUNT(*)
FROM dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;



-- Creating dim_seller

create table dim_seller(
	seller_id varchar primary key,
	seller_city varchar,
	seller_state varchar, 
	seller_zip_code_prefix varchar
);

-- selecting and inserting data into dim_sellers



insert into dim_seller(
	seller_id,
	seller_city,
	seller_state,
	seller_zip_code_prefix
)
select 
	s.seller_id,
	s.seller_city,
	s.seller_state,
	s.seller_zip_code_prefix
from sellers s;

select * from dim_seller ds 
limit 10;



/* 
 * Now for the Analytics. 
 * First, revenue analysis, group by year, order by month, and see when do the orders spike, ie. what time of the year has more sales. 
 */

select 
	order_year,
	order_month,
	sum(price) as total_revenue,
	count(distinct order_id) as total_orders,
	sum(price)/count(distinct order_id) as avg_order_value
from fact_sales
group by fact_sales.order_year, fact_sales.order_month 
order by fact_sales.order_year, fact_sales.order_month 


-- Revenue analysis by product category

select
	dp.product_category_name_english as category,
	sum(fs.price) as total_revenue,
	count(*) as total_sold,
	avg(fs.price) as average_price
from fact_sales fs
join dim_product dp 
	on dp.product_id = fs.product_id 
group by dp.product_category_name_english 
order by total_revenue desc;


--- Customer Analysis


-- Total customers (customer_unique_id count)
SELECT 
    COUNT(DISTINCT c.customer_unique_id) AS total_customers
FROM fact_sales fs
JOIN orders o 
    ON fs.order_id = o.order_id
JOIN customers c 
    ON o.customer_id = c.customer_id;



-- Orders per customer (using CTE)
WITH customer_orders AS (
    SELECT 
        c.customer_unique_id,
        COUNT(DISTINCT fs.order_id) AS total_orders
    FROM fact_sales fs
    JOIN orders o 
        ON fs.order_id = o.order_id
    JOIN customers c 
        ON o.customer_id = c.customer_id
    GROUP BY c.customer_unique_id
)
select
	count(case when total_orders = 1 then 1 end) as new_customers,
	count(case when total_orders > 1 then 1 end) as returning_customers
from customer_orders;

/*
 * New customers = 92507
 * Returning customers = 2913
 */

-- Total spent per customer
SELECT 
    c.customer_unique_id,
    SUM(fs.price) AS customer_lifetime_value
FROM fact_sales fs
JOIN orders o 
    ON fs.order_id = o.order_id
JOIN customers c 
    ON o.customer_id = c.customer_id
GROUP BY c.customer_unique_id
ORDER BY customer_lifetime_value DESC;


-- Average money spent per customer
select avg(customer_spend) as avg_customer_spend
from(
	select 
		c.customer_unique_id,
		sum(fs.price) as customer_spend
	from fact_sales  fs
		join orders o on o.customer_id = fs.customer_id 
		join customers c on c.customer_id = fs.customer_id 
	group by c.customer_unique_id 
) t;
 -- Average_customer_spend = 141.7305


-- Order delivery analysis (customer experience analysis)


-- Average delivery time
SELECT 
    AVG(order_delivered_customer_date - order_purchase_timestamp) AS avg_delivery_time
FROM fact_sales
WHERE order_delivered_customer_date IS NOT NULL;
-- 12 Days

-- Delivery delay analysis
select 
	avg(order_delivered_customer_date - order_estimated_delivery_date)
	from fact_sales 
where order_delivered_customer_date is not null;
-- Order is being delivered before the estimated time which is good. 

-- Ontime vs late delivery analysis

select 
	case
		when order_delivered_customer_date > order_estimated_delivery_date
		then 'Late'
		else 'On-Time'
	end as delivery_status,
	count(*) as total_orders
from fact_sales
where order_delivered_customer_date is not null
group by delivery_status;

/*
 * Late deliveries = 8715
 * On-Time deliveries = 101,481
 */

-- Total delivery time trend

select
	order_year,
	order_month,
	avg(order_delivered_customer_date - order_purchase_timestamp) as average_delivery_time
from fact_sales 
where order_delivered_customer_date is not null
group by order_year, order_month
order by order_year, order_month;



	
