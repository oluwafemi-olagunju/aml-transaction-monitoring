# Case Investigation: Account 2837392634

> **Synthetic data.** This is a mock investigation on the SAML-D synthetic dataset, written for demonstration purposes. It was completed **blind**: dataset labels were not viewed until after the disposition was recorded.

## 1. Alert summary
| Field | Detail |
|---|---|
| Subject account | 2837392634 |
| Alert week | 29 May 2023 |
| Rules triggered | R1 Cash smurfing + R7 Inbound structuring |
| Priority score | 54.9 (top-ranked v3 alert) |
| Review window | 1 May – 2 Jul 2023 (4 weeks either side of the alert) |

## 2. Activity review
**Weekly profile.** Inflows were minimal before the alert (21,557 across four weeks, with zero in three of them). In the alert week, the account received **1,563,531 across 166 transactions**, about 97% of all inflows in the review window and roughly 250× the average of other weeks. Activity returned to low levels afterwards (4–6 transactions per week).

**Flows.** Inflows over the window totalled ≈1.61M from ~14 counterparties via five channels (debit card, cheque, credit card, ACH and cash deposits). Outflows totalled ≈0.17M and remained at pre-alert levels, so ≈1.45M was retained within the window.

**Geography.** All activity was domestic (UK, GBP). No high-risk jurisdiction exposure.

## 3. Counterparty analysis
All 14 counterparties paying the subject in the alert week paid **no other account** in the dataset. Thirteen made exactly 12 transactions each (one made 15), with lifetime totals of 35,000–360,000 and a combined ≈1.52M, nearly all directed to the subject.

## 4. Red flags identified
- Sudden, extreme change in activity inconsistent with the account's prior profile
- Funds aggregated from multiple sources through several payment channels in a single week
- Counterparty accounts with no independent activity, dedicated solely to funding the subject
- Highly uniform transaction counts across counterparties, indicating coordination
- Sub-threshold cash deposits from multiple depositors alongside large non-cash inflows
- Funds retained rather than consumed in line with the account's normal outflow pattern

## 5. Analysis
**Supporting suspicion:** the combination of a one-off inflow spike, exclusively dedicated counterparties, uniform payment behaviour and multi-channel aggregation is consistent with a collection (funnel) account used during placement and early layering. The counterparties' lack of independent activity suggests they may be controlled by, or acting for, the same party.

**Mitigating considerations:** a legitimate business could receive a large one-off settlement from many customers (e.g. an event or a bulk invoice run). However, legitimate customers would typically show independent banking activity, varied payment counts and an ongoing relationship, none of which are present. No KYC profile, stated business purpose or expected-activity information was available to support a legitimate explanation.

## 6. Disposition
**Escalate.** The activity is unusual, lacks an apparent economic rationale and presents multiple indicators of money laundering. Recommend SAR consideration.

## 7. Recommended next steps
- Request information (RFI) from the customer on the source and purpose of the alert-week inflows
- Review KYC: occupation or business type, expected activity, and source of funds
- Expand the investigation to the 14 counterparty accounts (ownership, linked parties, onboarding details)
- Extend the lookback beyond 2 July 2023 to trace where the retained ≈1.45M was moved

