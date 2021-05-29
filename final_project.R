library(tidyverse)
setwd("C:/Users/16477/Desktop/final_project")
df <- read_csv("south_sudan_2013.csv")

##### we need to check the unique identifier of the data set #####

# there are 220 rows in the data set
nrow(df) == length(unique(df$sample_id))
# so, I sample id is the unique id in the analysis

##### separate into four groups and change into long format for better analysis #####

all_colnames <- colnames(df)
se1_df <- df %>% 
  dplyr::select(c("sample_id", contains("se1_")))
col_se1 <- colnames(se1_df)

se2_df <- df %>% 
  select(contains(c("sample_id", "se2_")))
col_se2 <- colnames(se2_df)

se3_df <- df %>% 
  select(contains(c("sample_id", "se3_")))
col_se3 <- colnames(se3_df)

se4_df <- df %>% 
  select(contains(c("sample_id", "se4_")))
col_se4 <- colnames(se4_df)


`%not_in%` <- purrr::negate(`%in%`)
subset(all_colnames, all_colnames %not_in% col_se1)
col_se1
col_se2
col_se3
col_se4