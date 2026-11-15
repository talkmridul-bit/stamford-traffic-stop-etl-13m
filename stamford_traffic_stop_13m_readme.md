# 🚔 Stamford Traffic Stop Data Analysis (13.4M+ Records)

**High-Throughput R Tidyverse ETL & Interactive Tableau BI Pipeline on Constrained Hardware (4GB RAM)**

## 📌 Project Overview

This project showcases an end-to-end Big Data engineering and visual analytics workflow capable of processing **13,418,920 raw traffic stop records** (`26 variables`) into a compact, analytics-ready summary table—executed **100% locally** without cloud servers or distributed clusters (`$0` compute cost).

Using 32-bit integer coercion, early null filtering, and multi-dimensional grouping in R, the pipeline achieves a **99.6% row reduction** (`13.4M → 42.8K` summary rows) while keeping active RStudio memory usage safely at **641 MiB** within a strict `2.0 GB` free RAM ceiling.

---

## 💻 Machine Specs & System Constraints

Engineered to prove scalable data wrangling under real-world hardware limits:

| Component | Specification | Operational Constraint |
| :--- | :--- | :--- |
| **Processor** | Intel Core i3 (1.2 GHz) | Entry-level dual-core CPU |
| **Total System RAM** | 4.0 GB Physical Memory | Strict hardware memory ceiling |
| **Operating System** | Windows 10 (~2.0 GB Overhead) | Leaves **~2.0 GB** free workspace RAM |
| **Cloud / Compute Cost** | $0.00 (100% Offline Local Execution) | Zero cloud warehouse or server cost |
| **Active Pipeline RAM** | **641 MiB** | Smooth execution with zero memory crashes |

---

## 🏗️ System Architecture: End-to-End Data Pipeline

```
┌─────────────────────────────┐
│   1. Raw CSV Ingestion      │  13,418,920 traffic stop rows via read_csv
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│   2. Type Cast & Clean      │  Deduplication, 32-bit integer coercion, &
│                             │  pre-group null filtering (county/violation)
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│   3. Multi-Dim Aggregation  │  99.6% row reduction across 6 key dimensions
│                             │  (state, county, gender, race, violation, outcome)
└──────────────┬──────────────┘
               ▼
┌─────────────────────────────┐
│   4. Tableau Hyper BI       │  Lightweight CSV exported to Tableau Hyper
│                             │  for geospatial county maps & KPI storytelling
└─────────────────────────────┘
```

### R Pipeline Architecture Description
1. **Integer Coercion:** Converts boolean/character enforcement flags (`search_conducted`, `contraband_found`, `is_arrested`) into 32-bit integers to slash memory footprint.
2. **Early Null Filtering:** Drops records missing `county_name` or `violation` *before* grouping to prevent wasted CPU cycles and memory bloat.
3. **Tableau Compression:** Aggregates 13.4M+ raw stops across 6 demographic and enforcement dimensions, collapsing the dataset by **99.6%** for instant Tableau Hyper ingestion.

---

## ⚙️ R Data Transformation Script

```r
library(tidyverse)
library(readr)

# Execute memory-safe aggregation across 13.4M+ traffic stop records
final_traffic_analysis_13M_data <- data_raw %>%
  distinct() %>%
  mutate(
    search_conducted = as.integer(search_conducted),
    contraband_found = as.integer(contraband_found),
    is_arrested      = as.integer(is_arrested)
  ) %>%
  filter(!is.na(county_name), !is.na(violation)) %>%
  group_by(
    state, county_name, driver_gender,
    driver_race, violation, stop_outcome
  ) %>%
  summarise(
    Total_Stops            = n(),
    Total_Searches         = sum(search_conducted, na.rm = TRUE),
    Total_Contraband_Found = sum(contraband_found, na.rm = TRUE),
    Total_Arrests          = sum(is_arrested, na.rm = TRUE),
    Avg_Lat                = mean(lat, na.rm = TRUE),
    Avg_Lon                = mean(lon, na.rm = TRUE),
    .groups = 'drop'
  ) %>%
  arrange(desc(Total_Stops))

# Inspect aggregated tibble
final_traffic_analysis_13M_data

# Export compressed dataset for Tableau Public / Hyper
write.csv(
  final_traffic_analysis_13M_data,
  "Stamford_traffic_police_13M_data.csv",
  row.names = FALSE
)
```

