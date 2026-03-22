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



-- Creating dim_date


