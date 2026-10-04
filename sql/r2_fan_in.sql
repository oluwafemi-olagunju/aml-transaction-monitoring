-- R2: Fan-in
-- Flags accounts receiving funds from 10+ distinct senders in a calendar week.
-- Threshold: between p99 (3) and p99.9 (17) of weekly distinct senders per
-- receiver, from unlabelled data (see 01_exploration, H2).
-- Labels (Is_laundering, Laundering_type) are NOT used.

CREATE OR REPLACE TABLE r2_alerts AS
SELECT Receiver_account               AS account,
       date_trunc('week', ts)         AS wk,
       COUNT(DISTINCT Sender_account) AS n_counterparties,
       COUNT(*)                       AS n_tx,
       ROUND(SUM(Amount), 2)          AS total_amount,
       'R2_fan_in'                    AS rule
FROM tx
GROUP BY account, wk
HAVING COUNT(DISTINCT Sender_account) >= 10;