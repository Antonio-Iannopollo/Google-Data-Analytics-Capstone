# Google Data Analytics Capstone
# Case Study 2: How Can a Wellness Technology Company Play It Smart?
# Antonio Iannopollo
# Date: June 2, 2025

# Load required packages
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(ggplot2)

# --- PROCESS PHASE: Load, Clean, and Aggregate Data ---

# 1. Daily Activity: Combine and clean dailyActivity_merged_m1.csv and m2.csv
daily_activity_m1 <- read_csv("dailyActivity_merged_m1.csv")
daily_activity_m2 <- read_csv("dailyActivity_merged_m2.csv")
daily_activity <- bind_rows(daily_activity_m1, daily_activity_m2) %>%
  mutate(ActivityDate = mdy(ActivityDate)) %>%
  rename(Date = ActivityDate)
sum(duplicated(daily_activity)) # Check duplicates
colSums(is.na(daily_activity)) # Check missing values
write_csv(daily_activity, "dailyActivity_combined.csv")

# 2. Heart Rate: Combine and aggregate heartrate_seconds_merged_m1.csv and m2.csv
heartrate_m1 <- read_csv("heartrate_seconds_merged_m1.csv")
heartrate_m2 <- read_csv("heartrate_seconds_merged_m2.csv")
heartrate_combined <- bind_rows(heartrate_m1, heartrate_m2) %>%
  mutate(Time = mdy_hms(Time)) %>%
  mutate(Date = as.Date(Time))
heartrate_daily <- heartrate_combined %>%
  group_by(Id, Date) %>%
  summarize(AvgHeartRate = mean(Value, na.rm = TRUE),
            MinHeartRate = min(Value, na.rm = TRUE),
            MaxHeartRate = max(Value, na.rm = TRUE)) %>%
  ungroup()
sum(duplicated(heartrate_daily))
colSums(is.na(heartrate_daily))
write_csv(heartrate_daily, "heartrate_daily_combined.csv")

# 3. Sleep: Combine and aggregate minuteSleep_merged_m1.csv and m2.csv
sleep_m1 <- read_csv("minuteSleep_merged_m1.csv")
sleep_m2 <- read_csv("minuteSleep_merged_m2.csv")
sleep_combined <- bind_rows(sleep_m1, sleep_m2) %>%
  mutate(date = mdy_hms(date)) %>%
  mutate(Date = as.Date(date))
sleep_daily <- sleep_combined %>%
  group_by(Id, Date) %>%
  summarize(
    TotalMinutesAsleep = sum(value == 1, na.rm = TRUE),
    TotalMinutesRestless = sum(value == 2, na.rm = TRUE),
    TotalMinutesAwake = sum(value == 3, na.rm = TRUE),
    TotalTimeInBed = sum(value %in% c(1, 2, 3), na.rm = TRUE),
    SleepRecords = n_distinct(logId)
  ) %>%
  ungroup()
sum(duplicated(sleep_daily))
colSums(is.na(sleep_daily))
write_csv(sleep_daily, "sleep_daily_combined.csv")

# --- ANALYZE PHASE: Merge, Summarize, and Correlate ---

# Merge datasets
combined_data <- daily_activity %>%
  left_join(heartrate_daily, by = c("Id", "Date")) %>%
  left_join(sleep_daily, by = c("Id", "Date"))

# Summary statistics
activity_summary <- daily_activity %>%
  summarize(AvgSteps = mean(TotalSteps, na.rm = TRUE),
            AvgDistance = mean(TotalDistance, na.rm = TRUE),
            AvgCalories = mean(Calories, na.rm = TRUE))
heartrate_summary <- heartrate_daily %>%
  summarize(AvgHeartRate = mean(AvgHeartRate, na.rm = TRUE),
            AvgMinHeartRate = mean(MinHeartRate, na.rm = TRUE),
            AvgMaxHeartRate = mean(MaxHeartRate, na.rm = TRUE))
