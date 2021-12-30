Use [ORDER_ENTRY]

-- TV1
DECLARE @OrderNumber INT = 1

SELECT [CustomerIdentifier], [OrderNumber], [OrderTotalCost]
FROM [dbo].[Order]
WHERE [OrderNumber] = @OrderNumber

-- TV2
DECLARE @ItemNumber INT = 1

SELECT [ItemNumber], [LowestPrice], [LowestPriceSupplier]
FROM [dbo].[Advertised_Item]
WHERE [ItemNumber] = @ItemNumber

-- TV3
SELECT C.[CustomerIdentifier], COUNT(CC.[CustomerCreditCardNumber]) AS N'Số thẻ tín dụng'
FROM [dbo].[Customer] AS C JOIN [dbo].[Credit_Card] AS CC
ON C.[CustomerIdentifier] = CC.[CustomerIdentifier]
GROUP BY C.[CustomerIdentifier]

-- TV4
DECLARE @Id_Customer INT = 1

SELECT * 
FROM Customer
WHERE CustomerIdentifier = @ID_Customer 

-- TV5
CREATE NONCLUSTERED INDEX [IDX_TV5]
ON [dbo].[Credit_Card] ([CustomerIdentifier])
INCLUDE ([TotalofUse])

SELECT C.[CustomerIdentifier], C.CustomerName, CC.TotalofUse
FROM [dbo].[Customer] AS C, [dbo].[Credit_Card] AS CC
WHERE C.[CustomerIdentifier] = CC.[CustomerIdentifier]

-- TV6
SELECT ItemNumber, TotalQuantityOrdered
FROM [dbo].[Advertised_Item]
WHERE [ItemNumber] = @ItemNumber

-- TV7
USE [ORDER_ENTRY]
GO
CREATE NONCLUSTERED INDEX [IDX_TV7]
ON [dbo].[Order] ([OrderDate])
INCLUDE ([OrderTotalCost])

DECLARE @OrderDate DATE = '2021-01-01'

SELECT OrderDate, SUM(OrderTotalCost) AS 'Total Cost' 
FROM [dbo].[Order] 
WHERE OrderDate = @OrderDate
GROUP BY OrderDate 

-- TV8
USE [ORDER_ENTRY]
GO
CREATE NONCLUSTERED INDEX [IDX_TV8]
ON [dbo].[Credit_Card] ([LastUse])
INCLUDE ([CustomerIdentifier])

SELECT C.*, 
Cr.CustomerCreditCardNumber, Cr.LastUse
FROM Customer C JOIN (
SELECT Cr1.CustomerIdentifier,
Cr1.CustomerCreditCardNumber,
Cr1.LastUse
FROM Credit_Card Cr1 JOIN (
SELECT CustomerIdentifier,
MIN(LastUse) AS minLastUse
FROM Credit_Card
GROUP BY CustomerIdentifier
) Cr2 ON Cr1.CustomerIdentifier =
Cr2.CustomerIdentifier AND 
Cr1.LastUse = Cr2.minLastUse
) Cr ON Cr.CustomerIdentifier =
C.CustomerIdentifier

