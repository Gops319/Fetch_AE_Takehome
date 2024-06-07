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

csv_file = 'C:/Users/gopio/Downloads/Fetch/receipts.csv'
df = pd.read_csv(csv_file)

timestamp_columns = ['createdDate', 'dateScanned','finishedDate','modifyDate','pointsAwardedDate','purchaseDate']  # Update with your timestamp column names
for col in timestamp_columns:
    if col in df.columns:
        df[col] = df[col].where(pd.notnull(df[col]), None)

table_name = 'receipts'

for index, row in df.iterrows():
    cursor.execute(
        f"INSERT INTO Fetchrewards.{table_name} (receiptId, bonusPointsEarned, bonusPointsEarnedReason, createDate, dateScanned, finishedDate, modifyDate, pointsAwardedDate, pointsEarned, purchaseDate, purchasedItemCount, rewardsReceiptStatus, totalSpent, userId) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
        (row['receiptId'], row['bonusPointsEarned'], row['bonusPointsEarnedReason'], row['createDate'], row['dateScanned'], row['finishedDate'], row['modifyDate'],row['pointsAwardedDate'],row['pointsEarned'],row['purchaseDate'],row['purchasedItemCount'],row['rewardsReceiptStatus'],row['totalSpent'],row['userId'])
    )
conn.commit()