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

--Trigger#1
CREATE OR ALTER TRIGGER [Order_OrderTotalCost]
ON [dbo].[Ordered_Item]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @OrderNumber INT

	SELECT @OrderNumber = OrderNumber
	FROM inserted i

	UPDATE [dbo].[Order]
	SET OrderTotalCost = (SELECT SUM (SellingPrice)
						  FROM Ordered_Item
						  WHERE OrderNumber = @OrderNumber)
	WHERE OrderNumber = @OrderNumber
END
GO
ALTER TABLE [dbo].[Ordered_Item] ENABLE TRIGGER [Order_OrderTotalCost]
GO

--Trigger#2
CREATE OR ALTER TRIGGER [AdvertisedItem_LowestPrice]
ON [Restock_Item]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @Supplier INT
	DECLARE @ItemNumber INT
	DECLARE @Price MONEY

	SELECT @Supplier = SupplierID, @ItemNumber = ItemNumber, @Price = PurchasePrice
	FROM inserted i

	UPDATE Advertised_Item
	SET LowestPrice = R.PurchasePrice, LowestPriceSupplier = R.SupplierID
	FROM Restock_Item R
	WHERE R.ItemNumber = @ItemNumber AND NOT EXISTS (SELECT *
													 FROM Restock_Item R1
													 WHERE R1.ItemNumber = R.ItemNumber AND
														   R1.PurchasePrice < R.PurchasePrice)
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