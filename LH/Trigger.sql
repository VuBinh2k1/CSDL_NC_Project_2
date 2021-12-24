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
	SELECT @CustomerID = CustomerIdentifer, @CardNumber = CustomerCreditCardNumber
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
	SELECT @CustomerID = CustomerIdentifer, @CardNumber = CustomerCreditCardNumber, @LastUse = OrderDate
	FROM inserted i

	IF @CardNumber IS NULL OR @LastUse IS NULL RETURN

	IF EXISTS (
		SELECT CustomerCreditCardNumber FROM Credit_Card 
		WHERE CustomerCreditCardNumber = @CardNumber)
	BEGIN
		UPDATE Credit_Card
		SET LastUse = @LastUse
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