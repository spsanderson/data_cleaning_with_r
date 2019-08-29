# lib load ####
library(tidyverse)
library(data.table)
library(outliers)
library(mvoutlier)
library(mice)
library(outliers)

# Lib Load ####
df <- read.csv("car_parts.csv") %>% as_tibble()
str(df)
head(df)
summary(df)

# Clean Data ####
# re-categorize columns
df$FirstName <- as.character(df$FirstName)
df$LastName <- as.character(df$LastName)
df$X <- NULL
df$Date <- lubridate::ymd(df$Date)

# MICE (Imputation)
# Missing Data
DataExplorer::plot_missing(df)
md.pattern(df)
# Impute missing values
mymice <- mice(df, m = 10, method = 'rf')
# The result has class mids
class(mymice)

# Display the calculated data
mymice$imp$Sales
mymice$imp$Profit

df <- complete(mymice, 5)
DataExplorer::plot_missing(df)

# Melt name column
df$Name <- str_to_upper(str_c(df$LastName, ", ", df$FirstName))

# Convert all Sales and Profit to USD
AUD <- 0.673371
CAD <- 0.751988
NZD <- 0.631728

df$Sales_USD <- if_else(
  df$Currency == 'AUD'
  , df$Sales * AUD
  , if_else(
    df$Currency == 'CAD'
    , df$Sales * CAD
    , if_else(
      df$Currency == 'NZD'
      , df$Sales * NZD
      , df$Sales
    )
  )
)

df$Profit_USD <- if_else(
  df$Currency == 'AUD'
  , df$Profit * AUD
  , if_else(
    df$Currency == 'CAD'
    , df$Profit * CAD
    , if_else(
      df$Currency == 'NZD'
      , df$Profit * NZD
      , df$Profit
    )
  )
)

# Outlier Review ####
summary(df)
plot(df$Sales_USD)
plot(df$Profit_USD)

elements <- tibble(Sales_USD = df$Sales_USD, Profit_USD = df$Profit_USD)
head(elements)

myout <- sign2(elements, qqcrit = 0.975)
myout
plot(df$Sales_USD, df$Profit_USD, col = myout$wfinal01+2)

df$Profit_USD <- rm.outlier(df$Profit_USD, fill = T, median = T)
boxplot(df$Profit_USD)

# questions
cp <- data.table(df)
str(cp)
cp[,sum(Profit_USD), by = Category]

mean(df$Profit_USD)

df$ProfitMargin <- round(((df$Profit_USD / df$Sales_USD) * 100),1)
head(df)
df %>%
  group_by(Category, add = T) %>%
  summarise(mean(ProfitMargin))
