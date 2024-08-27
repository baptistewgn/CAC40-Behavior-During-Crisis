# Analyzing the Behavior of French Stocks During Crises :
# A Comparative Study of Return Distributions from 2007 to 2022 Using the Tail Index
#
# Author : Baptiste WAIGNON
# Supervisor :  Marcel ALOY            

# Note to the user:
# The script '1_data_collection.R' is for data collection only.
# The data has already been collected and exported, so you do NOT need to run that script again.
# All 4 parts of the code are provided for information and review purpose but should not be run.
# Only this code should be run.

# ========================================================
# Main Script to Run All Parts
# ========================================================

# Load Data from 1_data_collection.R
cac40DailyPrices <- readRDS("CAC40_index_daily_Prices_2008_2022.rds")
compDailyPrices <- readRDS("CAC40_components_daily_Prices_2008_2022.rds")

# Run the remaining code
source("2_data_processing.R")
source("3_tail_index_computation.R")
source("4_data_visualisation.R")
