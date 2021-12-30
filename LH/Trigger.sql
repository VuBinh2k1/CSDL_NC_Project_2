USE [ORDER_ENTRY]
GO

--Trigger#4
CREATE OR ALTER TRIGGER [Customer_PreferredCreditCard]
ON [dbo].[Credit_Card]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @CustomerId INT, @CardNumber INT, @PreferredOpt INT 
	SELECT @CustomerId = CustomerIdentifier, @CardNumber = CustomerCreditCardNumber, @PreferredOpt = PreferredOption
	FROM inserted i

	DECLARE @CardNumber2 INT = (
		SELECT CustPreferredCreditCard FROM Customer 
		WHERE CustomerIdentifier = @CustomerId)

	IF @CardNumber2 IS NULL OR @PreferredOpt > (
		SELECT PreferredOption FROM Credit_Card 
		WHERE CustomerCreditCardNumber = @CardNumber2)
	BEGIN
		UPDATE Customer
		SET CustPreferredCreditCard = @CardNumber
		WHERE CustomerIdentifier = @CustomerId
	END
END
GO
ALTER TABLE [dbo].[Credit_Card] ENABLE TRIGGER [Customer_PreferredCreditCard]
GO

--Trigger#5
CREATE OR ALTER TRIGGER [CreditCard_TotalofUse]
ON [dbo].[Order]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @CustomerID INT, @CardNumber INT
	SELECT @CustomerID = CustomerIdentifier, @CardNumber = CustomerCreditCardNumber
	FROM inserted i

	IF @CardNumber IS NULL RETURN

	IF EXISTS (
		SELECT CustomerCreditCardNumber FROM Credit_Card 
		WHERE CustomerCreditCardNumber = @CardNumber)
	BEGIN
		UPDATE Credit_Card
		SET TotalofUse = TotalofUse + 1
		WHERE CustomerCreditCardNumber = @CardNumber
	END
	ELSE
	BEGIN
		INSERT Credit_Card(CustomerCreditCardNumber, CustomerIdentifier, TotalofUse)
		VALUES (@CustomerID, @CardNumber, 1)
	END
END
GO
ALTER TABLE [dbo].[Order] ENABLE TRIGGER [CreditCard_TotalofUse]
GO

--Trigger#8
CREATE OR ALTER TRIGGER [CreditCard_TheLastUse]
ON [dbo].[Order]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @CustomerID INT, @CardNumber INT, @LastUse DATE
	SELECT @CustomerID = CustomerIdentifier, @CardNumber = CustomerCreditCardNumber, @LastUse = OrderDate
	FROM inserted i

	IF @CardNumber IS NULL OR @LastUse IS NULL RETURN

	IF EXISTS (
		SELECT CustomerCreditCardNumber FROM Credit_Card 
		WHERE CustomerCreditCardNumber = @CardNumber)
	BEGIN
		UPDATE Credit_Card
		SET LastUse = CASE WHEN LastUse IS NULL OR LastUse < @LastUse THEN @LastUse END
		WHERE CustomerCreditCardNumber = @CardNumber
	END
	ELSE
	BEGIN
		INSERT Credit_Card(CustomerCreditCardNumber, CustomerIdentifier, LastUse)
		VALUES (@CustomerID, @CardNumber, @LastUse)
	END
END
GO
ALTER TABLE [dbo].[Order] ENABLE TRIGGER [CreditCard_TheLastUse]
GO

--Trigger#6
CREATE OR ALTER TRIGGER [AdvertisedItem_TotalQuantityOrdered]
ON [dbo].[Ordered_Item]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @QuantityOrdered BIGINT
	DECLARE @ItemNumber INT

	SELECT @QuantityOrdered = QuantityOrdered, @ItemNumber = ItemNumber
	FROM inserted i

	UPDATE Advertised_Item
	SET TotalQuantityOrdered = CASE 
								WHEN TotalQuantityOrdered IS NULL THEN (SELECT SUM (QuantityOrdered)
																		FROM Ordered_Item
																		WHERE ItemNumber = @ItemNumber)
								ELSE TotalQuantityOrdered + @QuantityOrdered
							END
	WHERE ItemNumber = @ItemNumber

END
GO
ALTER TABLE [dbo].[Ordered_Item] ENABLE TRIGGER [AdvertisedItem_TotalQuantityOrdered]
GO

--Trigger#2
CREATE OR ALTER TRIGGER [AdvertisedItem_LowestPrice]
ON [Restock_Item]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @Supplier_in INT
	DECLARE @ItemNumber_in INT
	DECLARE @Price_in MONEY

	DECLARE @Supplier INT
	DECLARE @Price MONEY

	SELECT @Supplier_in = SupplierID, @ItemNumber_in = ItemNumber, @Price_in = PurchasePrice
	FROM inserted i

	SELECT @Supplier = LowestPriceSupplier, @Price = LowestPrice
	FROM Advertised_Item A
	WHERE ItemNumber = @ItemNumber_in

	IF @Price IS NULL OR @Price_in < @Price 
		UPDATE Advertised_Item
		SET LowestPrice = @Price_in, LowestPriceSupplier = @Supplier_in
		WHERE ItemNumber = @ItemNumber_in

END
GO
ALTER TABLE [dbo].[Restock_Item] ENABLE TRIGGER [AdvertisedItem_LowestPrice]
GO

--Trigger#3
CREATE OR ALTER TRIGGER [CreditCard_CustomerIdentifier]
ON [Order]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @CusId INT
	DECLARE @CreditCard INT

	SELECT @CusId = CustomerIdentifier, @CreditCard = CustomerCreditCardNumber
	FROM inserted i

	UPDATE Credit_Card
	SET CustomerIdentifier = @CusId
	WHERE CustomerCreditCardNumber = @CreditCard

END
GO
ALTER TABLE [dbo].[Order] ENABLE TRIGGER [CreditCard_CustomerIdentifier]
GO

USE [ORDER_ENTRY]
GO

--Trigger#1

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
