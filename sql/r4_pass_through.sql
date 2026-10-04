-- R4: Pass-through (rapid movement of funds)
-- Step 1: match each incoming payment to outgoing payments from the same
-- account within 48 hours at 80-120% of the incoming amount.
-- Labels (Is_laundering, Laundering_type) are NOT used.

CREATE OR REPLACE TABLE r4_pairs AS
SELECT i.Receiver_account AS account,
       i.Sender_account   AS from_account,
       o.Receiver_account AS to_account,
       i.ts               AS in_ts,
       o.ts               AS out_ts,
       i.Amount           AS in_amount,
       o.Amount           AS out_amount
FROM tx AS i
JOIN tx AS o
  ON  o.Sender_account = i.Receiver_account
  AND o.ts >  i.ts
  AND o.ts <= i.ts + INTERVAL 48 HOUR
  AND o.Amount BETWEEN 0.8 * i.Amount AND 1.2 * i.Amount;

  -- Step 2: flag accounts that passed through 45+ distinct incoming payments in
-- a calendar week. Counts distinct incoming payments (not pairs) to avoid
-- Threshold of 45 sits between p90 (6) and p99 (60), toward the upper end, to prioritise
-- precision. Pass-through activity is common among legitimate high-volume accounts, so
-- a conservative threshold limits false positives. Sensitivity to this choice is tested in Step 4
-- many-to-many join inflation. Threshold: between p90 and p99 of weekly
-- distinct passed-through payments (unlabelled).

CREATE OR REPLACE TABLE r4_alerts AS
SELECT account,
       date_trunc('week', in_ts) AS wk,
       COUNT(DISTINCT CAST(from_account AS VARCHAR) || '_' || CAST(in_ts AS VARCHAR)) AS n_passed,
       COUNT(DISTINCT from_account) AS n_sources,
       COUNT(DISTINCT to_account)   AS n_destinations,
       'R4_pass_through'            AS rule
FROM r4_pairs
GROUP BY account, wk
HAVING COUNT(DISTINCT CAST(from_account AS VARCHAR) || '_' || CAST(in_ts AS VARCHAR)) >= 45;