sleep_summary <- sleep_daily %>%
  summarize(AvgSleepMinutes = mean(TotalMinutesAsleep, na.rm = TRUE),
            AvgRestlessMinutes = mean(TotalMinutesRestless, na.rm = TRUE),
            AvgAwakeMinutes = mean(TotalMinutesAwake, na.rm = TRUE),
            AvgTimeInBed = mean(TotalTimeInBed, na.rm = TRUE),
            AvgSleepRecords = mean(SleepRecords, na.rm = TRUE))

# Usage patterns
usage_summary <- combined_data %>%
  summarize(
    Users_Activity = n_distinct(Id[!is.na(TotalSteps)]),
    Days_Activity = sum(!is.na(TotalSteps)),
    Users_Sleep = n_distinct(Id[!is.na(TotalMinutesAsleep)]),
    Days_Sleep = sum(!is.na(TotalMinutesAsleep)),
    Users_HeartRate = n_distinct(Id[!is.na(AvgHeartRate)]),
    Days_HeartRate = sum(!is.na(AvgHeartRate))
  )
percent_summary <- combined_data %>%
  summarize(
    Percent_Activity = mean(!is.na(TotalSteps)) * 100,
    Percent_Sleep = mean(!is.na(TotalMinutesAsleep)) * 100,
    Percent_HeartRate = mean(!is.na(AvgHeartRate)) * 100
  )

# Correlations
cor_steps_calories <- cor.test(combined_data$TotalSteps, combined_data$Calories, use = "complete.obs")
cor_sleep_steps <- cor.test(combined_data$TotalMinutesAsleep, combined_data$TotalSteps, use = "complete.obs")
cor_heartrate_steps <- cor.test(combined_data$AvgHeartRate, combined_data$TotalSteps, use = "complete.obs")

# --- SHARE PHASE: Visualizations ---

# Steps vs. Calories
ggplot(combined_data, aes(x = TotalSteps, y = Calories)) +
  geom_point(color = "blue", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Strong Correlation: Steps vs. Calories Burned",
       x = "Total Steps", y = "Calories",
       caption = "Correlation: r = 0.59, p < 2.2e-16 (1397 records)") +
  theme_minimal()
ggsave("steps_calories.png")

# Sleep vs. Steps
ggplot(combined_data, aes(x = TotalMinutesAsleep, y = TotalSteps)) +
  geom_point(color = "green", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Weak Negative Correlation: Sleep vs. Steps",
       x = "Minutes Asleep", y = "Total Steps",
       caption = "Correlation: r = -0.17, p = 1.591e-05 (646 records)") +
  theme_minimal()
ggsave("sleep_steps.png")

# Heart Rate vs. Steps
ggplot(combined_data, aes(x = AvgHeartRate, y = TotalSteps)) +
  geom_point(color = "purple", alpha = 0.5) +
  geom_smooth(method = "lm", color = "red") +
  labs(title = "Weak Positive Correlation: Heart Rate vs. Steps",
       x = "Average Heart Rate (bpm)", y = "Total Steps",
       caption = "Correlation: r = 0.23, p = 3.812e-07 (478 records)") +
  theme_minimal()
ggsave("heartrate_steps.png")

# Feature usage bar plot
percent_data <- data.frame(
  Feature = c("Activity", "Sleep", "Heart Rate"),
  Percent = c(100, mean(!is.na(combined_data$TotalMinutesAsleep)) * 100, mean(!is.na(combined_data$AvgHeartRate)) * 100)
)
ggplot(percent_data, aes(x = Feature, y = Percent, fill = Feature)) +
  geom_bar(stat = "identity") +
  labs(title = "Percentage of Records with Data by Feature",
       x = "Feature", y = "Percentage of Records (%)",
       caption = "Activity: 1397 records, Sleep: 646 records, Heart Rate: 478 records") +
  theme_minimal() +
  scale_fill_manual(values = c("Activity" = "blue", "Sleep" = "green", "Heart Rate" = "purple"))
ggsave("feature_usage.png")