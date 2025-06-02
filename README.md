# Google Data Analytics Professional Certificate Capstone

**Case Study 2: How Can a Wellness Technology Company Play It Smart?**

**Author:** Antonio Iannopollo

**Date:** June 2, 2025

## Overview
This project analyzes FitBit Fitness Tracker Data to identify trends in smart device usage and recommend marketing strategies for Bellabeat’s Leaf tracker. The analysis, conducted in R, includes data cleaning, statistical correlations (e.g., steps vs. calories, sleep vs. steps), visualizations, and actionable recommendations, presented in an HTML report and PowerPoint slide deck.

## Deliverables
- **`Google-Data-Analytics-Professional-Certificate-Capstone.R`**: R script for data loading, cleaning, analysis, and visualization generation. Includes:
  - Data processing for activity, sleep, and heart rate files.
  - Summary statistics (average steps, calories, sleep duration, heart rate).
  - Correlation analysis (e.g., steps-calories r = 0.59).
  - Four visualizations saved as PNGs.
- **`Google-Data-Analytics-Professional-Certificate-Capstone.Rmd`**: R Markdown source file for the HTML report, combining narrative, code, and output.
- **`Google-Data-Analytics-Professional-Certificate-Capstone.html`**: Knitted HTML report with:
  - Business task, data sources, and limitations.
  - Analysis summary (correlations, usage patterns).
  - Visualizations and recommendations for Bellabeat’s marketing strategy.
- **`Google-Data-Analytics-Professional-Certificate-Capstone.pptx`**: PowerPoint slide deck summarizing findings and recommendations for Bellabeat executives, including a data sources table and key visualizations.
- **Visualizations**:
  - `Strong-Correlation-Steps-v-Calories-Burned.png`: Scatter plot of steps vs. calories (r = 0.59, p < 2.2e-16, 1397 records).
  - `Weak-Negative-Correlation-Sleep-Duration-v-Steps.png`: Scatter plot of sleep duration vs. steps (r = -0.17, p = 1.591e-05, 646 records).
  - `Weak-Positive-Correlation-Average-Heart-Rate-v-Steps.png`: Scatter plot of average heart rate vs. steps (r = 0.23, p = 3.812e-07, 478 records).
  - `Percentage-of-Records-with-Data-by-Feature.png`: Bar chart of feature usage (100% activity, 46% sleep, 34% heart rate).

## Data Source
- **Source**: FitBit Fitness Tracker Data (CC0: Public Domain, Kaggle, via Mobius): [Link](https://www.kaggle.com/datasets/arashnic/fitbit)
- **Files Used**:
  - `dailyActivity_merged_m1.csv`, `m2.csv`: Steps, distance, calories.
  - `minuteSleep_merged_m1.csv`, `m2.csv`: Sleep states (asleep, restless, awake).
  - `heartrate_seconds_merged_m1.csv`, `m2.csv`: Heart rate.
- **Note**: Original file names were modified by adding `_m1` or `_m2` to distinguish between files with identical names in the dataset.
- **Limitations**: Small sample (30 users), no demographic data, outdated (2016), missing sleep (46% of records) and heart rate (34% of records) data.

## Requirements
- **R Packages**: `dplyr`, `tidyr`, `lubridate`, `readr`, `ggplot2`
- **Data Files**: Download from the Kaggle link above and place in your working directory.

## Usage
1. Clone this repository: `git clone https://github.com/your-username/bellabeat-case-study.git`
2. Install required packages: `install.packages(c("dplyr", "tidyr", "lubridate", "readr", "ggplot2"))`
3. Download the FitBit dataset from Kaggle and update `setwd()` in `Google-Data-Analytics-Professional-Certificate-Capstone.R` to point to your data folder.
4. Run `Google-Data-Analytics-Professional-Certificate-Capstone.R` to reproduce the analysis and generate visualizations.
5. Knit `Google-Data-Analytics-Professional-Certificate-Capstone.Rmd` to produce the HTML report.

## Contact
For questions or feedback, reach out via https://www.linkedin.com/in/antonio-iannopollo
