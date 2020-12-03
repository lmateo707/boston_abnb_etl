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
- We took our data from the three CSV files - Reviews, Listings, Calendar - and created a set of rules or objectives in order to transform them into what we wanted.
Our objective was to create a list of top-rated airbnb listings in and around Boston with relevant booking information for prospective, hypothetical clients. We decided that we wanted to only have the clean data with these specifications:

  1. We wanted only quantifying information in our dataset, no comments, review blurbs, etc.
  2. Specific information on reviewers of listings or their reviews were not included
  3. We wanted Airbnb listings with ratings greater than 90.
  4. We wanted data to be in specific formats. Dates in datetime, numbers in int etc.
  5. Full information: no empty cells.

- We cleaned up our data as follows:

  reviews.csv

  Dropped any data with empty data cells. Eliminated the “comments” column. Converted the string dates to datetime format. Grouped data by listing_id for easier access. Looked at review counts by listing id

  calendar csv

  Converted string dates to datetime format. Converted available data output to boolean. Cleaned price column to clean numeric values.

  Listing.csv

  Merged with calendar on listing id. Eliminated 91 irrelevant columns. Dropped any duplicates and empty rows. Filtered data, leaving listings with ratings greater than 90. Dropped any duplicate listings/dates, only keeping the latest ones. Important columns: "id", "listing_url", "name", "price_y", "number_of_reviews", "review_scores_rating", "date", "available"
  

   


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
  
  
  

