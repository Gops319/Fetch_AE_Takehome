WITH max_created_date AS (
    SELECT 
        MAX(createdDate) AS max_created_date, 
        (MAX(createdDate) - INTERVAL '6 months') AS six_months_prior
    FROM Fetchrewards.users
),
recent_users AS (
    SELECT userId
    FROM Fetchrewards.users, max_created_date
    WHERE createdDate >= max_created_date.six_months_prior
)
SELECT brands.name, COUNT(distinct receipts.receiptId) AS transaction_count
--If each receipt is considered as a transaction, distinct receipts have to be taken 
FROM Fetchrewards.receipts 
INNER JOIN recent_users ON receipts.userId = recent_users.userId
INNER JOIN Fetchrewards.items ON receipts.receiptId = Fetchrewards.items.receiptId
INNER JOIN Fetchrewards.brands ON Fetchrewards.items.barCode = Fetchrewards.brands.barCode
GROUP BY brands.name
ORDER BY transaction_count DESC
LIMIT 1;
