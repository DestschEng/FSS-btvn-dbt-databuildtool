# dbt
docker compose run dbt dbt run
docker compose run dbt dbt docs generate
docker compose run -p 8080:8080 dbt dbt docs serve --port 8080

# postgresql
docker exec -it btvn_fss-db-1 psql -U postgres
docker exec -it <CONTAINER_NAME> psql -U postgres

# superset
docker-compose exec superset superset db upgrade
docker-compose exec superset superset init
docker-compose exec superset flask fab create-admin --username admin --firstname Admin --lastname User --email admin@example.com --password admin

docker-compose exec superset superset fab list-users
docker-compose exec superset pip install psycopg2


# psql shell
\copy Product FROM '/data/Product.csv' DELIMITER E'\t' CSV HEADER;
\copy Region FROM '/data/Region.csv' DELIMITER E'\t' CSV HEADER;
\copy Reseller FROM '/data/Reseller.csv' DELIMITER E'\t' CSV HEADER;
\copy Salesperson FROM '/data/Salesperson.csv' DELIMITER E'\t' CSV HEADER;
\copy Targets FROM '/data/Targets.csv' DELIMITER E'\t' CSV HEADER;
\copy Sales FROM '/data/Sales.csv' DELIMITER E'\t' CSV HEADER;
\copy SalespersonRegion FROM '/data/SalespersonRegion.csv' DELIMITER E'\t' CSV HEADER;

# -------------------------------------------------------------------------------------------------
CREATE TABLE Product_staging (
    ProductKey TEXT,
    Product TEXT,
    StandardCost TEXT,
    Color TEXT,
    Subcategory TEXT,
    Category TEXT,
    BackgroundColorFormat TEXT,
    FontColorFormat TEXT
);
# Insert Cleaned Data into Final Table: Use REPLACE to remove the dollar sign and cast to NUMERIC for the StandardCost field.

INSERT INTO Product (ProductKey, Product, StandardCost, Color, Subcategory, Category, BackgroundColorFormat, FontColorFormat)
SELECT 
CAST(ProductKey AS INTEGER),
Product,
CAST(REPLACE(REPLACE(StandardCost, '$', ''), ',', '') AS NUMERIC),
Color,
Subcategory,
Category,
BackgroundColorFormat,
FontColorFormat
FROM Product_staging;

DROP TABLE Product_staging;

# -----------------------------------------------------------------------------
DROP TABLE IF EXISTS Region;

CREATE TABLE IF NOT EXISTS Region (
    SalesTerritoryKey INT PRIMARY KEY,
    TerritoryName VARCHAR(100),
    Country VARCHAR(100),
    GroupName VARCHAR(100)
);

ALTER TABLE Region
ADD COLUMN Country VARCHAR(100),
ADD COLUMN GroupName VARCHAR(100);


# ---------------------------------------------------------------------------------
DROP TABLE IF EXISTS Reseller;

CREATE TABLE IF NOT EXISTS Reseller (
    ResellerKey INT PRIMARY KEY,
    BusinessType VARCHAR(100),
    ResellerName VARCHAR(100),
    City VARCHAR(100),
    StateProvince VARCHAR(100),
    CountryRegion VARCHAR(100)
);

ALTER TABLE Reseller
ADD COLUMN BusinessType VARCHAR(100),
ADD COLUMN City VARCHAR(100),
ADD COLUMN StateProvince VARCHAR(100),
ADD COLUMN CountryRegion VARCHAR(100);

# -----------------------------------------------------------------------------------

ALTER TABLE Salesperson
ADD COLUMN EmployeeNumber VARCHAR(100),
ADD COLUMN JobTitle VARCHAR(100),
ADD COLUMN EmailAddress VARCHAR(100);

CREATE TABLE Salesperson_staging (
    EmployeeKey INT,
    EmployeeID VARCHAR(100),
    Salesperson VARCHAR(100),
    Title VARCHAR(100),
    UPN VARCHAR(100)
);

\copy Salesperson_staging FROM '/data/Salesperson.csv' DELIMITER E'\t' CSV HEADER;

