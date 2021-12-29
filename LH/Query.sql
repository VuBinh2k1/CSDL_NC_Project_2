Use [ORDER_ENTRY]

-- TV1
SELECT [CustomerIdentifier], [OrderNumber], [OrderTotalCost]
FROM [dbo].[Order]

-- TV2
SELECT [ItemNumber], [LowestPrice], [LowestPriceSupplier]
FROM [dbo].[Advertised_Item]

-- TV3
SELECT C.[CustomerIdentifier], COUNT(CC.[CustomerCreditCardNumber]) AS N'Số thẻ tín dụng'
FROM [dbo].[Customer] AS C, [dbo].[Credit_Card] AS CC
WHERE C.[CustomerIdentifier] = CC.[CustomerIdentifier]
GROUP BY C.[CustomerIdentifier]

-- TV4
SELECT [CustomerIdentifier], [CustPreferredCreditCard]
FROM [dbo].[Customer]

-- TV5
SELECT C.[CustomerIdentifier], C.CustomerName, CC.TotalofUse
FROM [dbo].[Customer] AS C, [dbo].[Credit_Card] AS CC
WHERE C.[CustomerIdentifier] = CC.[CustomerIdentifier]

-- TV6
SELECT ItemNumber, TotalQuantityOrdered
FROM [dbo].[Advertised_Item]

-- TV7
SELECT OrderDate, SUM(OrderTotalCost) AS 'Total Cost' 
FROM [dbo].[Order] 
GROUP BY OrderDate 

-- TV8
SELECT CustomerCreditCardNumber, LastUse
FROM Credit_Card
ORDER BY LastUse ASC
