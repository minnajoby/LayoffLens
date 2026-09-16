# LayoffLens

**Tech layoffs are becoming less frequent — but more severe (2020–2026)**

A data analytics project examining real tech industry layoff events from 2020 through 2026, built to demonstrate an end-to-end Python → SQL → Power BI analytical pipeline.

![Dashboard Overview](powerbi/screenshots/overview.png)

## Overview

Most public "layoffs" datasets get summarized as a single declining trend line. Digging deeper into six years of real event data tells a different story: **layoff events have dropped roughly 80% in frequency since their 2023 peak, but the average size of each layoff has more than tripled — from 201 people per event in 2022 to 696 in 2026.** Layoffs are rarer, but far more severe when they happen.

This project traces that finding (and several supporting ones) from raw data through to an interactive dashboard.

## Dataset

**Source:** [Layoffs.fyi](https://layoffs.fyi) (via a [Kaggle mirror](https://www.kaggle.com/datasets/swaptr/layoffs-2022)) — a public tracker of tech industry layoffs referenced by outlets including *The New York Times* and *The Wall Street Journal*.

- 4,540 real, individually-sourced layoff events, March 2020 – July 2026
- Fields: company, location, country, industry, funding stage, funds raised, total laid off, % of workforce affected, date, source article
- **Missing data is intentional, not a flaw:** ~35% of events don't disclose an exact headcount. Rather than imputing these values, they're left as-is and the disclosure pattern itself is analyzed as a finding — filling them in would fabricate numbers no company ever reported.

## Key Findings

1. **Fewer layoffs, bigger each time.** Event count fell from a 2023 peak of 1,390 to 274 in 2026 (partial year), while average size per event climbed from 201 (2022) to 696 (2026).
2. **Frequency and severity are different stories by industry.** Finance has the most events (540) but a modest average size (196/event). Hardware has far fewer events (85) but the largest average size (1,783/event) of any industry.
3. **Post-IPO companies dominate, not startups.** Post-IPO companies account for both the most layoff events (1,091) and among the highest average severity (753/event) — challenging the assumption that mature, publicly-traded companies are more stable.
4. **Disclosure transparency varies by industry.** Sales and AI disclose headcounts most often (>70%); Construction and Crypto least often (<58%).
5. **Geography is skewed by real reporting gaps, not real activity.** Some countries show near-zero totals despite real, dated layoff events — because none of those events disclosed a headcount, not because layoffs didn't happen there.
6. **India-specific pattern differs from the global one.** Education leads India's layoffs (14,474) — a different top industry than the global pattern (Hardware/Retail) — reflecting the country's edtech sector turbulence specifically.

## Tech Stack & Pipeline

| Stage | Tool | What it does |
|---|---|---|
| **Cleaning & EDA** | Python (pandas, matplotlib) | Fixes inconsistent date formats and company-name casing, engineers year/quarter/disclosure fields, explores 7 analytical angles |
| **Structured analysis** | SQL (SQLite) | Data is split into two relational tables (`companies`, `layoffs`) so real joins are possible; queries use JOINs, window functions (`RANK`, running `SUM`), CTEs, and `HAVING` |
| **Visualization** | Power BI | A 3-page interactive dashboard on a proper star schema (fact table + two dimension tables), with custom DAX measures |

### Data model
A star schema with `Fact_layoffs_tbl` (events) joined to two dimension tables: `Dim_companies_tbl` (industry, stage, country, funds raised) and `Dim_date_tbl` (a dedicated calendar table enabling time-intelligence functions).

### Notable DAX measures
- `Disclosure Rate` — uses `VAR` to separate total vs. disclosed event counts before dividing
- `YoY Change %` — time intelligence via `SAMEPERIODLASTYEAR`, built with `VAR`
- `Running Total Laid Off` — cumulative total using `CALCULATE` + `FILTER` + `ALL` + `MAX`
- `Industry Rank` — dynamic ranking via `RANKX`, recalculates live under any filter context

## Dashboard Pages

1. **Market Overview** — headline KPIs, the core "fewer but bigger" trend chart, running total, top sectors, funding-stage split
2. **Industry Analysis** — industry-level severity vs. volume, top individual layoff events, disclosure transparency
3. **Geographic Impact** — layoffs by country (choropleth map + matrix with drill-down to city), trend by country over time

## Repository Structure

```
LayoffLens/
├── data/               raw and cleaned dataset
├── notebooks/          Python cleaning, EDA, and SQL-setup notebooks
├── sql/                queries.sql (9 annotated queries) + layoffs.db
├── powerbi/            .pbix file and dashboard screenshots
└── README.md
```

## Challenges & Decisions

- **Hidden case-mismatch duplicates** (e.g. "AppGate" vs. "Appgate") broke a Power BI relationship on the companies table — traced back to the source data and fixed with standardized casing before the relational split, rather than patched after the fact.
- **No native Power BI–SQLite connector** — required installing an ODBC driver and configuring a DSN to get a genuinely live connection between the SQL layer and the dashboard, rather than a static CSV export.
- **Missing data was kept missing, deliberately** — instead of imputing undisclosed headcounts, the analysis treats non-disclosure as its own signal worth studying.

## Data Currency

Data reflects records through July 31, 2026, sourced from an actively-maintained tracker. This is a point-in-time snapshot, not a live feed.

## Author

Minna Joby — [GitHub](https://github.com/minnajoby) · [LinkedIn](https://linkedin.com/in/minnajoby)
