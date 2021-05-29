library(tidyverse)
#setwd("C:/Users/16477/Desktop/final_project")
setwd("~/Documents/")
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

### Create new delta T columns: 
  # define se1_time = 0, then
  # need to calculate:
  # dt_1 = se2_time - se1_time,
  # dt_2 = se3_time - se2_time,
  # dt_3 = se4_time - se3_time
library(lubridate)
df$se1_time <- hms::as_hms(df$se1_time)
df$se2_time <- hms::as_hms(df$se2_time)
df$se3_time <- hms::as_hms(df$se3_time)
df$se4_time <- hms::as_hms(df$se4_time)

df <- df %>% mutate (dt_1=se1_time-se1_time) %>% 
  mutate(dt_2=se2_time-se1_time) %>%
  mutate(dt_3=se3_time-se1_time) %>%
  mutate(dt_4=se4_time-se1_time)

#### Transform nto long format ###
library(sjmisc)
df_long <- to_long(data = df,
        keys = "time",
        values = c("frc","dt","trc"),
        c("se1_frc","se2_frc","se3_frc","se4_frc"),
        c("dt_1","dt_2","dt_3","dt_4"),
        c("se1_trc","se2_trc","se3_trc","se4_trc"))




##### Plot FRC Overall

library(ggplot2)
ggplot(df_long, aes(x=frc,y=trc,color=camp))+geom_point()

ggplot(df_long, aes(x=frc,y=trc,color=sb_drawing))+geom_point()

#### Plot FRC at each time point (X axis: dt (in seconds), Y axis: frc)
library(lubridate)
# Most basic bubble plot
p <- ggplot(df_long, aes(x=dt, y=frc,color=camp)) +
  geom_point() + 
  xlab("Time in Seconds")

p

# Plot the distributions of FRC at each stage separately
ggplot(data = df_long) +
  geom_histogram(aes(x = frc, y=(..count..)/sum(..count..), fill=time), 
                 alpha=0.5, binwidth=0.1, position="identity")


