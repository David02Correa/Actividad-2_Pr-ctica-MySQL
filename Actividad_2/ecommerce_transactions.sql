
-- Limpieza de datos
SELECT Transaction_ID, COUNT(*) AS total
FROM ecommerce_transactions
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;

SELECT *
FROM ecommerce_transactions
WHERE Country IS NULL OR Country = ''
   OR Product_Category IS NULL OR Product_Category = ''
   OR Purchase_Amount IS NULL;

-- Sentencias que nos dan informacion para resolver la pregunta ¿Qué categorías de productos 
-- generan mayores ingresos en las ventas online y en qué región se concentran las compras?

-- Ingresos por categoría con mayores ingresos USD.

SELECT Product_Category, 
       SUM(Purchase_Amount) AS total_ingresos
FROM ecommerce_transactions
GROUP BY Product_Category
ORDER BY total_ingresos DESC;

-- Ingresos por categoría y país
SELECT Country, 
       Product_Category, 
       SUM(Purchase_Amount) AS total_ingresos
FROM ecommerce_transactions
GROUP BY Country, Product_Category
ORDER BY total_ingresos DESC;

-- Conozcamos el lider del mercado de cada producto

SELECT t.Product_Category, t.Country, t.total_ingresos
FROM (
    SELECT Product_Category, Country, SUM(Purchase_Amount) AS total_ingresos,
           RANK() OVER (PARTITION BY Product_Category ORDER BY SUM(Purchase_Amount) DESC) AS rnk
    FROM ecommerce_transactions
    GROUP BY Product_Category, Country
) t
WHERE t.rnk = 1
ORDER BY t.total_ingresos DESC;
