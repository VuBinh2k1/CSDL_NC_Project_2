USE [master]
GO
/****** Object:  Database [ORDER_ENTRY]    Script Date: 24/12/2021 11:22:51 CH ******/
DROP DATABASE IF EXISTS [ORDER_ENTRY]
GO
CREATE DATABASE [ORDER_ENTRY]
GO
ALTER DATABASE [ORDER_ENTRY] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ORDER_ENTRY].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ORDER_ENTRY] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET ARITHABORT OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [ORDER_ENTRY] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ORDER_ENTRY] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ORDER_ENTRY] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET  ENABLE_BROKER 
GO
ALTER DATABASE [ORDER_ENTRY] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ORDER_ENTRY] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [ORDER_ENTRY] SET  MULTI_USER 
GO
ALTER DATABASE [ORDER_ENTRY] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ORDER_ENTRY] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ORDER_ENTRY] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ORDER_ENTRY] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [ORDER_ENTRY] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [ORDER_ENTRY] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [ORDER_ENTRY] SET QUERY_STORE = OFF
GO
USE [ORDER_ENTRY]
GO
/****** Object:  Table [dbo].[Advertised_Item]    Script Date: 24/12/2021 11:22:51 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Advertised_Item](
	[ItemNumber] [int] NOT NULL,
	[ItemDescription] [nvarchar](50) NULL,
	[ItemDepartment] [nchar](10) NULL,
	[ItemWeight] [float] NULL,
	[ItemColor] [nvarchar](10) NULL,
	[ItemPrice] [money] NOT NULL,
	[LowestPrice] [money] NULL, -- Green
	[LowestPriceSupplier] [int] NULL, -- Green
 CONSTRAINT [PK_Advertised_Item] PRIMARY KEY CLUSTERED 
(
	[ItemNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Credit_Card]    Script Date: 24/12/2021 11:22:51 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Credit_Card](
	[CustomerCreditCardNumber] [int] NOT NULL,
	[CustomerCreditCardName] [nvarchar](50) NULL,
	[CustomerIdentifier] [int] NOT NULL, -- Green
	[PreferredOption] [int] DEFAULT(1), -- Green
	[TotalofUse] [int] DEFAULT(0), -- Green
	[LastUse] [date] NULL, -- Blue
 CONSTRAINT [PK_Credit_Card] PRIMARY KEY CLUSTERED 
(
	[CustomerCreditCardNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Customer]    Script Date: 24/12/2021 11:22:51 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Customer](
	[CustomerIdentifier] [int] NOT NULL,
	[CustomerTelephoneNumber] [char](10) NULL,
	[CustomerName] [nvarchar](50) NULL,
	[CustomerStreetAddress] [nvarchar](50) NULL,
	[CustomerCity] [nvarchar](50) NULL,
	[CustomerState] [nvarchar](50) NULL,
	[CustomerZipCode] [nvarchar](50) NULL,
	[CustomerCreditRating] [nvarchar](50) NULL,
	[CustPreferredCreditCard] [int] NULL, -- Green
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Order]    Script Date: 24/12/2021 11:22:51 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Order](
	[OrderNumber] [int] NOT NULL,
	[CustomerTelephoneNumber] [char](10) NULL,
	[CustomerIdentifier] [int] NOT NULL,
	[OrderDate] [date] NULL,
	[ShippingStreetAddress] [nvarchar](50) NULL,
	[ShippingCity] [nvarchar](50) NULL,
	[ShippingState] [nvarchar](50) NULL,
	[ShippingZipCode] [nvarchar](50) NULL,
	[CustomerCreditCardNumber] [int] NULL,
	[ShippingDate] [date] NULL,
	[OrderTotalCost] [money] NULL, -- Green
 CONSTRAINT [PK_Order] PRIMARY KEY CLUSTERED 
(
	[OrderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Ordered_Item]    Script Date: 24/12/2021 11:22:51 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Ordered_Item](
	[ItemNumber] [int] NOT NULL,
	[OrderNumber] [int] NOT NULL,
	[QuantityOrdered] [int] NOT NULL,
	[SellingPrice] [money] NULL,
	[ShippingDate] [date] NULL,
 CONSTRAINT [PK_Ordered_ Item] PRIMARY KEY CLUSTERED 
(
	[ItemNumber] ASC,
	[OrderNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Restock_Item]    Script Date: 24/12/2021 11:22:51 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Restock_Item](
	[ItemNumber] [int] NOT NULL,
	[SupplierID] [int] NOT NULL,
	[PurchasePrice] [money] NOT NULL,
 CONSTRAINT [PK_Restock_Item] PRIMARY KEY CLUSTERED 
(
	[ItemNumber] ASC,
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Supplier]    Script Date: 24/12/2021 11:22:51 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Supplier](
	[SupplierID] [int] NOT NULL,
	[SupplierName] [nvarchar](50) NULL,
	[SupplierStreetAddress] [nvarchar](50) NULL,
	[SupplierCity] [nvarchar](50) NULL,
	[SupplierState] [nvarchar](50) NULL,
	[SupplierZipCode] [nchar](10) NULL,
 CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED 
(
	[SupplierID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Credit_Card]  WITH CHECK ADD  CONSTRAINT [FK_Credit_Card_Customer] FOREIGN KEY([CustomerIdentifier])
REFERENCES [dbo].[Customer] ([CustomerIdentifier])
GO
ALTER TABLE [dbo].[Credit_Card] CHECK CONSTRAINT [FK_Credit_Card_Customer]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Customer] FOREIGN KEY([CustomerIdentifier])
REFERENCES [dbo].[Customer] ([CustomerIdentifier])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Customer]
GO
ALTER TABLE [dbo].[Order]  WITH CHECK ADD  CONSTRAINT [FK_Order_Order] FOREIGN KEY([CustomerCreditCardNumber])
REFERENCES [dbo].[Credit_Card] ([CustomerCreditCardNumber])
GO
ALTER TABLE [dbo].[Order] CHECK CONSTRAINT [FK_Order_Order]
GO
ALTER TABLE [dbo].[Ordered_Item]  WITH CHECK ADD  CONSTRAINT [FK_Ordered_ Item_Advertised_Item] FOREIGN KEY([ItemNumber])
REFERENCES [dbo].[Advertised_Item] ([ItemNumber])
GO
ALTER TABLE [dbo].[Ordered_Item] CHECK CONSTRAINT [FK_Ordered_ Item_Advertised_Item]
GO
ALTER TABLE [dbo].[Ordered_Item]  WITH CHECK ADD  CONSTRAINT [FK_Ordered_ Item_Order] FOREIGN KEY([OrderNumber])
REFERENCES [dbo].[Order] ([OrderNumber])
GO
ALTER TABLE [dbo].[Ordered_Item] CHECK CONSTRAINT [FK_Ordered_ Item_Order]
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
USE [master]
GO
ALTER DATABASE [ORDER_ENTRY] SET  READ_WRITE 
GO

USE [ORDER_ENTRY]
GO
ALTER TABLE [Advertised_Item] ADD [TotalQuantityOrdered] BIGINT DEFAULT 0
GO

-- exec sp_rename 'dbo.Ordered_ Item', 'Ordered_Item'
--CONSTRAINT: ItemNumber, LowestPriceSupplier, LowestPrice must exists
ALTER TABLE [dbo].[Restock_Item]
ADD UNIQUE([ItemNumber], [SupplierID], [PurchasePrice]);

ALTER TABLE [dbo].[Advertised_Item]
ADD CONSTRAINT FK_AdvItem_LowestPrice FOREIGN KEY ([ItemNumber], [LowestPriceSupplier], [LowestPrice])
REFERENCES [dbo].[Restock_Item]([ItemNumber], [SupplierID], [PurchasePrice])

ALTER TABLE [dbo].[Customer]
ADD CONSTRAINT FK_Customer_PreferCreditCard FOREIGN KEY ([CustPreferredCreditCard])
REFERENCES [dbo].[Credit_Card]([CustomerCreditCardNumber])