# lib load ####
library(tidyverse)
library(data.table)
library(outliers)
library(mvoutlier)
library(mice)

# Lib Load ####
df <- read.csv("car_parts.csv") %>% as_tibble()
str(df)
head(df)
summary(df)

df$FirstName <- as.character(df$FirstName)
df$LastName <- as.character(df$LastName)
