-- R6: Frequent cash withdrawals
-- Flags accounts making 4+ cash withdrawals in a calendar week.
-- Threshold: between p90 (3) and p99 (5) of weekly withdrawal counts per
-- account (unlabelled). Amount is NOT used: typical withdrawal amounts are
-- similar across all accounts (median ~143), so frequency is the signal.
-- Threshold of 4 is the first value above the normal p90 (3) of weekly withdrawal counts.
-- It flags the top ~10% of withdrawal activity, leaning toward recall over precision.
-- Label informed design is validated on a held-out test period.
-- Labels (Is_laundering, Laundering_type) are NOT used.

CREATE OR REPLACE TABLE r6_alerts AS
SELECT Sender_account          AS account,
       date_trunc('week', ts)  AS wk,
       COUNT(*)                AS n_withdrawals,
       ROUND(SUM(Amount), 2)   AS total_withdrawn,
       'R6_cash_withdrawals'   AS rule
FROM tx
WHERE Payment_type = 'Cash Withdrawal'
GROUP BY account, wk
HAVING COUNT(*) >= 4;