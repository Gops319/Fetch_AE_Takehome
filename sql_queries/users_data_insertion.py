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
csv_file = 'C:/Users/gopio/Downloads/Fetch/users.csv'
df = pd.read_csv(csv_file)

timestamp_columns = ['createdDate', 'lastLogin'] 
for col in timestamp_columns:
    if col in df.columns:
        df[col] = df[col].where(pd.notnull(df[col]), None)

table_name = 'users'

for index, row in df.iterrows():
    cursor.execute(
        f"INSERT INTO Fetchrewards.{table_name} (userId, active, createdDate, lastLogin, role, signUpSource, state) VALUES (%s, %s, %s, %s, %s, %s, %s)",
        (row['userId'], row['active'], row['createdDate'], row['lastLogin'], row['role'], row['signUpSource'], row['state'])
    )
conn.commit()