WITH recent_month AS (
    SELECT '2021-01-01'::timestamp AS recent_month,
           '2020-12-01'::timestamp AS previous_month),
recent_ranking AS (
    SELECT brands.name AS brandName,
           COUNT(DISTINCT receipts.receiptId) AS receipts_scanned,
           DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT receipts.receiptId) DESC) AS rank
    FROM Fetchrewards.receipts
    JOIN Fetchrewards.items ON Fetchrewards.receipts.receiptId = Fetchrewards.items.receiptId
    JOIN Fetchrewards.brands ON items.barCode = brands.barCode
    JOIN recent_month ON receipts.dateScanned >= recent_month.recent_month
                     AND receipts.dateScanned < recent_month.recent_month + INTERVAL '1 month'
    GROUP BY brands.name
    ORDER BY rank
    LIMIT 5),
previous_ranking AS (
    SELECT brands.name AS brandName,
           COUNT(DISTINCT receipts.receiptId) AS receipts_scanned,
           DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT receipts.receiptacId) DESC) AS rank
    FROM Fetchrewards.receipts
    JOIN Fetchrewards.items ON Fetchrewards.receipts.receiptId = Fetchrewards.items.receiptId
    JOIN Fetchrewards.brands ON items.barCode = brands.barCode
    JOIN recent_month ON receipts.dateScanned >= recent_month.previous_month
                     AND receipts.dateScanned < recent_month.previous_month + INTERVAL '1 month'
    GROUP BY brands.name
    ORDER BY rank
    LIMIT 5
)
SELECT r.brandName AS recent_brandName, r.receipts_scanned AS recent_receipts_scanned, r.rank AS recent_rank,
       p.brandName AS previous_brandName, p.receipts_scanned AS previous_receipts_scanned, p.rank AS previous_rank
FROM recent_ranking r
FULL OUTER JOIN previous_ranking p ON r.brandName = p.brandName
ORDER BY COALESCE(r.rank, p.rank), COALESCE(p.rank, r.rank);


"""
WITH recent_month AS (
    SELECT (MAX(dateScanned)) AS recent_month,
           (MAX(dateScanned) - INTERVAL '1 month') AS previous_month FROM Fetchrewards.receipts),
recent_ranking AS (
    SELECT brands.name AS brandName,
           COUNT(DISTINCT receipts.receiptId) AS receipts_scanned,
           DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT receipts.receiptId) DESC) AS rank
    FROM Fetchrewards.receipts
    JOIN Fetchrewards.items ON Fetchrewards.receipts.receiptId = Fetchrewards.items.receiptId
    JOIN Fetchrewards.brands ON items.barCode = brands.barCode
    JOIN recent_month ON TO_CHAR(receipts.dateScanned,'YYYY-MM') >= TO_CHAR(recent_month.recent_month,'YYYY-MM')
                     AND TO_CHAR(receipts.dateScanned,'YYYY-MM') < TO_CHAR(recent_month.recent_month + INTERVAL '1 month','YYYY-MM')
    GROUP BY brands.name
    ORDER BY rank
    LIMIT 5),
previous_ranking AS (
    SELECT brands.name AS brandName,
           COUNT(DISTINCT receipts.receiptId) AS receipts_scanned,
           DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT receipts.receiptId) DESC) AS rank
    FROM Fetchrewards.receipts
    JOIN Fetchrewards.items ON Fetchrewards.receipts.receiptId = Fetchrewards.items.receiptId
    JOIN Fetchrewards.brands ON items.barCode = brands.barCode
    JOIN recent_month ON TO_CHAR(receipts.dateScanned,'YYYY-MM') >= TO_CHAR(recent_month.previous_month,'YYYY-MM')
                     AND TO_CHAR(receipts.dateScanned,'YYYY-MM') < TO_CHAR(recent_month.previous_month + INTERVAL '1 month','YYYY-MM')
    GROUP BY brands.name
    ORDER BY rank
    LIMIT 5
)
SELECT r.brandName AS recent_brandName, r.receipts_scanned AS recent_receipts_scanned, r.rank AS recent_rank,
       p.brandName AS previous_brandName, p.receipts_scanned AS previous_receipts_scanned, p.rank AS previous_rank
FROM recent_ranking r
FULL OUTER JOIN previous_ranking p ON r.brandName = p.brandName
ORDER BY COALESCE(r.rank, p.rank), COALESCE(p.rank, r.rank);

"""