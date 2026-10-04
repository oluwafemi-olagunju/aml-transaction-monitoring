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