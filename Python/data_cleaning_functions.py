''' Core for all functions
def clean_xxx(df):
    1. Fix data types
    2. Handle missing values
    3. Feature engineering (new columns)
    4. Standardize Data (Categories are in Protuguese, change them into English)
    5. Return cleaned dataframe
    
   return df'''

import pandas as pd

def load_data(path):
    """
    Load a CSV file into a pandas dataframe.
    """
    return pd.read_csv(path)

''' 
Orders Table

- change order timestamps into date time (year and month)
- create new columns, order_year and order_month
'''

# Changing time stamps to datetime
def clean_orders(df):
    date_columns = [
        'order_purchase_timestamp',
        'order_approved_at',
        'order_delivered_carrier_date',
        'order_delivered_customer_date',
        'order_estimated_delivery_date'
    ]
    for col in date_columns:
        df[col] = pd.to_datetime(df[col])

    # Creating new columns

    df['order_year'] = df['order_purchase_timestamp'].dt.year
    df['order_month'] = df['order_purchase_timestamp'].dt.month
        
    return df
    

'''
Customers Table:
- ensure no nulls (already done in explore.py. There are no nulls here)
- keep both ids (done)
'''
def clean_customers(df):
    df['customer_id'] = df['customer_id'].astype(str)
    df['customer_unique_id'] = df['customer_unique_id'].astype(str)
    return df
'''
Order Items
- Ensure: 
    price is in float data type
    Freight_value is also in float data type
'''
# Ensuring the datatypes are in float

def clean_order_items(df):
    df['price'] = df['price'].astype(float)
    df['freight_value'] = df['price'].astype(float)
    return df
'''
Payments:
- check payment_value type
- no major cleaning needed
'''
def clean_payments(df):
    df['payment_value'] = df['payment_value'].astype(float)
    return df

'''
Products Table:
- Handle missing values (product_category_name -> Null, fill with unknown)
- convert Portuguese to English
- Ensure numeric columns are float
'''
def clean_products(df, translation_df):
    df['product_category_name'] = df['product_category_name'].fillna('unknown')
    df = df.merge(translation_df, on='product_category_name', how='left')

    numeric_cols = [
        'product_name_lenght',
        'product_description_lenght',
        'product_photos_qty',
        'product_weight_g',
        'product_length_cm',
        'product_height_cm',
        'product_width_cm',
    ]
    for col in numeric_cols:
        df[col] = df[col].astype(float)

    return df


'''
Reviews table:
- keep null text
- ensure review_score is numeric
'''
def clean_reviews(df):
    df['review_score'] = df['review_score'].astype(int)

    return df


'''
Geolocation
- drop duplicates
'''
def clean_geolocation(df):
    df = df.drop_duplicates()
    return df


def save_data(df, path):
    df.to_csv(path, index=False)

 

