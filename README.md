# Boston AirBnb ETL


# Background Information


## Data Source
- Kaggle: https://www.kaggle.com/airbnb/boston

## Data Files
- One "listing.csv" file that contains information on several locations on the Airbnb platform including but not limited too, # of bedrooms, size per square feet, acception rates, price, etc. 

- One "reviews.csv" file that contains customer feedback on their stay at host locations

- One "calendar.csv" file that contains information on availability at the locations


## Extract
- CSV files are taken from a Kaggle web page and saved in the "Resources" folder
- Data is extracted from the four CSV files in the "Resources" folder
- Python code to extract data from the CSV files is listed below:

1. 
```
file_to_load = "Resources/reviews.csv"
# Read Purchasing File and store into Pandas data frame
review_data = pd.read_csv(file_to_load,encoding="utf8")
review_data.head()
```

## Transform

## Clean

## Load
