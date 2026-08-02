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
- Next: open notebook, load data, fix date format issue

