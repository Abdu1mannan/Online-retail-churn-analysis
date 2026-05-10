# Online-retail-churn-analysis
# Online Retail Customer Churn Analysis

Customer churn analysis project built on transactional data from a UK-based online retailer between December 2009 and December 2011.

The project combines SQL, Python, and Power BI to identify churn patterns, segment customer behavior, and estimate churn risk at the customer level.

## Project Overview

The analysis covers:

- 1,067,371 transaction records
- 5,942 unique customers
- 24 months of retail activity

A customer was classified as churned if they made no purchase within four months before the analysis cutoff date.

The project focuses on:

- Identifying which customers churned
- Measuring revenue impact of churn
- Segmenting customers by revenue and frequency
- Predicting churn probability using logistic regression
- Building an interactive dashboard for business monitoring

## Workflow

### SQL
Used PostgreSQL for:

- Data cleaning
- Feature engineering
- Customer-level aggregation

Cleaning decisions included:

- Removing rows with null customer IDs
- Removing negative unit prices
- Retaining returns as negative quantity adjustments

Twelve behavioral features were engineered from raw transactions, including:

- Revenue
- Transaction count
- Average order value
- Product diversity
- Customer tenure
- Purchase frequency
- Days inactive

### Python
Used pandas, numpy, matplotlib, and scikit-learn for:

- Exploratory data analysis
- Revenue and frequency segmentation
- Distribution analysis
- Logistic regression modeling
- Churn probability scoring

The initial model showed data leakage because `days inactive` was directly derived from the churn label(98% accuracy somehow). After removing the feature, the revised model achieved 71% accuracy.

Key findings from the model:

- Longer customer tenure strongly reduces churn probability
- Higher product diversity is associated with retention
- Rare and low-revenue customers account for most churn
- Revenue loss from churn is significantly lower than customer-count churn

### Power BI
Built a multi-page dashboard covering:

- Executive summary
- Segment analysis
- Geographic distribution
- Predictive risk scoring
- Revenue-at-risk tracking

The dashboard includes churn segmentation by:

- Revenue tier
- Purchase frequency
- Country
- Risk category

## Key Findings

- Overall churn rate: 46.82%
- Revenue loss from churn: 19.18%
- UK customers represent roughly 75% of the dataset
- Low-revenue and low-frequency customers form the largest churn cluster
- Premium and frequent buyers show strong retention

The highest-risk active customers represented approximately \$159.91K in revenue at risk.

## Tech Stack

- PostgreSQL
- Python
- pandas
- numpy
- scikit-learn
- matplotlib
- Power BI
- power query
  
## Repository Contents

- SQL scripts for cleaning and feature engineering
- Python notebooks/scripts for EDA and modeling
- Power BI dashboard
- Final report
- Presentation slides

## Limitations

- Logistic regression cannot capture non-linear churn behavior
- Strong multicollinearity exists between some engineered features
- Dataset is heavily UK-skewed
- No demographic or acquisition-channel data was available
- Static churn threshold may misclassify seasonal buyers
