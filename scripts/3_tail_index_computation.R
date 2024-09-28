# Analyzing the Behavior of French Stocks During Crises :
# A Comparative Study of Return Distributions from 2007 to 2022 Using the Tail Index
#
# Author : Baptiste WAIGNON
# Supervisor :  Marcel ALOY                                                  

#----------------------------------Libraries----------------------------------

library("ptsuite")

#----------------------------------Constants----------------------------------

StartDate <- as.Date("2007-01-01")
EndDate   <- as.Date("2022-12-31")

#-----------------------------------Script------------------------------------

# Tail Index (xi) using Weighted Least Square Estimator

  # Reference period
referencePeriodxi <- list()
for (tickers in names(referencePeriodNeg)) {
  alpha <- alpha_wls(referencePeriodNeg[[tickers]])
  for (item in names(alpha)) {
    alpha[[item]] <- 1 / alpha[[item]]
  }
  referencePeriodxi[[tickers]] <- alpha
}

  # Benchmark
cac40Periods <- list(period1CAC40, period2CAC40, period3CAC40, period4CAC40, referencePeriodCAC40)
cac40xi <- list()

for (i in seq_along(cac40Periods)) {
  neg <- cac40Periods[[i]][cac40Periods[[i]] < 0]
  abs_neg <- abs(neg)
  alpha <- alpha_wls(abs_neg)
  for (item in names(alpha)) {
    alpha[[item]] <- 1 / alpha[[item]]
  }
  cac40xi[[i]] <- alpha
}

  # Period (1)
period1xi <- list()
for (tickers in names(period1Neg)) {
  alpha <- alpha_wls(period1Neg[[tickers]])
  for (item in names(alpha)) {
    alpha[[item]] <- 1 / alpha[[item]]
  }
  period1xi[[tickers]] <- alpha
}

  # Period (2)
period2xi <- list()
for (tickers in names(period2Neg)) {
  alpha <- alpha_wls(period2Neg[[tickers]])
  for (item in names(alpha)) {
    alpha[[item]] <- 1 / alpha[[item]]
  }
  period2xi[[tickers]] <- alpha
}

  # Period (3)
period3xi <- list()
for (tickers in names(period3Neg)) {
  alpha <- alpha_wls(period3Neg[[tickers]])
  for (item in names(alpha)) {
    alpha[[item]] <- 1 / alpha[[item]]
  }
  period3xi[[tickers]] <- alpha
}

  # Period (4)
period4xi <- list()
for (tickers in names(period4Neg)) {
  alpha <- alpha_wls(period4Neg[[tickers]])
  for (item in names(alpha)) {
    alpha[[item]] <- 1 / alpha[[item]]
  }
  period4xi[[tickers]] <- alpha
}

# Result by Category (ICB Classification)

ICBclassification <- c(
  "AI" = "Basic Materials", "MT" = "Basic Materials",
  "KER" = "Consumer Discretionary", "MC" = "Consumer Discretionary",
  "ML" = "Consumer Discretionary", "OR" = "Consumer Discretionary",
  "PUB" = "Consumer Discretionary", "RMS" = "Consumer Discretionary",
  "RNO" = "Consumer Discretionary", "STLAP" = "Consumer Discretionary",
  "VIV" = "Consumer Discretionary", "BN" = "Consumer Staples",
  "CA" = "Consumer Staples", "RI" = "Consumer Staples",
  "TTE" = "Energy", "ACA" = "Financials", "BNP" = "Financials",
  "CS" = "Financials", "GLE" = "Financials", "EL" = "Health Care",
  "ERF" = "Health Care", "SAN" = "Health Care", "AIR" = "Industrials",
  "ALO" = "Industrials", "DG" = "Industrials", "EDEN" = "Industrials",
  "EN" = "Industrials", "HO" = "Industrials", "LR" = "Industrials",
  "SAF" = "Industrials", "SGO" = "Industrials", "SU" = "Industrials",
  "TEP" = "Industrials", "URW" = "Real estate", "CAP" = "Technology",
  "DSY" = "Technology", "STMPA" = "Technology", "ORA" = "Telecommunications",
  "ENGI" = "Utilities", "VIE" = "Utilities"
)

periods <- list(period1xi, period2xi, period3xi, period4xi, referencePeriodxi)
TailIndexes <- list()

for (i in seq_along(periods)) {
  period <- periods[[i]]
  for (ticker in names(period)) {
    TailIndex <- period[[ticker]]$shape
    if (!ticker %in% names(TailIndexes)) {
      TailIndexes[[ticker]] <- numeric(length(periods))
    }
    TailIndexes[[ticker]][i] <- TailIndex
  }
}

TailIndexes$CAC40 <- sapply(cac40xi, function(x) x$shape)

TailIndexesDf <- as.data.frame(do.call(rbind, TailIndexes))
rownames(TailIndexesDf) <- names(TailIndexes)
colnames(TailIndexesDf) <- c("(1)", "(2)", "(3)", "(4)", "Reference")

TailIndexesDf$Sector <- ICBclassification[rownames(TailIndexesDf)]
TailIndexesDf$Sector[rownames(TailIndexesDf) == "CAC40"] <- "Benchmark"

sectorTables <- split(TailIndexesDf, TailIndexesDf$Sector)
sectorTables <- lapply(sectorTables, function(df) {
  df$Sector <- NULL
  return(df)
})
