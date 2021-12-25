CREATE OR ALTER TRIGGER Price_OrderedItem
ON [dbo].[Ordered_Item]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @Price MONEY
	SET @Price = (SELECT ItemPrice FROM Advertised_Item AI, inserted I WHERE I.ItemNumber = AI.ItemNumber)

	UPDATE Ordered_Item
	SET SellingPrice = I.QuantityOrdered * @Price
	FROM inserted I, Ordered_Item OI
	WHERE OI.OrderNumber = I.OrderNumber AND OI.ItemNumber = I.ItemNumber
END
GO
CREATE OR ALTER TRIGGER TotalCost_Order
ON [dbo].[Ordered_Item]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @Total MONEY
	SET @Total = (SELECT SUM(OI.SellingPrice) FROM Ordered_Item OI, inserted I WHERE I.OrderNumber = OI.OrderNumber GROUP BY OI.OrderNumber)
	
	UPDATE [dbo].[Order]
	SET OrderTotalCost = @Total
	FROM inserted I, [dbo].[Order] O
	WHERE I.OrderNumber = O.OrderNumber 
END
GO
