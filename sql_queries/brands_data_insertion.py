import pandas as pd
import psycopg2
db_config = {
    'user': 'postgres',
    'password': 'password',
    'host': 'localhost',
    'port': '5434',
    'database': 'postgres'
}

conn = psycopg2.connect(**db_config)
cursor = conn.cursor()

csv_file = 'C:/Users/gopio/Downloads/Fetch/brands.csv'
df = pd.read_csv(csv_file)

timestamp_columns = ['createdDate', 'lastLogin']
for col in timestamp_columns:
    if col in df.columns:
        df[col] = df[col].where(pd.notnull(df[col]), None)

df['topBrand'] = df['topBrand'].apply(lambda x: None if pd.isna(x) else x)

table_name = 'brands'

for index, row in df.iterrows():
    cursor.execute(
        f"INSERT INTO Fetchrewards.{table_name} (barcode, category, categoryCode, name, topBrand, brandCode, brandId, cpgId, cpgRef) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
        (row['barcode'], row['category'], row['categoryCode'], row['name'], row['topBrand'], row['brandCode'], row['brandId'],row['cpgId'],row['cpgRef'])
    )
conn.commit()