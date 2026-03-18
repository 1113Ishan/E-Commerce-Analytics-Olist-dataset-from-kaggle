import pandas as pd
import os
from data_cleaning_functions import *

raw_data_path = 'dataset for E-Commerce Anaytics/Dataset/Raw'
clean_data_path = 'dataset for E-Commerce Anaytics/Dataset/Cleaned'

tables = {
    'customers_dataset.csv': clean_customers,
    'geolocation_dataset.csv': clean_geolocation,
    'order_items_dataset.csv': clean_order_items,
    'order_reviews_dataset.csv': clean_reviews,
    'orders_dataset.csv': clean_orders,
    'payments_dataset.csv': clean_payments,
    'products_dataset.csv': lambda df: clean_products(df, load_data(os.path.join(raw_data_path, 'product_category_name_translation.csv'))),
    'sellers_dataset.csv': lambda df:df,    
}

# Looping through the tables

for file_name, clean_func in tables.items():
    print(f"Processing {file_name} ...")

    # load raw data
    df = load_data(os.path.join(raw_data_path, file_name))

    # clean data
    df_clean = clean_func(df)

    # save data
    save_data(df_clean, os.path.join(clean_data_path, file_name))

    print(f"Saved the clean data for {file_name}")

