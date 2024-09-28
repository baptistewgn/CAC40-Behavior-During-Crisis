# Analyzing the Behavior of French Stocks During Crises :
# A Comparative Study of Return Distributions from 2007 to 2022 Using the Tail Index
#
# Author : Baptiste WAIGNON
# Supervisor :  Marcel ALOY                                                  

#----------------------------------Libraries----------------------------------

library("quantmod")
library("readxl")
library("xts")

#----------------------------------Constants----------------------------------

StartDate <- as.Date("2007-01-01")
EndDate   <- as.Date("2022-12-31")

#-----------------------------------Script------------------------------------

# Raw Data Collection and cleaning 

  # CAC40 Index
getSymbols(Symbols="^FCHI",
           from=StartDate, 
           to=EndDate, 
           src="yahoo")
cac40DailyPrices <- na.omit(FCHI[,6])

  # CAC40 Components 
comp <- c("AI.PA","MT","MC.PA","OR.PA","RMS.PA","KER.PA","ML.PA",
          "PUB.PA","RNO.PA","VIV.PA","BN.PA","RI.PA","CA.PA","TTE.PA","BNP.PA",
          "CS.PA","GLE.PA","ACA.PA","SAN.PA","EL.PA","ERF.PA","SU.PA","AIR.PA",
          "DG.PA","SAF.PA","SGO.PA","LR.PA","HO.PA","EDEN.PA","TEP.PA","EN.PA",
          "ALO.PA","CAP.PA","DSY.PA","STMPA.PA","ORA.PA","ENGI.PA","VIE.PA")

compDailyPrices <- c()
for (ticker in comp) {
  cat(ticker, "\n")
  price <- suppressWarnings(getSymbols(Symbol=ticker, from=StartDate, to=EndDate))
  adjustedPrice <- get(price)[ ,6]
  adjustedPrice <- na.locf(adjustedPrice)
  compDailyPrices  <- cbind(compDailyPrices, adjustedPrice)
}

    # URW missing data from src 'yahoo finance'
    # Data collected from investing.com as URW.csv
URW <- na.locf(as.xts(read_excel(path = "/Users/bwgn/Library/Mobile Documents/com~apple~CloudDocs/Cours/M2 Financial Management Risk/Master Thesis/data/URW.xlsx")))
compDailyPrices  <- cbind(compDailyPrices, URW)

    # STLAP issue during importation from 'yahoo finance'
    # manual extraction form yahoo finance
STLAP <- na.locf(as.xts(read_excel(path = "/Users/bwgn/Library/Mobile Documents/com~apple~CloudDocs/Cours/M2 Financial Management Risk/Master Thesis/data/STLAP.PA.xlsx")))
compDailyPrices  <- cbind(compDailyPrices, STLAP)

comp <- c("AI","MT","MC","OR","RMS","KER","ML","PUB",
          "RNO","VIV","BN","RI","CA","TTE","BNP","CS",
          "GLE","ACA","SAN","EL","ERF","SU","AIR","DG",
          "SAF","SGO","LR","HO","EDEN","TEP","EN","ALO",
          "CAP","DSY","STMPA","ORA","ENGI","VIE","URW","STLAP")
colnames(compDailyPrices) <- comp

# Export data for repeatability 

saveRDS(cac40DailyPrices, file = "../database/CAC40_index_daily_Prices_2008_2022.rds")
saveRDS(compDailyPrices, file = "../database/CAC40_components_daily_Prices_2008_2022.rds")
