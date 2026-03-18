import pandas as pd
import os

folder_path = "dataset for E-Commerce Anaytics\Dataset"

for file in os.listdir(folder_path):
    if file.endswith(".csv"):
        print(f"\n\n===== {file} =====")

        df = pd.read_csv(os.path.join(folder_path, file))

        print("\n===== BASIC INFO =====")
        print("Shape (Rows, Columns):", df.shape)
        print("\nColumns:")
        print(df.columns)

        print("\n===== DATA TYPES =====")
        df.info()

        print("\n===== SAMPLE DATA =====")
        print(df.head())

        print("\n===== NULL VALUES COUNT =====")
        null_cal = df.isnull().sum()
        if(null_cal.sum()!=0):
            print(null_cal)
        else:
            print("No Null values")


        print("\n===== DUPLICATES =====")
        duplicates = df.duplicated().sum()
        if(duplicates.sum()!=0):
            print(duplicates)
        else:
            print("No duplicates")

