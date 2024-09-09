# Fetch Rewards Coding Exercise - Analytics Engineer


## Overview
This project is part of a take-home coding exercise for the role of Analytics Engineer at Fetch Rewards. The objective was to review unstructured JSON data, design a structured relational data model, write SQL queries to answer business questions and identify data quality issues.

## Project Structure
The repository is divided into three main parts based on the exercise requirements:


### Part 1: Data Modeling
- Entity Relationship Diagram (ERD):

  - This section includes the ERD that represents how I structured the provided JSON data into a relational database model.

  - Diagram: ERD.pdf

### Part 2: SQL Queries

- SQL Table Creation Scripts:

  - Scripts for creating tables in the structured data model:
  
    - table_creation.py - Contains table creation queries for the Users, Brands, Receipts, and Items tables.


- Data Insertion Scripts:

  - Scripts to insert the JSON data into the tables:
  
    - users_data_insertion.py
    - brands_data_insertion.py
    - receipts_data_insertion.py
    - items_data_insertion.py


- Business Queries:

  - SQL queries to answer specific business questions from the exercise:

    - query1.sql - Top 5 brands by receipts scanned for the most recent month.
    - query2.sql - Comparison of brand rankings between the most recent and previous month.
    - query3.sql - Comparison of average spend between 'Accepted' and 'Rejected' receipts.
    - query4.sql - Total number of items purchased comparison for 'Accepted' and 'Rejected' receipts.
    - query5.sql - Top brand by spend among users created in the last 6 months.
    - query6.sql - Brand with the most transactions among new users.


- Query Results:

  - A document containing snapshots of query results:
    - queries_results.pdf



### Part 3: Data Analysis and Quality Checks

- Exploratory Data Analysis (EDA):

  - Jupyter Notebook that explores and identifies data quality issues in the provided JSON files:

    - EDA.ipynb - Notebook for data exploration and issue identification.
    - EDA.pdf - PDF export of the Jupyter notebook.



### Preprocessed and Raw Files:

- The repository also contains preprocessed versions of the original JSON data files:

  - raw_json/ - Folder containing the raw JSON files.
  - preprocessed/ - Folder containing the cleaned and preprocessed versions of the JSON data for easier analysis.
 

## Data Schema

Here is the schema information for the JSON data provided as part of the exercise:


### Receipts Data Schema
- _id: UUID for this receipt
- bonusPointsEarned: Number of bonus points that were awarded upon receipt completion
- bonusPointsEarnedReason: Event that triggered bonus points
- createDate: The date that the event was created
- dateScanned: Date that the user scanned their receipt
- finishedDate: Date that the receipt finished processing
- modifyDate: The date the event was modified
- pointsAwardedDate: The date we awarded points for the transaction
- pointsEarned: The number of points earned for the receipt
- purchaseDate: The date of the purchase
- purchasedItemCount: Count of number of items on the receipt
- rewardsReceiptItemList: The items that were purchased on the receipt
- rewardsReceiptStatus: Status of the receipt through receipt validation and processing
- totalSpent: The total amount on the receipt
- userId: String ID back to the User collection for the user who scanned the receipt


### Users Data Schema
- _id: User ID
- state: State abbreviation
- createdDate: When the user created their account
- lastLogin: Last time the user was recorded logging in to the app
- role: Constant value set to 'CONSUMER'
- active: Indicates if the user is active; only Fetch will de-activate an account with this flag


### Brand Data Schema
- _id: Brand UUID
- barcode: The barcode on the item
- brandCode: String that corresponds with the brand column in a partner product file
- category: The category name for which the brand sells products in
- categoryCode: The category code that references a BrandCategory
- cpg: Reference to CPG collection
- topBrand: Boolean indicator for whether the brand should be featured as a 'top brand'
- name: Brand name



### Technologies Used
- SQL: For creating tables and querying the relational data model.
- Python: For data manipulation and ETL tasks.
- Jupyter Notebook: For performing Exploratory Data Analysis (EDA).
- Diagramming Tool: For creating the ERD (could be draw.io, Lucidchart, etc.).



### Setup Instructions
1. Clone the repository.
2. Run the SQLtableCreation.py script to create the necessary tables.
3. Execute the data insertion scripts (UsersSQL.py, BrandsSQL.py, ReceiptsSQL.py, ItemsSQL.py) to load data into the tables.
4. Execute the business query scripts to retrieve answers to the predetermined questions.
