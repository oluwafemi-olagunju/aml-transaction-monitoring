-- R5: High-risk geography
-- Reference list: FATF jurisdictions under increased monitoring, date-aware for
-- the data period (Oct 2022 - Aug 2023). Source: FATF public statements
-- (Oct 2022, Feb 2023, Oct 2023). NULL listed_from = listed before data start;
-- NULL delisted_on = still listed at end of data period.
-- Labels (Is_laundering, Laundering_type) are NOT used.

CREATE OR REPLACE TABLE high_risk_jurisdictions AS
SELECT * FROM (VALUES
    ('Pakistan', CAST(NULL AS DATE),  DATE '2022-10-21'),
    ('Morocco',  CAST(NULL AS DATE),  DATE '2023-02-24'),
    ('Nigeria',  DATE '2023-02-24',   CAST(NULL AS DATE)),
    ('Albania',  CAST(NULL AS DATE),  CAST(NULL AS DATE)),
    ('UAE',      CAST(NULL AS DATE),  CAST(NULL AS DATE)),
    ('Turkey',   CAST(NULL AS DATE),  CAST(NULL AS DATE))
) AS t(country, listed_from, delisted_on);

-- Cross-border transactions involving a jurisdiction listed on that date.
-- The alerted account is the one on the non-high-risk side of the payment.
CREATE OR REPLACE TABLE r5_tx AS
SELECT CASE WHEN hr_r.country IS NOT NULL THEN t.Sender_account
            ELSE t.Receiver_account END            AS account,
       t.ts,
       t.Amount,
       COALESCE(hr_r.country, hr_s.country)        AS hr_country
FROM tx AS t
LEFT JOIN high_risk_jurisdictions AS hr_r
       ON t.Receiver_bank_location = hr_r.country
      AND (hr_r.listed_from IS NULL OR t.ts >= hr_r.listed_from)
      AND (hr_r.delisted_on IS NULL OR t.ts <  hr_r.delisted_on)
LEFT JOIN high_risk_jurisdictions AS hr_s
       ON t.Sender_bank_location = hr_s.country
      AND (hr_s.listed_from IS NULL OR t.ts >= hr_s.listed_from)
      AND (hr_s.delisted_on IS NULL OR t.ts <  hr_s.delisted_on)
WHERE t.Sender_bank_location <> t.Receiver_bank_location
  AND (hr_r.country IS NOT NULL OR hr_s.country IS NOT NULL);

  -- Step 2: flag account-weeks with 200000+ total value to/from jurisdictions
-- listed on the transaction date. Threshold: between p90 (99,100) and
-- p99 (314,045) of weekly high-risk exposure (unlabelled). The minority moves large sums which is where
-- the risk concentrates hence the selected threshold.

CREATE OR REPLACE TABLE r5_alerts AS
SELECT account,
       date_trunc('week', ts)                AS wk,
       COUNT(*)                              AS n_tx,
       ROUND(SUM(Amount), 2)                 AS total_amount,
       STRING_AGG(DISTINCT hr_country, ', ') AS countries,
       'R5_high_risk_geo'                    AS rule
FROM r5_tx
GROUP BY account, wk
HAVING SUM(Amount) >= 200000;