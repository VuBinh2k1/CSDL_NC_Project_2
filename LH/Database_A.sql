GO
DROP DATABASE IF EXISTS [ORDER_ENTRY_A]
GO
CREATE DATABASE [ORDER_ENTRY_A]

USE [ORDER_ENTRY_A]
GO
/****** Object:  Table [dbo].[Advertised_Item]    Script Date: 12/23/2021 11:23:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Advertised_Item](
	[ItemNumber] [int] NOT NULL,
	[ItemDescription] [nvarchar](max) NULL,
	[ItemDepartment] [int] NULL,
	[ItemWeight] [float] NULL,
	[ItemColor] [nvarchar](20) NULL,
	[ItemPrice] [money] NULL,
 CONSTRAINT [PK_Advertised_Item] PRIMARY KEY CLUSTERED 
(
	[ItemNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Credit_Card]    Script Date: 12/23/2021 11:23:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credit_Card](
	[CustomerCreditCardNumber] [int] NOT NULL,
	[CustomerCreditCardName] [nvarchar](50) NULL,
 CONSTRAINT [PK_Credit_Card] PRIMARY KEY CLUSTERED 
(
	[CustomerCreditCardNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 12/23/2021 11:23:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerIdentifier] [int] NOT NULL,
	[CustomerTelephoneNumber] [char](10) NULL,
	[CustomerName] [nvarchar](50) NULL,
	[CustomerStreetAddress] [nvarchar](max) NULL,
	[CustomerCity] [nvarchar](50) NULL,
	[CustomerState] [nvarchar](50) NULL,
	[CustomerZipCode] [int] NULL,
	[CustomerCreditRating] [float] NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 12/23/2021 11:23:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[OrderNumber] [int] NOT NULL,
	[CustomerTelephoneNumber] [char](10) NULL,
	[CustomerIdentifer] [int] NULL,
	[OrderDate] [date] NULL,
	[ShippingStreetAddress] [nvarchar](max) NULL,
	[ShippingCity] [nvarchar](50) NULL,
	[ShippingState] [nvarchar](50) NULL,
	[ShippingZipCode] [int] NULL,
	[CustomerCreditCardNumber] [int] NULL,
	[ShippingDate] [date] NULL,
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ordered_ Item]    Script Date: 12/23/2021 11:23:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ordered_ Item](
	[ItemNumber] [int] NOT NULL,
	[OrderNumber] [int] NOT NULL,
	[QuantityOrdered] [int] NULL,
	[SellingPrice] [money] NULL,
	[ShippingDate] [date] NULL,
 CONSTRAINT [PK_Ordered_ Item] PRIMARY KEY CLUSTERED 
(
	[ItemNumber] ASC,
	[OrderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Restock_Item]    Script Date: 12/23/2021 11:23:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restock_Item](
	[ItemNumber] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[PurchasePrice] [money] NULL,
 CONSTRAINT [PK_Restock_Item] PRIMARY KEY CLUSTERED 
(
	[ItemNumber] ASC,
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 12/23/2021 11:23:50 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supplier](
	[SupplierID] [int] NOT NULL,
	[SupplierName] [nvarchar](50) NULL,
	[SupplierStreetAddress] [nvarchar](max) NULL,
	[SupplierCity] [nvarchar](50) NULL,
	[SupplierState] [nvarchar](50) NULL,
	[SupplierZipCode] [int] NULL,
 CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Credit_Card] FOREIGN KEY([CustomerCreditCardNumber])
REFERENCES [dbo].[Credit_Card] ([CustomerCreditCardNumber])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Credit_Card]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Customer] FOREIGN KEY([OrderNumber])
REFERENCES [dbo].[Customer] ([CustomerIdentifier])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Customer]
GO
ALTER TABLE [dbo].[Ordered_ Item]  WITH CHECK ADD  CONSTRAINT [FK_Ordered_ Item_Advertised_Item] FOREIGN KEY([ItemNumber])
REFERENCES [dbo].[Advertised_Item] ([ItemNumber])
GO
ALTER TABLE [dbo].[Ordered_ Item] CHECK CONSTRAINT [FK_Ordered_ Item_Advertised_Item]
GO
ALTER TABLE [dbo].[Ordered_ Item]  WITH CHECK ADD  CONSTRAINT [FK_Ordered_ Item_Order] FOREIGN KEY([OrderNumber])
REFERENCES [dbo].[Order] ([OrderNumber])
GO
ALTER TABLE [dbo].[Ordered_ Item] CHECK CONSTRAINT [FK_Ordered_ Item_Order]
GO
ALTER TABLE [dbo].[Restock_Item]  WITH CHECK ADD  CONSTRAINT [FK_Restock_Item_Advertised_Item] FOREIGN KEY([ItemNumber])
REFERENCES [dbo].[Advertised_Item] ([ItemNumber])
GO
ALTER TABLE [dbo].[Restock_Item] CHECK CONSTRAINT [FK_Restock_Item_Advertised_Item]
GO
ALTER TABLE [dbo].[Restock_Item]  WITH CHECK ADD  CONSTRAINT [FK_Restock_Item_Supplier] FOREIGN KEY([SupplierID])
REFERENCES [dbo].[Supplier] ([SupplierID])
GO
ALTER TABLE [dbo].[Restock_Item] CHECK CONSTRAINT [FK_Restock_Item_Supplier]
GO
