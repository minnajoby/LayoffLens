# LayoffLens - Progress Notes

## [31/07/2026]
- Set up project folder structure (data, notebooks, sql, powerbi)
- Pushed initial commit to GitHub with raw layoffs.csv
- Dataset: Layoffs.fyi mirror, 4,523 rows, 11 columns, real tech layoff events (2020-2026)
- Manually reviewed dataset in Excel:
  - company, industry, source, country: clean
  - location: global, not just US (expected)
  - total_laid_off, percentage_laid_off, funds_raised: missing values present (expected, real-world reporting gaps)
  - date, date_added: inconsistent formats — needs fixing before analysis
  - stage: company funding stage (Seed to IPO/Acquired) — useful for funding-vs-layoff analysis
  - Fixed date/date_added format issue using pd.to_datetime() - 0 rows failed to parse
  - Confirmed missing value counts match expectations: total_laid_off (1563), percentage_laid_off (1690), funds_raised (533) missing due to real-world non-disclosure
## [02/08/2026]
- Re-downloaded dataset: now 4,540 rows (was 4,523), latest date extended to July 31, 2026
  (confirmed dataset is actively updated by Layoffs.fyi)
- July 2026 is now a complete month; 2026 as a full year is still partial (Jan-July only)
  - Decision: label 2026 as "partial year" in any year-over-year comparison, don't compare
    directly against complete years
- In notebook (01_load_explore.ipynb):
  - Loaded dataset, checked shape (4540, 11) and dtypes
  - Converted date and date_added from text to proper datetime using pd.to_datetime()
  - Confirmed 0 rows failed to parse after fix
  - Added year, quarter columns extracted from date
  - Added disclosed column (True/False flag for whether total_laid_off was reported)
  - Confirmed missing value counts: total_laid_off (1570), percentage_laid_off (1693),
    funds_raised (537) - expected real-world reporting gaps
## [03/08/2026]
- Data quality checks: 0 duplicate rows, industry/stage categories clean (no typos),
  numeric ranges sane (total_laid_off 3-22000, percentage 0-1, funds_raised
  0.7M-121,900M)
- Python EDA - headline insight found:
  - Layoff EVENT COUNT peaks in 2023 (1390), then declines (633 -> 333 -> 274)
  - AVERAGE SIZE per event rises steadily 2022-2026: 201 -> 313 -> 394 -> 540 -> 696
  - INSIGHT: tech layoffs are becoming less frequent but more severe - avg event
    size more than tripled since 2022, even as event count dropped ~80% from peak
  - Built dual-line chart (event count vs avg size, 2020-2026) confirming this
    visually - lines cross around 2023-2024
  - This is the confirmed headline finding / hero visual for Power BI Page 1

- Industry breakdown reveals same frequency-vs-severity pattern as the year trend:
  - Finance: most frequent layoffs (540 events) but smaller average size (196/event)
  - Hardware: infrequent layoffs (85 events) but by far the LARGEST average size
    (1,783/event) - rare but severe
  - Retail: high on both dimensions (361 events, 448 avg) - consistently disruptive
- This reinforces the headline theme: layoff SIZE and FREQUENCY are separate stories,
  and looking at only one metric (like raw event count or raw totals) can be misleading

  - Funding-stage breakdown: Post-IPO companies dominate BOTH frequency (1091 events -
  most of any stage) and severity (avg 753/event - second highest) - challenges
  assumption that mature, public companies are more layoff-stable than startups
- Seed/Series A show much smaller avg layoff size (57-58) - expected, since early
  companies are small to begin with
- Series I/J, Private Equity, Subsidiary have very low event counts (9-36) -
  averages unreliable, don't treat as strong findings

  - Disclosure rate by industry (% of layoffs reporting actual headcount):
  - Highest: Sales (80.5%), Recruiting (74.6%), Manufacturing (71.9%), AI (71.4%)
  - Lowest: Construction (48%), Infrastructure (52.6%), Crypto (55.9%), Energy (57.1%)
  - Moderate spread (48%-80%), not extreme, but Crypto's low transparency is notable
    given its general reputation for opacity.