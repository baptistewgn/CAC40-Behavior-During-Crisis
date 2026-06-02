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

compute_xi <- function(neg_list) {
  lapply(neg_list, function(returns) {
    alpha <- alpha_wls(returns)
    lapply(alpha, function(x) 1 / x)
  })
}

referencePeriodxi <- compute_xi(referencePeriodNeg)
period1xi         <- compute_xi(period1Neg)
period2xi         <- compute_xi(period2Neg)
period3xi         <- compute_xi(period3Neg)
period4xi         <- compute_xi(period4Neg)

  # Benchmark
cac40Periods <- list(period1CAC40, period2CAC40, period3CAC40, period4CAC40, referencePeriodCAC40)
cac40xi <- lapply(cac40Periods, function(period) {
  abs_neg <- abs(period[period < 0])
  alpha   <- alpha_wls(abs_neg)
  lapply(alpha, function(x) 1 / x)
})

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
