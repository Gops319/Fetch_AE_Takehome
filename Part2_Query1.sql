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
SELECT Fetchrewards.brands.name, COUNT(DISTINCT receipts.receiptid) AS receipts_scanned FROM Fetchrewards.receipts
JOIN Fetchrewards.items ON items.receiptId = receipts.receiptId
JOIN Fetchrewards.brands ON items.barcode = brands.barcode
WHERE TO_CHAR(receipts.dateScanned,'YYYY-MM')>=  (SELECT TO_CHAR(MAX(dateScanned),'YYYY-MM') FROM Fetchrewards.receipts)
GROUP BY brands.name
ORDER BY receipts_scanned desc
LIMIT 5;
"""