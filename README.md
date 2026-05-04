\# 🏥 Hospital Readmission Analysis



\## Project Overview

This project analyses 7,890 hospital readmission records across 1,960 hospitals

in 34 US states, covering 6 medical conditions. Data was sourced from the 

CMS Hospital Readmissions Reduction Program (HRRP) — a US government dataset 

tracking whether hospitals are sending patients home too soon.



The goal was to identify which states, conditions, and hospital sizes are 

most associated with excess readmissions — and present findings in an 

interactive dashboard.



\---



\## Tools Used

| Tool | Purpose |

|---|---|

| Excel | Data cleaning, IFS formulas, derived columns |

| MySQL | Database creation, data import, 5 analysis queries |

| Power BI | Interactive dashboard with KPI cards, charts, and map |



\---



\## Dataset

\- - \*\*Source:\*\* CMS Hospital Readmissions Reduction Program (HRRP)

&#x20; via Kaggle — https://www.kaggle.com/datasets/jvstinjtvy/cms-hrrp

\- \*\*Rows:\*\* 7,890 | \*\*Hospitals:\*\* 1,960 | \*\*States:\*\* 34

\- \*\*Conditions covered:\*\*

&#x20; - Heart Failure

&#x20; - Heart Attack

&#x20; - Pneumonia

&#x20; - COPD

&#x20; - Hip/Knee Replacement

&#x20; - Bypass Surgery



\---



\## Data Cleaning (Excel)

\- Standardised all column headers to lowercase with underscores

\- Added 3 derived columns using IFS formulas:

&#x20; - `condition\_name` — readable condition label extracted from measure code

&#x20; - `performance\_flag` — categorised hospitals as Good / Average / High Risk

&#x20;   based on excess readmission ratio (below 1.0 = Good, 1.0 = Average, above 1.0 = High Risk)

&#x20; - `volume\_category` — classified hospitals as Low / Medium / High Volume

&#x20;   based on number of discharges



\---



\## SQL Analysis (MySQL)

| Query | Business Question |

|---|---|

| Q1 | Which states have the highest avg excess readmission ratio? |

| Q2 | Which medical condition has the worst readmission performance? |

| Q3 | Does hospital size affect readmission performance? |

| Q4 | Which 10 hospitals are the worst individual performers? |

| Q5 — CTE | Which hospitals are High Risk across 3 or more conditions? |



\---



\## Key Findings



\*\*1. Nearly half of all hospitals are underperforming\*\*

46.33% of the 1,960 hospitals analysed were flagged as High Risk —

meaning they are readmitting patients at a rate above what is

nationally expected for their patient mix.



\*\*2. California has the highest concentration of High Risk hospitals\*\*

With 532 High Risk hospitals, California leads the Top 10 states by

a significant margin. Illinois (180) and Louisiana (122) follow.

High population states show greater total risk exposure.



\*\*3. Hospital size is the strongest predictor of performance\*\*

\- Low Volume hospitals averaged an excess ratio of 1.02

\- Medium Volume hospitals averaged 1.01

\- High Volume hospitals averaged 0.99 — the only group performing

&#x20; better than the national expected rate



Larger hospitals consistently manage readmissions more effectively,

likely due to greater resources, staffing, and specialist availability.



\*\*4. No single condition is dramatically worse than others\*\*

All 6 conditions had nearly identical average excess ratios of 1.01,

suggesting the readmission problem is systemic across the healthcare

system rather than being driven by any specific disease category.



\*\*5. 1 in 4 hospitals is High Risk\*\*

25.87% of all hospitals in the dataset carry a High Risk flag —

meaning a quarter of US hospitals in this sample are consistently

sending patients home before they are fully recovered.



\---



\## Dashboard

Built in Power BI Desktop with:

\- 4 KPI Cards (Total Hospitals, Avg Excess Ratio, High Risk %, Total Discharges)

\- 3 Interactive Slicers (State, Condition, Performance Flag)

\- Bar Chart — Avg Excess Ratio by Condition

\- Bar Chart — Top 10 States by High Risk Hospital Count

\- Bar Chart — Hospital Volume vs Avg Excess Ratio

\- Filled Map — Readmission Risk by US State

\- Donut Chart — Hospital Performance Distribution



\---



\## Repository Contents

| File | Description |

|---|---|

| `Hospital\_Readmission\_cleaned.csv` | Cleaned dataset with derived columns |

| `hospital\_readmission\_queries.sql` | All 5 SQL analysis queries |

| `Hospital\_Readmission\_Dashboard.pbix` | Power BI dashboard file |

| `README.md` | This file |



\---



\## About

Built by Darryl Sosthenes

Tools: Excel · MySQL · Power BI

