-- R7: Inbound structuring (many senders, sub-threshold, non-cash)
-- Flags accounts receiving non-cash payments from 4+ distinct senders in a
-- calendar week, where the weekly total reaches 10,000+ but the typical
-- (median) payment stays below 10,000.
-- Thresholds: 4 senders = first value above the normal p99 (3) of weekly
-- distinct senders per receiver (unlabelled, see 01_exploration H2);
-- 10,000 = common reporting threshold. Cash deposits are excluded because
-- R1 covers cash.
-- Labels (Is_laundering, Laundering_type) are NOT used.

CREATE OR REPLACE TABLE r7_alerts AS
SELECT Receiver_account               AS account,
       date_trunc('week', ts)         AS wk,
       COUNT(DISTINCT Sender_account) AS n_counterparties,
       COUNT(*)                       AS n_tx,
       ROUND(SUM(Amount), 2)          AS total_amount,
       ROUND(MEDIAN(Amount), 2)       AS median_amount,
       'R7_inbound_structuring'       AS rule
FROM tx
WHERE Payment_type <> 'Cash Deposit'
GROUP BY account, wk
HAVING COUNT(DISTINCT Sender_account) >= 4
   AND SUM(Amount) >= 10000
   AND MEDIAN(Amount) < 10000;