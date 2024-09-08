--Assumming 2021-01 as the recent month
WITH recent_month AS (
    SELECT '2021-01-01 00:00:00'::timestamp AS recent_month)

SELECT brands.name AS brandName, 
COUNT(DISTINCT receipts.receiptId) AS receipts_scanned
FROM Fetchrewards.receipts 
JOIN Fetchrewards.items ON Fetchrewards.receipts.receiptId = Fetchrewards.items.receiptId
JOIN Fetchrewards.brands ON items.barCode = brands.barCode
JOIN recent_month ON TRUE
where receipts.dateScanned>= recent_month.recent_month
group by brands.name
order by receipts_scanned desc
LIMIT 5
;


"""
If we consider the month with latest transaction as the recent month
WITH recent_month AS (
    SELECT DATE_TRUNC('month', MAX(dateScanned)) AS recent_month
    FROM Fetchrewards.receipts
)
SELECT b.name AS brand_name, COUNT(DISTINCT r.receiptId) AS receipts_scanned
FROM Fetchrewards.receipts r
JOIN Fetchrewards.items i ON i.receiptId = r.receiptId
JOIN Fetchrewards.brands b ON i.barcode = b.barcode
JOIN recent_month rm ON DATE_TRUNC('month', r.dateScanned) >= rm.recent_month
GROUP BY b.name
ORDER BY receipts_scanned DESC
LIMIT 5;

"""

"""
If we consider the transactions for a month from the date of last transaction 
with recent_month as(
select (max(receipts.dateScanned) - interval '1 month') as recent_month 
	from Fetchrewards.receipts)
SELECT Fetchrewards.brands.name, COUNT(DISTINCT receipts.receiptid) AS receipts_scanned FROM Fetchrewards.receipts
JOIN Fetchrewards.items ON items.receiptId = receipts.receiptId
JOIN Fetchrewards.brands ON items.barcode = brands.barcode
join recent_month on receipts.dateScanned>=  recent_month.recent_month
GROUP BY brands.name
ORDER BY receipts_scanned desc
LIMIT 5;
"""