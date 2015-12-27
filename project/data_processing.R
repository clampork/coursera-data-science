library(dplyr)

# Load dataset
url <- "https://data.gov.sg/dataset/edcc4d35-08e0-4ebd-b3bb-ac3a6a10c103/resource/eb8b932c-503c-41e7-b513-114cffbe2338/download/Graduates-From-University-First-Degree-Courses.csv"
file <- basename(url)

if(!file.exists(file)) {
    library(downloader)
    download(url, file, mode = "wb")
}

df_raw <- tbl_df(read.csv(file, na.strings = "na"))

# Aggregate and clean dataset
df_agg <- df_raw %>%
    na.omit() %>%
    group_by(year) %>%
    summarize(graduates = sum(no_of_graduates))

df_cleaned <- df_raw %>%
    na.omit() %>%
    left_join(df_agg) %>%
    mutate(proportion = no_of_graduates * 100 / graduates)