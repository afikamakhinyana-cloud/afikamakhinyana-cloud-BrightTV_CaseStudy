# BrightTV Analytics Project

## What I Did

I had two tables in Databricks:
- `bright_tv_users` – user information (name, age, province, gender)
- `bright_tv_viewership` – what users watched (channel, date, duration)

## Steps I Followed

**1. Cleaned the data in SQL**
- Fixed the duration column (converted time to minutes)
- Changed UTC time to South Africa time
- Joined both tables together

**2. Ran queries to answer business questions**
- How many users are active?
- When do people watch the most?
- What channels are popular?
- Who are the inactive users?

**3. Exported results to Excel**
- Saved each query result as a CSV file
- Opened each CSV in Excel
- Created charts (bar charts, line charts, pie charts)

**4. Made a PowerPoint presentation**
- Added charts to slides
- Wrote insights and recommendations
- Prepared 20-minute presentation 

## What I Found

| Finding | Detail |
|---------|--------|
| 76% of users are inactive | 989 users never watched anything |
| Monday is the lowest day | 115 hours vs Saturday 296 hours |
| Best time to send alerts | 5 PM (584 users watching) |
| Most users are male | 3,723 males vs 488 females |
| Eastern Cape watches most | 25.6 hours per user |

## What I Recommended

- Put new shows on Monday nights
- Send push notifications at 5 PM
- Email inactive users with special offers
- Create more content for female viewers

## Files in This Repository

| Folder | What's Inside |
|--------|----------------|
| SQL_Queries | All the SQL code I wrote |
| CSV_Exports | Results from Databricks |
| Excel_Charts | Charts made from each CSV |
| Presentation | Final PowerPoint slides |

## Tools I Used

- Databricks (to write SQL)
- Excel (to make charts)
- Canva (to build presentation)

## Author

Afika Makhinyana
