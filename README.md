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
- All three dataframes are cleaned using the following commands:

  i. "drop_duplicates" to remove all duplicate entries in each dataframe
  ii. "to_datetime" to convert columns to datetime format that are initially registered as strings
  iii. "rename" to change column titles so that all column titles are lower case, contain zero spaces, and are overall clearly written
  iv. "dropna" to drop rows that have N/As in critical columns (e.g. if rows do not have information listed in their primary key figures)
  v. "merge" to establish foreign key figures in tables where there is not a foreign key originally listed. The same command is also used to test if two tables can be linked together in a schema
  vi. "assign" in order to establish primary keys in tables where primary keys are not originally listed
  

   


## Load

SQL: Create the Schema
- Data is organized into a schema of three tables (reviews, listings, and calendars)
- Created the following in MySQL to create schema:
    -  Calendar table
    ```
    CREATE TABLE "Calendar" (
    "listing_id" INT   NOT NULL,
    "date" DATE   NOT NULL,
    "available" BOOLEAN   NOT NULL,
    "price" FLOAT   NOT NULL
    );
    ```
    
    - Listings table
    ```
    CREATE TABLE "Listings" (
    "id" INT   NOT NULL,
    "listing_url" VARCHAR(100)   NOT NULL,
    "scrape_id" INT   NOT NULL,
    "last_scraped" INT   NOT NULL,
    "name" varchar   NOT NULL,
    "summary" varchar   NOT NULL,
    "space" varchar   NOT NULL,
    "description" varchar   NOT NULL,
    "neighborhood_overview" varchar   NOT NULL,
    "street" varchar   NOT NULL,
    "neighbourhood" varchar   NOT NULL,
    "city" varchar   NOT NULL,
    "state" varchar   NOT NULL,
    "zipcode" int   NOT NULL,
    "market" varchar   NOT NULL,
    "latitude" float   NOT NULL,
    "longitude" float   NOT NULL,
    "property_type" varchar   NOT NULL,
    "room_type" varchar   NOT NULL,
    "bathrooms" int   NOT NULL,
    "bedrooms" int   NOT NULL,
    "beds" int   NOT NULL,
    "bed_type" varchar   NOT NULL,
    "amenities" varchar   NOT NULL,
    "square_feet" int   NOT NULL,
    "price" varchar   NOT NULL,
    "weekly_price" varchar   NOT NULL,
    "monthly_price" varchar   NOT NULL,
    "security_deposit" varchar   NOT NULL,
    "cleaning_fee" varchar   NOT NULL,
    "guests_included" int   NOT NULL,
    "extra_people" varchar   NOT NULL,
    "minimum_nights" int   NOT NULL,
    "maximum_nights" int   NOT NULL,
    "calendar_updated" varchar   NOT NULL,
    "has_availability" boolean   NOT NULL
    );
    ```
    
    - Reviews table
    ```
    CREATE TABLE "Reviews" (
    "listing_id" int   NOT NULL,
    "id" int   NOT NULL,
    "date" date   NOT NULL,
    "reviewer_id" int   NOT NULL,
    "comments" varchar   NOT NULL,
    CONSTRAINT "pk_Reviews" PRIMARY KEY (
        "id"
     )
    );
    ```
    
  ## Python: Connect DataFrames to MySQL Database
  - A MySQL database connection is created and an engine is created in Python (if reproducing, make sure to add in the appropriate computer password):
  ``` 
  connection = "postgres:postgres@localhost:5432/airbnb_db"
  engine = create_engine(f'postgresql://{connection}')
  ```
  
  - The engine is used to populate all the SQL tables
  ```
  dropped_listings_df.to_sql(name='listings', con=engine, if_exists='append', index=True)
  
  
  review_count.to_sql(name='reviews', con=engine, if_exists='append', index=True)
  
  
  #query results to confirm data has been added
  pd.read_sql_query('select * from reviews', con=engine).head()
  pd.read_sql_query('select * from listings', con=engine).head()
  ```
  
  
  

