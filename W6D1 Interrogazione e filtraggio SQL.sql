-- Esploro la tabella 'dimproduct'
SELECT * FROM dimproduct;

--  Seleziono i campi 'ProductKey', 'ProductAlternateKey', 'EnglishProductName', 'Color', 'StandardCost', 'FinishedGoodsFlag' e assegno un alias
SELECT ProductKey AS IDProdotto, ProductAlternateKey AS ID_alt_Prodotto, EnglishProductName AS NomeENG, Color AS Colore, StandardCost AS Prezzo, FinishedGoodsFlag AS Terminato FROM dimproduct
WHERE FinishedGoodsFlag = 1;

-- Seleziono i campi 'ProductKey', 'ProductAlternateKey', 'StandardCost' e 'ListPrice'
-- Seleziono solo 'ProductAlternateKey' che iniziano con 'FR' e 'BK'
SELECT ProductKey AS IDProdotto, ProductAlternateKey AS ID_alt_Prodotto, EnglishProductName AS NomeENG, StandardCost AS Prezzo, ListPrice AS Prezzo_listino FROM dimproduct
WHERE ProductAlternateKey LIKE 'FR%'
  OR ProductAlternateKey LIKE 'BK%';

-- Aggiungo campo calolato 'Markup'
SELECT ProductKey AS IDProdotto, ProductAlternateKey AS ID_alt_Prodotto, EnglishProductName AS NomeENG, StandardCost AS Prezzo, ListPrice AS Prezzo_listino, ListPrice - StandardCost AS Markup FROM dimproduct
WHERE ProductAlternateKey LIKE 'FR%'
  OR ProductAlternateKey LIKE 'BK%';

-- Espongo l'elenco dei prodotti finiti il cui prezzo di listino è compreso tra 1000 e 2000.
SELECT ProductKey AS IDProdotto, ProductAlternateKey AS ID_alt_Prodotto, EnglishProductName AS NomeENG, ListPrice AS Prezzo_listino, FinishedGoodsFlag AS Terminato FROM dimproduct
WHERE (ListPrice >1000 AND ListPrice <2000)
  AND FinishedGoodsFlag = 1;
  
-- Esploro la tabella 'dimemployee'
SELECT * FROM dimemployee;

-- Espongo l'elenco dei dipendenti per i quali il campo 'SalesPersonFlag' è uguale a 1
SELECT EmployeeKey, FirstName, LastName, Title, SalesPersonFlag FROM dimemployee
WHERE SalespersonFlag = 1;

-- Esploro la tabella 'FactResellerSales'
SELECT * FROM factresellersales;

-- Espongo l'elenco delle transazioni a partire dal 1/1/2020 dei codici prodotto 597, 598, 477, 214.
SELECT SalesOrderNumber from factresellersales
WHERE (ProductKey = 597 OR ProductKey = 598 OR ProductKey = 477 OR ProductKey = 214) AND OrderDate >= '2020-01-01'; -- Metodo più veloce: WHERE ProductKey IN (597, 598, 477, 214) AND OrderDate >= '2020-01-01';

-- Calcolo per ciascuna transazione il profitto 'SalesAmount' - 'TotalProductCost'.
SELECT OrderDate, SalesAmount, TotalProductCost, SalesAmount - TotalProductCost AS Profitto FROM factresellersales;