set.seed(343)

mydf <- data.frame(
  a = c("Paul","Kim","Nora","Sue","Paul","Kim")
  , b = c("A","A","B","B","B","C")
  , c = rnorm(2)
)
mydf
sapply(mydf, class)

mydatatable <- data.table::data.table(
  a = c("Paul","Kim","Nora","Sue","Paul","Kim")
  , b = c("A","A","B","B","B","C")
  , c = rnorm(2)
)
mydatatable
sapply(mydatatable, class)

library(tidyverse)
mydata_table <- tibble(
  a = c("Paul","Kim","Nora","Sue","Paul","Kim")
  , b = c("A","A","B","B","B","C")
  , c = rnorm(6)
)
mydata_table
sapply(mydata_table, class)

class(mydf);class(mydatatable);class(mydata_table);
 

set.seed(123)
measurement.a = c(rnorm(20), 22, rnorm(10), 54, rnorm(10))
measurement.b = c(rnorm(19,5), NA, rnorm(10,5), NA, rnorm(11,5))
mydf <- data.frame(measurement.a, measurement.b)

summary(mydf)
plot(mydf)

library(zoo)
rollmean(mydf$measurement.b, 5)

library(mice)
mymice <- mice(mydf, m = 3, method = "rf")
mydf <- complete(mymice, 1)
summary(mydf)

library(outliers)
mydf$measurement.a <- rm.outlier(mydf$measurement.a, fill = T, median = T)
summary(mydf)
plot(mydf)

summary(FlowerPicks)

compcases <- complete.cases(FlowerPicks) == T
boxplot(Score ~ Player, FlowerPicks)
lm(data = FlowerPicks, formula = Score ~ Time)

cleandata <- na.omit(FlowerPicks)
summary(cleandata)

library(zoo)
x = na.locf(FlowerPicks$Score)
summary(x)

library(mice)
md.pattern(FlowerPicks)

mymice <- mice(FlowerPicks, m = 10, method = 'rf')
class(mymice)
mymice$imp$Score
mymicecomplete <- complete(mymice, 5)
summary(mymicecomplete)

lmfit <- with(mymice, lm(Score ~Time))
summary(pool(lmfit))

        