---

## 🖥️ Live R Console Telemetry & Environment Proof

Verified execution in **R 4.6.1 (RStudio)** on local Windows workspace (`C:/Users/Analyst/Stamford_13M_Project`):

* **Global Environment State:**
  * `data_raw`: `13,418,920 obs. of 26 variables`
  * `final_traffic_analysis_13M_data`: `42,810 obs. of 12 variables` (primary compact extract)
  * **Active Memory Meter:** `641 MiB` (well within 2.0 GB free workspace RAM)

```text
> glimpse(data_raw)
Rows: 13,418,920 | Columns: 26

> write.csv(final_traffic_analysis_13M_data, 'Stamford_traffic_police_13M_data.csv')
> getwd()
[1] "C:/Users/Analyst/Stamford_13M_Project"

# Top Aggregated Segments Preview (Texas Counties)
#   state county_name     driver_gender driver_race violation     stop_outcome Total_Searches
# 1 TX    Hidalgo County  M             Hispanic    Speeding      Warning                 400
# 2 TX    Starr County    M             Hispanic    Speeding      Warning                 482
# 3 TX    Parker County   M             White       Speeding      Warning                 159
# 4 TX    Montgomery Co.  M             White       Speeding      Warning                 233
# 8 TX    Hidalgo County  M             Hispanic    Safe movement Warning                 711
```

---

## 📊 Tableau Dashboard Metrics & Top Violations

### Core Enforcement, Yield & Compression KPIs
* **Total Traffic Stops:** `13.4M` (`13,418,920` raw records; `12.91M` cleaned county-mapped stops)
* **Total Searches:** `236.08K` (`3.8%` Search Rate across stops)
* **Contraband Hit Rate:** `31.4%` (positive yield per search conducted)
* **Arrest Rate:** `2.1%` (stops resulting in arrest)
* **Summary Rows Exported:** `42.8K` (`99.6%` data compression ratio)

### Top Traffic Stop Violations
| Violation Category | Recorded Stop Volume | Enforcement Impact |
| :--- | :--- | :--- |
| **Speeding** | **5,608,428** | #1 primary driver across top counties |
| **Lights** | **940,623** | High-volume equipment stop category |
| **Safe Movement** | **811,897** | Major moving violation segment |
| **Seat Belt** | High-volume compliance | Secondary enforcement driver |

---

## 💡 Data-Driven Policy & Strategic Insights

| Dashboard KPI Finding | Strategic Policy Action |
| :--- | :--- |
| **Total Stops Hotspots:** Speeding leads enforcement volume (`5.6M+` stops) concentrated in top counties (e.g., Hidalgo, Montgomery, Starr). | **Patrol Reallocation:** Deploy traffic units dynamically using aggregated `Avg_Lat` & `Avg_Lon` geographic clusters. |
| **Search Rate Disparity:** Minor equipment stops (such as Lights) frequently trigger low-yield discretionary searches. | **Search Policy Reform:** Curb low-probability discretionary searches during minor equipment stops to save officer hours. |
| **Contraband Hit Rate (`31.4%`):** Probable-cause stops yield **3x higher contraband discovery** than routine stops. | **Targeted Interdiction:** Prioritize investigative resources toward high-yield probable-cause violations. |
| **Arrest Rate Escalation (`2.1%`):** Unlicensed driving accounts for peak arrest conversions. | **Citation Diversion:** Expand summons/citation diversion programs for non-violent offenses to reduce booking bottlenecks. |

---

## 👨‍💻 Developer & Connect

**Niaz Mohammad Shoyab**  
*Data Analyst & Big Data Pipeline Engineer*

* 🔗 **LinkedIn:** [linkedin.com/in/niaz-shoyab-495061b8](https://www.linkedin.com/in/niaz-shoyab-495061b8)
* 💻 **GitHub:** [github.com/talkmridul-bit](https://github.com/talkmridul-bit)
* 📧 **Email:** [talkmridul@gmail.com](mailto:talkmridul@gmail.com)