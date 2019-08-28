### The Pipe Operator
### Using the Pipe Operator
library(dygraphs)

dygraph(lynx, main = "Canadian Lynx Trappings") %>%
  dyRangeSelector() %>%
  dyLegend(show = "always", hideOnMouseOut = FALSE) %>%
  dyAxis("y", label = "Yearly Catches") %>%
  dyHighlight(highlightCircleSize = 5) %>%
  dyAnnotation("1904-01-01", text = "RS", tooltip = "Record Season")

## Alternative Operators - in magrittr
library(magrittr)

# Attaching to environment
mtcars %$% plot(hp, mpg)
mtcars %<>% transform(mpg = mpg * 10)

# Note how mpg is now in the hundreds
head(mtcars)

# T pipe for intermediary step
rnorm(200) %>%
  matrix(ncol = 2) %T>%
  plot() %>%
  str()

### Using the Tibble
# 3 numeric columns, n of 200
set.seed(123)

A = rnorm(200, 34583)
B = rnorm(200, 54)
C = rnorm(200, 2)

# Standard data.frame
mydf = data.frame(A, B, C)
head(mydf)

# Comparing to a tibble
library(tibble)

mytibble = tibble(A, B, C)
head(mytibble)
mytibble

# This is the same thing!
mytibble2 = data_frame(A, B, C) # function available in tibble
head(mytibble2)

mytibble2

# Does not work any more
library(dplyr)

mytibble3 = tbl_df(A, B, C) # from dplyr, discontinued function

# tibble allows columns to be created with other columns
mytibble = tibble(a = rnorm(100), b = a + 5)

# Data.frame does not support that
mydf = data.frame(a = rnorm(100), b = a + 5)

# Using tribble to build a tibble row by row manually
tibblebyrow = tribble(~ Person, ~ Score,
                      "Matt Rosen", 5464,
                      "Steve Pitt", 3453,
                      "Todd Welch", 6934,
                      "Mike Ingram", 3452,
                      "Jacob Nunes", 5683)
head(tibblebyrow)

# We can add rows
tibblebyrow = add_row(tibblebyrow,
                      Person = "Harold Rao",
                      Score = 8457)

head(tibblebyrow)

# And we can add columns
tibblebyrow = add_column(tibblebyrow,
                         Year = c(1992, 1995, 1992, 1997, 1991, 1993))
head(tibblebyrow)

# This year column contains only 5 values
tibblebyrow1 = add_column(tibblebyrow,
                          Year1 = c(1992, 1995, 1992, 1997, 1991))

# This year column contains only 1 value
tibblebyrow2 = add_column(tibblebyrow,
                          Year2 = c(1992))

head(tibblebyrow2)


# Conversion function for existing data.frame
iristibble = as.tibble(iris)
head(iristibble)
class(iristibble)

### Cleaning your data - Restructuring it with tidyr
library(tidyr)
library(dplyr) # also activate dplyr since it has helpful add on fuctions

# set wd
# Wide to long form conversion
# import as csv , make sure to have heading activated
# if there is no heading R might not recognize all columns
bugs = Bug.Frequency # easier to code
head(bugs)

# lets redo the header line since the import worked poorly
names(bugs) <- c("Region", "<10 g", "10-20 g", "20-30 g", "30-40 g", ">40 g")
bugs

# now we can convert to long form
gather(data = bugs, key = weight, value = counts, -Region)

# we are specifying the dataset, our key-the different weights in one column
# we put all the counts in 1 column, and we suppress a gathering of Region
# we can store it as a table
bugs.table = tbl_df(gather(data = bugs, key = weight,value = counts, -Region))

# we can of course change the order with the arrange function
arrange(bugs.table, Region)

## alternative with package reshape2
bugs.melt = melt(data = bugs, measure.vars = c(2:6), # here we use col IDs
                 variable.name = "weight",
                 value.name = "counts"); bugs.melt

# Column separation
# Sometimes you might have too much information in 1 column
age.sex <- data.frame(
  name = c("Paul", "Kim", "Nora", "Sue", "Paul", "Kim"),
  biometrics = c("179m", "173f", "174f", "159f", "188m", "163f"),
  measurement = rnorm(6)); age.sex

# here the column biometrics contains height in cm and sex at the same time
# this requires separation in many cases
# we can use separate to split the biometrics column in 2
separate(data = age.sex, col = biometrics,
         into = c("height", "sex"), 3)

# number 3 indicates were to split, pos starts from left, - from right
# Long to wide form conversion
# What can you do if you have two variables in the same column
# going from long form to wide form
sports <- data.frame(
  name = c("Paul", "Paul", "Nora", "Nora", "Kim", "Kim"),
  performance = c("top", "low", "top", "low", "top", "low"),
  counts = c(11,3,18,2,9,1)); sports

# here we have 2 variables the top and low performance in 1 column
# how do we split it up?
spread(data=sports, key = performance, value = counts)

## lets check the alternative from the reshape2 package
# the argument names differ a bit, but the function structure looks very similar
dcast(data = sports, name ~ performance, value.var = "counts" )

### Handling Strings in R with "stringr"
# quotations "" or '' are used to specify data as a string (character)
mystring <- "this is a string!"
class(mystring)

library(stringr)
# example vectors
length(fruit)
length(words)
length(sentences)

# adding strings together
combstrings <- str_c(c(fruit, words)); combstrings

# we can count the occurences of a specific symbol combination
sum(str_count(combstrings, "lo"))

# replacement similar to sub - first occurence
str_replace(fruit, "ap", "XX")
# str_replace_all as alternative
# case conversions
str_to_upper(fruit)

# number of symbols in each string value
str_length(fruit)

# padding to get equal length for all values
str_pad(fruit, 19, "right", pad = "X")