INSERT INTO Salesperson (SalespersonID, SalespersonName, RegionID, EmployeeNumber, JobTitle, EmailAddress)
SELECT EmployeeKey, Salesperson, NULL AS RegionID, EmployeeID, Title, UPN
FROM Salesperson_staging;

# ---------------------------------
CREATE TABLE Targets_staging (
    EmployeeID INT,
    Target VARCHAR(100),
    TargetMonth VARCHAR(100)
);




\copy Targets_staging FROM '/data/Targets.csv' DELIMITER E'\t' CSV HEADER;


INSERT INTO Targets (targetid, salespersonid, targetamount, targetmonth)
SELECT 
ROW_NUMBER() OVER () AS targetid, -- Generate a targetid automatically (or use your own logic)
EmployeeID, -- Corresponds to salespersonid in the Targets table
CAST(REPLACE(REPLACE(Target, '$', ''), ',', '') AS NUMERIC(10, 2)) AS CleanedTargetAmount, -- Clean and cast the Target field to numeric
TO_DATE(TargetMonth, 'Day, Month DD, YYYY') AS CleanedTargetMonth  -- Convert TargetMonth to DATE format
FROM Targets_staging;


ALTER TABLE Targets RENAME COLUMN month TO targetmonth;

INSERT INTO Targets (employeeid, target, targetmonth)
SELECT 
EmployeeID, -- Corresponds to salespersonid in the Targets table
CAST(REPLACE(REPLACE(Target, '$', ''), ',', '') AS NUMERIC(10, 2)) AS CleanedTargetAmount, -- Clean the Target field 
TO_DATE(TargetMonth, 'Day, Month DD, YYYY') AS CleanedTargetMonth  -- Convert TargetMonth to DATE format
FROM Targets_staging;


ALTER TABLE Targets ALTER COLUMN targetmonth TYPE VARCHAR(100);
ALTER TABLE Targets ALTER COLUMN targetmonth TYPE DATE USING TO_DATE(targetmonth::TEXT, 'Day, Month DD, YYYY');
ALTER TABLE Targets DROP COLUMN targetmonth;
ALTER TABLE Targets RENAME COLUMN targetmonth_date TO targetmonth;

ALTER TABLE Targets ADD COLUMN targetmonth_date DATE;

UPDATE Targets 
SET targetmonth_date = TO_DATE(targetmonth, 'Day, Month DD, YYYY');


ALTER TABLE Targets DROP CONSTRAINT targets_pkey;

SELECT EmployeeID
FROM Targets_staging
WHERE EmployeeID NOT IN (SELECT salespersonid FROM salesperson);

ALTER TABLE Targets ADD CONSTRAINT targets_salespersonid_fkey FOREIGN KEY (target) REFERENCES salesperson(salespersonid) ON DELETE CASCADE;
# -----------------------------------------------------

CREATE TABLE Sales_staging (
    SalesOrderNumber VARCHAR(50),
    OrderDate VARCHAR(50),
    ProductKey INTEGER,
    ResellerKey INTEGER,
    EmployeeKey INTEGER,
    SalesTerritoryKey INTEGER,
    Quantity INTEGER,
    UnitPrice VARCHAR(50),
    Sales VARCHAR(50),
    Cost VARCHAR(50)
);

\copy Sales_staging FROM '/data/Sales.csv' DELIMITER E'\t' CSV HEADER;

INSERT INTO sales (productkey, salespersonid, resellerid, quantity, unitprice)
SELECT 
ProductKey,
EmployeeKey AS salespersonid,
ResellerKey AS resellerid,
Quantity,
CAST(REPLACE(REPLACE(UnitPrice, '$', ''), ',', '') AS NUMERIC(10, 2)) AS unitprice
FROM Sales_staging;


ALTER TABLE sales 
ALTER COLUMN salesid SET DEFAULT nextval('sales_salesid_seq'::regclass);

# -------------------------------------------------------------------
CREATE TABLE SalespersonRegion (
    SalespersonID INTEGER,
    SalesTerritoryKey INTEGER
);
