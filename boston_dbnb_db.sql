-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/N6Hzob
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "Calendar" (
    "listing_id" INT   NOT NULL,
    "date" DATE   NOT NULL,
    "available" BOOLEAN   NOT NULL,
    "price" FLOAT   NOT NULL
);

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

ALTER TABLE "Calendar" ADD CONSTRAINT "fk_Calendar_listing_id" FOREIGN KEY("listing_id")
REFERENCES "Reviews" ("listing_id");

ALTER TABLE "Calendar" ADD CONSTRAINT "fk_Calendar_available" FOREIGN KEY("available")
REFERENCES "Listings" ("has_availability");

ALTER TABLE "Listings" ADD CONSTRAINT "fk_Listings_id" FOREIGN KEY("id")
REFERENCES "Reviews" ("id");
