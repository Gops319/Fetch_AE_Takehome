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
SELECT brands.name, SUM(receipts.totalSpent) AS total_spend
FROM Fetchrewards.receipts 
INNER JOIN recent_users ON receipts.userId = recent_users.userId
INNER JOIN Fetchrewards.items ON receipts.receiptId = Fetchrewards.items.receiptId
INNER JOIN Fetchrewards.brands ON Fetchrewards.items.barCode = Fetchrewards.brands.barCode
GROUP BY brands.name
ORDER BY total_spend DESC
LIMIT 1;
