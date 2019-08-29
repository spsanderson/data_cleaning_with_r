### Course Project Solutions - dataset car_parts.csv
# Converting to a tibble
library(tibble)
carpts <- as_tibble(read.csv('car_parts.csv'))

# Combining the names
library(tidyr) # unite function
carpts = unite(carpts, col = "Name", c("FirstName", "LastName"), sep = " ")

# How does the end of the dataset look?
tail(carpts) # problem in last observation

# Deleting the last row
carpts <- carpts[1:1000,]
tail(carpts)
summary(carpts)

# Outlier detection - Boxplot
boxplot(carpts$Profit) # Outliers present
boxplot(carpts$Sales) # No Outlier visible

library(outliers)
# Depending on the Boxplot we need to run this several times
carpts$Profit <- rm.outlier(carpts$Profit, fill = T, median = T)
boxplot(carpts$Profit) # Check the column
summary(carpts)

# Missing Data Handling
library(mice)
carptscomp <- mice(carpts, m = 3, method = "rf")
carpts <- complete(carptscomp, 1)
summary(carpts)

## Currency Conversion Rates Used
# 1 USD equals -
# 1.376 AUD
# 1.312 CAD
# 1.516 NZD
# tibble containing the currency rates
currencies <- tribble(~Currency, ~Rate,
                      "USD", 1,
                      "AUD", 1.376,
                      "CAD", 1.312,
                      "NZD", 1.516)

# join with the merge function of R Base
carpts = merge(currencies, carpts, by = "Currency")
head(carpts)

# converting Sales and Profit to USD
carpts$Sales = carpts$Sales/carpts$Rate
carpts$Profit = carpts$Profit/carpts$Rate
head(carpts)

# renaming the relevant columns
library(dplyr)

carpts = rename(carpts,
                USDSales = Sales,
                USDProfit = Profit,
                TransactionCurrency = Currency)
head(carpts)

# reordering the columns
head(carpts)
carpts = carpts[, c(8,4,3,7,5,6,2,1)]
head(carpts)

# rounding
carpts$USDSales = round(carpts$USDSales, 1)
carpts$USDProfit = round(carpts$USDProfit, 1)
head(carpts)

## Queries
# 1.First you want to know the overall profit achieved by category
library(data.table)

carpts <- data.table(carpts)
carpts[, sum(USDProfit), by = Category]

# 2.What is the average profit by transaction
mean(carpts$USDProfit)

# 3.Add an extra column with profit margin (the percentage of sales which is the profit)
carpts$ProfitMargin <- round(((carpts$USDProfit/carpts$USDSales)*100),1)
head(carpts)

# 4.What is the average profit margin by category
carpts[, mean(ProfitMargin), by = Category]

