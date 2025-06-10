-- Esponi lʼanagrafica dei prodotti indicando per ciascun prodotto anche la sua sottocategoria (DimProduct, DimProductSubcategory).
-- Join
SELECT p.ProductKey, p.EnglishProductName, s.EnglishProductSubcategoryName
FROM DimProduct p
JOIN DimProductSubcategory s ON p.ProductSubcategoryKey = s.ProductSubcategoryKey;
-- Subquery
SELECT ProductKey, EnglishProductName,
       (SELECT EnglishProductSubcategoryName
        FROM DimProductSubcategory s
        WHERE s.ProductSubcategoryKey = p.ProductSubcategoryKey) AS Subcategory
FROM DimProduct p;

-- Esponi lʼanagrafica dei prodotti indicando per ciascun prodotto la sua sottocategoria e la sua categoria (DimProduct, DimProductSubcategory, DimProductCategory).
-- Join
SELECT p.ProductKey, p.EnglishProductName,
       s.EnglishProductSubcategoryName,
       c.EnglishProductCategoryName
FROM DimProduct p
JOIN DimProductSubcategory s ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
JOIN DimProductCategory c ON s.ProductCategoryKey = c.ProductCategoryKey;
-- Subquery
SELECT ProductKey, EnglishProductName,
       (SELECT s.EnglishProductSubcategoryName
        FROM DimProductSubcategory s
        WHERE s.ProductSubcategoryKey = p.ProductSubcategoryKey) AS Subcategory,
       (SELECT c.EnglishProductCategoryName
        FROM DimProductSubcategory s
        JOIN DimProductCategory c ON s.ProductCategoryKey = c.ProductCategoryKey
        WHERE s.ProductSubcategoryKey = p.ProductSubcategoryKey) AS Category
FROM DimProduct p;

-- Esponi lʼelenco dei soli prodotti venduti (DimProduct, FactResellerSales).
-- Join
SELECT DISTINCT p.ProductKey, p.EnglishProductName
FROM DimProduct p
JOIN FactResellerSales f ON p.ProductKey = f.ProductKey;
-- Subquery
SELECT ProductKey, EnglishProductName
FROM DimProduct
WHERE ProductKey IN (SELECT ProductKey FROM FactResellerSales);

-- Esponi lʼelenco dei prodotti non venduti (considera i soli prodotti finiti cioè quelli per i quali il campo FinishedGoodsFlag è uguale a 1).
-- Join
SELECT p.ProductKey, p.EnglishProductName
FROM DimProduct p
LEFT JOIN FactResellerSales f ON p.ProductKey = f.ProductKey
WHERE f.ProductKey IS NULL AND p.FinishedGoodsFlag = 1;
-- Subquery
SELECT ProductKey, EnglishProductName
FROM DimProduct
WHERE FinishedGoodsFlag = 1
  AND ProductKey NOT IN (SELECT ProductKey FROM FactResellerSales);

-- Esponi lʼelenco delle transazioni di vendita (FactResellerSales) indicando anche il nome del prodotto venduto (DimProduct).
-- Join
SELECT f.SalesOrderNumber, f.OrderDate, p.EnglishProductName, f.UnitPrice, f.OrderQuantity
FROM FactResellerSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey;

-- Esponi lʼelenco delle transazioni di vendita indicando la categoria di appartenenza di ciascun prodotto venduto.
-- Join
SELECT f.SalesOrderNumber, f.OrderDate, p.EnglishProductName,
       c.EnglishProductCategoryName
FROM FactResellerSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
JOIN DimProductSubcategory s ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
JOIN DimProductCategory c ON s.ProductCategoryKey = c.ProductCategoryKey;

-- Esplora la tabella DimReseller.
SELECT * FROM DimReseller;

-- Esponi in output lʼelenco dei reseller indicando, per ciascun reseller, anche la sua area geografica.
SELECT 
  r.ResellerKey,
  r.ResellerName,
  g.City,
  g.StateProvinceName,
  g.EnglishCountryRegionName AS Country
FROM DimReseller r
JOIN DimGeography g ON r.GeographyKey = g.GeographyKey;

-- Esponi lʼelenco delle transazioni di vendita. Il result set deve esporre i campi SalesOrderNumber, SalesOrderLineNumber, OrderDate, UnitPrice, Quantity, TotalProductCost.
-- Il result set deve anche indicare il nome del prodotto, il nome della categoria del prodotto, il nome del reseller e lʼarea geografica.
SELECT
  f.SalesOrderNumber,
  f.SalesOrderLineNumber,
  f.OrderDate,
  f.UnitPrice,
  f.OrderQuantity AS Quantity,
  f.TotalProductCost,
  p.EnglishProductName,
  c.EnglishProductCategoryName,
  r.ResellerName,
  (SELECT g.City
   FROM DimGeography g
   WHERE g.GeographyKey = r.GeographyKey) AS ResellerCity,
  (SELECT g.StateProvinceName
   FROM DimGeography g
   WHERE g.GeographyKey = r.GeographyKey) AS StateProvinceName,
  (SELECT g.EnglishCountryRegionName
   FROM DimGeography g
   WHERE g.GeographyKey = r.GeographyKey) AS CountryRegion
FROM FactResellerSales f
JOIN DimProduct p
  ON f.ProductKey = p.ProductKey
JOIN DimProductSubcategory s
  ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
JOIN DimProductCategory c
  ON s.ProductCategoryKey = c.ProductCategoryKey
JOIN DimReseller r
  ON f.ResellerKey = r.ResellerKey;

