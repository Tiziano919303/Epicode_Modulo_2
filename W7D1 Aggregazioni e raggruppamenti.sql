-- Scrivi una query per verificare che il campo ProductKey nella tabella DimProduct sia una chiave primaria. Quali considerazioni/ragionamenti è necessario che tu faccia?
-- Controllo NULL
SELECT COUNT(*) AS NullCount
FROM DimProduct
WHERE ProductKey IS NULL;

-- Controllo duplicati
SELECT ProductKey, COUNT(*) AS CountPerKey
FROM DimProduct
GROUP BY ProductKey
HAVING COUNT(*) > 1;

-- Risultato: nessun valore null e nessun duplicato, quindi il campo ProductKey è una chiave primaria.

-- Scrivi una query per verificare che la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber sia una PK.
-- Controllo NULL
SELECT COUNT(*) AS NullCount
FROM FactResellerSales
WHERE SalesOrderNumber IS NULL
   OR SalesOrderLineNumber IS NULL;

-- Controllo duplicati
SELECT SalesOrderNumber, SalesOrderLineNumber, COUNT(*) AS CountPerCombo
FROM FactResellerSales
GROUP BY SalesOrderNumber, SalesOrderLineNumber
HAVING COUNT(*) > 1;

-- Risultato: nessun valore null e nessun duplicato, quindi la combinazione dei campi SalesOrderNumber e SalesOrderLineNumber è una chiave primaria.

-- Conta il numero transazioni (SalesOrderLineNumber) realizzate ogni giorno a partire dal 1 Gennaio 2020.
SELECT OrderDate, COUNT(SalesOrderLineNumber) AS NumTransazioni
FROM FactResellerSales
WHERE OrderDate >= '2020-01-01'
GROUP BY OrderDate
ORDER BY OrderDate;

-- Calcola il fatturato totale (FactResellerSales.SalesAmount), la quantità totale venduta (FactResellerSales.OrderQuantity) e il prezzo medio di
-- vendita (FactResellerSales.UnitPrice) per prodotto (DimProduct) a partire dal 1 Gennaio 2020. Il result set deve esporre pertanto il nome del
-- prodotto, il fatturato totale, la quantità totale venduta e il prezzo medio di vendita. I campi in output devono essere parlanti!
SELECT
  p.EnglishProductName AS Prodotto,
  SUM(f.SalesAmount) AS FatturatoTotale,
  SUM(f.OrderQuantity) AS QuantitaTotale,
  AVG(f.UnitPrice) AS PrezzoMedioVendita
FROM FactResellerSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
WHERE f.OrderDate >= '2020-01-01'
GROUP BY p.EnglishProductName
ORDER BY FatturatoTotale DESC;

-- Calcola il fatturato totale (FactResellerSales.SalesAmount) e la quantità totale venduta (FactResellerSales.OrderQuantity) per Categoria prodotto (DimProductCategory).
-- Il result set deve esporre pertanto il nome della categoria prodotto, il fatturato totale e la quantità totale venduta. I campi in output devono essere parlanti!
SELECT
  c.EnglishProductCategoryName AS CategoriaProdotto,
  SUM(f.SalesAmount) AS FatturatoTotale,
  SUM(f.OrderQuantity) AS QuantitaTotale
FROM FactResellerSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
JOIN DimProductSubcategory s ON p.ProductSubcategoryKey = s.ProductSubcategoryKey
JOIN DimProductCategory c ON s.ProductCategoryKey = c.ProductCategoryKey
GROUP BY c.EnglishProductCategoryName
ORDER BY FatturatoTotale DESC;

-- Calcola il fatturato totale per area città (DimGeography.City) realizzato a partire dal 1 Gennaio 2020. Il result set deve esporre lʼelenco delle città con
-- fatturato realizzato superiore a 60K.
SELECT
  g.City,
  SUM(f.SalesAmount) AS FatturatoTotale
FROM FactResellerSales f
JOIN DimReseller r ON f.ResellerKey = r.ResellerKey
JOIN DimGeography g ON r.GeographyKey = g.GeographyKey
WHERE f.OrderDate >= '2020-01-01'
GROUP BY g.City
HAVING SUM(f.SalesAmount) > 60000
ORDER BY FatturatoTotale DESC;
