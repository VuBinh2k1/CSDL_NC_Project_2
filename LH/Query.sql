Use [ORDER_ENTRY]
GO

-- TV1
DECLARE @OrderNumber INT = 1

SELECT [CustomerIdentifier], [OrderNumber], [OrderTotalCost]
FROM [dbo].[Order]
WHERE [OrderNumber] = @OrderNumber
GO

-- TV2
DECLARE @ItemNumber INT = 1

SELECT [ItemNumber], [LowestPrice], [LowestPriceSupplier]
FROM [dbo].[Advertised_Item]
WHERE [ItemNumber] = @ItemNumber
GO

-- TV3
SELECT C.[CustomerIdentifier], COUNT(CC.[CustomerCreditCardNumber]) AS N'Số thẻ tín dụng'
FROM [dbo].[Customer] AS C JOIN [dbo].[Credit_Card] AS CC
ON C.[CustomerIdentifier] = CC.[CustomerIdentifier]
GROUP BY C.[CustomerIdentifier]
GO

-- TV4
DECLARE @Id_Customer INT = 939

SELECT * 
FROM Customer
WHERE CustomerIdentifier = @ID_Customer 
GO

-- TV5
USE [ORDER_ENTRY]
GO
CREATE NONCLUSTERED INDEX [IDX_TV5]
ON [dbo].[Credit_Card] ([CustomerIdentifier])
INCLUDE ([TotalofUse])
GO

DECLARE @Id_Customer INT = 939

SELECT C.[CustomerIdentifier], C.CustomerName, CC.TotalofUse
FROM [dbo].[Customer] C JOIN [dbo].[Credit_Card] CC ON C.[CustomerIdentifier] = CC.[CustomerIdentifier]
WHERE C.[CustomerIdentifier] = @Id_Customer
GO

-- TV6
DECLARE @ItemNumber INT = 1000

SELECT ItemNumber, TotalQuantityOrdered
FROM [dbo].[Advertised_Item]
WHERE [ItemNumber] = @ItemNumber
GO

-- TV7
USE [ORDER_ENTRY]
GO
CREATE NONCLUSTERED INDEX [IDX_TV7]
ON [dbo].[Order] ([OrderDate])
INCLUDE ([OrderTotalCost])
GO

DECLARE @OrderDate DATE = '2021-01-01'

SELECT OrderDate, SUM(OrderTotalCost) AS 'Total Cost' 
FROM [dbo].[Order] 
WHERE OrderDate = @OrderDate
GROUP BY OrderDate 
GO

-- TV8
USE [ORDER_ENTRY]
GO
CREATE NONCLUSTERED INDEX [IDX_TV8]
ON [dbo].[Credit_Card] ([CustomerIdentifier], [LastUse])
GO

SELECT C.*, Cr.CustomerCreditCardNumber, Cr.LastUse
FROM Customer C JOIN (
    SELECT Cr1.CustomerIdentifier, Cr1.CustomerCreditCardNumber, Cr1.LastUse
    FROM Credit_Card Cr1 JOIN (
        SELECT CustomerIdentifier, MIN(LastUse) AS minLastUse
        FROM Credit_Card
        GROUP BY CustomerIdentifier
    ) Cr2 ON Cr1.CustomerIdentifier = Cr2.CustomerIdentifier AND Cr1.LastUse = Cr2.minLastUse
) Cr ON Cr.CustomerIdentifier = C.CustomerIdentifier
GO
