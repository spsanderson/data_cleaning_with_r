### Queries, Filtering, Subsetting
# Creating mydf as our data.frame
set.seed(343)
mydf = data.frame(a = c("Paul", "Kim", "Nora", "Sue", "Paul", "Kim"),
                  b = c("A", "A", "B", "B", "B", "C"),
                  c = rnorm(2)); 
mydf

# Creating mytable as our data.table
library(data.table)

set.seed(343)
mytable = data.table(a = c("Paul", "Kim", "Nora", "Sue", "Paul", "Kim"),
                     b = c("A", "A", "B", "B", "B", "C"),
                     c = rnorm(2)); 
mytable

# Row extraction
mydf[3,]
mytable[3,]

# Difference in how these 2 react
mydf[3]
mytable[3]

# Column extraction
mydf[,3]
mytable[,3]

# Filtering based on group variable
mydf[mydf$b == "A",]
mytable[b == "A",]

# Using both row and column specification
mydf[mydf$b == "A", 3]
mytable[b == "A", 3]

# More advanced queries
mydf[mydf$b == "A" | mydf$b == "B",]
mytable[b == "A" | b == "B",]

##  Using a tibble in a query
library(tibble)
library(dplyr)

# Convert our data.frame to a tibble
mytibble = as_tibble(mydf)
class(mytibble)

# Standard queries on a tibble do work
mytibble[mytibble$b == "A" | mytibble$b == "B",]
mytibble[3,3]

### Dplyr
install.packages("dplyr") # install once
library(dplyr) # activation

mydf = data.frame(a = c("Paul", "Kim", "Nora", "Sue", "Paul", "Kim"), b = c("A", "A", "B", "B", "B", "C"), c = rnorm(2)); mydf
filter(mydf, a == "Paul" & b == "A") # filtering the df with logical operators
filter(mydf, c < 0.1) # filtering for column c smaller 0.1
slice(mydf, c(1,3,6)) # selecting rows with row IDs and the slice function
arrange(mydf, -c) # ordering after c descendingly
arrange(mydf, desc(c)) # the same effect
select(mydf, a, c) # with select we can simply pick specific columns
select(mydf, -b) # same result
rename(mydf, names = a) # rename function for column names
distinct(select(mydf, b)) # identifying the levels in a column
mutate(mydf, squared_measurement = c^2) # adding a new calculated column, similar to base transform
sample_n(mydf, 3) # random sample generator

### data.table specific queries
library(data.table)

# Sample dataset
set.seed(343)
mytable = data.table(a = c("Paul", "Kim", "Nora", "Sue", "Paul", "Kim"),
                     b = c("A", "A", "B", "B", "B", "C"),
                     c = rnorm(2)); 
mytable

# Getting counts in column b
mytable[, sum(b == "B")]

# Alternative
mytable[ b =="B", .N]

# Summation in column c
mytable[3:6, sum(c)]
mytable[!3:6, sum(c)]

# Using the by parameter
mytable[, by = b, .N]

# Combining by and counts
mytable[, by = .(b,a), .N]

# Ordering a table
mytable[order(-b, -a)]

# Permanently change the order
setorder(mytable, -b,-a)
mytable

# Table transposition
transpose(mytable)

# Class conversion to dt
newmt = data.table(mtcars); class(newmt)
