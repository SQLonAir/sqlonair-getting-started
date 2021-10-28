IF NOT EXISTS (SELECT * from sys.databases WHERE name = 'ACME_DB')
BEGIN
	CREATE DATABASE [ACME_DB];
END
GO
         

Use [ACME_DB];

/****************** DROP TABLES ***********************/

ALTER TABLE [dbo].[CartItem] DROP CONSTRAINT [FK_CartItem_Product]
GO

ALTER TABLE [dbo].[CartItem] DROP CONSTRAINT [FK_CartItem_ShoppingCart]
GO

ALTER TABLE [dbo].[CartItem] DROP CONSTRAINT [DF_CartItem_CartItemId]
GO

/****** Object:  Table [dbo].[CartItem]    Script Date: 10/1/2021 12:06:54 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CartItem]') AND type in (N'U'))
DROP TABLE [dbo].[CartItem]
GO


ALTER TABLE [dbo].[ShoppingCart] DROP CONSTRAINT [FK_ShoppingCart_Customer]
GO

ALTER TABLE [dbo].[ShoppingCart] DROP CONSTRAINT [DF_ShoppingCart_CartId]
GO

/****** Object:  Table [dbo].[ShoppingCart]    Script Date: 10/1/2021 12:05:57 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ShoppingCart]') AND type in (N'U'))
DROP TABLE [dbo].[ShoppingCart]
GO

/****** Object:  Table [dbo].[Customer]    Script Date: 10/1/2021 12:05:30 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
DROP TABLE [dbo].[Customer]
GO


/****** Object:  Table [dbo].[Product]    Script Date: 10/1/2021 12:02:42 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Product]') AND type in (N'U'))
DROP TABLE [dbo].[Product]
GO



/*********************************************************************/
/******** CREATE TABLES *****/
CREATE TABLE [dbo].[Product](
	[ProductId] [nvarchar](150) NOT NULL,
	[Name] [nvarchar](50) NULL,
	[UnitPrice] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_ProductId]  DEFAULT (newid()) FOR [ProductId]
GO



CREATE TABLE [dbo].[Customer](
	[CustomerId] [nvarchar](150) NOT NULL,
	[Name] [nvarchar](150) NULL,
	[PhoneNumber] [nvarchar](150) NULL,
	[EmailAddress] nvarchar(150) NULL,
	[TaxRate] decimal(18,4) NULL,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[CustomerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Customer] ADD  CONSTRAINT [DF_Customer_CustomerId]  DEFAULT (newid()) FOR [CustomerId]
GO



/****** Object:  Table [dbo].[ShoppingCart]    Script Date: 10/1/2021 12:05:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ShoppingCart](
	[ShoppingCartId] [nvarchar](150) NOT NULL,
	[CartNumber] [int] NULL,
	[CartDate] DateTime NULL,
	[Customer] [nvarchar](150) NULL,
 CONSTRAINT [PK_ShoppingCart] PRIMARY KEY CLUSTERED 
(
	[ShoppingCartId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ShoppingCart] ADD  CONSTRAINT [DF_ShoppingCart_CartId]  DEFAULT (newid()) FOR [ShoppingCartId]
GO

ALTER TABLE [dbo].[ShoppingCart]  WITH CHECK ADD  CONSTRAINT [FK_ShoppingCart_Customer] FOREIGN KEY([Customer])
REFERENCES [dbo].[Customer] ([CustomerId])
GO

ALTER TABLE [dbo].[ShoppingCart] CHECK CONSTRAINT [FK_ShoppingCart_Customer]
GO

CREATE TABLE [dbo].[CartItem](
	[CartItemId] [nvarchar](150) NOT NULL,
	[ShoppingCart] [nvarchar](150) NULL,
	[Product] [nvarchar](150) NULL,
	[Quantity] [decimal](18, 2) NULL,
 CONSTRAINT [PK_CartItem] PRIMARY KEY CLUSTERED 
(
	[CartItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CartItem] ADD  CONSTRAINT [DF_CartItem_CartItemId]  DEFAULT (newid()) FOR [CartItemId]
GO

ALTER TABLE [dbo].[CartItem]  WITH CHECK ADD  CONSTRAINT [FK_CartItem_ShoppingCart] FOREIGN KEY([ShoppingCart])
REFERENCES [dbo].[ShoppingCart] ([ShoppingCartId])
GO

ALTER TABLE [dbo].[CartItem] CHECK CONSTRAINT [FK_CartItem_ShoppingCart]
GO

ALTER TABLE [dbo].[CartItem]  WITH CHECK ADD  CONSTRAINT [FK_CartItem_Product] FOREIGN KEY([Product])
REFERENCES [dbo].[Product] ([ProductId])
GO

ALTER TABLE [dbo].[CartItem] CHECK CONSTRAINT [FK_CartItem_Product]
GO


DELETE FROM CartItem;
DELETE FROM [ShoppingCart];
DELETE FROM Customer;
DELETE FROM Product;



/*  INSERT SAMPLE DATA */
DECLARE @p1 NVARCHAR(50) = newid();
INSERT INTO Product (ProductId, Name, UnitPrice) VALUES(@p1, 'Product A', 2);
DECLARE @p2 NVARCHAR(50) = newid();
INSERT INTO Product (ProductId, Name, UnitPrice) VALUES(@p2, 'Product B', 5);


DECLARE @ejId NVARCHAR(50) = newid()
INSERT INTO Customer (CustomerId, Name, PhoneNumber, EmailAddress, TaxRate) VALUES (@ejId, 'ej', '123-456-7890', 'ej@ssot.me', 0.05)
DECLARE @bobId NVARCHAR(50) = newid()
INSERT INTO Customer (CustomerId, Name, PhoneNumber, EmailAddress, TaxRate) VALUES (@bobId, 'bob', '321-456-7890', 'bob@ssot.me', 0.025);
DECLARE @maryId NVARCHAR(50) = newid()
INSERT INTO Customer (CustomerId, Name, PhoneNumber, EmailAddress, TaxRate) VALUES (@maryId, 'mary', '525-555-7890', 'marshopy@ssot.me', 0.05);

DECLARE @o1 NVARCHAR(50) = newid();
INSERT INTO [ShoppingCart] (ShoppingCartId, CartNumber, CartDate, Customer) VALUES (@o1, 1250, getDate(), @ejId);

INSERT INTO CartItem (ShoppingCart, Product, Quantity) VALUES (@o1, @p1, 3);

DECLARE @o2 NVARCHAR(50) = newid();
INSERT INTO [ShoppingCart] (ShoppingCartId, CartNumber, CartDate, Customer) VALUES (@o2, 1251, getDate(), @bobId);

INSERT INTO CartItem (ShoppingCart, Product, Quantity) VALUES (@o2, @p1, 1);
INSERT INTO CartItem (ShoppingCart, Product, Quantity) VALUES (@o2, @p2, 5);

DECLARE @o3 NVARCHAR(50) = newid();
INSERT INTO [ShoppingCart] (ShoppingCartId, CartNumber, CartDate, Customer) VALUES (@o3, 1252, getDate(), @maryId);

INSERT INTO CartItem (ShoppingCart, Product, Quantity) VALUES (@o3, @p2, 1);
