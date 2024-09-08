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

# Create a cursor
cursor = conn.cursor()


cursor.execute("CREATE SCHEMA IF NOT EXISTS FetchRewards;")


users="""
CREATE TABLE IF NOT EXISTS FetchRewards.users (
        userId VARCHAR(255) PRIMARY KEY,
        active BOOLEAN,
        createdDate TIMESTAMP,
        lastLogin TIMESTAMP,
        role VARCHAR(255),
        signUpSource VARCHAR(255),
        state VARCHAR(255)
);
"""

brands = """
    CREATE TABLE IF NOT EXISTS FetchRewards.brands (
        barcode VARCHAR(255),
        category VARCHAR(255),
        categoryCode VARCHAR(255),
        name VARCHAR(255),
        topBrand BOOLEAN,
        brandCode VARCHAR(255),
        cpgId VARCHAR(255),
        cpgRef VARCHAR(255),
        brandId VARCHAR(255) PRIMARY KEY
    );
    """
cursor.execute(brands)

receipts = """
    CREATE TABLE IF NOT EXISTS FetchRewards.receipts (
        receiptId VARCHAR(255) PRIMARY KEY,
        bonusPointsEarned NUMERIC(38,2),
        bonusPointsEarnedReason VARCHAR(255),
        createDate TIMESTAMP,
        dateScanned TIMESTAMP,
        finishedDate TIMESTAMP,
        modifyDate TIMESTAMP,
        pointsAwardedDate TIMESTAMP,
        pointsEarned NUMERIC(38,2),
        purchaseDate TIMESTAMP,
        purchasedItemCount NUMERIC(38,2),
        rewardsReceiptStatus VARCHAR(255),
        totalSpent NUMERIC(38,2),
        userId VARCHAR(255),
        FOREIGN KEY (userId) REFERENCES FetchRewards.users(userId)
    );
    """
cursor.execute(receipts)


items = """
    CREATE TABLE IF NOT EXISTS FetchRewards.items (
    barcode VARCHAR(255),
    description VARCHAR(255),
    finalPrice NUMERIC(38,2),
    itemPrice NUMERIC(38,2),
    needsFetchReview BOOLEAN,
    partnerItemId VARCHAR(255),
    preventTargetGapPoints BOOLEAN,
    quantityPurchased NUMERIC(38,2),
    userFlaggedBarcode VARCHAR(255),
    userFlaggedNewItem BOOLEAN,
    userFlaggedPrice NUMERIC(38,2),
    userFlaggedQuantity NUMERIC(38,2),
    receiptId VARCHAR(255),
    needsFetchReviewReason VARCHAR(255),
    pointsNotAwardedReason VARCHAR(255),
    pointsPayerId VARCHAR(255),
    rewardsGroup VARCHAR(255),
    rewardsProductPartnerId VARCHAR(255),
    userFlaggedDescription VARCHAR(255),
    originalMetaBriteBarcode VARCHAR(255),
    originalMetaBriteDescription VARCHAR(255),
    brandCode VARCHAR(255),
    competitorRewardsGroup VARCHAR(255),
    discountedItemPrice NUMERIC(38,2),
    originalReceiptItemText VARCHAR(255),
    itemNumber NUMERIC(38,2),
    originalMetaBriteQuantityPurchased NUMERIC(38,2),
    pointsEarned NUMERIC(38,2),
    targetPrice NUMERIC(38,2),
    competitiveProduct BOOLEAN,
    originalFinalPrice NUMERIC(38,2),
    originalMetaBriteItemPrice NUMERIC(38,2),
    deleted BOOLEAN,
    priceAfterCoupon NUMERIC(38,2),
    metabriteCampaignId VARCHAR(255),
    PRIMARY KEY (receiptId, partnerItemId),
    FOREIGN KEY (receiptId) REFERENCES FetchRewards.receipts(receiptId)
);

    """
cursor.execute(items)

conn.commit()

cursor.close()
conn.close()