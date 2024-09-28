# Analyzing the Behavior of French Stocks During Crises :
# A Comparative Study of Return Distributions from 2007 to 2022 Using the Tail Index
#
# Author : Baptiste WAIGNON
# Supervisor :  Marcel ALOY                                                  

#----------------------------------Libraries----------------------------------

library("xts")      
library("ggplot2")

#----------------------------------Constants----------------------------------

StartDate <- as.Date("2007-01-01")
EndDate   <- as.Date("2022-12-31")

#-----------------------------------Script------------------------------------

  # CAC40 Index Returns Historic
print(autoplot(cac40DailyReturns, facets = NULL) +
  ggtitle("CAC40 Index Daily Returns") +
  theme_minimal() +
  ylab("Returns") +
  xlab("Date"))

  # CAC40 Index Returns Distribution
print(ggplot(cac40DailyReturns, aes(x = FCHI.Adjusted)) +
  geom_histogram(binwidth = 0.0005, fill = "black") +
  theme_minimal() +
  ggtitle("CAC40 Index Daily Returns Distribution") +
  ylab("Frequency") +
  xlab("Returns"))

  # CAC40 Index Equity Curve
print(autoplot(equityCurveCac40, facets = NULL) +
  ggtitle("CAC40 Index Daily Equity Curve") +
  theme_minimal() +
  ylab("Value") +
  xlab("Date"))

  # CAC40 Realized Volatility
print(autoplot(cac40DailyReturns^2, facets = NULL) +
  ggtitle("CAC40 Index Realized Daily Volatility") +
  theme_minimal() +
  ylab("Squared Returns") +
  xlab("Date"))

acf(cac40DailyReturns, lag.max = 20, 
    type = "correlation", plot = TRUE, na.action = na.pass, demean = TRUE)
acf(cac40DailyReturns^2, lag.max = 20, 
    type = "correlation", plot = TRUE, na.action = na.pass, demean = TRUE)
acf(referencePeriodCAC40, lag.max = 20, 
    type = "correlation", plot = TRUE, na.action = na.pass, demean = TRUE)

acf(period1CAC40, lag.max = 20, 
    type = "correlation", plot = TRUE, na.action = na.pass, demean = TRUE)
acf(period2CAC40, lag.max = 20, 
    type = "correlation", plot = TRUE, na.action = na.pass, demean = TRUE)
acf(period3CAC40, lag.max = 20, 
    type = "correlation", plot = TRUE, na.action = na.pass, demean = TRUE)
acf(period4CAC40, lag.max = 20, 
    type = "correlation", plot = TRUE, na.action = na.pass, demean = TRUE)

# Tail Indices by Sector
for (sector in names(sectorTables)) {
  cat("Sector:", sector, "\n")
  print(sectorTables[[sector]])
  cat("\n")
}

# Plot results
sectorTables <- split(TailIndexesDf, TailIndexesDf$Sector)
periods <- colnames(TailIndexesDf)[1:(ncol(TailIndexesDf) - 1)]

for (sector in names(sectorTables)) {
  sectorData <- sectorTables[[sector]]
  sectorData$Sector <- NULL
  
  matData <- t(sectorData)
  
  plotColors <- rainbow(ncol(matData))
  
  op <- par(no.readonly = TRUE)
  
  layout(matrix(c(1, 2), nrow = 1), widths = c(3, 1))
  
  par(mar = c(4, 4, 4, 0) + 0.1)
  
  matplot(matData, type = "l", lty = 1, col = plotColors, xaxt = "n", 
          main = paste("Evolution of Tail Index :", sector),
          xlab = "Period", ylab = "Tail Index")
  
  axis(1, at = 1:nrow(matData), labels = periods)
  
  par(mar = c(0, 0, 0, 0))
  plot.new()
  
  legend("center", legend = rownames(sectorData), col = plotColors, lty = 1, 
         cex = 0.8, pt.cex = 1, y.intersp = 1.5, bty = "n")  # Adjust y.intersp for more space
  
  par(op)
}