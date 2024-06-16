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
If we consider the month with latest transaction as the recent month
with recent_months as(
select DATE_TRUNC('month', max(receipts.dateScanned)) as recent_month,
		   DATE_TRUNC('month', max(receipts.dateScanned) - INTERVAL '1 month' ) as previous_month
from Fetchrewards.receipts),

recent_ranking as (
select  brands.name as brandName, 
	count(distinct receipts.receiptId) as receiptsScanned,
    dense_rank() over(order by count(distinct receipts.receiptId) desc) as rank
from Fetchrewards.receipts
join Fetchrewards.items on items.receiptid = receipts.receiptid
join Fetchrewards.brands on brands.barcode = items.barcode
join recent_months on DATE_TRUNC('month',receipts.dateScanned) >= recent_months.recent_month
group by brands.name
order by rank
limit 5),

previous_ranking as (
select brands.name as brandName, 
	   count(distinct receipts.receiptId) as receiptsScanned,
	   dense_rank() over(order by count(distinct receipts.receiptId) desc) as rank
from Fetchrewards.receipts
join Fetchrewards.items on items.receiptid = receipts.receiptid
join Fetchrewards.brands on brands.barcode = items.barcode
join recent_months on DATE_TRUNC('month',receipts.dateScanned) >= recent_months.previous_month
and DATE_TRUNC('month',receipts.dateScanned) <= recent_months.recent_month
group by brands.name
order by rank
limit 5)

select r.brandName as recent_brandName, r.receiptsScanned as recent_receipts_scanned, r.rank as recent_rank,
p.brandName as previous_brandName, p.receiptsScanned as previous_receipts_scanned, p.rank as previous_rank
from recent_ranking r
full outer join previous_ranking p on r.brandName=p.brandName
order by coalesce(r.rank,p.rank), COALESCE(p.rank,r.rank);

"""


"""
If we consider the transactions for a month from the date of last transaction 
with recent_months as(
select max(receipts.dateScanned) as recent_month,
		   (max(receipts.dateScanned) - INTERVAL '1 month' ) as previous_month
from Fetchrewards.receipts),

recent_ranking as (
select  brands.name as brandName, 
	count(distinct receipts.receiptId) as receiptsScanned,
    dense_rank() over(order by count(distinct receipts.receiptId) desc) as rank
from Fetchrewards.receipts
join Fetchrewards.items on items.receiptid = receipts.receiptid
join Fetchrewards.brands on brands.barcode = items.barcode
join recent_months on receipts.dateScanned >= recent_months.recent_month
group by brands.name
order by rank
limit 5),

previous_ranking as (
select brands.name as brandName, 
	   count(distinct receipts.receiptId) as receiptsScanned,
	   dense_rank() over(order by count(distinct receipts.receiptId) desc) as rank
from Fetchrewards.receipts
join Fetchrewards.items on items.receiptid = receipts.receiptid
join Fetchrewards.brands on brands.barcode = items.barcode
join recent_months on receipts.dateScanned >= recent_months.previous_month
and receipts.dateScanned <= recent_months.recent_month
group by brands.name
order by rank
limit 5)

select r.brandName as recent_brandName, r.receiptsScanned as recent_receipts_scanned, r.rank as recent_rank,
p.brandName as previous_brandName, p.receiptsScanned as previous_receipts_scanned, p.rank as previous_rank
from recent_ranking r
full outer join previous_ranking p on r.brandName=p.brandName
order by coalesce(r.rank,p.rank), COALESCE(p.rank,r.rank);
"""