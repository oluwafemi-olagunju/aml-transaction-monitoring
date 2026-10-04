-- R1: Structuring / smurfing
-- Flags accounts receiving 3+ cash deposits in a calendar week where the
-- weekly total reaches 9,000+ but every individual deposit stays below 10,000.
-- Thresholds: count = p99 of weekly deposit counts (3);
-- total = near p99 of weekly totals (9,282), just under a 10,000 reporting threshold.
-- Labels (Is_laundering, Laundering_type) are NOT used.

CREATE OR REPLACE TABLE r1_alerts AS
SELECT Receiver_account               AS account,
       date_trunc('week', ts)         AS wk,
       COUNT(*)                       AS n_deposits,
       COUNT(DISTINCT Sender_account) AS n_depositors,
       ROUND(SUM(Amount), 2)          AS total_deposited,
       ROUND(MAX(Amount), 2)          AS max_deposit,
       'R1_structuring'               AS rule
FROM tx
WHERE Payment_type = 'Cash Deposit'
GROUP BY account, wk
HAVING COUNT(*) >= 3
   AND SUM(Amount) >= 9000
   AND MAX(Amount) < 10000;
   