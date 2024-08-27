# Analyzing the Behavior of French Stocks During Crises :
# A Comparative Study of Return Distributions from 2007 to 2022 Using the Tail Index
#
# Author : Baptiste WAIGNON
# Supervisor :  Marcel ALOY                                                  

#----------------------------------Libraries----------------------------------

library("PerformanceAnalytics")
library("xts")

#----------------------------------Constants----------------------------------

StartDate <- as.Date("2007-01-01")
EndDate   <- as.Date("2022-12-31")

#-----------------------------------Script------------------------------------

cac40DailyReturns <- na.omit(Return.calculate(cac40DailyPrices))
compDailyReturns <- Return.calculate(compDailyPrices)

equityCurveCac40 <- cumprod(1 + cac40DailyReturns)

# Index Statistics

cac40Mean <- round(mean(cac40DailyReturns), 4)
cac40Sd <- round(sd(cac40DailyReturns), 4)
cac40Skew <- round(skewness(cac40DailyReturns), 4)
cac40Kurt <- round(kurtosis(cac40DailyReturns), 4)
cac40Statistics <- data.frame(cbind(cac40Mean , cac40Sd, cac40Skew, cac40Kurt))
print(cac40Statistics)

# Split by periods 

  # Reference Period
referencePeriod <- compDailyReturns["2014-01/2015-12"]
referencePeriodCAC40 <- cac40DailyReturns["2014-01/2015-12"]
# plot acf
referencePeriod <- referencePeriod[,colSums(is.na(referencePeriod))!=nrow(referencePeriod)]
referencePeriod <- na.omit(referencePeriod)
referencePeriodDf <- data.frame(coredata(referencePeriod)) 
referencePeriodNeg <- list()
for (tickers in names(referencePeriodDf)) {
  neg <- referencePeriodDf[[tickers]][referencePeriodDf[[tickers]] < 0]
  referencePeriodNeg[[tickers]] <- abs(neg)
}

  # Global Financial Crisis
period1 <- compDailyReturns["2008-08/2009-01"]
period1CAC40 <- cac40DailyReturns["2008-08/2009-01"]
period1 <- period1[,colSums(is.na(period1))!=nrow(period1)]
period1 <- na.omit(period1) 
period1Df <- data.frame(coredata(period1)) 
period1Neg <- list()
for (tickers in names(period1Df)) {
  neg <- period1Df[[tickers]][period1Df[[tickers]] < 0]
  period1Neg[[tickers]] <- abs(neg)
}

  # European Debt Crisis
period2 <- compDailyReturns["2011-04/2011-07"]
period2CAC40 <- cac40DailyReturns["2011-04/2011-07"]
period2 <- period2[,colSums(is.na(period2))!=nrow(period2)]
period2 <- na.omit(period2)
period2Df <- data.frame(coredata(period2)) 
period2Neg <- list()
for (tickers in names(period2Df)) {
  neg <- period2Df[[tickers]][period2Df[[tickers]] < 0]
  period2Neg[[tickers]] <- abs(neg)
}

  # Covid-19 Crisis
period3 <- compDailyReturns["2020-01/2020-03"]
period3CAC40 <- cac40DailyReturns["2020-01/2020-03"]
period3 <- period3[,colSums(is.na(period3))!=nrow(period3)]
period3Df <- data.frame(coredata(period3)) 
period3Df <- na.locf(period3Df)      
period3Neg <- list()
for (tickers in names(period3Df)) {
  neg <- period3Df[[tickers]][period3Df[[tickers]] < 0]
  period3Neg[[tickers]] <- abs(neg)
}

  # Ukrainian War Crisis
period4 <- compDailyReturns["2022-01/2022-02"]
period4CAC40 <- cac40DailyReturns["2022-01/2022-02"]
period4Df <- data.frame(coredata(period4)) 
period4Df <- na.locf(period4Df)
period4Neg <- list()
for (tickers in names(period4Df)) {
  neg <- period4Df[[tickers]][period4Df[[tickers]] < 0]
  period4Neg[[tickers]] <- abs(neg)
}