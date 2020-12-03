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

1. reviews.csv
```
file_to_load = "Resources/reviews.csv"
review_data = pd.read_csv(file_to_load,encoding="utf8")
```
2. calendar.csv
```
calendar_csv = "Resources/calendar.csv"
calendar_df = pd.read_csv(calendar_csv,encoding="utf8")
```
3. listings.csv
```
listings_file = "Resources/listings.csv"
listings_df = pd.read_csv(listings_file)
```

## Transform
- Python is used to create tables using only the relevant columns:
  i. Reviews table:
  #drop non applicable variables
  ```
  review_clean = review_data.dropna()
  ```
  #convert to datetime
  ```
  review_cln = review_clean.drop(['comments'],axis=1)
  review_cln["date"]=pd.to_datetime(review_cln["date"])
  ```
  #groupby listing_id
  ```
  review_grouped = review_cln.groupby(['listing_id'])
  ```

  ii. Calendar Table
  #rename and convert to datetime
  ```
  calendar_df.rename(index=str,columns={"date":"date"},inplace=True)
  calendar_df["date"]=pd.to_datetime(calendar_df["date"])
  ```
  #concert to boolean
  ```
  calendar_df["available"].replace(["t","f"], [True,False], inplace=True)
  ```
  #Remove dollar sign and convert the price column to numeric values
  ```

  calendar_df["price"] = calendar_df["price"].replace({'\$': '', ',': ''}, regex=True)
  calendar_df["price"] = pd.to_numeric(calendar_df["price"])
  calendar_df.head()
  ```

  iii. Listings table
  #merge listings and calendar
  ```
  listings_calendar_df = listings_df.merge(calendar_df, left_on='id', right_on='listing_id')
  ```



## Clean

## Load
