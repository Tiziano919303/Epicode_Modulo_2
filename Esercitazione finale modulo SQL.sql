-- Creo le tabelle
CREATE TABLE Product_Category (
    CategoriaID INT PRIMARY KEY,
    Nome_Categoria VARCHAR(50)
);

CREATE TABLE Product (
    ProdottoID INT PRIMARY KEY,
    Nome_Prodotto VARCHAR(100),
    CategoriaID INT,
    FOREIGN KEY (CategoriaID) REFERENCES Product_Category(CategoriaID)
);

CREATE TABLE Region (
    RegioneID INT PRIMARY KEY,
    Nome_Regione VARCHAR(50)
);

CREATE TABLE Country (
    NazioneID INT PRIMARY KEY,
    Nome_Nazione VARCHAR(50),
    RegioneID INT,
    FOREIGN KEY (RegioneID) REFERENCES Region(RegioneID)
);

CREATE TABLE Sales (
    VenditaID INT PRIMARY KEY,
    ProdottoID INT,
    NazioneID INT,
    Data_Vendita DATE,
    Qta INT,
    Ricavato DECIMAL(10,2),
    FOREIGN KEY (ProdottoID) REFERENCES Product(ProdottoID),
    FOREIGN KEY (NazioneID) REFERENCES Country(NazioneID)
);

-- Popolo le tabelle
INSERT INTO Product_Category VALUES 
(1, 'Biciclette'),
(2, 'Abbigliamento');

INSERT INTO Product VALUES 
(101, 'Bici-100', 1),
(102, 'Bici-200', 1),
(201, 'Guanti M', 2),
(202, 'Guanti L', 2);

INSERT INTO Region VALUES 
(1, 'Europa Occidentale'),
(2, 'Europa Meridionale');

INSERT INTO Country VALUES 
(1, 'Francia', 1),
(2, 'Germania', 1),
(3, 'Italia', 2),
(4, 'Grecia', 2);

INSERT INTO Sales VALUES 
(1, 101, 1, '2024-01-15', 10, 1500.00),
(2, 102, 2, '2024-12-01', 5, 1000.00),
(3, 201, 3, '2023-10-20', 20, 600.00),
(4, 101, 4, '2024-03-10', 7, 1100.00);

-- Verifico univocità delle chiavi primarie
SELECT CategoriaID, COUNT(*) 
FROM Product_Category 
GROUP BY CategoriaID 
HAVING COUNT(*) > 1;

SELECT ProdottoID, COUNT(*) 
FROM Product 
GROUP BY ProdottoID 
HAVING COUNT(*) > 1;

SELECT RegioneID, COUNT(*) 
FROM Region 
GROUP BY RegioneID 
HAVING COUNT(*) > 1;

SELECT NazioneID, COUNT(*) 
FROM Country 
GROUP BY NazioneID 
HAVING COUNT(*) > 1;

SELECT VenditaID, COUNT(*) 
FROM Sales 
GROUP BY VenditaID 
HAVING COUNT(*) > 1;

-- Controllo quali prodotti sono stati venduti più di 180 giorni fa + dettagli categoria, regione, nazione
SELECT 
    s.VenditaID,
    s.Data_Vendita,
    p.Nome_Prodotto,
    pc.Nome_Categoria,
    c.Nome_Nazione,
    r.Nome_Regione,
    DATEDIFF(CURDATE(), s.Data_Vendita) > 180 AS Oltre_180_Giorni
FROM Sales s
JOIN Product p ON s.ProdottoID = p.ProdottoID
JOIN Product_Category pc ON p.CategoriaID = pc.CategoriaID
JOIN Country c ON s.NazioneID = c.NazioneID
JOIN Region r ON c.RegioneID = r.RegioneID;

-- Prodotti venduti in quantità superiore alla media nell'ultimo anno censito
SELECT 
    s.ProdottoID,
    SUM(s.Qta) AS Totale_Qta
FROM Sales s
WHERE YEAR(s.Data_Vendita) = (SELECT MAX(YEAR(Data_Vendita)) FROM Sales)
GROUP BY s.ProdottoID
HAVING SUM(s.Qta) > (SELECT AVG(Somma_Qta) FROM
		(SELECT SUM(Qta) AS Somma_Qta FROM Sales WHERE YEAR(Data_Vendita) = (SELECT MAX(YEAR(Data_Vendita)) FROM Sales)
        GROUP BY ProdottoID) AS media_per_prodotto
);

-- Prodotti venduti con fatturato annuale
SELECT 
    s.ProdottoID,
    YEAR(s.Data_Vendita) AS Anno,
    SUM(s.Ricavato) AS Fatturato_Annuale
FROM Sales s
GROUP BY s.ProdottoID, YEAR(s.Data_Vendita);

-- Fatturato per nazione e per anno (descrescente per anno)
SELECT 
    c.Nome_Nazione,
    YEAR(s.Data_Vendita) AS Anno,
    SUM(s.Ricavato) AS Fatturato
FROM Sales s
JOIN Country c ON s.NazioneID = c.NazioneID
GROUP BY c.Nome_Nazione, YEAR(s.Data_Vendita)
ORDER BY Anno, Fatturato DESC;

-- Categoria più richiesta
SELECT 
    pc.Nome_Categoria,
    SUM(s.Qta) AS Totale_Venduto
FROM Sales s
JOIN Product p ON s.ProdottoID = p.ProdottoID
JOIN Product_Category pc ON p.CategoriaID = pc.CategoriaID
GROUP BY pc.Nome_Categoria
ORDER BY Totale_Venduto DESC;

-- Prodotti invenduti (IS NULL)
SELECT p.ProdottoID, p.Nome_Prodotto
FROM Product p
LEFT JOIN Sales s ON p.ProdottoID = s.ProdottoID
WHERE s.VenditaID IS NULL;

-- Prodotti invenduti (NOT IN)
SELECT p.ProdottoID, p.Nome_Prodotto
FROM Product p
WHERE p.ProdottoID NOT IN (SELECT DISTINCT ProdottoID FROM Sales);

-- Creazione view prodotti
CREATE VIEW View_Prodotti AS
SELECT 
    p.ProdottoID,
    p.Nome_Prodotto,
    pc.Nome_Categoria
FROM Product p
JOIN Product_Category pc ON p.CategoriaID = pc.CategoriaID;

-- Creazione view geografiva
CREATE VIEW View_Geografica AS
SELECT 
    c.NazioneID,
    c.Nome_Nazione,
    r.Nome_Regione
FROM Country c
JOIN Region r ON c.RegioneID = r.RegioneID;
