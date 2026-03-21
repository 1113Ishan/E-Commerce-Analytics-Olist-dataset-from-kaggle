create table fact_sales(
	
	order_item_id varchar primary key,
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
	order_mont int
	
)


with payments_agg as(
	select 
	order_id, sum(payment_value) as total_payment
	from payments 
	group by order_id 
)
select * 
from payments_agg;


