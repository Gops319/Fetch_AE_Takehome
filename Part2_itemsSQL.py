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
csv_file = 'C:/Users/gopio/Downloads/Fetch/items.csv'
df = pd.read_csv(csv_file)

timestamp_columns = ['createdDate', 'dateScanned','finishedDate','modifyDate','pointsAwardedDate','purchaseDate'] 
for col in timestamp_columns:
    if col in df.columns:
        df[col] = df[col].where(pd.notnull(df[col]), None)

df['competitiveProduct'] = df['competitiveProduct'].apply(lambda x: None if pd.isna(x) else x)
df['deleted'] = df['deleted'].apply(lambda x: None if pd.isna(x) else x)
df['needsFetchReview'] = df['needsFetchReview'].apply(lambda x: None if pd.isna(x) else x)
df['preventTargetGapPoints'] = df['preventTargetGapPoints'].where(pd.notnull(df['preventTargetGapPoints']), None)
df['userFlaggedNewItem'] = df['userFlaggedNewItem'].where(pd.notnull(df['userFlaggedNewItem']), None)

table_name = 'items'
for index, row in df.iterrows():
    cursor.execute(
        f"INSERT INTO Fetchrewards.{table_name} (barcode, description, finalPrice, itemPrice, needsFetchReview, partnerItemId, preventTargetGapPoints, quantityPurchased, userFlaggedBarcode, userFlaggedNewItem, userFlaggedPrice, userFlaggedQuantity, receiptId, needsFetchReviewReason, pointsNotAwardedReason, pointsPayerId, rewardsGroup, rewardsProductPartnerId, userFlaggedDescription, originalMetaBriteBarcode, originalMetaBriteDescription, brandCode, competitorRewardsGroup, discountedItemPrice, originalReceiptItemText, itemNumber, originalMetaBriteQuantityPurchased, pointsEarned, targetPrice, competitiveProduct, originalFinalPrice, originalMetaBriteItemPrice, deleted, priceAfterCoupon, metabriteCampaignId) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
        (row['barcode'], row['description'], row['finalPrice'], row['itemPrice'], row['needsFetchReview'], row['partnerItemId'], row['preventTargetGapPoints'], row['quantityPurchased'], row['userFlaggedBarcode'], row['userFlaggedNewItem'], row['userFlaggedPrice'], row['userFlaggedQuantity'], row['receiptId'], row['needsFetchReviewReason'], row['pointsNotAwardedReason'], row['pointsPayerId'], row['rewardsGroup'], row['rewardsProductPartnerId'], row['userFlaggedDescription'], row['originalMetaBriteBarcode'], row['originalMetaBriteDescription'], row['brandCode'], row['competitorRewardsGroup'], row['discountedItemPrice'], row['originalReceiptItemText'], row['itemNumber'], row['originalMetaBriteQuantityPurchased'], row['pointsEarned'], row['targetPrice'], row['competitiveProduct'], row['originalFinalPrice'], row['originalMetaBriteItemPrice'], row['deleted'], row['priceAfterCoupon'], row['metabriteCampaignId'])
    )

conn.commit()