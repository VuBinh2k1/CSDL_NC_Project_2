
DECLARE @OrderDate DATE
SET @OrderDate = '2021-01-01'

SELECT OrderDate, SUM(OrderTotalCost) AS 'Total Cost' 
FROM [dbo].[Order] 
WHERE OrderDate = @OrderDate
GROUP BY OrderDate 

/* INDEX */
CREATE NONCLUSTERED INDEX ID_Order ON [dbo].[Order](OrderDate) INCLUDE (OrderTotalCost)