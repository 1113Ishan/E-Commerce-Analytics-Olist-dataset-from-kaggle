# &#x20;Pre-analysis of all datasets





##### ===== customers\_dataset.csv =====



**===== BASIC INFO =====**

Shape (Rows, Columns): (99441, 5)



Columns:

Index\['customer\_id', 'customer\_unique\_id', 'customer\_zip\_code\_prefix',

&#x20;      'customer\_city', 'customer\_state'])



* customer\_id is the primary key.
* customer\_unique\_id represents the actual unique customer (business key)



**datatypes**: int64(1), str(4)



**===== NULL VALUES COUNT =====**

No Null values



**===== DUPLICATES =====**

No duplicates



**Notes**:

* This table contains information about the customers. 
* customer\_id is unique per order not per customer
* customer\_unique\_id will be used to count customers as customer\_id will over count because there can be multiple orders from the same customer. 
* This data will be used to count number of customers, and track orders based on the customers.





##### ===== geolocation\_dataset.csv =====



**===== BASIC INFO =====**

Shape (Rows, Columns): (1000163, 5)



Columns:

Index(\['geolocation\_zip\_code\_prefix', 'geolocation\_lat', 'geolocation\_lng',

&#x20;      'geolocation\_city', 'geolocation\_state'])



**datatypes**: float64(2), int64(1), str(2)



**===== NULL VALUES COUNT =====**

No Null values



**===== DUPLICATES =====**

261831 (There are 261831 duplicate rows which show identical records exist multiple times)



Notes:

* This dataset contains information about the geolocation of the orders
* It will be used for mapping customer and seller locations and also for geographic distribution analysis





##### ===== orders\_dataset.csv =====



**===== BASIC INFO =====**

Shape (Rows, Columns): (99441, 8)



**Columns:**

Index(\['order\_id', 'customer\_id', 'order\_status', 'order\_purchase\_timestamp',

&#x20;      'order\_approved\_at', 'order\_delivered\_carrier\_date',

&#x20;      'order\_delivered\_customer\_date', 'order\_estimated\_delivery\_date'])



* order\_id is the primary key here. 
* customer\_id is a foreign key.



**dtypes**: str(8)



**===== NULL VALUES COUNT =====**

order\_id                            0

customer\_id                         0

order\_status                        0

order\_purchase\_timestamp            0

order\_approved\_at                 160

order\_delivered\_carrier\_date     1783

order\_delivered\_customer\_date    2965

order\_estimated\_delivery\_date       0



**===== DUPLICATES =====**

No duplicates



**Notes:**

* This is the central dataset for all orders. 
* This dataset will be used to compute total orders, their delivery status and know the relationship between order and customer via customer\_id





##### **===== order\_items\_dataset.csv =====**



**===== BASIC INFO =====**

Shape (Rows, Columns): (112650, 7)



Columns:

Index(\['order\_id', 'order\_item\_id', 'product\_id', 'seller\_id',

&#x20;      'shipping\_limit\_date', 'price', 'freight\_value'])



* order\_id is the foreign key from orders\_dataset.csv.
* (order\_item\_id, order\_id) is the primary key for this dataset. (A composite key) Because order\_item\_id is only unique for an item inside an order.
* product\_id and seller\_id are the foreign keys for products\_dataset.csv and seller\_dataset.csv.



**dtypes**: float64(2), int64(1), str(4)



**===== NULL VALUES COUNT =====**

No Null values



**===== DUPLICATES =====**

No duplicates



**Notes**:

* This dataset contains information about the items that are being purchased in each order. 
* It will be used to find the relationship between order, product, and seller. 



##### ===== order\_payments\_dataset.csv =====



**===== BASIC INFO =====**

Shape (Rows, Columns): (103886, 5)



Columns:

Index(\['order\_id', 'payment\_sequential', 'payment\_type',

&#x20;      'payment\_installments', 'payment\_value'])



* order\_id is the foreign key in this table from orders dataset.



**dtypes**: float64(1), int64(2), str(2)



**===== NULL VALUES COUNT =====**

No Null values



**===== DUPLICATES =====**

No duplicates



**Notes:**

* This dataset will help to track payment for each order. 





##### ===== order\_reviews\_dataset.csv =====



**===== BASIC INFO =====**

Shape (Rows, Columns): (99224, 7)



**Columns**:

Index(\['review\_id', 'order\_id', 'review\_score', 'review\_comment\_title',

&#x20;      'review\_comment\_message', 'review\_creation\_date',

&#x20;      'review\_answer\_timestamp'])



* review\_id is the primary key in this dataset
* order\_id is the foreign key from orders dataset



**dtypes**: int64(1), str(6)



**===== NULL VALUES COUNT =====**

review\_id                      0

order\_id                       0

review\_score                   0

review\_comment\_title       87656

review\_comment\_message     58247

review\_creation\_date           0

review\_answer\_timestamp        0

dtype: int64



**===== DUPLICATES =====**

No duplicates



**Notes:**

* It tracks orders and their reviews
* Not all products get reviews
* This dataset will be used to check for reviews for each product purchased. 



##### **===== products\_dataset.csv =====**



**===== BASIC INFO =====**

Shape (Rows, Columns): (32951, 9)



Columns:

Index(\['product\_id', 'product\_category\_name', 'product\_name\_lenght',

&#x20;      'product\_description\_lenght', 'product\_photos\_qty', 'product\_weight\_g',

&#x20;      'product\_length\_cm', 'product\_height\_cm', 'product\_width\_cm']')



* product\_id is the primary key for this dataset



**dtypes**: float64(7), str(2)



**===== NULL VALUES COUNT =====**

product\_id                      0

product\_category\_name         610

product\_name\_lenght           610

product\_description\_lenght    610

product\_photos\_qty            610

product\_weight\_g                2

product\_length\_cm               2

product\_height\_cm               2

product\_width\_cm                2

dtype: int64



**===== DUPLICATES =====**

No duplicates



**Notes**:

* This table has the details of every product





##### ===== sellers\_dataset.csv =====



**===== BASIC INFO =====**

Shape (Rows, Columns): (3095, 4)



**Columns**:

Index(\['seller\_id', 'seller\_zip\_code\_prefix', 'seller\_city', 'seller\_state']) 



* seller\_id is the primary key for this dataset.



**dtypes**: int64(1), str(3)



**===== NULL VALUES COUNT =====**

No Null values



**===== DUPLICATES =====**

No duplicates



**Notes:**

* This dataset has the details of every seller. 





##### ===== product\_category\_name\_translation.csv =====



**===== BASIC INFO =====**

Shape (Rows, Columns): (71, 2)



**Columns**:

Index(\['product\_category\_name', 'product\_category\_name\_english'])



**dtypes**: str(2)



**===== NULL VALUES COUNT =====**

No Null values



**===== DUPLICATES =====**

No duplicates



**Notes:**

* This dataset will help in the calculation of products in different categories





##### Extra notes

**orders**:

\- total rows: 99441

\- unique order\_id: 99441 → valid primary key



**products**:

\- total rows: 32951

\- unique product\_id: 32951 → valid primary key



**customers**:

\- customer\_id is unique per row

\- customer\_unique\_id has fewer unique values → confirms repeat customers



order\_**items**:

\- order\_item\_id alone is not unique

\- (order\_id, order\_item\_id) combination is unique

\- Joining these tables without aggregation will duplicate revenue

\- Must aggregate payments before joining



**Important** **Observation**:

\- order\_items contains multiple rows per order

\- payments may also contain multiple rows per order

\- orders is the central table connecting all entities

\- order\_items provides product-level granularity

\- payments provides revenue data and must be aggregated before joins

\- customers require use of customer\_unique\_id for accurate analysis

\- product categories require translation to English



This structure supports building a star schema with:

\- fact table: sales

\- dimension tables: customer, product, seller, date





