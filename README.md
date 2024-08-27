# Analyzing the Behavior of French Stocks During Crises

This repository contains code and data for a comparative study of French stocks' return distributions from 2007 to 2022. The study focuses on analyzing the behavior of the CAC40 Index and its components during various financial crises using the tail index.

## Author and Supervisor

- **Author:** Baptiste WAIGNON
- **Supervisor:** Marcel ALOY

## Project Overview

The project investigates the impact of crises on the return distributions of French stocks. It utilizes historical stock price data and calculates various financial metrics to analyze how stock returns behave during different economic crises.

## Repository Structure

1. **`1_data_collection.R`**: Script for collecting and cleaning data. **Note:** This script is only needed to be run if you are collecting new data. The data has already been collected and exported, so you do not need to run this script again.

2. **`2_data_processing.R`**: Script for processing the data, including return calculations and crisis period analysis.

3. **`3_tail_index_computation.R`**: Script for computing the tail index using the Weighted Least Squares (WLS) estimator.

4. **`4_data_visualisation.R`**: Script for visualizing the results, including plots of returns, distributions, volatility, and tail indices.

5. **`main.R`**: Main script to run all parts of the analysis.

## How to Use

1. **Prepare the Data:**
   - Ensure that the data files `CAC40_index_daily_Prices_2008_2022.rds` and `CAC40_components_daily_Prices_2008_2022.rds` are present in the working directory. These files should be the result of running `1_data_collection.R`.

2. **Run the Analysis:**
   - Execute the `main.R` script to perform the following actions:
     - Load the pre-collected data.
     - Source and run the remaining scripts for data processing, tail index computation, and visualization.

   ```r
   source("main.R")
   ```

   This script will sequentially run the other scripts (`2_data_processing.R`, `3_tail_index_computation.R`, `4_data_visualisation.R`).

## Scripts

### 1_data_collection.R

This script collects and cleans the financial data for the CAC40 Index and its components. It fetches daily prices from Yahoo Finance and handles missing data for specific stocks. The cleaned data is saved as RDS files.

### 2_data_processing.R

This script processes the collected data, calculates daily returns, computes equity curves, and performs statistical analysis of the returns. It also splits data into different crisis periods and computes summary statistics.

### 3_tail_index_computation.R

This script computes the tail index for different periods using the Weighted Least Squares (WLS) estimator. It analyzes the tail behavior of returns during the reference period and various financial crises.

### 4_data_visualisation.R

This script visualizes the results of the analysis. It generates plots of CAC40 Index returns, their distribution, equity curves, realized volatility, and autocorrelation functions. It also plots the evolution of tail indices by sector.

### main.R

The main script loads the data and sources the other scripts to execute the complete analysis. It assumes that the data has already been collected and is available in the specified RDS files.

## Notes

- Ensure all required R packages are installed before running the scripts. You can install them using `install.packages("package_name")`.
- The code is designed to be run sequentially as specified in the `main.R` script. Individual scripts should not be run separately unless for specific purposes or debugging.
