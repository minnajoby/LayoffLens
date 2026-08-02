# LayoffLens - Progress Notes

## [02/08/2026]
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