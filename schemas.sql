-- Drop tables if they exist (in reverse order of creation to handle foreign keys)
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Targets;
DROP TABLE IF EXISTS SalespersonRegion;
DROP TABLE IF EXISTS Salesperson;
DROP TABLE IF EXISTS Reseller;
DROP TABLE IF EXISTS Region;
DROP TABLE IF EXISTS Product;
-- Create Product table
CREATE TABLE IF NOT EXISTS Product (
    ProductKey INT PRIMARY KEY,
    Product VARCHAR(255) NOT NULL,
    StandardCost DECIMAL(10, 2),
    Color VARCHAR(50),
    Subcategory VARCHAR(100),
    Category VARCHAR(100),
    BackgroundColorFormat VARCHAR(50),
    FontColorFormat VARCHAR(50)
);
COMMENT ON TABLE Product IS 'Contains product details';
-- Create Region table
CREATE TABLE IF NOT EXISTS Region (
    SalesTerritoryKey INT PRIMARY KEY,
    TerritoryName VARCHAR(100)
);
COMMENT ON TABLE Region IS 'Contains region details';
-- Create Salesperson table
CREATE TABLE IF NOT EXISTS Salesperson (
    SalespersonID INT PRIMARY KEY,
    SalespersonName VARCHAR(100) NOT NULL,
    RegionID INT REFERENCES Region(SalesTerritoryKey) ON DELETE
    SET NULL
);
COMMENT ON TABLE Salesperson IS 'Contains salesperson information';
-- Create Reseller table
CREATE TABLE IF NOT EXISTS Reseller (
    ResellerID INT PRIMARY KEY,
    ResellerName VARCHAR(100)
);
COMMENT ON TABLE Reseller IS 'Contains reseller details';
-- Create Targets table
CREATE TABLE IF NOT EXISTS Targets (
    TargetID INT PRIMARY KEY,
    SalespersonID INT REFERENCES Salesperson(SalespersonID) ON DELETE CASCADE,
    TargetAmount DECIMAL(10, 2)
);
COMMENT ON TABLE Targets IS 'Contains target information for each salesperson';
-- Create Sales table
CREATE TABLE IF NOT EXISTS Sales (
    SalesID INT PRIMARY KEY,
    ProductKey INT REFERENCES Product(ProductKey) ON DELETE CASCADE,
    SalespersonID INT REFERENCES Salesperson(SalespersonID) ON DELETE
    SET NULL,
        ResellerID INT REFERENCES Reseller(ResellerID) ON DELETE
    SET NULL,
        Quantity INT,
        UnitPrice DECIMAL(10, 2)
);
COMMENT ON TABLE Sales IS 'Contains all sales transactions';