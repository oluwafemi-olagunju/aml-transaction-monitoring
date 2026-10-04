-- R3: Fan-out
-- Flags accounts sending funds to 17+ distinct receivers in a calendar week.
-- Threshold: between p99 and p99.9 of weekly distinct receivers per sender,
-- from unlabelled data (see 02_rules, R3 threshold research).
-- Labels (Is_laundering, Laundering_type) are NOT used.

CREATE OR REPLACE TABLE r3_alerts AS
SELECT Sender_account                   AS account,
       date_trunc('week', ts)           AS wk,
       COUNT(DISTINCT Receiver_account) AS n_counterparties,
       COUNT(*)                         AS n_tx,
       ROUND(SUM(Amount), 2)            AS total_amount,
       'R3_fan_out'                     AS rule
FROM tx
GROUP BY account, wk
HAVING COUNT(DISTINCT Receiver_account) >= 17;