
GO
/****** Object:  UserDefinedTableType [dbo].[UT_AeraMaster]    Script Date: 12-04-2019 15:31:34 ******/
CREATE TYPE [dbo].[UT_AeraMaster] AS TABLE(
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[Area] [nvarchar](50) NOT NULL,
	[CityID] [int] NOT NULL,
	[LastUpdatedDate] [datetime] NULL DEFAULT (getdate())
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_AeraMaster1]    Script Date: 12-04-2019 15:31:35 ******/
CREATE TYPE [dbo].[UT_AeraMaster1] AS TABLE(
	[AreaID] [int] NULL,
	[Area] [nvarchar](50) NOT NULL,
	[CityID] [int] NOT NULL,
	[LastUpdatedDate] [datetime] NULL DEFAULT (getdate())
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_CustomerMaster]    Script Date: 12-04-2019 15:31:35 ******/
CREATE TYPE [dbo].[UT_CustomerMaster] AS TABLE(
	[CustomerID] [int] NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](350) NOT NULL,
	[Mobile] [nvarchar](50) NOT NULL,
	[AreaID] [int] NULL,
	[SalesPersonID] [int] NULL,
	[VehicleID] [int] NULL,
	[CustomerTypeId] [int] NULL,
	[CustomerNameEnglish] [varchar](50) NULL,
	[LastUpdatedDate] [datetime] NULL,
	[isBillRequired] [bit] NULL,
	[isActive] [bit] NULL,
	[DeliveryCharges] [decimal](9, 2) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_EmployeeMaster]    Script Date: 12-04-2019 15:31:35 ******/
CREATE TYPE [dbo].[UT_EmployeeMaster] AS TABLE(
	[EmployeeID] [int] NULL,
	[EmployeeName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](350) NOT NULL,
	[AreaID] [datetime] NULL,
	[Mobile] [int] NOT NULL,
	[UserId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_EmployeeMasters]    Script Date: 12-04-2019 15:31:35 ******/
CREATE TYPE [dbo].[UT_EmployeeMasters] AS TABLE(
	[EmployeeID] [int] NULL,
	[EmployeeName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](350) NOT NULL,
	[AreaID] [datetime] NULL,
	[Mobile] [nvarchar](10) NOT NULL,
	[UserId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_ProductMaster]    Script Date: 12-04-2019 15:31:35 ******/
CREATE TYPE [dbo].[UT_ProductMaster] AS TABLE(
	[ProductID] [int] NULL,
	[Product] [nvarchar](50) NULL,
	[ProductBrandID] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreatedBy] [int] NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [int] NULL,
	[isActive] [bit] NULL,
	[CrateSize] [int] NULL,
	[GST] [decimal](9, 2) NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_SupplierMaster]    Script Date: 12-04-2019 15:31:35 ******/
CREATE TYPE [dbo].[UT_SupplierMaster] AS TABLE(
	[VendorID] [int] NULL,
	[VendorName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](250) NOT NULL,
	[AreaID] [int] NULL,
	[CityID] [int] NOT NULL,
	[EmailID] [nvarchar](50) NULL,
	[OfficePhone] [nvarchar](50) NULL,
	[FaxNo] [nvarchar](50) NULL,
	[ContactPerson] [nvarchar](50) NULL,
	[PersonMobileNo] [varchar](20) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreateDate] [datetime] NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_VehicalMaster]    Script Date: 12-04-2019 15:31:35 ******/
CREATE TYPE [dbo].[UT_VehicalMaster] AS TABLE(
	[VechicleID] [int] NOT NULL,
	[Transport] [varchar](50) NULL,
	[Owner] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[Mobile] [varchar](50) NULL,
	[VechicleNo] [varchar](15) NULL,
	[Marathi] [varchar](100) NULL,
	[RatePerTrip] [decimal](18, 2) NULL,
	[PrintOrder] [int] NULL
)
GO
/****** Object:  UserDefinedFunction [dbo].[properCase]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[properCase](@string varchar(8000)) returns varchar(8000) as
begin
		
	set @string = lower(@string)
	
	declare @i int
	set @i = ascii('a')
	
	while @i <= ascii('z')
	begin
	
		set @string = replace( @string, ' ' + char(@i), ' ' + char(@i-32))
		set @i = @i + 1
	end
	
	set @string = char(ascii(left(@string, 1))-32) + right(@string, len(@string)-1)
	
	return @string
end



GO
/****** Object:  UserDefinedFunction [dbo].[udf_CusomerProductRate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_CusomerProductRate]
	(
		@CustomerId int,
		@productId INT,
		@OrderDate Date
	)

	RETURNs Decimal(18,2)
AS
BEGIN

	DECLARE @CustomerRate DECIMAL(18,2)
	BEGIN
		 select  @CustomerRate= isnull(Rate,0) from CustomerRates where CustomerID=@CustomerId and ProductID=@productId  and @OrderDate between StartDate and EndDate
	END

	RETURN isnull(@CustomerRate,0);
End


GO
/****** Object:  UserDefinedFunction [dbo].[udf_PutSpacesBetweenChars]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[udf_PutSpacesBetweenChars] 

(@String VARCHAR(100))

RETURNS VARCHAR(100)
AS
BEGIN
   DECLARE @pos INT, @result VARCHAR(100); 
   SET @result = @String; 
   SET @pos = 2 -- location where we want first space 
   WHILE @pos < LEN(@result)+1 
   BEGIN 
       SET @result = STUFF(@result, @pos, 0, Space(10)); 
       SET @pos = @pos+1; 
   END 
   RETURN @result; 
END




GO
/****** Object:  UserDefinedFunction [dbo].[ufnGetSupplierRate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create FUNCTION [dbo].[ufnGetSupplierRate](@ProductID [int], @OrderDate [datetime])
RETURNS [money] 
AS 
BEGIN
    DECLARE @ListPrice money;

    SELECT @ListPrice = plph.[ListPrice] 
    FROM  [ProductMast] p 
        INNER JOIN  [SupplierRateHistory] plph 
        ON p.[ProductID] = plph.[ProductID] 
            AND p.[ProductID] = @ProductID 
            AND @OrderDate BETWEEN plph.[StartDate] AND COALESCE(plph.[EndDate], CONVERT(datetime, '99991231', 112)); -- Make sure we get all the prices!

    RETURN @ListPrice;
END;



GO
/****** Object:  Table [dbo].[AreaMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AreaMast](
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[Area] [nvarchar](50) NOT NULL,
	[CityID] [int] NOT NULL,
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_AreaMast_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_AreaMast] PRIMARY KEY CLUSTERED 
(
	[AreaID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Bank]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Bank](
	[BankID] [int] IDENTITY(1,1) NOT NULL,
	[BankName] [varchar](50) NULL,
	[Branch] [varchar](50) NULL,
	[OwnBank] [bit] NULL,
	[AccNo] [varchar](50) NULL,
	[opBal] [decimal](18, 2) NULL,
 CONSTRAINT [PK_Bank] PRIMARY KEY CLUSTERED 
(
	[BankID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CompanyProfileMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CompanyProfileMast](
	[CompanyID] [int] NOT NULL,
	[Name] [nvarchar](max) NULL,
	[Nickname] [nvarchar](max) NULL,
	[Address1] [nvarchar](max) NULL,
	[Address2] [nvarchar](max) NULL,
	[Address3] [nvarchar](max) NULL,
	[Phone] [nvarchar](max) NULL,
	[Mobile] [nvarchar](max) NULL,
	[LogoFile] [nvarchar](max) NULL,
	[ReturnAmt] [decimal](18, 0) NULL,
 CONSTRAINT [PK_CompanyProfileMast] PRIMARY KEY CLUSTERED 
(
	[CompanyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CratesCustomer]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CratesCustomer](
	[CratesCustID] [int] IDENTITY(1,1) NOT NULL,
	[BillId] [int] NULL,
	[CustomerID] [int] NULL,
	[Date] [datetime] NULL,
	[PreBalance] [int] NULL,
	[CratesIn] [int] NULL,
	[CratesOut] [int] NULL,
	[Balance] [int] NULL,
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_CratesCustomer_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_CratesCustomer] PRIMARY KEY CLUSTERED 
(
	[CratesCustID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CratesVendor]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CratesVendor](
	[CratesVendorID] [int] IDENTITY(1,1) NOT NULL,
	[BillId] [int] NULL,
	[VendorID] [int] NULL,
	[OrderDate] [datetime] NULL,
	[PreBalance] [int] NULL,
	[CratesIn] [int] NULL,
	[CratesOut] [int] NULL,
	[BalanceCrates]  AS ([CratesIn]-[CratesOut]),
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_CratesVendor_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_CratesVendor] PRIMARY KEY CLUSTERED 
(
	[CratesVendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustBankInfoMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustBankInfoMast](
	[BankInfoID] [int] IDENTITY(1,1) NOT NULL,
	[CustID] [int] NOT NULL,
	[BankName] [nvarchar](max) NULL,
	[BranchAddress] [nvarchar](max) NULL,
	[AccNo] [varchar](50) NULL,
 CONSTRAINT [PK_CustBankInfo] PRIMARY KEY CLUSTERED 
(
	[BankInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomerBillDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerBillDetails](
	[BillDtlsID] [int] IDENTITY(1,1) NOT NULL,
	[BillID] [int] NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_CustomerBillDetails_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_CustomerBillDetails] PRIMARY KEY CLUSTERED 
(
	[BillDtlsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerBillMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerBillMast](
	[BillID] [int] IDENTITY(1,1) NOT NULL,
	[BillDate] [datetime] NULL,
	[TotalQty] [decimal](18, 2) NULL CONSTRAINT [DF_CustomerBillMast_TotalQty]  DEFAULT ((0)),
	[TotalAmount] [decimal](18, 2) NULL,
	[LastUpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_CustomerBillMast] PRIMARY KEY CLUSTERED 
(
	[BillID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerLikages]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerLikages](
	[CustLikageID] [int] IDENTITY(1,1) NOT NULL,
	[BillId] [int] NULL,
	[BillDate] [datetime] NULL,
	[CustomerID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Likage] [decimal](18, 2) NOT NULL,
	[LastUpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_CustomerLikages] PRIMARY KEY CLUSTERED 
(
	[CustLikageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerMast](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](350) NOT NULL,
	[Mobile] [nvarchar](50) NOT NULL,
	[AreaID] [int] NULL,
	[SalesPersonID] [int] NULL,
	[VehicleID] [int] NULL,
	[CustomerTypeId] [int] NULL,
	[CustomerNameEnglish] [varchar](50) NULL,
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_CustomerMast_UpdatedOn]  DEFAULT (getdate()),
	[isBillRequired] [bit] NULL,
	[isActive] [bit] NULL,
	[DeliveryCharges] [decimal](9, 2) NULL,
	[TenantID] [bigint] NULL,
 CONSTRAINT [PK_CustomerMast] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomerPayment]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerPayment](
	[CustPaymentID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerId] [bigint] NOT NULL,
	[OpBalAsOn] [datetime] NULL,
	[OpeningBalance] [decimal](18, 2) NOT NULL CONSTRAINT [DF_CustomerPayment_OpeningBalance]  DEFAULT ((0)),
	[BalanceCF] [decimal](18, 2) NULL,
	[PaidAmount] [decimal](18, 2) NOT NULL CONSTRAINT [DF_CustomerPayment_PaidAmount]  DEFAULT ((0)),
	[UnPaidAmount] [decimal](18, 2) NOT NULL CONSTRAINT [DF_CustomerPayment_OutstandingAmount]  DEFAULT ((0)),
	[BalanceDue]  AS (([OpeningBalance]+[UnPaidAmount])-[PaidAmount]) PERSISTED,
	[LastPayment] [decimal](18, 2) NULL,
	[LastPaymentDate] [datetime] NULL,
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_CustomerPayment_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_CustomerPayment] PRIMARY KEY CLUSTERED 
(
	[CustPaymentID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomerPaymentDetail]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomerPaymentDetail](
	[CustPaymentDetailID] [bigint] IDENTITY(1,1) NOT NULL,
	[CustomerId] [int] NOT NULL,
	[PreviousBalance] [decimal](18, 2) NULL CONSTRAINT [DF_CustomerPaymentDetail_PreviousBalance]  DEFAULT ((0.0)),
	[BillID] [bigint] NULL,
	[BillDate] [datetime] NULL,
	[BillAmount] [decimal](18, 2) NULL CONSTRAINT [DF_CustomerPaymentDetail_BillAmount]  DEFAULT ((0)),
	[PaymentDate] [datetime] NULL,
	[PaymentMode] [int] NULL,
	[CashAmount] [decimal](18, 2) NULL CONSTRAINT [DF_CustomerPaymentDetail_CashAmount]  DEFAULT ((0.00)),
	[ChequeAmount] [decimal](18, 2) NULL CONSTRAINT [DF_CustomerPaymentDetail_ChequeAmount]  DEFAULT ((0)),
	[ChequeNo] [varchar](15) NULL,
	[Amount]  AS (isnull([CashAmount]+[ChequeAmount],(0))) PERSISTED NOT NULL,
	[BalanceDue]  AS ((isnull([BillAmount],(0))+isnull([PreviousBalance],(0)))-(isnull([CashAmount],(0))+isnull([ChequeAmount],(0)))),
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_CustomerPaymentDetail_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_CustomerPaymentDetail] PRIMARY KEY CLUSTERED 
(
	[CustPaymentDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomerRates]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerRates](
	[CustRateID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Rate] [money] NOT NULL CONSTRAINT [DF_CustomerRates_Rate]  DEFAULT ((0)),
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_CustomerRates_LastUpdatedDate]  DEFAULT (getdate()),
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
 CONSTRAINT [PK_CustomerRates] PRIMARY KEY CLUSTERED 
(
	[CustRateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[CustomerType]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CustomerType](
	[CustomerTypeId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerType] [nvarchar](50) NULL,
	[Sequence] [int] NULL,
	[LastUpdatedDate] [datetime] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmployeeMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeMast](
	[EmployeeID] [int] NOT NULL,
	[EmployeeName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](350) NOT NULL,
	[AreaID] [int] NULL,
	[Mobile] [nvarchar](50) NOT NULL,
	[UserId] [bigint] NULL,
 CONSTRAINT [PK_EmployeeMast] PRIMARY KEY CLUSTERED 
(
	[EmployeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[login]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[login](
	[userid] [int] IDENTITY(1,1) NOT NULL,
	[username] [varchar](50) NULL,
	[password] [varchar](50) NULL,
 CONSTRAINT [PK_login] PRIMARY KEY CLUSTERED 
(
	[userid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OutStandingMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OutStandingMast](
	[OutStandingID] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [int] NOT NULL,
	[TotalOutStandingAmt] [decimal](18, 2) NOT NULL,
	[LastPaymentDate] [datetime] NULL,
	[LastPayment] [decimal](18, 2) NULL,
 CONSTRAINT [PK_OutStandingMast] PRIMARY KEY CLUSTERED 
(
	[OutStandingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Product]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Product](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Product] [varchar](50) NOT NULL,
	[ProductBrandID] [int] NULL,
	[isActive] [bit] NULL,
 CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductBrandMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductBrandMast](
	[ProductBrandID] [int] IDENTITY(1,1) NOT NULL,
	[BrandName] [varchar](50) NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreatedBy] [int] NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [int] NULL,
 CONSTRAINT [PK_ProductBrandMast] PRIMARY KEY CLUSTERED 
(
	[ProductBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductMapping]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ProductMapping](
	[MapId] [int] IDENTITY(1,1) NOT NULL,
	[CustomerTenantId] [bigint] NULL,
	[SupplierTenantId] [bigint] NULL,
	[CustomerDBNme] [nvarchar](150) NULL,
	[SupplierDBName] [nvarchar](150) NULL,
	[CustomerProductID] [bigint] NULL,
	[SupplierProductID] [bigint] NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ProductMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductMast](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Product] [nvarchar](50) NULL,
	[ProductBrandID] [int] NULL,
	[PurchasePrice] [decimal](18, 2) NULL CONSTRAINT [DF_ProductMast_ReorderLevel]  DEFAULT ((0)),
	[SalePrice] [decimal](18, 2) NULL,
	[StockCount] [int] NULL CONSTRAINT [DF_ProductMast_StockCount]  DEFAULT ((0)),
	[CreateDate] [datetime] NOT NULL CONSTRAINT [DF_ProductMast_CreateDate]  DEFAULT (getdate()),
	[CreatedBy] [int] NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [int] NULL,
	[isActive] [bit] NULL CONSTRAINT [DF_ProductMast_isActive]  DEFAULT ((1)),
	[CrateSize] [int] NULL,
	[GST] [decimal](9, 2) NULL,
	[GlobalID] [varchar](12) NULL,
 CONSTRAINT [PK_ProductMast] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ProductMastNew]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ProductMastNew](
	[ProductID] [int] IDENTITY(1,1) NOT NULL,
	[Product] [varchar](50) NULL,
	[ProductBrandID] [int] NULL,
	[PurchasePrice] [decimal](18, 2) NULL,
	[SalePrice] [decimal](18, 2) NULL,
	[StockCount] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreatedBy] [int] NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [int] NULL,
	[isActive] [bit] NULL,
	[CrateSize] [int] NULL,
 CONSTRAINT [PK_ProductMastNew] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Purchase]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Purchase](
	[PurchaseId] [bigint] IDENTITY(1,1) NOT NULL,
	[BillId] [int] NULL,
	[BillDate] [datetime] NOT NULL,
	[VendorId] [bigint] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductRate] [decimal](18, 2) NOT NULL,
	[Quantity] [decimal](18, 2) NOT NULL,
	[Amount]  AS ([ProductRate]*[Quantity]),
	[PaidAmount] [decimal](18, 0) NULL,
	[BalanceDue] [decimal](18, 0) NULL,
	[PreviousBalance] [decimal](18, 2) NULL,
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_Purchase_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Purchase] PRIMARY KEY CLUSTERED 
(
	[PurchaseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SupplierPaymentDetail]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SupplierPaymentDetail](
	[SupplierPaymentDetailID] [bigint] IDENTITY(1,1) NOT NULL,
	[SupplierId] [int] NOT NULL,
	[PreviousBalance] [decimal](18, 2) NULL,
	[BillID] [bigint] NULL,
	[BillDate] [datetime] NULL,
	[BillAmount] [decimal](18, 2) NULL,
	[PaymentDate] [datetime] NULL,
	[PaymentMode] [int] NULL,
	[CashAmount] [decimal](18, 2) NULL,
	[ChequeAmount] [decimal](18, 2) NULL,
	[ChequeNo] [varchar](15) NULL,
	[Amount]  AS (isnull([CashAmount]+[ChequeAmount],(0))) PERSISTED NOT NULL,
	[BalanceDue]  AS (((isnull([BillAmount],(0))+isnull([PreviousBalance],(0)))-isnull([ChequeAmount],(0)))-isnull([CashAmount],(0))),
	[LastUpdatedDate] [datetime] NULL,
 CONSTRAINT [PK_SupplierPaymentDetail] PRIMARY KEY CLUSTERED 
(
	[SupplierPaymentDetailID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[SupplierRateHistory]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SupplierRateHistory](
	[ProductID] [int] NOT NULL,
	[StartDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[ListPrice] [money] NOT NULL,
	[ModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_SupplierRateHistory_ProductID_StartDate] PRIMARY KEY CLUSTERED 
(
	[ProductID] ASC,
	[StartDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SyncDetail]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SyncDetail](
	[SyncDetailId] [int] NOT NULL,
	[SyncObjectId] [int] NOT NULL,
	[RecordNo] [bigint] NULL,
 CONSTRAINT [PK_SyncDetail] PRIMARY KEY CLUSTERED 
(
	[SyncDetailId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SyncObject]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SyncObject](
	[SyncObjectId] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](25) NOT NULL,
	[SyncDate] [date] NULL,
	[isSync] [bit] NULL,
 CONSTRAINT [PK_SyncObject] PRIMARY KEY CLUSTERED 
(
	[SyncObjectId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[UserMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserMast](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Fname] [varchar](50) NOT NULL,
	[Lname] [varchar](50) NOT NULL,
	[UserName] [varchar](50) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[UserTypeID] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[TenantId] [int] NULL,
	[IsAdmin] [bit] NOT NULL,
 CONSTRAINT [PK_UserMast] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [bigint] IDENTITY(1,1) NOT NULL,
	[TenantID] [bigint] NULL,
	[Name] [varchar](30) NOT NULL,
	[MobileNo] [varchar](12) NOT NULL,
	[UserName] [varchar](10) NULL,
	[Password] [varchar](10) NULL,
	[DeviceID] [varchar](50) NULL,
	[UserTypeID] [int] NULL,
	[isActive] [bit] NULL,
	[isApproved] [bit] NULL,
	[ApprovedDate] [datetime] NULL,
	[isDeleted] [bit] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VehicleMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VehicleMast](
	[VechicleID] [int] IDENTITY(1,1) NOT NULL,
	[Transport] [varchar](50) NULL,
	[Owner] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[Mobile] [varchar](50) NULL,
	[VechicleNo] [varchar](15) NULL,
	[Marathi] [varchar](100) NULL,
	[RatePerTrip] [decimal](18, 2) NULL,
	[PrintOrder] [int] NULL,
 CONSTRAINT [PK_VehicleMast] PRIMARY KEY CLUSTERED 
(
	[VechicleID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VendorLikages]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorLikages](
	[VendorLikageID] [int] IDENTITY(1,1) NOT NULL,
	[BillId] [int] NULL,
	[BillDate] [datetime] NULL,
	[VendorID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[Likage] [decimal](18, 2) NOT NULL CONSTRAINT [DF_VendorLikages_Likage]  DEFAULT ((0)),
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_VendorLikages_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_VendorLikages] PRIMARY KEY CLUSTERED 
(
	[VendorLikageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[VendorMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VendorMast](
	[VendorID] [int] IDENTITY(1,1) NOT NULL,
	[VendorName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](250) NOT NULL,
	[AreaID] [int] NULL,
	[CityID] [int] NOT NULL,
	[EmailID] [nvarchar](50) NULL,
	[OfficePhone] [nvarchar](50) NULL,
	[FaxNo] [nvarchar](50) NULL,
	[ContactPerson] [nvarchar](50) NULL,
	[PersonMobileNo] [varchar](20) NULL,
	[IsActive] [bit] NULL CONSTRAINT [DF_VendorMast_IsActive]  DEFAULT ((1)),
	[CreatedBy] [int] NULL,
	[CreateDate] [datetime] NULL CONSTRAINT [DF_VendorMast_CreateDate_1]  DEFAULT (getdate()),
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_VendorMast_LastUpdatedDate]  DEFAULT (getdate()),
	[LastUpdatedBy] [int] NULL,
	[TenantID] [bigint] NULL,
 CONSTRAINT [PK_VendorMast] PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VendorMastNew]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[VendorMastNew](
	[VendorID] [int] IDENTITY(1,1) NOT NULL,
	[VendorName] [varchar](50) NULL,
	[Address] [nvarchar](250) NULL,
	[AreaID] [int] NULL,
	[CityID] [int] NULL,
	[EmailID] [nvarchar](50) NULL,
	[OfficePhone] [nvarchar](50) NULL,
	[FaxNo] [nvarchar](50) NULL,
	[ContactPerson] [varchar](50) NULL,
	[PersonMobileNo] [varchar](20) NULL,
	[IsActive] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreateDate] [datetime] NULL,
	[LastUpdatedDate] [datetime] NULL,
	[LastUpdatedBy] [int] NULL,
 CONSTRAINT [PK_VendorMastNew] PRIMARY KEY CLUSTERED 
(
	[VendorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[VendorProducts]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VendorProducts](
	[VendorProductID] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [int] NOT NULL,
	[ProductId] [int] NOT NULL,
	[Rate] [decimal](8, 2) NULL CONSTRAINT [DF_VendorProducts_Rate]  DEFAULT ((0)),
	[LastUpdatedDate] [datetime] NULL CONSTRAINT [DF_VendorProducts_LastUpdatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_VendorProducts] PRIMARY KEY CLUSTERED 
(
	[VendorProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  UserDefinedFunction [dbo].[udfGetProductRateForCustomer]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[udfGetProductRateForCustomer]
(
@CustomerID int,
@ProductId Int,
@OrderDate date
)
RETURNS Table
AS 
RETURN 
(
Select CustomerId, ProductId , Rate from CustomerRates where CustomerID = @CustomerID and ProductID =@ProductId
and @OrderDate between StartDate and EndDate
)




GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [Unx_Product_Brand]    Script Date: 12-04-2019 15:31:35 ******/
CREATE UNIQUE NONCLUSTERED INDEX [Unx_Product_Brand] ON [dbo].[ProductMast]
(
	[Product] ASC,
	[ProductBrandID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CustomerLikages] ADD  CONSTRAINT [DF_CustomerLikages_Likage]  DEFAULT ((0)) FOR [Likage]
GO
ALTER TABLE [dbo].[CustomerLikages] ADD  CONSTRAINT [DF_CustomerLikages_LastUpdatedDate]  DEFAULT (getdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[CustomerType] ADD  CONSTRAINT [DF_CustomerType_LastUpdatedDate]  DEFAULT (getdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[OutStandingMast] ADD  CONSTRAINT [DF_OutStandingMast_TotalOutStandingAmt]  DEFAULT ((0.00)) FOR [TotalOutStandingAmt]
GO
ALTER TABLE [dbo].[Product] ADD  CONSTRAINT [DF_Product_isActive]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[ProductBrandMast] ADD  CONSTRAINT [DF_ProductBrandMast_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[ProductBrandMast] ADD  CONSTRAINT [DF_ProductBrandMast_LastUpdatedDate]  DEFAULT (getdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[ProductMastNew] ADD  CONSTRAINT [DF_ProductMastNew_ReorderLevel]  DEFAULT ((0)) FOR [PurchasePrice]
GO
ALTER TABLE [dbo].[ProductMastNew] ADD  CONSTRAINT [DF_ProductMastNew_StockCount]  DEFAULT ((0)) FOR [StockCount]
GO
ALTER TABLE [dbo].[ProductMastNew] ADD  CONSTRAINT [DF_ProductMastNew_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[ProductMastNew] ADD  CONSTRAINT [DF_ProductMastNew_isActive]  DEFAULT ((1)) FOR [isActive]
GO
ALTER TABLE [dbo].[SupplierRateHistory] ADD  CONSTRAINT [DF_SupplierRateHistory_ModifiedDate]  DEFAULT (getdate()) FOR [ModifiedDate]
GO
ALTER TABLE [dbo].[SyncObject] ADD  CONSTRAINT [DF_SyncObject_isSync]  DEFAULT ((0)) FOR [isSync]
GO
ALTER TABLE [dbo].[UserMast] ADD  CONSTRAINT [DF_UserMast_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_isActive]  DEFAULT ((0)) FOR [isActive]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_isApproved]  DEFAULT ((0)) FOR [isApproved]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_isDeleted]  DEFAULT ((0)) FOR [isDeleted]
GO
ALTER TABLE [dbo].[VendorMastNew] ADD  CONSTRAINT [DF_VendorMastNew_IsActive]  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [dbo].[VendorMastNew] ADD  CONSTRAINT [DF_VendorMastNew_CreateDate_1]  DEFAULT (getdate()) FOR [CreateDate]
GO
ALTER TABLE [dbo].[VendorMastNew] ADD  CONSTRAINT [DF_VendorMastNew_LastUpdatedDate]  DEFAULT (getdate()) FOR [LastUpdatedDate]
GO
ALTER TABLE [dbo].[SupplierRateHistory]  WITH CHECK ADD  CONSTRAINT [FK_SupplierRateHistory_Product_ProductID] FOREIGN KEY([ProductID])
REFERENCES [dbo].[Product] ([ProductID])
GO
ALTER TABLE [dbo].[SupplierRateHistory] CHECK CONSTRAINT [FK_SupplierRateHistory_Product_ProductID]
GO
ALTER TABLE [dbo].[SupplierRateHistory]  WITH CHECK ADD  CONSTRAINT [CK_SupplierRateHistory_EndDate] CHECK  (([EndDate]>=[StartDate] OR [EndDate] IS NULL))
GO
ALTER TABLE [dbo].[SupplierRateHistory] CHECK CONSTRAINT [CK_SupplierRateHistory_EndDate]
GO
ALTER TABLE [dbo].[SupplierRateHistory]  WITH CHECK ADD  CONSTRAINT [CK_SupplierRateHistory_ListPrice] CHECK  (([ListPrice]>(0.00)))
GO
ALTER TABLE [dbo].[SupplierRateHistory] CHECK CONSTRAINT [CK_SupplierRateHistory_ListPrice]
GO
/****** Object:  StoredProcedure [dbo].[addCustomerRates]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[addCustomerRates]
     
    
    
AS
BEGIN
SELECT        dbo.CustomerMast.CustomerName, dbo.CustomerMast.AreaID, dbo.ProductMast.Product, dbo.CustomerRates.Rate
FROM            dbo.ProductMast INNER JOIN
                         dbo.CustomerRates ON dbo.ProductMast.ProductID = dbo.CustomerRates.CustRateID RIGHT OUTER JOIN
                         dbo.CustomerMast ON dbo.CustomerRates.CustomerID = dbo.CustomerMast.CustomerID
END




GO
/****** Object:  StoredProcedure [dbo].[AutoGenerate_GRNNo]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AutoGenerate_GRNNo] 
	
AS
BEGIN

	SET NOCOUNT ON;

SELECT   top 1 GRN_No+1 as GRN_No
FROM         Spare_GRNMast
ORDER BY GRN_ID DESC
END




GO
/****** Object:  StoredProcedure [dbo].[AutoGeneratePONo]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AutoGeneratePONo] 
	
AS
BEGIN

	SET NOCOUNT ON;

SELECT   top 1 PoNumber+1 as PoNumber
FROM         Spare_PurchaseOrderMast
ORDER BY PoID DESC
END




GO
/****** Object:  StoredProcedure [dbo].[AutoGenerateReceiptNo]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[AutoGenerateReceiptNo] 
	
AS
BEGIN

	SET NOCOUNT ON;
SELECT     TOP (1) VoucherNo + 1 AS VoucherNo
FROM         Receipt
order by ReceiptID desc
END




GO
/****** Object:  StoredProcedure [dbo].[Bank_GetAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Bank_GetAll] 
AS
Select 
[BankID],
[BankName],
[Branch],
[OwnBank],
[AccNo],
[opBal]

from 
Bank
Return




GO
/****** Object:  StoredProcedure [dbo].[CustomerListCopy]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[CustomerListCopy] 
 
AS
BEGIN

	SELECT      C.CustomerID as [Sr_No],  C.CustomerName, A.Area as [Area]
	FROM            CustomerMast C LEFT OUTER JOIN
                         CustomerPaymentDetail CPD ON C.CustomerID = CPD.CustomerId LEFT OUTER JOIN
                         AreaMast A ON C.AreaID = A.AreaID
						 WHERE        (CPD.BillID = 1)
END




GO
/****** Object:  StoredProcedure [dbo].[CustomerRateCopy]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- exec [CustomerRateCopy] 1,6,98,''
-- =============================================
CREATE PROCEDURE [dbo].[CustomerRateCopy] 
 @CustomerId int,
 @ProductId int,
 @CheckCustomerID int,
 @pdate date
AS
BEGIN
declare @temprate int;
set @temprate = (select top 1 Rate from CustomerRates where CustomerID=@CustomerId and ProductId=@ProductId);

IF EXISTS (SELECT 'True' FROM CustomerRates WHERE CustomerId=@CheckCustomerID and ProductId=@ProductId) 
BEGIN
 update CustomerRates set Rate = @temprate
 where CustomerId=@CheckCustomerID and ProductId=@ProductId 
END

ELSE

BEGIN
insert into CustomerRates(CustomerId,ProductId,Rate,lastupdateddate,startdate) 
values (@CheckCustomerID,@ProductId,@temprate,getdate(),@pdate)

END



END


--select * from CustomerRates




GO
/****** Object:  StoredProcedure [dbo].[CustomersRate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[CustomersRate] 
@pName nvarchar(50) =''
    
as 
begin
--Declare @Product varchar(max)  ,@query  AS NVARCHAR(MAX)

--Select @Product= Coalesce(@Product + ',', '') + Ltrim(Product) From ProductMast  
 
-- print @Product

DECLARE @cols AS nvarchar(MAX),
@query  AS NVARCHAR(MAX)
Declare @search nvarchar(50)

SELECT @cols = STUFF((SELECT distinct ',' + QUOTENAME(cast(c.product as nvarchar)) 
            FROM ProductMast c
            FOR XML PATH(''), TYPE
            ).value('.', 'nvarchar(MAX)') 
        ,1,1,'')       
		SET @search = '''%' + @pName + '%'''
SELECT @query ='SELECT  *
FROM    ( 
	   SELECT DISTINCT dbo.CustomerMast.CustomerName, dbo.AreaMast.Area, dbo.CustomerRates.Rate, dbo.ProductMast.Product
FROM            dbo.ProductMast LEFT OUTER JOIN
                         dbo.CustomerRates ON dbo.ProductMast.ProductID = dbo.CustomerRates.ProductID RIGHT OUTER JOIN
                         dbo.CustomerMast ON dbo.CustomerRates.CustomerID = dbo.CustomerMast.CustomerID LEFT OUTER JOIN
                         dbo.AreaMast ON dbo.CustomerMast.AreaID = dbo.AreaMast.AreaID
						 where
	
    (dbo.CustomerMast.CustomerName LIKE  '+ @search +' or '''+ CAST((@pName) AS nvarchar) +''' = '''' )
        )a
      
PIVOT   (SUM(Rate) FOR Product IN ('+ @cols +')) md'

execute(@query)
end

GO
/****** Object:  StoredProcedure [dbo].[DashBoard_Outstanding_Customer]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Delete Procedure for ProductTypeMast
-- Exec [dbo].[UC_DeleteProductTypeMast] @ProductTypeID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[DashBoard_Outstanding_Customer]

    
AS
BEGIN


BEGIN TRY

--SELECT     (CustomerMast.Lname)as fullname, AreaMast.Area, CityMast.CityName, sum(SpareInvoiceMast.BalanceAmt)as OutstandingAmt
--FROM         CustomerMast INNER JOIN
--                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID INNER JOIN
--                      CityMast ON CustomerMast.CityID = CityMast.CityID AND AreaMast.CityID = CityMast.CityID INNER JOIN
--                      SpareInvoiceMast ON CustomerMast.CustomerID = SpareInvoiceMast.CustomerID
--
--where SpareInvoiceMast.BalanceAmt>0
--group by  CustomerMast.Lname, AreaMast.Area, CityMast.CityName


SELECT     CustomerMast.Lname AS fullname, AreaMast.Area, CityMast.CityName, OutStandingMast.TotalOutStandingAmt as OutstandingAmt
FROM         CustomerMast INNER JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID INNER JOIN
                      CityMast ON CustomerMast.CityID = CityMast.CityID INNER JOIN
                      OutStandingMast ON CustomerMast.CustomerID = OutStandingMast.CustomerID
GROUP BY CustomerMast.Lname, AreaMast.Area, CityMast.CityName, OutStandingMast.TotalOutStandingAmt

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[DashBoard_Outstanding_Dealer]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DashBoard_Outstanding_Dealer]
   
AS
BEGIN

BEGIN TRY

SELECT     DealerMast.DealerID, DealerMast.DealerName, SUM(OutStandingMast.TotalOutStandingAmt) AS TotalOutstanding, AreaMast.Area, CityMast.CityName
                     
FROM         OutStandingMast INNER JOIN
                      GatePassMast ON OutStandingMast.GatePassID = GatePassMast.GatePassID INNER JOIN
                      DealerMast ON GatePassMast.OwnerID = DealerMast.DealerID INNER JOIN
                      AreaMast ON DealerMast.AreaID = AreaMast.AreaID INNER JOIN
                      CityMast ON DealerMast.CityID = CityMast.CityID
WHERE     (OutStandingMast.IsPaid = 0) and GatePassMast.OwnerType='d'
GROUP BY DealerMast.DealerID, DealerMast.DealerName, AreaMast.Area, CityMast.CityName, GatePassMast.OwnerType
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[DashBoard_Outstanding_SalesPerson]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DashBoard_Outstanding_SalesPerson]

    
AS
BEGIN


BEGIN TRY

SELECT     (EmployeeMast.Fname+' '+EmployeeMast.Mname+' '+ EmployeeMast.Lname)as fullname, CityMast.CityName, AreaMast.Area, 
                      isnull(sum(SpareGatePassMast.TotalOutStandingAmt),0.00)as OutstandingAmt
FROM         EmpUserTypeMast INNER JOIN
                      EmployeeMast ON EmpUserTypeMast.EmpUsrTypeID = EmployeeMast.EmpUsrTypeID left outer JOIN
                      SpareGatePassMast ON EmployeeMast.EmployeeID = SpareGatePassMast.ServicePersonID INNER JOIN
                      AreaMast ON EmployeeMast.AreaID = AreaMast.AreaID INNER JOIN
                      CityMast ON EmployeeMast.CityID = CityMast.CityID AND AreaMast.CityID = CityMast.CityID
where SpareGatePassMast.TotalOutStandingAmt!=0
group by EmployeeMast.Fname,EmployeeMast.Mname,EmployeeMast.Lname,CityMast.CityName, AreaMast.Area



END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[DashBoard_Outstanding_SalesPerson_By_SalesPersonID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Delete Procedure for ProductTypeMast
-- Exec [dbo].[UC_DeleteProductTypeMast] @ProductTypeID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[DashBoard_Outstanding_SalesPerson_By_SalesPersonID]
@ServicePersonID int
    
AS
BEGIN


BEGIN TRY

SELECT     CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS custname, SpareInvoiceMast.InvoiceNumber, 
                      SpareInvoiceMast.BalanceAmt, SpareInvoiceMast.OwnerID
FROM         CustomerMast INNER JOIN
                      SpareInvoiceMast ON CustomerMast.CustomerID = SpareInvoiceMast.CustomerID INNER JOIN
                      SpareGatePassMast INNER JOIN
                      SpareGatePassDtls ON SpareGatePassMast.GatePassID = SpareGatePassDtls.GatePassID ON 
                      SpareInvoiceMast.OwnerID = SpareGatePassMast.ServicePersonID


where SpareInvoiceMast.OwnerID=@ServicePersonID and SpareInvoiceMast.BalanceAmt>0
GROUP BY CustomerMast.Fname, CustomerMast.Mname, CustomerMast.Lname, SpareInvoiceMast.InvoiceNumber, SpareInvoiceMast.BalanceAmt, 
                      SpareInvoiceMast.OwnerID


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[DashBoard_ProductChart_By_ProductTypeID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Delete Procedure for ProductTypeMast
-- Exec [dbo].[UC_DeleteProductTypeMast] @ProductTypeID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[DashBoard_ProductChart_By_ProductTypeID]

    
AS
BEGIN


BEGIN TRY

/*, SpareInvoiceDtls.Quantity*/
--SELECT DISTINCT ProductMast.Product, ProductBrandMast.BrandName, SUM(SpareInvoiceDtls.Quantity) AS Pcount
--FROM         ProductBrandMast INNER JOIN
--                      ProductMast ON ProductBrandMast.ProductBrandID = ProductMast.ProductBrandID INNER JOIN
--                      SpareInvoiceDtls ON ProductMast.ProductID = SpareInvoiceDtls.ProductID
--GROUP BY ProductMast.Product, ProductBrandMast.BrandName
SELECT DISTINCT ProductMast.Product, ProductBrandMast.BrandName, SUM(CustomerBillDetails.Quantity)AS Pcount
FROM         ProductBrandMast INNER JOIN
                      ProductMast ON ProductBrandMast.ProductBrandID = ProductMast.ProductBrandID INNER JOIN
                      CustomerBillDetails ON ProductMast.ProductID = CustomerBillDetails.ProductID
GROUP BY ProductMast.Product, ProductBrandMast.BrandName, CustomerBillDetails.Quantity

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[DashBoard_Sale_Monthly]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Vinod Sabade
-- Create date : 
-- Description : 
-- Exec DashBoard_Sale_Monthly
    
-- ============================================= */
CREATE PROCEDURE [dbo].[DashBoard_Sale_Monthly]

    
AS
BEGIN


BEGIN TRY

Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'Jan' as Month,1 as MonthOrder
from CustomerPaymentDetail  where month(CustomerPaymentDetail.BillDate)=1 
and year(CustomerPaymentDetail.BillDate)=year(getdate())
union 
Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'Feb' as Month,2 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=2 
and year(CustomerPaymentDetail.BillDate)=year(getdate()) union
Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'March' as Month,3 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=3 
and year(CustomerPaymentDetail.BillDate)=year(getdate()) union
Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'Apr' as Month,4 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=4 
and year(CustomerPaymentDetail.BillDate)=year(getdate()) union
Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'May' as Month,5 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=5 
and year(CustomerPaymentDetail.BillDate)=year(getdate()) union
Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'Jun' as Month, 6 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=6 
and year(CustomerPaymentDetail.BillDate)=year(getdate()) union
Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'Jul' as Month ,7 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=7 
and year(CustomerPaymentDetail.BillDate)=year(getdate()) union
Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'Aug' as Month,8 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=8 
and year(CustomerPaymentDetail.BillDate)=year(getdate())

 union

Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'Sept' as Month, 9 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=9
and year(CustomerPaymentDetail.BillDate)=year(getdate())



 union

Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'Oct' as Month,10 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=10 
and year(CustomerPaymentDetail.BillDate)=year(getdate()) union
Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'Nov' as Month,11 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=11 
and year(CustomerPaymentDetail.BillDate)=year(getdate()) union

Select isnull(SUM(CustomerPaymentDetail.BillAmount),0.00) as Total,'Dec' as Month,12 as MonthOrder
from CustomerPaymentDetail where month(CustomerPaymentDetail.BillDate)=12 
and year(CustomerPaymentDetail.BillDate)=year(getdate())

order by MonthOrder asc
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END





GO
/****** Object:  StoredProcedure [dbo].[DashBoard_Sale_Quaterly]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Delete Procedure for ProductTypeMast
-- Exec [dbo].[UC_DeleteProductTypeMast] @ProductTypeID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[DashBoard_Sale_Quaterly]

    
AS
BEGIN


BEGIN TRY
Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,'Jan - March' as Month,1 as MonthOrder
from RecieptMast RecieptMast where month(RecieptMast.RecieptDate)=1 or month(RecieptMast.RecieptDate)=2 or  month(RecieptMast.RecieptDate)=3
and year(RecieptMast.RecieptDate)=year(getdate())
union 
Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,'Apr - June' as Month,2 as MonthOrder
from RecieptMast RecieptMast where month(RecieptMast.RecieptDate)=4 or month(RecieptMast.RecieptDate)=5 or  month(RecieptMast.RecieptDate)=6
and year(RecieptMast.RecieptDate)=year(getdate())
union 
Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,'Jul - Sept' as Month,3 as MonthOrder
from RecieptMast RecieptMast where month(RecieptMast.RecieptDate)=7 or month(RecieptMast.RecieptDate)=8 or  month(RecieptMast.RecieptDate)=9
and year(RecieptMast.RecieptDate)=year(getdate())
union 
Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,'Oct - Dec' as Month,4 as MonthOrder
from RecieptMast RecieptMast where month(RecieptMast.RecieptDate)=10 or month(RecieptMast.RecieptDate)=11 or  month(RecieptMast.RecieptDate)=12
and year(RecieptMast.RecieptDate)=year(getdate())
order by MonthOrder asc


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[DashBoard_Sale_Yearly]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Delete Procedure for ProductTypeMast
-- Exec [dbo].[UC_DeleteProductTypeMast] @ProductTypeID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[DashBoard_Sale_Yearly]

    
AS
BEGIN


BEGIN TRY


Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,year(getdate())-9  as SaleYear,2 as YearOrder
from RecieptMast RecieptMast where year(RecieptMast.RecieptDate)=year(getdate())-9 
union
Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,year(getdate())-8 as SaleYear,3 as YearOrder
from RecieptMast RecieptMast where year(RecieptMast.RecieptDate)=year(getdate())-8
 union
Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,year(getdate())-7 as SaleYear,4 as YearOrder
from RecieptMast RecieptMast where year(RecieptMast.RecieptDate)=year(getdate())-7
 union
Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,year(getdate())-6 as SaleYear,5 as YearOrder
from RecieptMast RecieptMast where year(RecieptMast.RecieptDate)=year(getdate())-6
 union
Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,year(getdate())-5 as SaleYear, 6 as YearOrder
from RecieptMast RecieptMast where year(RecieptMast.RecieptDate)=year(getdate())-5
 union
Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,year(getdate())-4 as Month ,7 as YearOrder
from RecieptMast RecieptMast where year(RecieptMast.RecieptDate)=year(getdate())-4
 union
Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,year(getdate())-3
 as SaleYear,8 as YearOrder
from RecieptMast RecieptMast where year(RecieptMast.RecieptDate)=year(getdate())-3

 union

Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,year(getdate())-2 as SaleYear, 9 as YearOrder
from RecieptMast RecieptMast where year(RecieptMast.RecieptDate)=year(getdate())-2



 union

Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,year(getdate())-1 as SaleYear,10 as YearOrder
from RecieptMast RecieptMast where year(RecieptMast.RecieptDate)=year(getdate())-1
union

Select isnull(SUM(RecieptMast.TotalAmt),0.00) as Total,year(getdate()) as SaleYear,11 as YearOrder
from RecieptMast RecieptMast where year(RecieptMast.RecieptDate)=year(getdate())

order by YearOrder


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[DashBoard_StockDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Delete Procedure for ProductTypeMast
-- Exec [dbo].[UC_DeleteProductTypeMast] @ProductTypeID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[DashBoard_StockDetails]

    
AS
BEGIN


BEGIN TRY

SELECT     Spare_StockMast.ProductID, ProductMast.Product, ProductBrandMast.BrandName, Spare_StockMast.Quantity
FROM         Spare_StockMast INNER JOIN
                      ProductMast ON Spare_StockMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID
GROUP BY Spare_StockMast.ProductID, ProductMast.Product, ProductBrandMast.BrandName, Spare_StockMast.Quantity
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[GetAreaList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetAreaList] 
	@pPageIndex INT=1,
	@pPageSize INT=5,
	@aname nvarchar(50) = null
    
	AS
	BEGIN
	declare @count int =0
	declare @start_p int=1  
    set @start_p=(((@pPageIndex-1)*@pPageSize))

SELECT        AreaID,Area,CityID
	into #Job_CTE 
    FROM        AreaMast
	where
	Area like '%'+@aname+'%' OR @aname IS NULL OR @aname=''
	select @count=count(1) from  #Job_CTE  
	select @count As TotalRows,* from #Job_CTE  
	order by AreaID desc 
	OFFSET @start_p ROWS FETCH NEXT @pPageSize ROWS ONLY

	select @count

	END

GO
/****** Object:  StoredProcedure [dbo].[GetCustomerList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetCustomerList] 
	@pPageIndex INT=1,
	@pPageSize INT=5,
	@pName Varchar(Max)='',
	@area int=0
    
	AS
	BEGIN
	declare @count int =0
	declare @start_p int=1  
    set @start_p=(((@pPageIndex-1)*@pPageSize))
SELECT        dbo.CustomerMast.CustomerID, dbo.CustomerMast.CustomerName, dbo.CustomerMast.Address, dbo.CustomerMast.Mobile, dbo.CustomerMast.AreaID, dbo.CustomerMast.CustomerTypeId, 
                         dbo.CustomerMast.CustomerNameEnglish, dbo.CustomerMast.LastUpdatedDate,isnull(dbo.CustomerMast.isBillRequired,0) as isBillRequired, isnull(dbo.CustomerMast.isActive,1) as isActive, dbo.CustomerMast.DeliveryCharges, dbo.AreaMast.Area, 
                         dbo.EmployeeMast.EmployeeName, dbo.VehicleMast.VechicleNo, dbo.CustomerMast.VehicleID, dbo.CustomerMast.SalesPersonID
						 

into #Job_CTE 
    FROM            dbo.VehicleMast RIGHT OUTER JOIN
                         dbo.CustomerMast LEFT OUTER JOIN
                         dbo.AreaMast ON dbo.CustomerMast.AreaID = dbo.AreaMast.AreaID LEFT OUTER JOIN
                         dbo.EmployeeMast ON dbo.CustomerMast.SalesPersonID = dbo.EmployeeMast.EmployeeID ON dbo.VehicleMast.VechicleID = dbo.CustomerMast.VehicleID
						  WHERE    

		 (dbo.CustomerMast.CustomerName like '%'+@pName+'%' OR @pName IS NULL OR @pName='') and (dbo.AreaMast.AreaID=@area or @area=0)
	
     select @count=count(1) from  #Job_CTE  
	select @count As TotalRows,* from #Job_CTE  
	order by CustomerID desc 
	OFFSET @start_p ROWS FETCH NEXT @pPageSize ROWS ONLY

	select @count

	END
GO
/****** Object:  StoredProcedure [dbo].[GetEmployeeList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetEmployeeList] 
	@pPageIndex INT=1,
	@pPageSize INT=5,
	@pName Varchar(Max)=''
    
	AS
	BEGIN
	declare @count int =0
	declare @start_p int=1  
    set @start_p=(((@pPageIndex-1)*@pPageSize))
SELECT        dbo.EmployeeMast.EmployeeID, dbo.EmployeeMast.EmployeeName, dbo.EmployeeMast.Address, dbo.EmployeeMast.Mobile, dbo.EmployeeMast.UserId, dbo.EmployeeMast.AreaID,isnull(dbo.AreaMast.Area,'')as Area

into #Job_CTE 
   FROM            dbo.EmployeeMast inner JOIN
                         dbo.AreaMast ON dbo.EmployeeMast.AreaID = dbo.AreaMast.AreaID
						 WHERE    

		 (dbo.EmployeeMast.EmployeeName like '%'+@pName+'%' OR @pName IS NULL OR @pName='') 
	
    select @count=count(1) from  #Job_CTE  
	select @count As TotalRows,* from #Job_CTE  
	order by EmployeeID desc 
		 
	OFFSET @start_p ROWS FETCH NEXT @pPageSize ROWS ONLY

	select @count

	END

GO
/****** Object:  StoredProcedure [dbo].[GetProductList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- select * from tblProduct
--exec GetAreaList 1,10
CREATE Proc [dbo].[GetProductList]
	@pPageIndex INT=1,
	@pPageSize INT=5,
	@pname nvarchar(50) =null
    
	AS
	BEGIN
	declare @count int =0
	declare @start_p int=1  
    set @start_p=(((@pPageIndex-1)*@pPageSize))

SELECT        ProductID,Product,ProductBrandID,CrateSize,GST
	into #Job_CTE 
    FROM        ProductMast
	where
	Product like '%'+@pName+'%' OR @pName IS NULL OR @pName=''
	
	select @count=count(1) from  #Job_CTE  
	select @count As TotalRows,* from #Job_CTE  
	order by ProductID desc 
	OFFSET @start_p ROWS FETCH NEXT @pPageSize ROWS ONLY

	select @count

	END

GO
/****** Object:  StoredProcedure [dbo].[GetSupplierList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- select * from tblProduct
--exec [GetSupplierList] 1,10,'t'
CREATE Proc [dbo].[GetSupplierList]
	@pPageIndex INT=1,
	@pPageSize INT=5,
	@sname nvarchar(50) =null
    
	AS
	BEGIN
	declare @count int =0
	declare @start_p int=1  
    set @start_p=(((@pPageIndex-1)*@pPageSize))

SELECT VendorID,VendorName,ContactPerson,PersonMobileNo,EmailID,IsActive 
	into #Job_CTE 
    FROM        VendorMast
	where
	VendorName like '%'+@sname+'%' OR @sname IS NULL OR @sname=''

	select @count=count(1) from  #Job_CTE  
	select @count As TotalRows,* from #Job_CTE  
	order by VendorID desc 
	OFFSET @start_p ROWS FETCH NEXT @pPageSize ROWS ONLY

	select @count

	END
	

GO
/****** Object:  StoredProcedure [dbo].[GetVehicalList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[GetVehicalList]
	@pPageIndex INT=1,
	@pPageSize INT=5,
		@pVehicle Varchar(Max)=''
    
	AS
	BEGIN
	declare @count int =0
	declare @start_p int=1  
    set @start_p=(((@pPageIndex-1)*@pPageSize))

SELECT        VechicleID,Transport,Owner,Address,Mobile,VechicleNo,Marathi,RatePerTrip,PrintOrder
	into #Job_CTE 
    FROM        VehicleMast
	 WHERE    

		 (dbo.VehicleMast.VechicleNo like '%'+@pVehicle+'%' OR @pVehicle IS NULL OR @pVehicle='') 
	
	select @count=count(1) from  #Job_CTE  
	select @count As TotalRows,* from #Job_CTE  
	order by VechicleID desc 
	OFFSET @start_p ROWS FETCH NEXT @pPageSize ROWS ONLY

	select @count

	END

GO
/****** Object:  StoredProcedure [dbo].[log]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[log]

@username varchar(50),@password varchar(50)

as 
begin
 select * from login where username= @username and password =@password

 end

GO
/****** Object:  StoredProcedure [dbo].[OpeningBalanceList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[OpeningBalanceList] 
@pPageIndex INT=1,
	@pPageSize INT=20,
		@pName Varchar(Max)=''
    
	AS
	BEGIN
	declare @count int =0
	declare @start_p int=1  
    set @start_p=(((@pPageIndex-1)*@pPageSize))

SELECT      C.CustomerID as [Sr_No],  C.CustomerName, A.Area as [Area], CPD.PreviousBalance as [BalanceAmount]
into #Job_CTE 
FROM            CustomerMast C LEFT OUTER JOIN
                         CustomerPaymentDetail CPD ON C.CustomerID = CPD.CustomerId LEFT OUTER JOIN
                         AreaMast A ON C.AreaID = A.AreaID
WHERE        (CPD.BillID = 1) and   

		 (C.CustomerName like '%'+@pName+'%' OR @pName IS NULL OR @pName='') 

	select @count=count(1) from  #Job_CTE  
	select @count As TotalRows,* from #Job_CTE  
	order by [Sr_No] asc 
	OFFSET @start_p ROWS FETCH NEXT @pPageSize ROWS ONLY

	select @count

end

GO
/****** Object:  StoredProcedure [dbo].[rpt_AMCList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rpt_AMCList]
--@ServiceTypeID int
AS
BEGIN
	
	SET NOCOUNT ON;

--SELECT DISTINCT 
--                      EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, ProductMast.Product, SpareInvoiceDtls.Quantity, 
--                      SpareInvoiceDtls.ActualPrice, SpareInvoiceDtls.TotalPrice, 
--                      CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, SpareInvoiceMast.InvoiceDate, 
--                      CompanyProfileMast.Name, CompanyProfileMast.Address1, CompanyProfileMast.Address2, CompanyProfileMast.Address3, 
--                      CompanyProfileMast.Phone, CompanyProfileMast.Mobile, DocPathSettingsMast.Path + '\' + CompanyProfileMast.LogoFile AS LogoFile, 
--                      SpareInvoiceMast.OwnerID
--FROM         SpareInvoiceMast LEFT OUTER JOIN
--                      SpareInvoiceDtls ON SpareInvoiceMast.InvoiceID = SpareInvoiceDtls.InvoiceID LEFT OUTER JOIN
--                      CustomerMast ON SpareInvoiceMast.CustomerID = CustomerMast.CustomerID LEFT OUTER JOIN
--                      ProductMast ON SpareInvoiceDtls.ProductID = ProductMast.ProductID LEFT OUTER JOIN
--                      EmployeeMast ON SpareInvoiceMast.OwnerID = EmployeeMast.EmployeeID CROSS JOIN
--                      CompanyProfileMast CROSS JOIN
--                      DocPathSettingsMast

SELECT     EmployeeMast.Fname AS Salesperson, ProductMast.Product, CustomerMast.Fname AS Customer, SpareInvoiceMast.InvoiceNumber, SpareInvoiceMast.InvoiceDate, 
                      SpareInvoiceMast.OwnerID, SpareInvoiceDtls.Quantity, RecieptMast.CashAmt, RecieptMast.ChequeAmt,  RecieptMast.TotalAmt,RecieptMast.PaymentModeID
FROM         CustomerMast RIGHT OUTER JOIN
                      EmployeeMast RIGHT OUTER JOIN
                      SpareInvoiceMast LEFT OUTER JOIN
                      RecieptMast ON SpareInvoiceMast.InvoiceID = RecieptMast.InvoiceID ON EmployeeMast.EmployeeID = SpareInvoiceMast.OwnerID ON 
                      CustomerMast.CustomerID = SpareInvoiceMast.CustomerID LEFT OUTER JOIN
                      SpareInvoiceDtls LEFT OUTER JOIN
                      ProductMast ON SpareInvoiceDtls.ProductID = ProductMast.ProductID ON SpareInvoiceMast.InvoiceID = SpareInvoiceDtls.InvoiceID
WHERE     (SpareInvoiceMast.OwnerType = 'S') AND (EmployeeMast.EmployeeID = 6) and  (DATEDIFF(day, SpareInvoiceMast.InvoiceDate, GETDATE()) = 0)
GROUP BY EmployeeMast.Fname, ProductMast.Product, CustomerMast.Fname, SpareInvoiceMast.InvoiceNumber, SpareInvoiceMast.InvoiceDate, SpareInvoiceMast.OwnerID, 
                      SpareInvoiceDtls.Quantity, RecieptMast.TotalAmt, RecieptMast.CashAmt, RecieptMast.ChequeAmt, RecieptMast.PaymentModeID
--WHERE     (DATEDIFF(day, SpareInvoiceMast.InvoiceDate, GETDATE()) = 0)

END




GO
/****** Object:  StoredProcedure [dbo].[rpt_CustomerList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rpt_CustomerList]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
SELECT     CustomerMast.CustomerID, CustomerMast.CustomerName AS FullName, CustomerMast.Address, AreaMast.Area, 
                      CustomerMast.Mobile 

FROM         CustomerMast INNER JOIN
                      --CityMast ON CustomerMast.CityID = CityMast.CityID INNER JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID 
                      --TitleMast ON CustomerMast.TitleID = TitleMast.TitleID
END




GO
/****** Object:  StoredProcedure [dbo].[Rpt_CustomerMonthQtyAmount]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Rpt_CustomerMonthQtyAmount]
as
Begin
---Execute Rpt_CustomerMonthQtyAmount

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' 
from ProductMast P
---inner join (Select Productid from VendorProducts where VendorID=@pVendorID Group by Productid) VP on (VP.ProductID=P.ProductID)

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max([' + Product + ']) as ' + '[' + Product + ']' 
from ProductMast P
---inner join (Select Productid from VendorProducts where VendorID=@pVendorID Group by Productid) VP on (VP.ProductID=P.ProductID)

--Select @vProductList,@vProductCol

set @vSQLText=
'
Select 
CustomerAmt.*,
Qty.*
from
(
(Select 
	Amt.CustomerId,
	convert(varchar(10),datepart(month,Amt.LastUpdatedDate)) + ''-'' + convert(varchar(10),Datepart(year,Amt.LastUpdatedDate)) BillDate,
	sum(BillAmount) BillAmount,
	Sum(Amount) PaidAmount,
	Sum(BalanceDue) BalanceAmount 
from [dbo].[CustomerPaymentDetail] Amt
where Amt.LastUpdatedDate is NOT NULL
Group by Amt.CustomerID,convert(varchar(10),datepart(month,Amt.LastUpdatedDate)) + ''-'' + convert(varchar(10),Datepart(year,Amt.LastUpdatedDate))
) CustomerAmt
outer Apply
(Select ' + @vProductCol +
'From
(Select 
convert(varchar(10),datepart(month,B.LastUpdatedDate))  + ''-'' + convert(varchar(10),Datepart(year,B.LastUpdatedDate)) BillDate,P.Product,Sum(B.Quantity) as Quantity 
from [dbo].[CustomerBillDetails] B 
inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
inner join [dbo].[CustomerMast] C on (C.CustomerId=B.CustomerId)
where convert(varchar(10),datepart(month,B.LastUpdatedDate))  + ''-'' + convert(varchar(10),Datepart(year,B.LastUpdatedDate))=CustomerAmt.BillDate
and C.CustomerID=CustomerAmt.CustomerId
 Group by convert(varchar(10),datepart(month,B.LastUpdatedDate))  + ''-'' + convert(varchar(10),Datepart(year,B.LastUpdatedDate)),P.Product
) P
pivot
( 
Max(Quantity) 
for [Product] in (' + @vProductList + ') ) pvt
Group by BillDate ) Qty
)'

print @vSQLText

exec (@vSQLText)
End





GO
/****** Object:  StoredProcedure [dbo].[Rpt_CustomerWiseQtyAmount]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[Rpt_CustomerWiseQtyAmount]
@pCustomerID int,
@pDate Datetime  
as
Begin
---Execute Rpt_CustomerWiseQtyAmount 1,'02/01/2017'

Declare @mMonthNo int =DATEPART(mm,@pDate)
Declare @mYear int =DATEPART(yyyy,@pDate)

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P
--inner join (Select Productid from customerRates where customerID=@pCustomerID Group by Productid) CP on (CP.ProductID=P.ProductID)

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P
--inner join (Select Productid from customerRates where customerID=@pCustomerID Group by Productid) CP on (CP.ProductID=P.ProductID)



set @vSQLText=
	'
	Select 
	convert(varchar(10),BillDate,103) [Date],Qty.*,CustAmt.BillAmount [Bill Amount],CustAmt.PreviousBalance [Previous Balance] , (CustAmt.BillAmount+CustAmt.PreviousBalance) Total,CAST ( CustAmt.PaidAmount AS Varchar(25) )[Paid Amount],BalanceAmount [Balance Amount] 

	from
	(
	(Select 
		Amt.CustomerID,
		Convert(date,Amt.BillDate) BillDate,
		sum(BillAmount) BillAmount,
		Sum(Amount) PaidAmount,
		Sum(PreviousBalance) PreviousBalance,
		Sum(BalanceDue) BalanceAmount 
	from [dbo].[CustomerPaymentDetail] Amt
	where Amt.CustomerID= ' + convert(varchar(100),@pCustomerID) + ' and
	 (CONVERT(varchar(10), DATEPART(month,  Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	AND (CONVERT(varchar(10), DATEPART(year,  Amt.BillDate)) = '+ convert(varchar(5),@mYear) + ')
	and Amt.Billdate is NOT NULL
	Group by Amt.CustomerID,Convert(date,Amt.BillDate)
	) CustAmt
	outer Apply
	(Select ' + @vProductCol +
	'From
	(Select 
	Convert(date,CO.BillDate) BillDate,P.Product,Sum(B.Quantity) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	where C.CustomerID= ' + convert(varchar(100),@pCustomerID) + 
	'
	 and (CONVERT(varchar(10), DATEPART(month,  CO.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	 AND (CONVERT(varchar(10), DATEPART(year,  CO.BillDate)) = '+ convert(varchar(5),@mYear) + ')
	and Convert(date,CO.BillDate)=Convert(date,CustAmt.BillDate)
	 Group by P.Product,Convert(date,CO.BillDate)
	) P
	pivot
	( 
	Max(Quantity) 
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate ) Qty
	)'

print @vSQLText

exec (@vSQLText)
End






GO
/****** Object:  StoredProcedure [dbo].[rpt_ICAMCReport]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rpt_ICAMCReport]
@ServiceTypeID int
,@IsClose bit
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ProductMast.Product, ProductBrandMast.BrandName, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, 
                      ServiceMast.PurchaseDate, ServiceMast.ServiceEndDate, ServiceMast.NoOfService, ServiceMast.IsClose, ServiceTypeMast.ServiceType, 
                      ServiceMast.ServiceTypeID, ServiceMast.SerialNo, CustomerMast.CustomerID, ServiceMast.FreuencyInMonth, ServiceMast.NxtServiceDate, 
                      ServiceMast.ProductID, ServiceMast.ServiceID
FROM         ProductMast INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      ServiceMast ON ProductMast.ProductID = ServiceMast.ProductID INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      ServiceTypeMast ON ServiceMast.ServiceTypeID = ServiceTypeMast.ServiceTypeID	
WHERE ServiceMast.ServiceTypeID=@ServiceTypeID and ServiceMast.IsClose=@IsClose


END




GO
/****** Object:  StoredProcedure [dbo].[rpt_InvoiceList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rpt_InvoiceList]
 @InvoiceID  int
AS
BEGIN

	SET NOCOUNT ON;

SELECT     SpareInvoiceMast.InvoiceNumber, SpareInvoiceMast.InvoiceDate, 
                      CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS cust_name, 
                      CustomerMast.Address + ' ' + AreaMast.Area + ' ' + CityMast.CityName AS Address, CustomerMast.ZipCode, CustomerMast.EmailID, 
                      CustomerMast.Phone, CustomerMast.Mobile, EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, 
                      ProductMast.Product, ProductBrandMast.BrandName, SpareInvoiceDtls.Quantity, SpareInvoiceDtls.ActualPrice, SpareInvoiceDtls.TotalPrice, 
                      SpareInvoiceMast.ChequeNo, SpareInvoiceMast.ChequeDate, SpareInvoiceMast.BankName, SpareInvoiceMast.BalanceAmt, 
                      PaymentMode.ModeName, CompanyProfileMast.Name, 
                      CompanyProfileMast.Address1 + ' ' + CompanyProfileMast.Address2 + ' ' + CompanyProfileMast.Address3 AS CompAdd, 
                      CompanyProfileMast.Phone AS Expr1, CompanyProfileMast.Mobile AS Expr2, 
                      DocPathSettingsMast.Path + '\' + CompanyProfileMast.LogoFile AS LogoFile, RecieptMast.TotalAmt
FROM         SpareInvoiceMast left outer JOIN
                      SpareInvoiceDtls ON SpareInvoiceMast.InvoiceID = SpareInvoiceDtls.InvoiceID left outer JOIN
                      CustomerMast ON SpareInvoiceMast.CustomerID = CustomerMast.CustomerID left outer JOIN
                      ProductMast ON SpareInvoiceDtls.ProductID = ProductMast.ProductID left outer JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID left outer JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID left outer JOIN
                      EmployeeMast ON AreaMast.AreaID = EmployeeMast.AreaID AND CustomerMast.SalesPersonID = EmployeeMast.EmployeeID left outer JOIN
                      CityMast ON CustomerMast.CityID = CityMast.CityID AND AreaMast.CityID = CityMast.CityID AND EmployeeMast.CityID = CityMast.CityID left outer JOIN
                      PaymentMode ON SpareInvoiceMast.PaymentModeID = PaymentMode.PaymentModeID left outer JOIN
                      RecieptMast ON SpareInvoiceMast.InvoiceID = RecieptMast.InvoiceID CROSS JOIN
                      DocPathSettingsMast CROSS JOIN
                      CompanyProfileMast
WHERE     (SpareInvoiceMast.InvoiceID = @InvoiceID) AND (CompanyProfileMast.CompanyID = - 1) AND (DocPathSettingsMast.DocID = 3)
END




GO
/****** Object:  StoredProcedure [dbo].[rpt_Service]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Vendor Details
-- =============================================

CREATE PROCEDURE [dbo].[rpt_Service]
@CustomerID int
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ServiceMast.ServiceID, ProductMast.Product, ProductBrandMast.BrandName, ServiceMast.SerialNo, ServiceMast.PurchaseDate, 
                      ServiceMast.NoOfService, ServiceMast.NxtServiceDate, ServiceMast.ServiceEndDate, ServiceMast.IsClose, ServiceTypeMast.ServiceType, 
                      ProductMast.ProductID, CustomerMast.Mobile, CustomerMast.Phone, CustomerMast.EmailID, CustomerMast.ZipCode, CustomerMast.Address, 
                      CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, ServiceDtls.ActualServiceDate, 
                      ServiceDtls.ServiceDoneDate, ServiceDtls.Remark
FROM         ServiceMast INNER JOIN
                      ServiceTypeMast ON ServiceMast.ServiceTypeID = ServiceTypeMast.ServiceTypeID INNER JOIN
                      ProductMast ON ServiceMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      ServiceDtls ON ServiceMast.ServiceID = ServiceDtls.ServiceID
WHERE     (ServiceMast.CustomerID = @CustomerID or CustomerMast.customerID=@CustomerID)
END




GO
/****** Object:  StoredProcedure [dbo].[rpt_Service_History]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Vendor Details
-- =============================================

CREATE  PROCEDURE [dbo].[rpt_Service_History]
@WhereClause varchar(150)
AS
BEGIN
	
	SET NOCOUNT ON;

declare @QuertText varchar(max)


 set @QuertText='SELECT     CustomerMast.Fname + SPACE(1) + CustomerMast.Mname + SPACE(1) + CustomerMast.Lname AS CustName, ProductMast.Product, 
                      ProductBrandMast.BrandName, ServiceTypeMast.ServiceType, ServiceDtls.ServiceNumb, EmployeeMast.Fname + SPACE(1) 
                      + EmployeeMast.Mname + SPACE(1) + EmployeeMast.Lname AS ServiceMan, ServiceDtls.ActualServiceDate, ServiceDtls.ServiceDoneDate, 
                      ServiceDtls.Remark, CityMast.CityName, AreaMast.Area, CustomerMast.Address
FROM         ServiceMast INNER JOIN
                      ServiceTypeMast ON ServiceMast.ServiceTypeID = ServiceTypeMast.ServiceTypeID INNER JOIN
                      ProductMast ON ServiceMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      ServiceDtls ON ServiceMast.ServiceID = ServiceDtls.ServiceID INNER JOIN
                      EmployeeMast ON ServiceDtls.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast ON CustomerMast.CityID = CityMast.CityID INNER JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID '

set @QuertText=@QuertText+@WhereClause

exec(@QuertText)





END




GO
/****** Object:  StoredProcedure [dbo].[rpt_StockList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[rpt_StockList]


AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ProductMast.Product, Spare_StockMast.Quantity, Spare_StockMast.MRP, ProductBrandMast.BrandName
FROM         ProductMast INNER JOIN
                      Spare_StockMast ON ProductMast.ProductID = Spare_StockMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID
END




GO
/****** Object:  StoredProcedure [dbo].[Rpt_VerdorMonthQtyAmount]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Rpt_VerdorMonthQtyAmount]
as
Begin
---Execute Rpt_VerdorMonthQtyAmount

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' 
from ProductMast P
---inner join (Select Productid from VendorProducts where VendorID=@pVendorID Group by Productid) VP on (VP.ProductID=P.ProductID)

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max([' + Product + ']) as ' + '[' + Product + ']' 
from ProductMast P
---inner join (Select Productid from VendorProducts where VendorID=@pVendorID Group by Productid) VP on (VP.ProductID=P.ProductID)

--Select @vProductList,@vProductCol

set @vSQLText=
'
Select 
VendorAmt.*,
Qty.*
from
(
(Select 
	Amt.SupplierID,
	convert(varchar(10),datepart(month,Amt.BillDate)) + ''-'' + convert(varchar(10),Datepart(year,Amt.BillDate)) BillDate,
	sum(BillAmount) BillAmount,
	Sum(Amount) PaidAmount,
	Sum(BalanceDue) BalanceAmount 
from [dbo].[SupplierPaymentDetail] Amt
where Amt.Billdate is NOT NULL
Group by Amt.SupplierID,convert(varchar(10),datepart(month,Amt.BillDate)) + ''-'' + convert(varchar(10),Datepart(year,Amt.BillDate))
) VendorAmt
outer Apply
(Select ' + @vProductCol +
'From
(Select 
convert(varchar(10),datepart(month,B.BillDate))  + ''-'' + convert(varchar(10),Datepart(year,B.BillDate)) BillDate,P.Product,Sum(B.Quantity) as Quantity 
from [dbo].[purchase] B 
inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
inner join [dbo].[VendorMast] C on (C.VendorID=B.VendorID)
where convert(varchar(10),datepart(month,B.BillDate))  + ''-'' + convert(varchar(10),Datepart(year,B.BillDate))=VendorAmt.BillDate
and C.VendorID=VendorAmt.SupplierId
 Group by convert(varchar(10),datepart(month,B.BillDate))  + ''-'' + convert(varchar(10),Datepart(year,B.BillDate)),P.Product
) P
pivot
( 
Max(Quantity) 
for [Product] in (' + @vProductList + ') ) pvt
Group by BillDate ) Qty
)'

print @vSQLText

exec (@vSQLText)
End





GO
/****** Object:  StoredProcedure [dbo].[Rpt_VerdorWiseQtyAmount]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[Rpt_VerdorWiseQtyAmount]
@pVendorID int=10
as
Begin
---Execute Rpt_VerdorWiseQtyAmount 10

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' 
from ProductMast P
--inner join (Select Productid from VendorProducts where VendorID=@pVendorID Group by Productid) VP on (VP.ProductID=P.ProductID)

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max([' + Product + ']) as ' + '[' + Product + ']' 
from ProductMast P
--inner join (Select Productid from VendorProducts where VendorID=@pVendorID Group by Productid) VP on (VP.ProductID=P.ProductID)

--Select @vProductList,@vProductCol

set @vSQLText=
'
Select 
VendorAmt.BillDate,
Qty.*,VendorAmt.BillAmount,VendorAmt.PaidAmount,VendorAmt.BalanceAmount
from
(
(Select 
--Amt.SupplierID,
	Convert(date,Amt.BillDate) BillDate,
	sum(BillAmount) BillAmount,
	Sum(Amount) PaidAmount,
	Sum(BalanceDue) BalanceAmount 
from [dbo].[SupplierPaymentDetail] Amt
where Amt.SupplierID= ' + convert(varchar(100),@pVendorID) + '
and Amt.Billdate is NOT NULL
Group by Amt.SupplierID,Convert(date,Amt.BillDate)
) VendorAmt
outer Apply
(Select ' + @vProductCol +
'From
(Select 
Convert(date,B.BillDate) BillDate,P.Product,Sum(B.Quantity) as Quantity 
from [dbo].[purchase] B 
inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
inner join [dbo].[VendorMast] C on (C.VendorID=B.VendorID)
where C.VendorID= ' + convert(varchar(100),@pVendorID) + 
'
and Convert(date,B.BillDate)=Convert(date,VendorAmt.BillDate)
 Group by P.Product,Convert(date,B.BillDate)
) P
pivot
( 
Max(Quantity) 
for [Product] in (' + @vProductList + ') ) pvt
Group by BillDate ) Qty
)'

print @vSQLText

exec (@vSQLText)
End




GO
/****** Object:  StoredProcedure [dbo].[rptDealerList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[rptDealerList] 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT     DealerMast.DealerID, DealerMast.DealerName, DealerMast.Address, AreaMast.Area, CityMast.CityName, DealerMast.EmailID, DealerMast.OfficePhone, 
                      DealerMast.FaxNo, DealerMast.ContactPerson, DealerMast.PersonMobileNo, DealerMast.IsActive, ISNULL(UserMast.Fname, '') + ' ' + ISNULL(UserMast.Mname, '') 
                      + ' ' + ISNULL(UserMast.Lname, '') AS CreatedBy, ISNULL(UserMast_1.Fname, '') + ' ' + ISNULL(UserMast_1.Mname, '') + ' ' + ISNULL(UserMast_1.Lname, '') 
                      AS LastUpdatedBy
    FROM         DealerMast INNER JOIN
                      AreaMast ON DealerMast.AreaID = AreaMast.AreaID INNER JOIN
                      CityMast ON DealerMast.CityID = CityMast.CityID INNER JOIN
                      UserMast ON DealerMast.CreatedBy = UserMast.UserID INNER JOIN
                      UserMast AS UserMast_1 ON DealerMast.LastUpdatedBy = UserMast_1.UserID

END




GO
/****** Object:  StoredProcedure [dbo].[Sales]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Proc [dbo].[Sales]
as 
begin

SELECT  cast(BillDate as varchar(7))  as month,convert(varchar(10), Billdate,101) Orderdate, TotalQty as Quantity, TotalAmount as Amount
FROM            dbo.CustomerBillMast ORDER BY Orderdate DESC
end

GO
/****** Object:  StoredProcedure [dbo].[SalesOrder]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[SalesOrder]
  @pDate Datetime=null,
  @customername nvarchar(50)=''
as 
begin
 
Declare @mDayNo int =DATEPART(dd,@pDate)
Declare @mMonthNo int =DATEPART(mm,@pDate)
Declare @mYear int =DATEPART(yyyy,@pDate)
Declare @search nvarchar(100)


DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P order by ProductBrandID asc

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P order by productid asc
SET @search = '''%' + @customername + '%''' 
		
set @vSQLText=
'Select  CustomerName,Area,  Qty.*,CustAmt.BillAmount [Bill Amount],CustAmt.PreviousBalance [Previous Balance] , (CustAmt.BillAmount+CustAmt.PreviousBalance) Total--,CAST ( CustAmt.PaidAmount AS Varchar(25) )[Paid Amount],BalanceAmount [Balance Amount] 
from 
(
(Select 
CustomerMast.CustomerID,CustomerMast.CustomerName,AreaMast.Area,
Convert(date,Amt.BillDate) BillDate,
sum(BillAmount) AS BillAmount,
Sum(Amount) AS PaidAmount,
Sum(PreviousBalance) AS PreviousBalance,
Sum(BalanceDue) AS BalanceAmount 
from [dbo].[CustomerPaymentDetail] Amt
INNER JOIN
CustomerMast ON Amt.CustomerId = CustomerMast.CustomerID INNER JOIN
AreaMast ON CustomerMast.AreaId = AreaMast.AreaId
where

(CONVERT(varchar(10), DATEPART(day, Amt.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
And (CONVERT(varchar(10), DATEPART(month, Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
AND (CONVERT(varchar(10), DATEPART(year, Amt.BillDate)) = '+ convert(varchar(4),@mYear) + ')
And Amt.Billdate is NOT NULL and (CustomerMast.CustomerName LIKE  '+ @search +' or '''+ CAST((@customername) AS nvarchar) +''' = '''' )

Group by CustomerMast.CustomerID,AreaMast.Area,Convert(date,Amt.BillDate),CustomerMast.CustomerName

) CustAmt
outer Apply
(Select ' + @vProductCol +
'From
(Select 
Convert(date,CO.BillDate) BillDate,P.Product,ROUND(CAST (Sum(B.Quantity)AS decimal (6,0)),0) as Quantity 
from [dbo].[CustomerBillDetails] B 
inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
where 
(CONVERT(varchar(10), DATEPART(Day, CO.BillDate)) ='+ convert(varchar(2),@mDayNo) + ') 
AND (CONVERT(varchar(10), DATEPART(month, CO.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ')
AND (CONVERT(varchar(10), DATEPART(year, CO.BillDate)) = '+ convert(varchar(4),@mYear) + ')

and Convert(date,CO.BillDate)=Convert(date,CustAmt.BillDate)
and c.CustomerID=custamt.CustomerId
   
Group by P.Product,Convert(date,CO.BillDate)
UNION ALL 
Select 
'''+convert(varchar(10),@pDate,101)+''' BillDate,''No Product'' Product, convert(Varchar,0) as Quantity 
from [dbo].[CustomerBillDetails] B 
inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
) P
pivot
( 
Max(Quantity) 
for [Product] in (' + @vProductList +') 
) pvt
Group by BillDate ) Qty 
)

'

print @vSQLText

exec (@vSQLText)


end

GO
/****** Object:  StoredProcedure [dbo].[Select_Products_For_Vendor]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Select_Products_For_Vendor] 
@vendorId int

AS
BEGIN
	SET NOCOUNT ON;

	If NOT EXISTS (SELECT VendorProductID, VendorID, productId, Rate FROM VendorProducts WHERE VendorID = @vendorId )
		BEGIN 
			SELECT ProductID, Product, isActive, 0 AS Rate FROM ProductMast
		End
else 
		BEGIN 
			SELECT VendorProductID, VendorID, productId, Rate FROM VendorProducts WHERE VendorID = @vendorId 
		End

	END




GO
/****** Object:  StoredProcedure [dbo].[SelectAll_PartDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 16 Sep 2010
-- Description:	Store Procedure For getting  Stock List
-- =============================================




CREATE PROCEDURE [dbo].[SelectAll_PartDtls]

@ServiceDtlsID int
AS
BEGIN
	
	SET NOCOUNT ON;
	


SELECT     ProductMast.Product, PartDtls.Quantity, ServiceDtls.TotalAmount
FROM         PartDtls INNER JOIN
                      ServiceDtls ON PartDtls.ServiceDtlsID = ServiceDtls.ServiceDtlsID INNER JOIN
                      ProductMast ON PartDtls.ParID = ProductMast.ProductID
where PartDtls.ServiceDtlsID=@ServiceDtlsID

END




GO
/****** Object:  StoredProcedure [dbo].[SelectAll_Product_By_BrandNameID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectAll_Product_By_BrandNameID]
@ProductBrandID int

AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     ProductMast.ProductID, ProductMast.Product, ProductMast.ProductBrandID
FROM         ProductMast Left Outer JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID
where ProductMast.ProductBrandID=@ProductBrandID
END




GO
/****** Object:  StoredProcedure [dbo].[SelectCustomer_ForReceipt]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[SelectCustomer_ForReceipt]
 @OwnerID int    
    
AS
BEGIN


BEGIN TRY

   
SELECT     SpareInvoiceMast.CustomerID, CustomerMast.Lname as 
CustName, CityMast.CityName, AreaMast.Area
                      
FROM         SpareInvoiceMast INNER JOIN
                      CustomerMast ON SpareInvoiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      CityMast ON CustomerMast.CityID = CityMast.CityID INNER JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID

where SpareInvoiceMast.OwnerID=@OwnerID
and SpareInvoiceMast.OwnerType='S'


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[SelectCustomerBankInfo_ForReceipt]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[SelectCustomerBankInfo_ForReceipt]
 @OwnerID int    
    
AS
BEGIN


BEGIN TRY

   
SELECT     BankName, BranchAddress, AccNo
FROM         CustBankInfoMast
WHERE     (CustID =@OwnerID)

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[SelectCustomerMast_By_SalesPersonID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectCustomerMast_By_SalesPersonID]
 @OwnerID int    

AS
BEGIN


BEGIN TRY
SELECT     CustomerMast.CustomerID,(CustomerMast.Fname +' '+ CustomerMast.Mname +' '+ CustomerMast.Lname)as CustName,CityMast.CityName, AreaMast.Area
FROM         CustomerMast INNER JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID INNER JOIN
                      CityMast ON CustomerMast.CityID = CityMast.CityID AND AreaMast.CityID = CityMast.CityID
where CustomerMast.SalesPersonID=@OwnerID
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[SelectCustomersInVoiceWithGatepassID_ForReceipt]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectCustomersInVoiceWithGatepassID_ForReceipt]
 @OwnerID int    
   ,@CustomerID int 
AS
BEGIN


BEGIN TRY
SELECT DISTINCT 
                      SpareInvoiceMast.InvoiceID, SpareInvoiceMast.TotalAmt, SpareInvoiceMast.InvoiceNumber, SpareInvoiceMast.InvoiceDate, 
                      SpareInvoiceMast.PaymentModeID, SpareInvoiceMast.ChequeNo, SpareInvoiceMast.ChequeDate, SpareInvoiceMast.BankName, 
                      SpareInvoiceMast.BalanceAmt
FROM         SpareGatePassMast INNER JOIN
                      SpareInvoiceDtls ON SpareGatePassMast.GatePassID = SpareInvoiceDtls.GatePassID INNER JOIN
                      SpareInvoiceMast ON SpareInvoiceDtls.InvoiceID = SpareInvoiceMast.InvoiceID
WHERE     (SpareInvoiceMast.OwnerID = @OwnerID) AND (SpareInvoiceMast.CustomerID =@CustomerID)

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[SelectGatepassID_By_SalesPersonID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectGatepassID_By_SalesPersonID]
 @OwnerID int    

AS
BEGIN


BEGIN TRY
SELECT     SpareGatePassDtls.ProductID, SUM(SpareGatePassDtls.Quantity) AS Quantity,SUM(SpareGatePassDtls.UsedQty) AS UsedQuantity,
(SUM(SpareGatePassDtls.Quantity)-SUM(SpareGatePassDtls.UsedQty))as RemaianingQty,NewQuantity=0
FROM         SpareGatePassDtls INNER JOIN
                      SpareGatePassMast ON SpareGatePassDtls.GatePassID = SpareGatePassMast.GatePassID

where SpareGatePassMast.ServicePersonID= @OwnerID and SpareGatePassDtls.IsSold=0
GROUP BY SpareGatePassDtls.ProductID

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[SelectProducts_by_GatePassID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SelectProducts_by_GatePassID]
 @GatePassID int    

AS
BEGIN


BEGIN TRY
SELECT     SpareGatePassMast.GatePassID, SpareGatePassMast.GatePassNumb, SpareGatePassDtls.ProductID, ProductMast.Product, 
                      SpareGatePassDtls.Quantity, SpareGatePassDtls.PerUnitPrice
FROM         ProductMast INNER JOIN
                      SpareGatePassDtls ON ProductMast.ProductID = SpareGatePassDtls.ProductID INNER JOIN
                      SpareGatePassMast ON SpareGatePassDtls.GatePassID = SpareGatePassMast.GatePassID
where SpareGatePassMast.GatePassID=@GatePassID



END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[SelectSalesPersonGatepassID_ForReceipt]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[SelectSalesPersonGatepassID_ForReceipt]
 @OwnerID int    

AS
BEGIN


BEGIN TRY
SELECT     GatePassMast.GatePassNumb, ProductMast.Product, GatePassDtls.SerialNo, GatePassDtls.PerUnitPrice, GatePassMast.GatePassID, 
                      GatePassMast.IssueDate AS GatapassDate, GatePassDtls.GatePassDtlID, GatePassDtls.ProductID
FROM         GatePassDtls INNER JOIN
                      GatePassMast ON GatePassDtls.GatePassID = GatePassMast.GatePassID INNER JOIN
                      ProductMast ON GatePassDtls.ProductID = ProductMast.ProductID
WHERE     (GatePassMast.OwnerID = @OwnerID) AND (GatePassMast.OwnerType = 'S') AND (GatePassDtls.IsSold = 0)



END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[Selet_Products_For_NewVendor]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Selet_Products_For_NewVendor] 

AS
BEGIN
	SET NOCOUNT ON;
select ProductID, Product, isActive, 0 as Rate from ProductMast

END




GO
/****** Object:  StoredProcedure [dbo].[SP_EXECUTESQL123]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[SP_EXECUTESQL123]
(
@suppliername nvarchar(50)=''
)
as
begin

DECLARE @cols AS nvarchar(MAX),
@query  AS NVARCHAR(MAX)
Declare @search nvarchar(50)


SELECT @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.product) 
            FROM ProductMast c
            FOR XML PATH(''), TYPE
            ).value('.', 'nvarchar(MAX)') 
        ,1,1,'') 
		
		SET @search = '''%' + @suppliername + '%'''       
		       
SELECT @query =
'SELECT *
FROM    ( 
	 select vendorname,product,isnull(VP.rate,0) as rate from  VendorProducts VP
	  left join ProductMast PM on PM.ProductID = VP.ProductId
	right join VendorMast VM on VM.VendorID = VP.VendorID  
	where
    (vm.VendorName LIKE  '+ @search +' or '''+ CAST((@suppliername) AS nvarchar) +''' = '''' )
        ) s
PIVOT   (SUM(rate) FOR Product IN ('+ @cols +')) pvt'

execute(@query)

end

--select * from ProductMast

GO
/****** Object:  StoredProcedure [dbo].[SP_Insert_CustmorIDFeedBack]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : dbo
-- Create date : Jul 16 2010  5:36PM
-- Description : Insert Procedure for CityMast
-- Exec [dbo].[cs_InsertCityMast] [StateID],[City],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[SP_Insert_CustmorIDFeedBack]
     @CustomerID  int
    ,@FeedBack  varchar(50)
    ,@CreateDate  datetime
    
AS
BEGIN

    INSERT INTO CustmorFeedbackMast
                      (CustmorID, Feedback, createdDate)
VALUES     (@CustomerID,@FeedBack,@CreateDate)
END




GO
/****** Object:  StoredProcedure [dbo].[SP_ListOfPurchasePaymentDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[SP_ListOfPurchasePaymentDetails]
as
begin

DECLARE @cols AS varchar(MAX),
@query  AS NVARCHAR(MAX)

SELECT @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.product) 
            FROM ProductMast c
            FOR XML PATH(''), TYPE
            ).value('.', 'varchar(MAX)') 
        ,1,1,'')		     
		       
SELECT @query =
'SELECT *
FROM    ( 
	 select vendorname,product,isnull(VP.rate,0) as rate from  VendorProducts VP
	  left join ProductMast PM on PM.ProductID = VP.ProductId
	right join VendorMast VM on VM.VendorID = VP.VendorID  
        ) s
PIVOT   (SUM(rate) FOR Product IN ('+ @cols +')) pvt'

execute(@query)
end

GO
/****** Object:  StoredProcedure [dbo].[SP_LoadPurchase]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec SP_LoadPurchase '2018-12-15 00:00:00.00',''

CREATE proc [dbo].[SP_LoadPurchase] 
(
@orderdate datetime =null,
@suppliername nvarchar(50)=''
)
as
begin

DECLARE @cols AS nvarchar(MAX),
@query  AS NVARCHAR(MAX)

Declare @mDayNo int =DATEPART(dd,@orderdate)
Declare @mMonthNo int =DATEPART(mm,@orderdate)
Declare @mYear int =DATEPART(yyyy,@orderdate)
Declare @search nvarchar(100)



SELECT @cols = STUFF((SELECT distinct ',' + QUOTENAME(c.product) 
            FROM ProductMast c
            FOR XML PATH(''), TYPE
            ).value('.','nvarchar(MAX)') 
        ,1,1,'')

		SET @search = '''%' + @suppliername + '%''' 
		


SELECT @query =

'SELECT VendorName,'+@cols+', amount,paidamount, previousbalance,balancedue

FROM  ( 
select distinct vm.VendorName,pm.Product,isnull(billamount,0.00) as amount,isnull(p.quantity,0.00) as quantity,isnull(cashamount,0.00) as paidamount,isnull(spd.previousbalance,0.00) as previousbalance,isnull(spd.balancedue,0.00) as balancedue,
spd.billdate
from VendorMast vm 
left join Purchase p on p.VendorId = vm.VendorID
left join ProductMast pm on pm.productid = p.productid
left join SupplierPaymentDetail spd on spd.supplierid = p.VendorId and spd.billdate = p.billdate
where 
   (CONVERT(varchar(10), DATEPART(Day, spd.billdate)) = '+ convert(varchar(2),@mDayNo) + ' or CONVERT(varchar(10), DATEPART(Day, spd.billdate)) is null) 
and (CONVERT(varchar(10), DATEPART(month, spd.billdate)) = '+ convert(varchar(2),@mMonthNo) + '  or CONVERT(varchar(10), DATEPART(month, spd.billdate)) is null) 
 AND (CONVERT(varchar(10), DATEPART(year, spd.billdate)) = '+ convert(varchar(4),@mYear) + '  or CONVERT(varchar(10), DATEPART(year, spd.billdate)) is null)
   and (vm.VendorName LIKE  '+ @search +' or '''+ CAST((@suppliername) AS nvarchar) +''' = '''' )
   
  ) s
PIVOT (max(quantity) FOR Product IN ('+ @cols +')) pvt'

execute(@query)

end

--select * from SupplierPaymentDetail

GO
/****** Object:  StoredProcedure [dbo].[SP_LoadPurchasetestproc]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec SP_LoadPurchasetestproc '2018-12-11 00:00:00.00'

CREATE proc [dbo].[SP_LoadPurchasetestproc] 
(
@orderdate datetime =null
)
as
begin

Declare @pDate Datetime = '10/11/2017'
Declare @mDayNo int =DATEPART(dd,@pDate)
Declare @mMonthNo int =DATEPART(mm,@pDate)
Declare @mYear int =DATEPART(yyyy,@pDate)

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P order by ProductBrandID asc

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P order by productid asc

set @vSQLText=
'Select Convert(Varchar(10),BillDate,103) BillDate, Area, CustomerName, Qty.*,CustAmt.BillAmount [Bill Amount],CustAmt.PreviousBalance [Previous Balance] , (CustAmt.BillAmount+CustAmt.PreviousBalance) Total--,CAST ( CustAmt.PaidAmount AS Varchar(25) )[Paid Amount],BalanceAmount [Balance Amount] 
from 
(
(Select 
CustomerMast.CustomerID,CustomerMast.CustomerName,AreaMast.Area,
Convert(date,Amt.BillDate) BillDate,
sum(BillAmount) AS BillAmount,
Sum(Amount) AS PaidAmount,
Sum(PreviousBalance) AS PreviousBalance,
Sum(BalanceDue) AS BalanceAmount 
from [dbo].[CustomerPaymentDetail] Amt
INNER JOIN
CustomerMast ON Amt.CustomerId = CustomerMast.CustomerID INNER JOIN
AreaMast ON CustomerMast.AreaId = AreaMast.AreaId
where

(CONVERT(varchar(10), DATEPART(day, Amt.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
And (CONVERT(varchar(10), DATEPART(month, Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
AND (CONVERT(varchar(10), DATEPART(year, Amt.BillDate)) = '+ convert(varchar(4),@mYear) + ')
And Amt.Billdate is NOT NULL
Group by CustomerMast.CustomerID,Convert(date,Amt.BillDate),CustomerMast.CustomerName,AreaMast.Area
) CustAmt
outer Apply
(Select ' + @vProductCol +
'From
(Select 
Convert(date,CO.BillDate) BillDate,P.Product,ROUND(CAST (Sum(B.Quantity)AS decimal (6,0)),0) as Quantity 
from [dbo].[CustomerBillDetails] B 
inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
where 
(CONVERT(varchar(10), DATEPART(Day, CO.BillDate)) ='+ convert(varchar(2),@mDayNo) + ') 
AND (CONVERT(varchar(10), DATEPART(month, CO.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ')
AND (CONVERT(varchar(10), DATEPART(year, CO.BillDate)) = '+ convert(varchar(4),@mYear) + ')
and Convert(date,CO.BillDate)=Convert(date,CustAmt.BillDate)
and c.CustomerID=custamt.CustomerId
Group by P.Product,Convert(date,CO.BillDate)
UNION ALL 
Select 
'''+convert(varchar(10),@pDate,101)+''' BillDate,''No Product'' Product, convert(Varchar,0) as Quantity 
from [dbo].[CustomerBillDetails] B 
inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
) P
pivot
( 
Max(Quantity) 
for [Product] in (' + @vProductList +') 
) pvt
Group by BillDate ) Qty
)
'
print @vSQLText
exec (@vSQLText)

end

--select * from SupplierPaymentDetail

GO
/****** Object:  StoredProcedure [dbo].[SP_Select_Cust_FeedbackList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_Select_Cust_FeedbackList] 
AS
BEGIN
	SET NOCOUNT ON;

SELECT     CustmorFeedbackMast.FeedBackID, CustmorFeedbackMast.Feedback, CustmorFeedbackMast.createdDate, 
                      CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, CustmorFeedbackMast.CustmorID
FROM         CustmorFeedbackMast INNER JOIN
                      CustomerMast ON CustmorFeedbackMast.CustmorID = CustomerMast.CustomerID

END




GO
/****** Object:  StoredProcedure [dbo].[Sp_Select_Customer_by_Salesperson]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Sp_Select_Customer_by_Salesperson] 

@OwnerID int

AS
BEGIN
	SET NOCOUNT ON;

	SELECT     (CustomerMast.Fname +' '+ CustomerMast.Mname+' '+ CustomerMast.Lname )as CustomerName
	FROM         InVoiceMast INNER JOIN
						  CustomerMast ON InVoiceMast.CustomerID = CustomerMast.CustomerID
	WHERE	InVoiceMast.OwnerID = @OwnerID and  InVoiceMast.OwnerType='S'

END




GO
/****** Object:  StoredProcedure [dbo].[SP_Update_FeedbackMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : dbo
-- Create date : Jul 16 2010  5:36PM
-- Description : Update Procedure for CityMast
-- Exec [dbo].[cs_UpdateCityMast] [StateID],[City],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[SP_Update_FeedbackMast]
     @FeedBackID  int
    ,@CustomerID int
    ,@FeedBack nvarchar(max)
,@CreatedDate datetime
AS
BEGIN

    UPDATE    CustmorFeedbackMast
SET              CustmorID =@CustomerID , Feedback =@FeedBack, createdDate =@CreatedDate
where FeedBackID=@FeedBackID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Add_PO_Details]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Update Procedure for ProductMast
-- Exec [dbo].[UC_UpdateProductMast] [Product],[ProductTypeID],[ProductBrandID],[CreateDate],[CreatedBy],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_Add_PO_Details]
   
    
AS
BEGIN


BEGIN TRY
SELECT     Quantity, PerUnitPrice, TotalAmt, ProductID,MRP, PoID, PoDtlID
FROM         PurchaseOrderDetail
WHERE PoID=-2

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Check_GRN_Ref_StockMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 16 Aug 2010
-- Description:	Store Procedure For GRN Ref StockMast
-- =============================================

CREATE PROCEDURE [dbo].[UC_Check_GRN_Ref_StockMast]
@GRN_ID int

AS
BEGIN
	
	SET NOCOUNT ON;
	

  
SELECT     COUNT(ProductID) AS RecordCount
FROM         StockMast
WHERE     (GRN_ID = @GRN_ID) AND (IsOccupied = 1)

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Check_PoID_In_GRN]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure Forcheck PoID in grn
-- =============================================




CREATE PROCEDURE [dbo].[UC_Check_PoID_In_GRN] 
@PoID int 

AS
BEGIN
	
	SET NOCOUNT ON;
	

SELECT     count(po.PoID) as RecordCount FROM         PurchaseOrderMast po
where po.poid = (select top 1 poid from grnmast g where g.poid = po.poid)
and po.poid = @poid

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Check_PoID_In_GRN_Spare]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure Forcheck PoID in grn
-- =============================================




create PROCEDURE [dbo].[UC_Check_PoID_In_GRN_Spare] 
@PoID int 

AS
BEGIN
	
	SET NOCOUNT ON;
	

SELECT     count(po.PoID) as RecordCount FROM         Spare_PurchaseOrderMast po
where po.poid = (select top 1 poid from Spare_grnmast g where g.poid = po.poid)
and po.poid = @poid

END




GO
/****** Object:  StoredProcedure [dbo].[UC_ClosePO]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  6 2010 11:24AM
-- Description : Update Procedure for PurchaseOrderMast
-- Exec [dbo].[UC_UpdatePurchaseOrderMast] [PoNumber],[VendorID],[PoDate],[ActualPo_Amt],[DiscountPercent],[DiscountAmt],[VatPercent],[VatAmt],[SalesTaxPercent],[SalesTaxAmt],[FinalPoAmt],[IsClose],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
create PROCEDURE [dbo].[UC_ClosePO]
     @PoID  int
    ,@IsClose  bit
    ,@LastUpdatedBy int
    
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[PurchaseOrderMast]
    SET 
         
        [IsClose] = @IsClose
        ,[LastUpdatedDate] = getdate()
        ,[LastUpdatedBy] = @LastUpdatedBy
        
    WHERE [PoID] = @PoID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Customer_Bill_Check]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Customer_Bill_Check] 

AS


select CustomerBillMast.BillDate from  CustomerBillMast 
where convert(varchar,CustomerBillMast.BillDate,103) =convert(varchar,Getdate(),103)
return




GO
/****** Object:  StoredProcedure [dbo].[UC_Customer_BlankRates]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Customer_BlankRates]

    
AS
BEGIN


BEGIN TRY

SELECT ProductID, Product, 0.00 AS Rate FROM ProductMast


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Customer_Ledger]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UC_Customer_Ledger] 

AS
BEGIN
	SET NOCOUNT ON;


--SELECT DISTINCT 
--                      SpareInvoiceMast.InvoiceDate, SpareInvoiceDtls.Quantity, CustomerMast.Lname AS Customer, ProductMast.Product, CratesCustomer.Date, CratesCustomer.CratesIn, 
--                      CratesCustomer.CratesOut, CratesCustomer.Balance, SpareInvoiceMast.TotalAmt, RecieptMast.TotalAmt AS Expr1, RecieptMast.CashAmt
--FROM         SpareInvoiceMast INNER JOIN
--                      SpareInvoiceDtls ON SpareInvoiceMast.InvoiceID = SpareInvoiceDtls.InvoiceID INNER JOIN
--                      CustomerMast ON SpareInvoiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
--                      CratesCustomer ON CustomerMast.CustomerID = CratesCustomer.CustomerID INNER JOIN
--                      ProductMast ON SpareInvoiceDtls.ProductID = ProductMast.ProductID INNER JOIN
--                      RecieptMast ON SpareInvoiceMast.InvoiceID = RecieptMast.InvoiceID


SELECT       CustomerBillDetails.Amount AS TotalAmt, CustomerMast.CustomerName AS Customer, 
                      ProductMast.Product, CustomerBillMast.BillDate, CustomerBillDetails.Quantity AS Quantity, CustomerBillDetails.Amount
FROM         CustomerBillDetails LEFT OUTER JOIN
                      CustomerBillMast ON CustomerBillDetails.BillID = CustomerBillMast.BillID LEFT OUTER JOIN
                      ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID RIGHT OUTER JOIN
                      CustomerMast ON CustomerBillDetails.CustomerId = CustomerMast.CustomerID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Customer_Ledger_By_CustID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UC_Customer_Ledger_By_CustID] 
@custId int
AS
BEGIN
	SET NOCOUNT ON;

--SELECT distinct    SpareInvoiceMast.InvoiceDate, SpareInvoiceDtls.Quantity, (CustomerMast.Lname) as Customer, ProductMast.Product, CratesCustomer.Date, 
--                      CratesCustomer.CratesIn, CratesCustomer.CratesOut, CratesCustomer.Balance, SpareInvoiceMast.TotalAmt, RecieptMast.TotalAmt AS Expr1, 
--                      RecieptMast.CashAmt
--FROM         SpareInvoiceMast INNER JOIN
--                      SpareInvoiceDtls ON SpareInvoiceMast.InvoiceID = SpareInvoiceDtls.InvoiceID INNER JOIN
--                      CustomerMast ON SpareInvoiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
--                      CratesCustomer ON CustomerMast.CustomerID = CratesCustomer.CustomerID INNER JOIN
--                      ProductMast ON SpareInvoiceDtls.ProductID = ProductMast.ProductID INNER JOIN
--                      RecieptMast ON SpareInvoiceMast.InvoiceID = RecieptMast.InvoiceID
SELECT       CustomerBillDetails.Amount AS TotalAmt, CustomerMast.CustomerName AS Customer, 
                      ProductMast.Product, convert(varchar,CustomerBillMast.BillDate,103) as Date, CustomerBillDetails.Quantity AS Quantity, CustomerBillDetails.Amount
FROM         CustomerBillDetails LEFT OUTER JOIN
                      CustomerBillMast ON CustomerBillDetails.BillID = CustomerBillMast.BillID LEFT OUTER JOIN
                      ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID RIGHT OUTER JOIN
                      CustomerMast ON CustomerBillDetails.CustomerId = CustomerMast.CustomerID
WHERE     (CustomerBillDetails.CustomerID = @custId)
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Customer_Ledger_by_Date]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UC_Customer_Ledger_by_Date] 
@Date datetime
AS
BEGIN
	SET NOCOUNT ON;

--SELECT distinct    SpareInvoiceMast.InvoiceDate, SpareInvoiceDtls.Quantity, (CustomerMast.Lname) as Customer, ProductMast.Product, CratesCustomer.Date, 
--                      CratesCustomer.CratesIn, CratesCustomer.CratesOut, CratesCustomer.Balance, SpareInvoiceMast.TotalAmt, RecieptMast.TotalAmt AS Expr1, 
--                      RecieptMast.CashAmt
--FROM         SpareInvoiceMast INNER JOIN
--                      SpareInvoiceDtls ON SpareInvoiceMast.InvoiceID = SpareInvoiceDtls.InvoiceID INNER JOIN
--                      CustomerMast ON SpareInvoiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
--                      CratesCustomer ON CustomerMast.CustomerID = CratesCustomer.CustomerID INNER JOIN
--                      ProductMast ON SpareInvoiceDtls.ProductID = ProductMast.ProductID INNER JOIN
--                      RecieptMast ON SpareInvoiceMast.InvoiceID = RecieptMast.InvoiceID
--where SpareInvoiceMast.InvoiceDate = @date

SELECT       CustomerBillDetails.Amount AS TotalAmt, CustomerMast.CustomerName AS Customer, 
                      ProductMast.Product, CustomerBillMast.BillDate, CustomerBillDetails.Quantity AS Quantity, CustomerBillDetails.Amount
FROM         CustomerBillDetails LEFT OUTER JOIN
                      CustomerBillMast ON CustomerBillDetails.BillID = CustomerBillMast.BillID LEFT OUTER JOIN
                      ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID RIGHT OUTER JOIN
                      CustomerMast ON CustomerBillDetails.CustomerId = CustomerMast.CustomerID
Where CustomerBillMast.BillDate =@Date 


END




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerBillDetails_DeleteAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_CustomerBillDetails_DeleteAll] 
AS Delete  
from 
CustomerBillDetails
Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerBillDetails_DeleteByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_CustomerBillDetails_DeleteByPK] 
	(
@BillDtlsID int
)
AS
Delete  from 
CustomerBillDetails 
where 
[BillDtlsID]=@BillDtlsID


Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerBillDetails_GetAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_CustomerBillDetails_GetAll] 
AS
Select 
[BillDtlsID],
[BillID],
[ProductID],
[Quantity],
[Amount]

from 
CustomerBillDetails
Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerBillDetails_Insert]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_CustomerBillDetails_Insert] 
	(
@BillID int,
@ProductID int,
@Quantity decimal,
@Amount decimal
)
AS
Insert Into 
CustomerBillDetails 
(
[BillID],
[ProductID],
[Quantity],
[Amount]
) 
values(
@BillID,
@ProductID,
@Quantity,
@Amount
)
RETURN Scope_identity()




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerBillDetails_UpdateByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_CustomerBillDetails_UpdateByPK] 
	(
@BillDtlsID int,
@BillID int,
@ProductID int,
@Quantity decimal,
@Amount decimal
)
AS
Update  CustomerBillDetails Set 
[BillID]=@BillID,
[ProductID]=@ProductID,
[Quantity]=@Quantity,
[Amount]=@Amount
 
where 
[BillDtlsID]=@BillDtlsID


Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerBillMast_DeleteAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_CustomerBillMast_DeleteAll] 
AS Delete  
from 
CustomerBillMast
Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerBillMast_DeleteByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_CustomerBillMast_DeleteByPK] 
	(
@BillID int
)
AS
Delete  from 
CustomerBillMast 
where 
[BillID]=@BillID


Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerMast_DeleteAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_CustomerMast_DeleteAll] 
AS Delete  
from 
CustomerMast
Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerMast_DeleteByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_CustomerMast_DeleteByPK] 
	(
@CustomerID int
)
AS
Delete  from 
CustomerMast 
where 
[CustomerID]=@CustomerID


Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerMast_Insert]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--UC_CustomerMast_Insert
CREATE PROCEDURE [dbo].[UC_CustomerMast_Insert] 
	(
		@CustomerName nvarchar(50),
		@Address nvarchar(350),
		@AreaID int=null,
		@Mobile nvarchar(50),
		@EmployeeId int,
		@VehicleId int
		,@isActive int,
		@BillRequired int
		--@CustomerID TINYINT OUTPUT
		,@DeliveryCharges int

	)
AS
BEGIN 
    BEGIN try 
        INSERT INTO customermast 
                    ([customername], 
                     [address], 
                     [areaid], 
                     [mobile], 
					 [SalesPersonID],
					 [VehicleID]
					 , [isBillRequired],
					 [isActive]
					 ,[DeliveryCharges]
        ) 
        VALUES      ( @CustomerName, 
                      @Address, 
                      @AreaID, 
                      @Mobile, 
					  @EmployeeId,
					  @VehicleId
					  
					  ,@BillRequired,
					  @isActive
					  ,@DeliveryCharges
        ) 
        select    Scope_identity() AS CustomerID ; 
    END try 

    BEGIN catch 
        SELECT Error_number()  AS ERROR_NUMBER, 
               Error_message() AS ERROR_MESSAGE; 
    END catch; 
END 


--BEGIN TRY
--INSERT INTO dbo.Pizza (pizzaSize, NumberOftoppings,pizzaname)
--VALUES (@PizzaSize, @NumberofToppings, @pizzaName)

--SELECT @PizzaID = SCOPE_IDENTITY();
--RETURN 0;
--END Try
--BEGIN Catch
--    RETURN -1
--END Catch





GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerRates_DeleteAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_CustomerRates_DeleteAll] 
AS Delete  
from 
CustomerRates
Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerRates_DeleteByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_CustomerRates_DeleteByPK] 
	(
@CustRateID int
)
AS
Delete  from 
CustomerRates 
where 
[CustRateID]=@CustRateID


Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerRates_GetAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_CustomerRates_GetAll] 
AS
Select 
[CustRateID],
[CustomerID],
[ProductID],
[Rate],
[StartDate],
[EndDate]

from 
CustomerRates
Return




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerRates_GetByCustomerID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--UC_CustomerRates_GetByCustomerID 1

CREATE PROCEDURE [dbo].[UC_CustomerRates_GetByCustomerID] 
	(
@CustID int
)
AS
SELECT     CustomerRates.CustRateID, CustomerRates.CustomerID, CustomerRates.ProductID, CustomerRates.Rate, ProductMast.Product
FROM         CustomerRates INNER JOIN
                      ProductMast ON CustomerRates.ProductID = ProductMast.ProductID
WHERE     (CustomerRates.CustomerID = @CustID) and EndDate='01-01-9999'


RETURN




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerRates_GetByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_CustomerRates_GetByPK] 
	(
@CustRateID int
)
AS
SELECT	 
[CustRateID],
[CustomerID],
[ProductID],
[Rate]

FROM 
CustomerRates  
WHERE 
[CustRateID]=@CustRateID


RETURN




GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerRates_Insert]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- UC_CustomerRates_Insert 1,22,39.50,'2017-06-23'
CREATE PROCEDURE [dbo].[UC_CustomerRates_Insert] 
(
@CustomerID int,
@ProductID int,
@Rate decimal(18,4),
@orderDate datetime
)
AS

Declare @OldRate decimal(18,2)
	--IF EXISTS (SELECT 1 FROM   CUSTOMERRATES WHERE  Customerid = @CustomerID AND Productid = @ProductID) 
	select @OldRate= isnull(([dbo].[udf_CusomerProductRate] (@CustomerID,@ProductID,@orderDate)),0)  

	print @OldRate
	Print @Rate

if @OldRate <> @Rate
Begin
	If @OldRate >0
	  BEGIN 
	  -- Update old rate enddate with current date 
		  UPDATE CUSTOMERRATES 
		  SET    EndDate = getdate() --dateadd(d,-1,getdate())
		  WHERE  Customerid = @CustomerID AND Productid = @ProductID and EndDate='9999-01-01'
	  -- insert new record with enddate as '9999-01-01'
		  INSERT INTO CUSTOMERRATES 
					  ([Customerid], 
					   [Productid], 
					   [Rate],
					   [StartDate],
					   [EndDate] )
		  VALUES     ( @CustomerID, 
					   @ProductID, 
					   @Rate,
					  @orderDate,
					   '9999-01-01') 
	  END 
	ELSE 
	  BEGIN 
		  INSERT INTO CUSTOMERRATES 
					  ([Customerid], 
					   [Productid], 
					   [Rate],
					    [StartDate],
						[EndDate] ) 
		  VALUES     ( @CustomerID, 
					   @ProductID, 
					   @Rate,
					   @orderDate,
					   '9999-01-01' ) 
	  END 
End








GO
/****** Object:  StoredProcedure [dbo].[UC_CustomerRates_UpdateByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_CustomerRates_UpdateByPK] 
(
@CustRateID int,
@CustomerID int,
@ProductID int,
@Rate decimal(18,3)
)
AS
Update  CustomerRates Set 
[CustomerID]=@CustomerID,
[ProductID]=@ProductID,
[Rate]=@Rate
 
where 
--[CustRateID]=@CustRateID
[CustomerID]=@CustomerID and
[ProductID]=@ProductID




Return




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteAreaMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  2 2010  5:06PM
-- Description : Delete Procedure for AreaMast
-- Exec [dbo].[UC_DeleteAreaMast] @AreaID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteAreaMast]
     @AreaID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[AreaMast]
    WHERE [AreaID] = @AreaID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteCityMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  2 2010  4:28PM
-- Description : Delete Procedure for CityMast
-- Exec [dbo].[UC_DeleteCityMast] @CityID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteCityMast]
     @CityID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[CityMast]
    WHERE [CityID] = @CityID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteCompanyProfileMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 15 2010 10:55AM
-- Description : Delete Procedure for CompanyProfileMast
-- Exec [dbo].[UC_DeleteCompanyProfileMast] 
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteCompanyProfileMast]
     
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[CompanyProfileMast]
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteCustBankInfoMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 25 2010  2:48PM
-- Description : Delete Procedure for CustBankInfoMast
-- Exec [dbo].[UC_DeleteCustBankInfoMast] @BankInfoID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteCustBankInfoMast]
     @BankInfoID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[CustBankInfoMast]
    WHERE [BankInfoID] = @BankInfoID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteCustomerComplaintDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 13 2010  5:49PM
-- Description : Delete Procedure for CustomerComplaintDtls
-- Exec [dbo].[UC_DeleteCustomerComplaintDtls] @CustomerComplntDtlID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteCustomerComplaintDtls]
     @CustomerComplntDtlID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[CustomerComplaintDtls]
    WHERE [CustomerComplntDtlID] = @CustomerComplntDtlID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteCustomerComplaintMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  2 2010 10:21AM
-- Description : Delete Procedure for CustomerComplaintMast
-- Exec [dbo].[UC_DeleteCustomerComplaintMast] 
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteCustomerComplaintMast]
    @CustomerComplaintID int 
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[CustomerComplaintMast]
where  CustomerComplaintID = @CustomerComplaintID
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteDateCountMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 18 2010  1:26PM
-- Description : Delete Procedure for DateCountMast
-- Exec [dbo].[UC_DeleteDateCountMast] @DatetimeCountID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteDateCountMast]
     @DatetimeCountID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[DateCountMast]
    WHERE [DatetimeCountID] = @DatetimeCountID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteDealerMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  3 2010  4:14PM
-- Description : Delete Procedure for DealerMast
-- Exec [dbo].[UC_DeleteDealerMast] @DealerID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteDealerMast]
     @DealerID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[DealerMast]
    WHERE [DealerID] = @DealerID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteDocPathSettingsMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 14 2010  1:58PM
-- Description : Delete Procedure for DocPathSettingsMast
-- Exec [dbo].[UC_DeleteDocPathSettingsMast] 
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteDocPathSettingsMast]
     
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[DocPathSettingsMast]
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteEmployeeMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 14 2010  2:34PM
-- Description : Delete Procedure for EmployeeMast
-- Exec [dbo].[UC_DeleteEmployeeMast] @EmployeeID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteEmployeeMast]
     @EmployeeID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[EmployeeMast]
    WHERE [EmployeeID] = @EmployeeID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteFeedBackMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 13 2010 12:51PM
-- Description : Delete Procedure for GRNMast
-- Exec [dbo].[UC_DeleteGRNMast] @GRN_ID  int
    
-- ============================================= */
Create PROCEDURE [dbo].[UC_DeleteFeedBackMast]
     @FeedBackID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM CustmorFeedbackMast
WHERE     (FeedBackID = @FeedBackID)


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteGatePassDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 24 2010 10:48AM
-- Description : Delete Procedure for GatePassDtls
-- Exec [dbo].[UC_DeleteGatePassDtls] @GatePassDtlID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteGatePassDtls]
     @GatePassID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[GatePassDtls]
    WHERE [GatePassID] = @GatePassID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteGRNDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 13 2010 12:51PM
-- Description : Delete Procedure for GRNDtls
-- Exec [dbo].[UC_DeleteGRNDtls] @GRNDtlID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteGRNDtls]
     @GRN_ID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[GRNDtls]
    WHERE [GRN_ID] = @GRN_ID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteGRNMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 13 2010 12:51PM
-- Description : Delete Procedure for GRNMast
-- Exec [dbo].[UC_DeleteGRNMast] @GRN_ID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteGRNMast]
     @GRN_ID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[GRNMast]
    WHERE [GRN_ID] = @GRN_ID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteInvoiceDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 27 2010  6:21PM
-- Description : Delete Procedure for InvoiceDtls
-- Exec [dbo].[UC_DeleteInvoiceDtls] @InvoiceDtlID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteInvoiceDtls]
     @InvoiceID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[InvoiceDtls]
    WHERE [InvoiceID] = @InvoiceID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteInVoiceMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 27 2010  6:21PM
-- Description : Delete Procedure for InVoiceMast
-- Exec [dbo].[UC_DeleteInVoiceMast] @InvoiceID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteInVoiceMast]
     @InvoiceID  int
    
AS
BEGIN


BEGIN TRY

	

    DELETE FROM [dbo].[InVoiceMast]
    WHERE [InvoiceID] = @InvoiceID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteNumberSettingsMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 14 2010  2:47PM
-- Description : Delete Procedure for NumberSettingsMast
-- Exec [dbo].[UC_DeleteNumberSettingsMast] 
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteNumberSettingsMast]
     
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[NumberSettingsMast]
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeletePartDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 13 2010  4:42PM
-- Description : Delete Procedure for PartDtls
-- Exec [dbo].[UC_DeletePartDtls] 
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeletePartDtls]
     
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[PartDtls]
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeletePayment]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : May 23 2012  2:08PM
-- Description : Delete Procedure for Payment
-- Exec [dbo].[UC_DeletePayment] @PaymentID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeletePayment]
     @PaymentID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[Payment]
    WHERE [PaymentID] = @PaymentID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteProductBrandMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Delete Procedure for ProductBrandMast
-- Exec [dbo].[UC_DeleteProductBrandMast] @ProductBrandID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteProductBrandMast]
     @ProductBrandID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[ProductBrandMast]
    WHERE [ProductBrandID] = @ProductBrandID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteProductMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Delete Procedure for ProductMast
-- Exec [dbo].[UC_DeleteProductMast] @ProductID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteProductMast]
     @ProductID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[ProductMast]
    WHERE [ProductID] = @ProductID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteProductTypeMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Delete Procedure for ProductTypeMast
-- Exec [dbo].[UC_DeleteProductTypeMast] @ProductTypeID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteProductTypeMast]
     @ProductTypeID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[ProductTypeMast]
    WHERE [ProductTypeID] = @ProductTypeID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteRecieptMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 21 2010 10:37AM
-- Description : Delete Procedure for RecieptMast
-- Exec [dbo].[UC_DeleteRecieptMast] @RecieptID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteRecieptMast]
     @RecieptID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[RecieptMast]
    WHERE [RecieptID] = @RecieptID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteServiceCallAsignMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  6 2010  5:16PM
-- Description : Delete Procedure for ServiceCallAsignMast
-- Exec [dbo].[UC_DeleteServiceCallAsignMast] @ServiceCallAsignID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteServiceCallAsignMast]
     @ServiceCallAsignID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[ServiceCallAsignMast]
    WHERE [ServiceCallAsignID] = @ServiceCallAsignID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteServiceDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 13 2010  2:42PM
-- Description : Delete Procedure for ServiceDtls
-- Exec [dbo].[UC_DeleteServiceDtls] @ServiceDtlsID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteServiceDtls]
     @ServiceDtlsID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[ServiceDtls]
    WHERE [ServiceDtlsID] = @ServiceDtlsID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteServiceMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  1 2010  5:19PM
-- Description : Delete Procedure for ServiceMast
-- Exec [dbo].[UC_DeleteServiceMast] @ServiceID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteServiceMast]
     @ServiceID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[ServiceMast]
    WHERE [ServiceID] = @ServiceID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteSpareGatePassDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 16 2010  6:17PM
-- Description : Delete Procedure for SpareGatePassDtls
-- Exec [dbo].[UC_DeleteSpareGatePassDtls] @GatePassDtlID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteSpareGatePassDtls]
     @GatePassDtlID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[SpareGatePassDtls]
    WHERE [GatePassDtlID] = @GatePassDtlID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteSpareGatePassMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 16 2010  3:04PM
-- Description : Delete Procedure for SpareGatePassMast
-- Exec [dbo].[UC_DeleteSpareGatePassMast] @GatePassID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteSpareGatePassMast]
     @GatePassID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[SpareGatePassMast]
    WHERE [GatePassID] = @GatePassID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteSpareGRNDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 15 2010  5:58PM
-- Description : Delete Procedure for Spare_GRNDtls
-- Exec [dbo].[UC_DeleteSpareGRNDtls] @GRNDtlID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteSpareGRNDtls]
     @GRNDtlID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[Spare_GRNDtls]
    WHERE [GRNDtlID] = @GRNDtlID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteSpareGRNMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 15 2010  5:57PM
-- Description : Delete Procedure for Spare_GRNMast
-- Exec [dbo].[UC_DeleteSpareGRNMast] @GRN_ID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteSpareGRNMast]
     @GRN_ID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[Spare_GRNMast]
    WHERE [GRN_ID] = @GRN_ID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteSpareInvoiceDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 20 2010  1:51PM
-- Description : Delete Procedure for SpareInvoiceDtls
-- Exec [dbo].[UC_DeleteSpareInvoiceDtls] 
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteSpareInvoiceDtls]
     
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[SpareInvoiceDtls]
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteSpareInvoiceMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 20 2010  1:12PM
-- Description : Delete Procedure for SpareInvoiceMast
-- Exec [dbo].[UC_DeleteSpareInvoiceMast] 
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteSpareInvoiceMast]
     
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[SpareInvoiceMast]
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteStockMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 16 2010  1:02PM
-- Description : Delete Procedure for StockMast
-- Exec [dbo].[UC_DeleteStockMast] @StockID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteStockMast]
     @GRN_ID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[StockMast]
    WHERE GRN_ID = @GRN_ID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeletetblPayMent]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 18 2010  3:29PM
-- Description : Delete Procedure for tblPayMent
-- Exec [dbo].[UC_DeletetblPayMent] 
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeletetblPayMent]
     
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[tblPayMent]
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteUserMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  2 2010 11:10AM
-- Description : Delete Procedure for UserMast
-- Exec [dbo].[UC_DeleteUserMast] @UserID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteUserMast]
     @UserID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[UserMast]
    WHERE [UserID] = @UserID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteUserTypeMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:32PM
-- Description : Delete Procedure for UserTypeMast
-- Exec [dbo].[UC_DeleteUserTypeMast] 
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteUserTypeMast]
     
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[UserTypeMast]
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Deletevatmast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  1 2010  5:20PM
-- Description : Delete Procedure for vatmast
-- Exec [dbo].[UC_Deletevatmast] @VatID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_Deletevatmast]
     @VatID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[vatmast]
    WHERE [VatID] = @VatID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteVehicleMast_ByPk]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 14 2010  2:34PM
-- Description : Delete Procedure for EmployeeMast
-- Exec [dbo].[UC_DeleteEmployeeMast] @EmployeeID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteVehicleMast_ByPk]
     @VechicleID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[VehicleMast]
    WHERE [VechicleID] = @VechicleID


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteVendorMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  3 2010  1:18PM
-- Description : Delete Procedure for VendorMast
-- Exec [dbo].[UC_DeleteVendorMast] @VendorID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteVendorMast]
     @VendorID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[VendorMast]
    WHERE [VendorID] = @VendorID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_DeleteVendorProducts]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Jun 29 2012  3:04PM
-- Description : Delete Procedure for VendorProducts
-- Exec [dbo].[UC_DeleteVendorProducts] @VendorProductID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_DeleteVendorProducts]
     @VendorProductID  int
    
AS
BEGIN


BEGIN TRY

    DELETE FROM [dbo].[VendorProducts]
    WHERE [VendorProductID] = @VendorProductID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_FetchDataForUpdate_AreaMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[UC_FetchDataForUpdate_AreaMast]
@AreaID int

AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     AreaMast.AreaID, AreaMast.Area,AreaMast.CityID
FROM         AreaMast where AreaID = @AreaID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_FetchDataForUpdate_ProductMaster]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[UC_FetchDataForUpdate_ProductMaster]
@ProductID int

AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     ProductID,Product,ProductBrandID,StockCount,SalePrice,CrateSize,GST
FROM         ProductMast where ProductID = @ProductID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_FetchDataForUpdate_VendorMaster]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UC_FetchDataForUpdate_VendorMaster]
@VendorID int

AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     VendorID,VendorName,Address,ContactPerson,PersonMobileNo,OfficePhone as OfficeNumber,FaxNo as FaxNumber,EmailID,IsActive,cast(0 as bigint) TenantID,cast(0 as bigint) userid
FROM         VendorMast where VendorID = @VendorID
END

GO
/****** Object:  StoredProcedure [dbo].[UC_Get_ItemCount_GRN_by_PoID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN details against PoID
-- =============================================



CREATE PROCEDURE [dbo].[UC_Get_ItemCount_GRN_by_PoID]
@PoID int 

AS
BEGIN
	
	SET NOCOUNT ON;
	
--SELECT     PurchaseOrderMast.PoID, ProductMast.Product,PurchaseOrderDetail.ProductID,PurchaseOrderDetail.Quantity as OrginalQuantity,
--IsNull((SELECT      COUNT(GRNDtls.ProductID) AS count
--FROM         GRNDtls where GRNDtls.GRN_ID = GRNMast.GRN_ID  and GRNDtls.ProductID =  PurchaseOrderDetail.ProductID
--GROUP BY  GRNDtls.GRN_ID, GRNDtls.ProductID),0) as RecieveQuanity, PurchaseOrderDetail.Quantity -
--IsNull((SELECT      COUNT(GRNDtls.ProductID) AS count
--FROM         GRNDtls where GRNDtls.GRN_ID = GRNMast.GRN_ID and GRNDtls.ProductID =  PurchaseOrderDetail.ProductID
--GROUP BY GRNDtls.GRN_ID, GRNDtls.ProductID),0) as RemainingQuanity
--FROM         PurchaseOrderMast INNER JOIN
--                      PurchaseOrderDetail ON PurchaseOrderMast.PoID = PurchaseOrderDetail.PoID INNER JOIN
--                      ProductMast ON PurchaseOrderDetail.ProductID = ProductMast.ProductID inner join 
--GRNMast on GRNMast.PoID = PurchaseOrderMast.PoID
--where PurchaseOrderMast.PoID = 3

SELECT     PurchaseOrderMast.PoID, ProductMast.Product,PurchaseOrderDetail.ProductID,PurchaseOrderDetail.Quantity as OrginalQuantity,
IsNull((SELECT     COUNT(GRNDtls.ProductID) AS count
FROM         GRNDtls INNER JOIN
                      GRNMast ON GRNDtls.GRN_ID = GRNMast.GRN_ID where GRNMast.PoID = PurchaseOrderMast.PoID and GRNDtls.ProductID =  PurchaseOrderDetail.ProductID group by  GRNDtls.ProductID ),0) as RecieveQuanity
, PurchaseOrderDetail.Quantity -
IsNull((SELECT     COUNT(GRNDtls.ProductID) AS count
FROM         GRNDtls INNER JOIN
                      GRNMast ON GRNDtls.GRN_ID = GRNMast.GRN_ID where GRNMast.PoID = PurchaseOrderMast.PoID and GRNDtls.ProductID =  PurchaseOrderDetail.ProductID group by  GRNDtls.ProductID ),0) as RemainingQuanity
FROM         PurchaseOrderMast INNER JOIN
                      PurchaseOrderDetail ON PurchaseOrderMast.PoID = PurchaseOrderDetail.PoID INNER JOIN
                      ProductMast ON PurchaseOrderDetail.ProductID = ProductMast.ProductID left outer join 
GRNMast on GRNMast.PoID = PurchaseOrderMast.PoID
where PurchaseOrderMast.PoID = @PoID
group by PurchaseOrderDetail.ProductID,PurchaseOrderMast.PoID,ProductMast.Product,PurchaseOrderDetail.Quantity


end




GO
/****** Object:  StoredProcedure [dbo].[UC_Get_ProductCount_GRN_by_PoID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN details against PoID
-- =============================================




CREATE PROCEDURE [dbo].[UC_Get_ProductCount_GRN_by_PoID]
@PoID int 

AS
BEGIN
	
	SET NOCOUNT ON;
	
--SELECT     PurchaseOrderMast.PoID, ProductMast.Product,PurchaseOrderDetail.ProductID,PurchaseOrderDetail.Quantity as OrginalQuantity,
--IsNull((SELECT      COUNT(GRNDtls.ProductID) AS count
--FROM         GRNDtls where GRNDtls.GRN_ID = GRNMast.GRN_ID  and GRNDtls.ProductID =  PurchaseOrderDetail.ProductID
--GROUP BY  GRNDtls.GRN_ID, GRNDtls.ProductID),0) as RecieveQuanity, PurchaseOrderDetail.Quantity -
--IsNull((SELECT      COUNT(GRNDtls.ProductID) AS count
--FROM         GRNDtls where GRNDtls.GRN_ID = GRNMast.GRN_ID and GRNDtls.ProductID =  PurchaseOrderDetail.ProductID
--GROUP BY GRNDtls.GRN_ID, GRNDtls.ProductID),0) as RemainingQuanity
--FROM         PurchaseOrderMast INNER JOIN
--                      PurchaseOrderDetail ON PurchaseOrderMast.PoID = PurchaseOrderDetail.PoID INNER JOIN
--                      ProductMast ON PurchaseOrderDetail.ProductID = ProductMast.ProductID inner join 
--GRNMast on GRNMast.PoID = PurchaseOrderMast.PoID
--where PurchaseOrderMast.PoID = 3

SELECT     PurchaseOrderMast.PoID, ProductMast.Product,PurchaseOrderDetail.ProductID,PurchaseOrderDetail.Quantity as OrginalQuantity,
IsNull((SELECT     COUNT(GRNDtls.ProductID) AS count
FROM         GRNDtls INNER JOIN
                      GRNMast ON GRNDtls.GRN_ID = GRNMast.GRN_ID where GRNMast.PoID = PurchaseOrderMast.PoID and GRNDtls.ProductID =  PurchaseOrderDetail.ProductID group by  GRNDtls.ProductID ),0) as RecieveQuanity
, PurchaseOrderDetail.Quantity -
IsNull((SELECT     COUNT(GRNDtls.ProductID) AS count
FROM         GRNDtls INNER JOIN
                      GRNMast ON GRNDtls.GRN_ID = GRNMast.GRN_ID where GRNMast.PoID = PurchaseOrderMast.PoID and GRNDtls.ProductID =  PurchaseOrderDetail.ProductID group by  GRNDtls.ProductID ),0) as RemainingQuanity
FROM         PurchaseOrderMast INNER JOIN
                      PurchaseOrderDetail ON PurchaseOrderMast.PoID = PurchaseOrderDetail.PoID INNER JOIN
                      ProductMast ON PurchaseOrderDetail.ProductID = ProductMast.ProductID left outer join 
GRNMast on GRNMast.PoID = PurchaseOrderMast.PoID
where PurchaseOrderMast.PoID = @PoID
group by PurchaseOrderDetail.ProductID,PurchaseOrderMast.PoID,ProductMast.Product,PurchaseOrderDetail.Quantity

--SELECT     ProductMast.Product, (Spare_PurchaseOrderDetail.Quantity)as ActualQuantity, Spare_GRNDtls.Quantity AS RecievedQuantity
--
--			,(Spare_PurchaseOrderDetail.Quantity-(Select sum(Spare_GRNDtls.Quantity) from Spare_GRNDtls 
--              where Spare_GRNDtls.GRN_ID = Spare_GRNMast.GRN_ID)) as RemainingQuantity 
--FROM         ProductMast INNER JOIN
--                      Spare_PurchaseOrderDetail ON ProductMast.ProductID = Spare_PurchaseOrderDetail.ProductID INNER JOIN
--                      Spare_PurchaseOrderMast ON Spare_PurchaseOrderDetail.PoID = Spare_PurchaseOrderMast.PoID INNER JOIN
--                      Spare_GRNDtls ON ProductMast.ProductID = Spare_GRNDtls.ProductID INNER JOIN
--                      Spare_GRNMast ON Spare_PurchaseOrderMast.PoID = Spare_GRNMast.PoID AND Spare_GRNDtls.GRN_ID = Spare_GRNMast.GRN_ID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_GetNextAutogenerateNumber_By_DocID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  3 2010  4:14PM
-- Description : Delete Procedure for DealerMast
-- Exec [dbo].[UC_DeleteDealerMast] @DealerID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_GetNextAutogenerateNumber_By_DocID]
     @DocID int
    
AS
BEGIN


BEGIN TRY
declare @prefix varchar(10);
declare @StartNumber int;
declare @returnNumber int;
set @prefix=(select prefix from NumberSettingsMast where DocID=@DocID)
set @StartNumber=(select StartNumber  from NumberSettingsMast where DocID=@DocID)


set @returnNumber =(select max(subString(CustomerComplaintMast.ComplaintNo,4,10))+1 as MaxNumber 
from CustomerComplaintMast 
where (subString(CustomerComplaintMast.ComplaintNo,1,3))=@prefix)

if(isnull(@returnNumber,0)!=0)
begin
select @prefix+convert(varchar(50),@returnNumber) as NewNumber
end
else
begin

select @prefix+convert(varchar(50),@StartNumber) as NewNumber

end


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as NewNumber,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertAreaMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Vinoad Sabbade
-- Create date : Sep  2 2010  5:06PM
-- Description : Insert Procedure for AreaMast
-- Exec [dbo].[UC_InsertAreaMast] [Area],[CityID],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertAreaMast]
     @Area  nvarchar(50)
    ,@CityID  int
    
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[AreaMast]
    ( 
         [Area]
        ,[CityID]
        
    )
    VALUES
    (
         @Area
        ,1
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertCityMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  2 2010  4:28PM
-- Description : Insert Procedure for CityMast
-- Exec [dbo].[UC_InsertCityMast] [CityName],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertCityMast]
     @CityName  varchar(50)
    ,@CreatedBy  int
    
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[CityMast]
    ( 
         [CityName]
        ,[CreatedBy]
        ,[CreateDate]
        ,[LastUpdatedDate]
        ,[LastUpdatedBy]
        
    )
    VALUES
    (
         @CityName
        ,@CreatedBy
        ,getdate()
        ,getdate()
        ,@CreatedBy
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertCompanyProfileMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 15 2010 10:55AM
-- Description : Insert Procedure for CompanyProfileMast
-- Exec [dbo].[UC_InsertCompanyProfileMast] [Name],[Nickname],[Address1],[Address2],[Address3],[Phone],[Mobile],[LogoFile]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertCompanyProfileMast]
     @Name  nvarchar(max)
    ,@Nickname  nvarchar(max)
    ,@Address1  nvarchar(max)
    ,@Address2  nvarchar(max)
    ,@Address3  nvarchar(max)
    ,@Phone  nvarchar(max)
    ,@Mobile  nvarchar(max)
    ,@LogoFile  nvarchar(max)
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[CompanyProfileMast]
    ( 
         [Name]
        ,[Nickname]
        ,[Address1]
        ,[Address2]
        ,[Address3]
        ,[Phone]
        ,[Mobile]
        ,[LogoFile]
        
    )
    VALUES
    (
         @Name
        ,@Nickname
        ,@Address1
        ,@Address2
        ,@Address3
        ,@Phone
        ,@Mobile
        ,@LogoFile
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertComplaintDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 16 2010  1:02PM
-- Description : Insert Procedure for StockMast
-- Exec [dbo].[UC_InsertStockMast] [GRN_ID],[ProductID],[SerialNo],[IsOccupied]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertComplaintDtls]
 @CustomerComplaintID int
,@ServicePersonID int 
,@ActualComplaintDate datetime
,@ComplaintDoneDate datetime
,@Remark nvarchar(MAX)
,@Document nvarchar(MAX)
    
AS
BEGIN

BEGIN TRY

    INSERT INTO CustomerComplaintDtls
   (CustomerComplaintID
, ServicePersonID
, ActualComplaintDate
, ComplaintDoneDate
, Remark
, [Document]
, CreateDate)
VALUES     
(@CustomerComplaintID
,@ServicePersonID
,@ActualComplaintDate
,@ComplaintDoneDate
,@Remark
,@Document
, GETDATE())

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertCratesCustomer]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Vinod Sabade
-- Create date : 17/02/2017
-- Description : Insert Procedure for CratesCustomer
-- Exec [dbo].[UC_InsertCratesCustomer] [CustomerID],[Date],[CratesIn],[CratesOut],[Balance]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertCratesCustomer]
     @CustomerID  int
    ,@BillId int
	,@BillDate  datetime
    ,@CratesIn  int =0
    ,@CratesOut  int
	--,@Balance int


    
AS
BEGIN

BEGIN TRY


		IF  EXISTS (SELECT 1 FROM   CratesCustomer WHERE  CustomerID  = @CustomerID   AND BillID = @BillID) 
		  BEGIN 

		  Update CratesCustomer 
		  Set	 [CratesOut] = @CratesOut,
				 [CratesIn]=@CratesIn,
				 [Balance]=@CratesOut - @CratesIn,
				 [LastUpdatedDate]=@BillDate
		  Where  CustomerID  = @CustomerID   AND BillID = @BillID
		  End

		Else

			Begin
					INSERT INTO [dbo].[CratesCustomer]
					( 
						 [CustomerID]
						,[BillId]
						,[Date]
						,[CratesIn]
						,[CratesOut]
						,[Balance]
						,[LastUpdatedDate]
					)
					VALUES
					(
						 @CustomerID
						,@BillId
						,@BillDate
						,@CratesIn
						,@CratesOut
						,@CratesOut - @CratesIn
						,@BillDate
					)

			End
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertCustBankInfoMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 25 2010  2:48PM
-- Description : Insert Procedure for CustBankInfoMast
-- Exec [dbo].[UC_InsertCustBankInfoMast] [CustID],[BankName],[BranchAddress],[AccNo]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertCustBankInfoMast]
     @CustID  int
    ,@BankName  nvarchar(max)
    ,@BranchAddress  nvarchar(max)
    ,@AccNo  varchar(50)
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[CustBankInfoMast]
    ( 
         [CustID]
        ,[BankName]
        ,[BranchAddress]
        ,[AccNo]
        
    )
    VALUES
    (
         @CustID
        ,@BankName
        ,@BranchAddress
        ,@AccNo
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertCustomerComplaintDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 13 2010  5:49PM
-- Description : Insert Procedure for CustomerComplaintDtls
-- Exec [dbo].[UC_InsertCustomerComplaintDtls] [CustomerComplaintID],[ServicePersonID],[ActualComplaintDate],[ComplaintDoneDate],[Remark],[Document],[NetAmount],[VatPercent],[VatAmount],[TaxPercent],[TaxAmount],[ServiceCharge],[TotalAmount],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertCustomerComplaintDtls]
     @CustomerComplaintID  int
    ,@ServicePersonID  int
    ,@ActualComplaintDate  datetime
    ,@ComplaintDoneDate  datetime
    ,@Remark  nvarchar(150)
    ,@Document  nvarchar(max)
    ,@NetAmount  decimal
    ,@VatPercent  decimal
    ,@VatAmount  decimal
    ,@TaxPercent  decimal
    ,@TaxAmount  decimal
    ,@ServiceCharge  decimal
    ,@TotalAmount  decimal
    
    ,@ServiceCallAsignID int
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[CustomerComplaintDtls]
    ( 
         [CustomerComplaintID]
        ,[ServicePersonID]
        ,[ActualComplaintDate]
        ,[ComplaintDoneDate]
        ,[Remark]
        ,[Document]
        ,[NetAmount]
        ,[VatPercent]
        ,[VatAmount]
        ,[TaxPercent]
        ,[TaxAmount]
        ,[ServiceCharge]
        ,[TotalAmount]
        ,[CreateDate]
        
    )
    VALUES
    (
         @CustomerComplaintID
        ,@ServicePersonID
        ,@ActualComplaintDate
        ,@ComplaintDoneDate
        ,@Remark
        ,@Document
        ,@NetAmount
        ,@VatPercent
        ,@VatAmount
        ,@TaxPercent
        ,@TaxAmount
        ,@ServiceCharge
        ,@TotalAmount
        ,getdate()
        
    )
declare @ScopeIdentity int

set @ScopeIdentity =(select scope_identity())

 UPDATE [dbo].[ServiceCallAsignMast]
    SET 
       
        
        
       [IsClose] = 1,
CallCompletedDate=@ComplaintDoneDate,
     ServicePersonID=   @ServicePersonID
        
    WHERE ServiceCallAsignID = @ServiceCallAsignID 


update CustomerComplaintMast set IsClose=1 where CustomerComplaintID=@CustomerComplaintID

select @ScopeIdentity as CustomerComplntDtlID,'inserted' as ERROR_MESSAGE



END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertCustomerComplaintMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  2 2010 10:21AM
-- Description : Insert Procedure for CustomerComplaintMast
-- Exec [dbo].[UC_InsertCustomerComplaintMast] [CustomerComplaintID],[CustomerID],[ProductID],[SerialNo],[Descriptn],[ComplaintDate],[CreatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertCustomerComplaintMast]
     
	 @CustomerID  int
    ,@ProductID  int
    ,@SerialNo  nvarchar(50)
    ,@Descriptn  nvarchar(max)
    ,@ComplaintDate  datetime
    ,@CreatedBy  int
    ,@ComplaintNo varchar(50)
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[CustomerComplaintMast]
    ( 
         
        [CustomerID]
        ,[ProductID]
        ,[SerialNo]
        ,[Descriptn]
        ,[ComplaintDate]
        ,[CreatedBy]
        ,[ComplaintNo]
    )
    VALUES
    (
         
         @CustomerID
        ,@ProductID
        ,@SerialNo
        ,@Descriptn
        ,@ComplaintDate
        ,@CreatedBy
,@ComplaintNo
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertDateCountMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 18 2010  1:26PM
-- Description : Insert Procedure for DateCountMast
-- Exec [dbo].[UC_InsertDateCountMast] [DateCount]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertDateCountMast]
     @DateCount  int
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[DateCountMast]
    ( 
         [DateCount]
        
    )
    VALUES
    (
         @DateCount
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertDealerMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  3 2010  4:14PM
-- Description : Insert Procedure for DealerMast
-- Exec [dbo].[UC_InsertDealerMast] [DealerName],[Address],[AreaID],[CityID],[EmailID],[OfficePhone],[FaxNo],[ContactPerson],[PersonMobileNo],[IsActive],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertDealerMast]
     @DealerName  varchar(50)
    ,@Address  nvarchar(250)
    ,@AreaID  int
    ,@CityID  int
    ,@EmailID  nvarchar(50)
    ,@OfficePhone  nvarchar(50)
    ,@FaxNo  nvarchar(50)
    ,@ContactPerson  varchar(50)
    ,@PersonMobileNo  varchar(20)
    ,@IsActive  bit
    ,@CreatedBy  int

    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[DealerMast]
    ( 
         [DealerName]
        ,[Address]
        ,[AreaID]
        ,[CityID]
        ,[EmailID]
        ,[OfficePhone]
        ,[FaxNo]
        ,[ContactPerson]
        ,[PersonMobileNo]
        ,[IsActive]
        ,[CreatedBy]
        ,[CreateDate]
        ,[LastUpdatedDate]
        ,[LastUpdatedBy]
        
    )
    VALUES
    (
         @DealerName
        ,@Address
        ,@AreaID
        ,@CityID
        ,@EmailID
        ,@OfficePhone
        ,@FaxNo
        ,@ContactPerson
        ,@PersonMobileNo
        ,@IsActive
        ,@CreatedBy
        ,getdate()
        ,getdate()
        ,@CreatedBy
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertDocPathSettingsMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 14 2010  1:58PM
-- Description : Insert Procedure for DocPathSettingsMast
-- Exec [dbo].[UC_InsertDocPathSettingsMast] [DocID],[DocType],[Path]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertDocPathSettingsMast]
     @DocID  int
    ,@DocType  varchar(50)
    ,@Path  nvarchar(max)
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[DocPathSettingsMast]
    ( 
         [DocID]
        ,[DocType]
        ,[Path]
        
    )
    VALUES
    (
         @DocID
        ,@DocType
        ,@Path
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertGatePassDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 24 2010 10:48AM
-- Description : Insert Procedure for GatePassDtls
-- Exec [dbo].[UC_InsertGatePassDtls] [GatePassID],[ProductID],[SerialNo],[PerUnitPrice]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertGatePassDtls]
     @GatePassID  int
    ,@ProductID  int
    ,@SerialNo  nvarchar(50)
    ,@PerUnitPrice  decimal(18,2)
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[GatePassDtls]
    ( 
         [GatePassID]
        ,[ProductID]
        ,[SerialNo]
        ,[PerUnitPrice]
        
    )
    VALUES
    (
         @GatePassID
        ,@ProductID
        ,@SerialNo
        ,@PerUnitPrice
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertGatePassMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 24 2010 10:48AM
-- Description : Insert Procedure for GatePassMast
-- Exec [dbo].[UC_InsertGatePassMast] [GatePassNumb],[OwnerID],[OwnerType],[IssueDate],[IssuedBy],[TotalOutStandingAmt],[CreatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertGatePassMast]
     @GatePassNumb  nvarchar(50)
    ,@OwnerID  int
    ,@OwnerType  char(1)
    ,@IssueDate  datetime
    ,@IssuedBy  int
    ,@TotalOutStandingAmt  decimal(18,2)
    ,@CreatedBy  int
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[GatePassMast]
    ( 
         [GatePassNumb]
        ,[OwnerID]
        ,[OwnerType]
        ,[IssueDate]
        ,[IssuedBy]
        ,[TotalOutStandingAmt]
        ,[CreatedBy]
        
    )
    VALUES
    (
         @GatePassNumb
        ,@OwnerID
        ,@OwnerType
        ,@IssueDate
        ,@IssuedBy
        ,@TotalOutStandingAmt
        ,@CreatedBy
        
    )
select scope_identity() as GatePassID,'inserted' as MESSAGEs

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as MESSAGEs;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertGRNDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 13 2010 12:51PM
-- Description : Insert Procedure for GRNDtls
-- Exec [dbo].[UC_InsertGRNDtls] [GRN_ID],[ProductID],[SerialNo],[Quantity]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertGRNDtls]
     @GRN_ID  int
    ,@ProductID  int
    ,@SerialNo  nvarchar(50)
    ,@Quantity  int
    ,@PoID int
AS
BEGIN

BEGIN TRY
 declare @perunitPrice decimal(18,2)

set @perunitPrice= (SELECT      MRP
FROM         PurchaseOrderDetail
where PoID=@PoID and  ProductID=@ProductID)

    INSERT INTO [dbo].[GRNDtls]
    ( 
         [GRN_ID]
        ,[ProductID]
        ,[SerialNo]
        ,[Quantity]
        ,[PerUnitPrice]
    )
    VALUES
    (
         @GRN_ID
        ,@ProductID
        ,@SerialNo
        ,@Quantity
        ,@perunitPrice
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertGRNMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 13 2010 12:51PM
-- Description : Insert Procedure for GRNMast
-- Exec [dbo].[UC_InsertGRNMast] [PoID],[GRN_No],[RecieveDate],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertGRNMast]
     @PoID  int
    ,@GRN_No  nvarchar(50)
    ,@RecieveDate  datetime
    ,@CreatedBy  int
    ,@LastUpdatedBy int

    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[GRNMast]
    ( 
         [PoID]
        ,[GRN_No]
        ,[RecieveDate]
        ,[CreatedBy]
        ,[CreateDate]
        ,[LastUpdatedDate]
        ,[LastUpdatedBy]
        
    )
    VALUES
    (
         @PoID
        ,@GRN_No
        ,@RecieveDate
        ,@CreatedBy
        ,getdate()
        ,getdate()
        ,@LastUpdatedBy
        
    )
select scope_identity() as GRN_ID,'inserted' as MESSAGEs
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as MESSAGEs;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertInvoiceDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 27 2010  6:21PM
-- Description : Insert Procedure for InvoiceDtls
-- Exec [dbo].[UC_InsertInvoiceDtls] [InvoiceID],[GatePassID],[ProductID],[SerialNo],[ActualPrice],[SoldPrice]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertInvoiceDtls]
     @InvoiceID  int
    ,@GatePassID  int
    ,@ProductID  int
    ,@SerialNo  nvarchar(50)
    ,@ActualPrice  decimal(18,2)
    ,@SoldPrice  decimal(18,2)
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[InvoiceDtls]
    ( 
         [InvoiceID]
        ,[GatePassID]
        ,[ProductID]
        ,[SerialNo]
        ,[ActualPrice]
        ,[SoldPrice]
        
    )
    VALUES
    (
         @InvoiceID
        ,@GatePassID
        ,@ProductID
        ,@SerialNo
        ,@ActualPrice
        ,@SoldPrice
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertInVoiceMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 27 2010  6:21PM
-- Description : Insert Procedure for InVoiceMast
-- Exec [dbo].[UC_InsertInVoiceMast] [InvoiceNumber],[InvoiceDate],[CustomerID],[OwnerID],[OwnerType],[IsWaranty],[TotalAmt],[NetAmt],[VatAmt],[VatPercent],[PaymentModeID],[ChequeNo],[ChequeDate],[BankName],[CreatedBy],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertInVoiceMast]
     @InvoiceNumber  nvarchar(50)
    ,@InvoiceDate  datetime
    ,@CustomerID  int
    ,@OwnerID  int
    ,@OwnerType  char(1)
    ,@IsWaranty  bit
    ,@TotalAmt  decimal(18,2)
    ,@NetAmt  decimal(18,2)
    ,@VatAmt  decimal(18,2)
    ,@VatPercent  decimal(18,2)
    ,@PaymentModeID  int
    ,@ChequeNo  nvarchar(50)
    ,@ChequeDate  datetime
    ,@BankName  varchar(50)
    ,@CreatedBy  int
   
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[InVoiceMast]
    ( 
         [InvoiceNumber]
        ,[InvoiceDate]
        ,[CustomerID]
        ,[OwnerID]
        ,[OwnerType]
        ,[IsWaranty]
        ,[TotalAmt]
        ,[NetAmt]
        ,[VatAmt]
        ,[VatPercent]
        ,[PaymentModeID]
        ,[ChequeNo]
        ,[ChequeDate]
        ,[BankName]
        ,[CreatedBy]
        ,[CreateDate]
        
    )
    VALUES
    (
         @InvoiceNumber
        ,@InvoiceDate
        ,@CustomerID
        ,@OwnerID
        ,@OwnerType
        ,@IsWaranty
        ,@TotalAmt
        ,@NetAmt
        ,@VatAmt
        ,@VatPercent
        ,@PaymentModeID
        ,@ChequeNo
        ,@ChequeDate
        ,@BankName
        ,@CreatedBy
        ,getdate()
        
    )
select scope_identity() as InvoiceID,'inserted' as MESSAGEs

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertNumberSettingsMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 14 2010  2:47PM
-- Description : Insert Procedure for NumberSettingsMast
-- Exec [dbo].[UC_InsertNumberSettingsMast] [DocID],[DocType],[Prefix],[StartNumber]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertNumberSettingsMast]
     @DocID  int
    ,@DocType  varchar(50)
    ,@Prefix  varchar(50)
    ,@StartNumber  int
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[NumberSettingsMast]
    ( 
         [DocID]
        ,[DocType]
        ,[Prefix]
        ,[StartNumber]
        
    )
    VALUES
    (
         @DocID
        ,@DocType
        ,@Prefix
        ,@StartNumber
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertPartDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 13 2010  4:42PM
-- Description : Insert Procedure for PartDtls
-- Exec [dbo].[UC_InsertPartDtls] [ServiceDtlsID],[ParID],[Quantity],[PerUnitPrice],[TotalAmount]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertPartDtls]
     @ServiceDtlsID  int
    ,@ParID  int
    ,@Quantity  int
    ,@PerUnitPrice  decimal
    ,@TotalAmount  decimal
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[PartDtls]
    ( 
         [ServiceDtlsID]
        ,[ParID]
        ,[Quantity]
        ,[PerUnitPrice]
        ,[TotalAmount]
        
    )
    VALUES
    (
         @ServiceDtlsID
        ,@ParID
        ,@Quantity
        ,@PerUnitPrice
        ,@TotalAmount
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertPartDtlsComplaint]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 13 2010  4:42PM
-- Description : Insert Procedure for PartDtls
-- Exec [dbo].[UC_InsertPartDtls] [ServiceDtlsID],[ParID],[Quantity],[PerUnitPrice],[TotalAmount]
-- ============================================= */
create PROCEDURE [dbo].[UC_InsertPartDtlsComplaint]
     @CustomerComplntDtlID  int
    ,@ParID  int
    ,@Quantity  int
    ,@PerUnitPrice  decimal
    ,@TotalAmount  decimal
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[PartDtlsComplaint]
    ( 
         [CustomerComplntDtlID]
        ,[ParID]
        ,[Quantity]
        ,[PerUnitPrice]
        ,[TotalAmount]
        
    )
    VALUES
    (
         @CustomerComplntDtlID
        ,@ParID
        ,@Quantity
        ,@PerUnitPrice
        ,@TotalAmount
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertPayment]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : May 23 2012  2:08PM
-- Description : Insert Procedure for Payment
-- Exec [dbo].[UC_InsertPayment] [PaymentMode],[VoucherNo],[VoucherDate],[BankID],[Amount],[ChequeAmt],[ChequeNo],[ChequeDate],[Narration],[PartyID]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertPayment]
     @PaymentMode  int
    ,@VoucherNo  int
    ,@VoucherDate  datetime
    ,@BankID  int
    ,@Amount  money
    ,@ChequeAmt  decimal
    ,@ChequeNo  varchar(20)
    ,@ChequeDate  datetime
    ,@Narration  varchar(150)
    ,@PartyID  int
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[Payment]
    ( 
         [PaymentMode]
        ,[VoucherNo]
        ,[VoucherDate]
        ,[BankID]
        ,[Amount]
        ,[ChequeAmt]
        ,[ChequeNo]
        ,[ChequeDate]
        ,[Narration]
        ,[PartyID]
        
    )
    VALUES
    (
         @PaymentMode
        ,@VoucherNo
        ,@VoucherDate
        ,@BankID
        ,@Amount
        ,@ChequeAmt
        ,@ChequeNo
        ,@ChequeDate
        ,@Narration
        ,@PartyID
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertProductBrandMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Insert Procedure for ProductBrandMast
-- Exec [dbo].[UC_InsertProductBrandMast] [BrandName],[CreateDate],[CreatedBy],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertProductBrandMast]
     
--@ProductTypeID int
--,
@BrandName  varchar(50)
    
    ,@CreatedBy  int
    
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[ProductBrandMast]
--    ( [ProductTypeID]
--,
       (  [BrandName]
        ,[CreateDate]
        ,[CreatedBy]
        ,[LastUpdatedDate]
        ,[LastUpdatedBy]
        
    )
    VALUES
    (
--@ProductTypeID,
         @BrandName
        ,getdate()
        ,@CreatedBy
        ,getdate()
        ,@CreatedBy
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertProductMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Feb 10 2012  5:34PM
-- Description : Insert Procedure for ProductMast
-- Exec [dbo].[UC_InsertProductMast] [Product],[ProductBrandID],[PurchasePrice],[SalePrice],[StockCount],[CreateDate],[CreatedBy],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
--UC_InsertProductMast 'Cow' ,'1',0,'0',12,2.2
CREATE PROCEDURE [dbo].[UC_InsertProductMast]
     @Product  nvarchar(50)
    ,@ProductBrandID  int =0 
    ,@StockCount int 
	,@SalePrice  decimal(18,2)=null
    ,@CrateSize  int=10
	,@GST Decimal(9,2)
    
AS
BEGIN
Declare @id bigint ,@GlobalID NVARCHAR(12)
BEGIN TRY

    INSERT INTO [dbo].[ProductMast]
    ( 
         [Product]
        ,[ProductBrandID]
        ,[StockCount]
        ,[SalePrice]
        ,[CreateDate]
        ,[CrateSize]
        ,[LastUpdatedDate]
        ,[LastUpdatedBy]
		,[GST] 
        
    )
    VALUES
    (
         @Product
        ,@ProductBrandID
        ,@StockCount
        ,@SalePrice
        ,getdate()
        ,@CrateSize
        ,getdate()
        ,1
		,@GST
         
    )
	SET @id  =@@identity 
	
	

	-- SELECT @id
	SET @GlobalID =( select Cast(TenantID as nvarchar(10))+'_'+Cast(@id as nvarchar(10)) from mDistributor.dbo.tenants where dbname=DB_name())
	 
	
	 Update ProductMast set 
	 GlobalID = @GlobalID
	 where productid=@id

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

 
END
 




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertProductTypeMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Insert Procedure for ProductTypeMast
-- Exec [dbo].[UC_InsertProductTypeMast] [ProductType],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertProductTypeMast]
     @ProductType  varchar(50),
@FrequencyInMonth int,
@NumberOFService int



    ,@CreatedBy  int
   
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[ProductTypeMast]
    ( 
         [ProductType],
[FrequencyInMonth],
[NumberOFService]

        ,[CreatedBy]
        ,[CreateDate]
        ,[LastUpdatedDate]
        ,[LastUpdatedBy]
        
    )
    VALUES
    (
         @ProductType
,@FrequencyInMonth
,@NumberOFService 

        ,@CreatedBy
        ,getdate()
        ,getdate()
        ,@CreatedBy
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertRecieptMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 20 2010  2:32PM
-- Description : Insert Procedure for RecieptMast
-- Exec [dbo].[UC_InsertRecieptMast] [PartyType],[PartyID],[against],[voucherNo],[CustomerID],[against_RecID],[RecieptAmt],[RecieptDate],[Comment],[PaymentModeID],[CashAmt],[ChequeAmt],[ChequeNo],[ChequeDate],[BankName],[ChequeStatus],[Remark],[ClearedDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertRecieptMast]
     @PartyType  char(10)
    ,@PartyID  int
    ,@against  char(10)
    ,@voucherNo  varchar(50)
    ,@CustomerID  int
    ,@InvoiceID  int
    ,@TotalAmt  decimal(18,2)
    ,@RecieptDate  datetime
    ,@Comment  varchar(50)
    ,@PaymentModeID  varchar(50)
    ,@CashAmt  decimal(18,2)
    ,@ChequeAmt  decimal(18,2)
    ,@ChequeNo  nvarchar(50)
    ,@ChequeDate  datetime
    ,@BankName  varchar(50)
    ,@ChequeStatus  bit

    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[RecieptMast]
    ( 
         [PartyType]
        ,[PartyID]
        ,[against]
        ,[voucherNo]
        ,[CustomerID]
        ,[InvoiceID]
        ,[TotalAmt]
        ,[RecieptDate]
        ,[Comment]
        ,[PaymentModeID]
        ,[CashAmt]
        ,[ChequeAmt]
        ,[ChequeNo]
        ,[ChequeDate]
        ,[BankName]
        ,[ChequeStatus]
        
    )
    VALUES
    (
         @PartyType
        ,@PartyID
        ,@against
        ,@voucherNo
        ,@CustomerID
        ,@InvoiceID
        ,@TotalAmt
        ,@RecieptDate
        ,@Comment
        ,@PaymentModeID
        ,@CashAmt
        ,@ChequeAmt
        ,@ChequeNo
        ,@ChequeDate
        ,@BankName
        ,@ChequeStatus
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertServiceCallAsignMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  6 2010  5:16PM
-- Description : Insert Procedure for ServiceCallAsignMast
-- Exec [dbo].[UC_InsertServiceCallAsignMast] [CallType],[RecordID],[CallDate],[CallCompletedDate],[ServicePersonID],[IsClose],[assignedBy],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertServiceCallAsignMast]
     @CallType  varchar(50)
    ,@RecordID  int
    ,@CallDate  datetime
    
    ,@ServicePersonID  int
    
    ,@assignedBy  int
   
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[ServiceCallAsignMast]
    ( 
         [CallType]
        ,[RecordID]
        ,[CallDate]
        
        ,[ServicePersonID]
        
        ,[assignedBy]
        ,[CreateDate]
        
    )
    VALUES
    (
         @CallType
        ,@RecordID
        ,@CallDate
       
        ,@ServicePersonID
        
        ,@assignedBy
        ,getdate()
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertServiceDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 13 2010  2:44PM
-- Description : Insert Procedure for ServiceDtls
-- Exec [dbo].[UC_InsertServiceDtls] [ServiceID],[ServiceTypeID],[ServiceNumb],[ServicePersonID],[ActualServiceDate],[ServiceDoneDate],[Remark],[Document],[NetAmount],[VatPercent],[VatAmount],[TaxPercent],[TaxAmount],[ServiceCharge],[TotalAmount]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertServiceDtls]
     @ServiceID  int
    ,@ServiceTypeID  int
    ,@ServiceNumb  int
    ,@ServicePersonID  int
    ,@ActualServiceDate  datetime
    ,@ServiceDoneDate  datetime
    ,@Remark  nvarchar(150)
    ,@Document  nvarchar(max)
    ,@NetAmount  decimal(18,0)
    ,@VatPercent  decimal(18,0)
    ,@VatAmount  decimal(18,0)
    ,@TaxPercent  decimal(18,0)
    ,@TaxAmount  decimal(18,0)
    ,@ServiceCharge  decimal(18,0)
    ,@TotalAmount  decimal(18,0)
    ,@ServiceCallAsignID int
AS
BEGIN


begin transaction trans
BEGIN TRY
    INSERT INTO [dbo].[ServiceDtls]
    ( 
         [ServiceID]
        ,[ServiceTypeID]
        ,[ServiceNumb]
        ,[ServicePersonID]
        ,[ActualServiceDate]
        ,[ServiceDoneDate]
        ,[Remark]
        ,[Document]
        ,[NetAmount]
        ,[VatPercent]
        ,[VatAmount]
        ,[TaxPercent]
        ,[TaxAmount]
        ,[ServiceCharge]
        ,[TotalAmount]
        
    )
    VALUES
    (
         @ServiceID
        ,@ServiceTypeID
        ,@ServiceNumb
        ,@ServicePersonID
        ,@ActualServiceDate
        ,@ServiceDoneDate
        ,@Remark
        ,@Document
        ,@NetAmount
        ,@VatPercent
        ,@VatAmount
        ,@TaxPercent
        ,@TaxAmount
        ,@ServiceCharge
        ,@TotalAmount
        
    )

declare @ScopeIdentity int

set @ScopeIdentity =(select scope_identity())

 UPDATE [dbo].[ServiceCallAsignMast]
    SET 
       
        
        
       [IsClose] = 1,
CallCompletedDate=@ServiceDoneDate,
     ServicePersonID=   @ServicePersonID
        
    WHERE ServiceCallAsignID = @ServiceCallAsignID 




declare @FreuencyInMonth int

set @FreuencyInMonth =(select FreuencyInMonth from ServiceMast where ServiceID=@ServiceID)


declare @contractEnddate datetime


set @contractEnddate=(select ServiceEndDate from ServiceMast where ServiceID=@ServiceID)

declare @updatedate datetime

set @updatedate =( select dateadd(month,@FreuencyInMonth,(select NxtServiceDate from ServiceMast where ServiceID=@ServiceID)))


--select datediff(day,@contractEnddate,@updatedate),@contractEnddate,@updatedate


IF (datediff(day,@contractEnddate,@updatedate)<=0)
  BEGIN
     update ServiceMast set NxtServiceDate=@updatedate where ServiceID=@ServiceID
  ENd
ELSe
  BEGIN
   update ServiceMast set NxtServiceDate=@contractEnddate where ServiceID=@ServiceID
  END








commit transaction trans;
select @ScopeIdentity as ServiceDetailID,'inserted' as ERROR_MESSAGE
END TRY

    BEGIN CATCH
rollback transaction trans;
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertServiceMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  1 2010  5:19PM
-- Description : Insert Procedure for ServiceMast
-- Exec [dbo].[UC_InsertServiceMast] [ServiceTypeID],[CustomerID],[ProductID],[SerialNo],[PurchaseDate],[NxtServiceDate],[NoOfService],[ServiceEndDate],[IsClose]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertServiceMast]
     @ServiceTypeID  int
    ,@CustomerID  int
    ,@ProductID  int
    ,@SerialNo  nvarchar(50)
    ,@PurchaseDate  datetime
    ,@NxtServiceDate  datetime
    ,@NoOfService  int
    ,@ServiceEndDate  datetime
    ,@IsClose  bit
    
AS
BEGIN

BEGIN TRY
--declare recCount int
--set recCount =(select count(ServiceID) from ServiceMast where ProductID=@ProductID and SerialNo=@SerialNo)
if ((select count(ServiceID) from ServiceMast where ProductID=@ProductID and SerialNo=@SerialNo)<=0)
begin
    INSERT INTO [dbo].[ServiceMast]
    ( 
         [ServiceTypeID]
        ,[CustomerID]
        ,[ProductID]
        ,[SerialNo]
        ,[PurchaseDate]
        ,[NxtServiceDate]
        ,[NoOfService]
        ,[ServiceEndDate]
        ,[IsClose]
        
    )
    VALUES
    (
         @ServiceTypeID
        ,@CustomerID
        ,@ProductID
        ,@SerialNo
        ,@PurchaseDate
        ,@NxtServiceDate
        ,@NoOfService
        ,@ServiceEndDate
        ,@IsClose
        
    )
end
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertSpareGatePassDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 16 2010  6:17PM
-- Description : Insert Procedure for SpareGatePassDtls
-- Exec [dbo].[UC_InsertSpareGatePassDtls] [GatePassID],[ProductID],[Quantity],[PerUnitPrice],[IsSold],[UsedQty]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertSpareGatePassDtls]
     @GatePassID  int
    ,@ProductID  int
    ,@Quantity  int
    ,@PerUnitPrice  decimal
    ,@IsSold  bit
  
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[SpareGatePassDtls]
    ( 
         [GatePassID]
        ,[ProductID]
        ,[Quantity]
        ,[PerUnitPrice]
        ,[IsSold]
        
        
    )
    VALUES
    (
         @GatePassID
        ,@ProductID
        ,@Quantity
        ,@PerUnitPrice
        ,@IsSold
        
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertSpareGatePassMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 16 2010  3:04PM
-- Description : Insert Procedure for SpareGatePassMast
-- Exec [dbo].[UC_InsertSpareGatePassMast] [GatePassNumb],[ServicePersonID],[IssueDate],[IssuedBy],[TotalOutStandingAmt],[CreatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertSpareGatePassMast]
     @GatePassNumb  nvarchar(50)
    ,@ServicePersonID  int
    ,@IssueDate  datetime
    ,@IssuedBy  int
    ,@TotalOutStandingAmt  decimal
    ,@CreatedBy  int
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[SpareGatePassMast]
    ( 
         [GatePassNumb]
        ,[ServicePersonID]
        ,[IssueDate]
        ,[IssuedBy]
        ,[TotalOutStandingAmt]
        ,[CreatedBy]
        
    )
    VALUES
    (
         @GatePassNumb
        ,@ServicePersonID
        ,@IssueDate
        ,@IssuedBy
        ,@TotalOutStandingAmt
        ,@CreatedBy
        
    )
select scope_identity() as GatePassID,'inserted' as MESSAGEs
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertSpareGRNDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 15 2010  5:58PM
-- Description : Insert Procedure for Spare_GRNDtls
-- Exec [dbo].[UC_InsertSpareGRNDtls] [GRN_ID],[ProductID],[PerUnitPrice],[Quantity]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertSpareGRNDtls]
     @GRN_ID  int
    ,@ProductID  int
    ,@PerUnitPrice  decimal
    ,@Quantity  int
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[Spare_GRNDtls]
    ( 
         [GRN_ID]
        ,[ProductID]
        ,[PerUnitPrice]
        ,[Quantity]
        
    )
    VALUES
    (
         @GRN_ID
        ,@ProductID
        ,@PerUnitPrice
        ,@Quantity
        
    )

	declare @chekrecord int;
	set @chekrecord=(select count(ProductID) from Spare_StockMast where ProductID=@ProductID)

	declare @OriginalQty int;
	set @OriginalQty=(select Quantity from Spare_StockMast where ProductID=@ProductID)

	if(@chekrecord>0)
		begin
			update Spare_StockMast set Quantity=@OriginalQty+@Quantity where  ProductID=@ProductID

		end
	else
		begin
			insert into Spare_StockMast (ProductID,Quantity,MRP)
			values(
 @ProductID
        
        ,@Quantity
,@PerUnitPrice)

		end



END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertSpareGRNMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 15 2010  5:57PM
-- Description : Insert Procedure for Spare_GRNMast
-- Exec [dbo].[UC_InsertSpareGRNMast] [PoID],[GRN_No],[RecieveDate],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertSpareGRNMast]
     @PoID  int
    ,@GRN_No  nvarchar(50)
    ,@RecieveDate  datetime
    ,@CreatedBy  int
   

    ,@LastUpdatedBy  int
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[Spare_GRNMast]
    ( 
         [PoID]
        ,[GRN_No]
        ,[RecieveDate]
        ,[CreatedBy]
        ,[CreateDate]
        ,[LastUpdatedDate]
        ,[LastUpdatedBy]
        
    )
    VALUES
    (
         @PoID
        ,@GRN_No
        ,@RecieveDate
        ,@CreatedBy
        ,getdate()
        ,getdate()
        ,@LastUpdatedBy
        
    )

select scope_identity() as GRN_ID,'inserted' as MESSAGEs
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertSpareInvoiceDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 20 2010  1:51PM
-- Description : Insert Procedure for SpareInvoiceDtls
-- Exec [dbo].[UC_InsertSpareInvoiceDtls] [InvoiceDtlID],[InvoiceID],[GatePassID],[ProductID],[Quantity],[ActualPrice],[TotalPrice]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertSpareInvoiceDtls]
    
    @InvoiceID  int
    ,@GatePassID  int
    ,@ProductID  int
    ,@Quantity  int
    ,@ActualPrice  decimal
    ,@TotalPrice  decimal
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[SpareInvoiceDtls]
    ( 
       
        [InvoiceID]
        ,[GatePassID]
        ,[ProductID]
        ,[Quantity]
        ,[ActualPrice]
        ,[TotalPrice]
        
    )
    VALUES
    (
        
        @InvoiceID
        ,@GatePassID
        ,@ProductID
        ,@Quantity
        ,@ActualPrice
        ,@TotalPrice
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertSpareInvoiceMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 20 2010  1:12PM
-- Description : Insert Procedure for SpareInvoiceMast
-- Exec [dbo].[UC_InsertSpareInvoiceMast] [InvoiceID],[InvoiceNumber],[InvoiceDate],[CustomerID],[OwnerID],[OwnerType],[TotalAmt],[PaymentModeID],[ChequeNo],[ChequeDate],[BankName],[CreatedBy],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertSpareInvoiceMast]
    
    @InvoiceNumber  nvarchar(50)
    ,@InvoiceDate  datetime
    ,@CustomerID  int
    ,@OwnerID  int
    ,@OwnerType  char(1)
    ,@TotalAmt  decimal
    ,@PaymentModeID  int
    ,@ChequeNo  nvarchar(50)
    ,@ChequeDate  datetime
    ,@BankName  varchar(50)
    ,@CreatedBy  int
,@BalanceAmt int
    
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[SpareInvoiceMast]
    ( 
       
        [InvoiceNumber]
        ,[InvoiceDate]
        ,[CustomerID]
        ,[OwnerID]
        ,[OwnerType]
        ,[TotalAmt]
        ,[PaymentModeID]
        ,[ChequeNo]
        ,[ChequeDate]
        ,[BankName]
        ,[CreatedBy]
        ,[CreateDate]
		,[BalanceAmt]
        
    )
    VALUES
    (
       
        @InvoiceNumber
        ,@InvoiceDate
        ,@CustomerID
        ,@OwnerID
        ,@OwnerType
        ,@TotalAmt
        ,@PaymentModeID
        ,@ChequeNo
        ,@ChequeDate
        ,@BankName
        ,@CreatedBy
        ,getdate()
		,@BalanceAmt
        
    )
select scope_identity() as InvoiceID,'inserted' as MESSAGEs
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertStockMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 16 2010  1:02PM
-- Description : Insert Procedure for StockMast
-- Exec [dbo].[UC_InsertStockMast] [GRN_ID],[ProductID],[SerialNo],[IsOccupied]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertStockMast]
     @GRN_ID  int
    ,@ProductID  int
    ,@SerialNo  nvarchar(50)
    
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[StockMast]
    ( 
         [GRN_ID]
        ,[ProductID]
        ,[SerialNo]
       
        
    )
    VALUES
    (
         @GRN_ID
        ,@ProductID
        ,@SerialNo
      
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InserttblPayMent]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 18 2010  3:29PM
-- Description : Insert Procedure for tblPayMent
-- Exec [dbo].[UC_InserttblPayMent] [date],[partyname],[against],[Ammount],[comments],[PayType],[BankName],[chequeNo],[chequeDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InserttblPayMent]
     @date  datetime
    ,@partyname  varchar(50)
    ,@against  varchar(50)
    ,@Ammount  decimal(18,2)
    ,@comments  varchar(250)
    ,@PaymentModeID  varchar(50)
    ,@BankName  varchar(50)
    ,@chequeNo  nvarchar(50)
    ,@chequeDate  datetime
    ,@chkAmt  decimal(18,2)
,@cashAmt  decimal(18,2)
,@partyType varchar(50)
,@voucherNo varchar(50)
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[tblPayMent]
    ( 
         [date]
        ,[partyname]
        ,[against]
        ,[Ammount]
        ,[comments]
        ,PaymentModeID
        ,[BankName]
        ,[chequeNo]
        ,[chequeDate]
        ,chkAmt
,cashAmt
,partyType
,voucherNo
    )
    VALUES
    (
         @date
        ,@partyname
        ,@against
        ,@Ammount
        ,@comments
        ,@PaymentModeID
        ,@BankName
        ,@chequeNo
        ,@chequeDate
            ,@chkAmt 
,@cashAmt  
,@partyType
,@voucherNo
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Insertvatmast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  1 2010  5:20PM
-- Description : Insert Procedure for vatmast
-- Exec [dbo].[UC_Insertvatmast] [Value],[CreateDate],[CreatedBy],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_Insertvatmast]
     @Value  decimal
    
    ,@CreatedBy  int
   
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[vatmast]
    ( 
         [Value]
        ,[CreateDate]
        ,[CreatedBy]
        ,[LastUpdatedDate]
        ,[LastUpdatedBy]
        
    )
    VALUES
    (
         @Value
        ,getdate()
        ,@CreatedBy
        ,getdate()
        ,@CreatedBy
        
    )

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertVendorMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  3 2010  1:18PM
-- Description : Insert Procedure for VendorMast
-- Exec [dbo].[UC_InsertVendorMast] [VendorName],[Address],[AreaID],[CityID],[EmailID],[OfficePhone],[FaxNo],[ContactPerson],[PersonMobileNo],[IsActive],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_InsertVendorMast]
     @VendorName  nvarchar(50)
    ,@Address  nvarchar(250)
    ,@AreaID  int
    ,@CityID  int
    ,@EmailID  nvarchar(50)=null
    ,@OfficePhone  nvarchar(50)=null
    ,@FaxNo  nvarchar(50)=null
    ,@ContactPerson  nvarchar(50)=null
    ,@PersonMobileNo  varchar(20)=null
    ,@IsActive  bit
    ,@CreatedBy  int
    
    
AS
BEGIN

BEGIN TRY

    INSERT INTO [dbo].[VendorMast]
    ( 
         [VendorName]
        ,[Address]
        ,[AreaID]
        ,[CityID]
        ,[EmailID]
        ,[OfficePhone]
        ,[FaxNo]
        ,[ContactPerson]
        ,[PersonMobileNo]
        ,[IsActive]
        ,[CreatedBy]
        ,[CreateDate]
        ,[LastUpdatedDate]
        ,[LastUpdatedBy]
        
    )
    VALUES
    (
         @VendorName
        ,@Address
        ,@AreaID
        ,@CityID
        ,@EmailID
        ,@OfficePhone
        ,@FaxNo
        ,@ContactPerson
        ,@PersonMobileNo
        ,@IsActive
        ,@CreatedBy
        ,getdate()
        ,getdate()
        ,@CreatedBy
        
    )
select scope_identity() as VendorID,'Inserted' as ERROR_MESSAGE

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_InsertVendorProducts]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_InsertVendorProducts]
     @VendorID  int
    ,@productId  int
    ,@Rate  decimal(18,2)
    
AS

if exists (Select 1 from VendorProducts where VendorID=@VendorID and ProductId=@productId)

	Begin
		UPDATE [dbo].[VendorProducts]
		SET 
		    
			[Rate] = @Rate
		    
		WHERE  [VendorID] = @VendorID and [productId] = @productId

	End
Else
	Begin
		INSERT INTO [dbo].[VendorProducts]
		( 
			 [VendorID]
			,[productId]
			,[Rate]
	        
		)
		VALUES
		(
			 @VendorID
			,@productId
			,@Rate
	        
		)

		RETURN Scope_identity()
	End



GO
/****** Object:  StoredProcedure [dbo].[UC_LoginUserMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinod Sabade
-- Create date: 03 Aug 2017
-- Description:	Store Procedure For getting Customer Details
-- =============================================

CREATE PROCEDURE [dbo].[UC_LoginUserMast]
@UserName varchar(150),
@Password varchar(150)
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     UserMast.UserID, UserMast.Fname + ' ' + UserMast.Lname AS FullName, UserMast.UserTypeID
,IsAdmin,IsActive FROM UserMast WHERE  (UserMast.UserName = @UserName) AND (UserMast.Password = @Password ) 
AND (UserMast.IsActive = 1)

END




GO
/****** Object:  StoredProcedure [dbo].[UC_OutStandingMast_DeleteAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_OutStandingMast_DeleteAll] 
AS Delete  
from 
OutStandingMast
Return




GO
/****** Object:  StoredProcedure [dbo].[UC_OutStandingMast_DeleteByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[UC_OutStandingMast_DeleteByPK] 
	(
@OutStandingID int
)
AS
Delete  from 
OutStandingMast 
where 
[OutStandingID]=@OutStandingID


Return




GO
/****** Object:  StoredProcedure [dbo].[UC_OutStandingMast_GetAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[UC_OutStandingMast_GetAll] 
AS

SELECT     CustomerMast.CustomerID, CustomerMast.CustomerName, isnull(CustomerPaymentDetail.PreviousBalance,0) as  OpeningBalance, AreaMast.Area
FROM         CustomerMast LEFT OUTER JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID LEFT OUTER JOIN
                      CustomerPaymentDetail ON CustomerMast.CustomerID = CustomerPaymentDetail.CustomerId
                      
               
Where CustomerPaymentDetail.BillID=1 order by CustomerMast.CustomerID asc

Return








GO
/****** Object:  StoredProcedure [dbo].[UC_Purchase_Ledger_By_Vendor]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UC_Purchase_Ledger_By_Vendor] 
@VendorID int
AS
BEGIN
	SET NOCOUNT ON;

SELECT    convert(varchar,Purchase.BillDate,103)as BillDate,   Purchase.Quantity, Purchase.Amount, VendorMast.VendorName, ProductMast.Product
FROM      Purchase LEFT OUTER JOIN
          ProductMast ON Purchase.ProductID = ProductMast.ProductID LEFT OUTER JOIN
          VendorMast ON Purchase.VendorId = VendorMast.VendorID

where	  Purchase.VendorId =@VendorID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Receipt_DeleteAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Receipt_DeleteAll] 
AS Delete  
from 
Receipt
Return




GO
/****** Object:  StoredProcedure [dbo].[UC_Receipt_DeleteByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Receipt_DeleteByPK] 
	(
@ReceiptID int
)
AS
Delete  from 
Receipt 
where 
[ReceiptID]=@ReceiptID


Return




GO
/****** Object:  StoredProcedure [dbo].[UC_Receipt_GetAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Receipt_GetAll] 
AS
SELECT     Receipt.ReceiptID, Receipt.PaymentMode, Receipt.VoucherNo, Receipt.VoucherDate, Receipt.BankID, Receipt.PartyID, Receipt.Amount, Receipt.ChequeAmt, 
                      Receipt.ChequeNo, 

--Case 
Receipt.ChequeDate
--When '01/01/1900' then convert(Datetime,'00/00/2000',101)
--Else
--Receipt.ChequeDate
--End


, Receipt.Narration, CustomerMast.Lname, PaymentMode.ModeName
FROM         Receipt LEFT OUTER JOIN
                      PaymentMode ON Receipt.PaymentMode = PaymentMode.PaymentModeID LEFT OUTER JOIN
                      CustomerMast ON Receipt.PartyID = CustomerMast.CustomerID
Where Receipt.ReceiptID <>1
Return




GO
/****** Object:  StoredProcedure [dbo].[UC_Receipt_GetByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Receipt_GetByPK] 
	(
@ReceiptID int
)
AS
SELECT	 
[ReceiptID],
[PaymentMode],
[VoucherNo],
[VoucherDate],
[BankID],
[PartyID],
[Amount],
[ChequeAmt],
[ChequeNo],
[ChequeDate],
[Narration]

FROM 
Receipt  
WHERE 
[ReceiptID]=@ReceiptID


RETURN




GO
/****** Object:  StoredProcedure [dbo].[UC_Receipt_Insert]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Receipt_Insert] 
	(
@PaymentMode int=null,
@VoucherNo int=null,
@VoucherDate datetime=null,
@BankID int=null,
@PartyID int=null,
@Amount decimal=null,
@ChequeAmt decimal=null,
@ChequeNo varchar(20)=null,
@ChequeDate datetime=null,
@Narration varchar(150)=null
)
AS
Insert Into 
Receipt 
(
[PaymentMode],
[VoucherNo],
[VoucherDate],
[BankID],
[PartyID],
[Amount],
[ChequeAmt],
[ChequeNo],
[ChequeDate],
[Narration]
) 
values(
@PaymentMode,
@VoucherNo,
@VoucherDate,
@BankID,
@PartyID,
@Amount,
@ChequeAmt,
@ChequeNo,
@ChequeDate,
@Narration
)
RETURN Scope_identity()




GO
/****** Object:  StoredProcedure [dbo].[UC_Receipt_UpdateByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Receipt_UpdateByPK] 
	(
@ReceiptID int,
@PaymentMode int=null,
@VoucherNo int=null,
@VoucherDate datetime=null,
@BankID int=null,
@PartyID int=null,
@Amount decimal=null,
@ChequeAmt decimal=null,
@ChequeNo varchar(20)=null,
@ChequeDate datetime=null,
@Narration varchar(150)=null
)
AS
Update  Receipt Set 
[PaymentMode]=@PaymentMode,
[VoucherNo]=@VoucherNo,
[VoucherDate]=@VoucherDate,
[BankID]=@BankID,
[PartyID]=@PartyID,
[Amount]=@Amount,
[ChequeAmt]=@ChequeAmt,
[ChequeNo]=@ChequeNo,
[ChequeDate]=@ChequeDate,
[Narration]=@Narration
 
where 
[ReceiptID]=@ReceiptID


Return




GO
/****** Object:  StoredProcedure [dbo].[UC_SalesPerson]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_SalesPerson]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT     CustomerMast.Fname +SPACE(1)+ CustomerMast.Mname +SPACE(1)+ CustomerMast.Lname AS CustName, ProductMast.Product, ProductBrandMast.BrandName, 
                      ServiceTypeMast.ServiceType, ServiceDtls.ServiceNumb, EmployeeMast.Fname+SPACE(1)+EmployeeMast.Mname+SPACE(1)+EmployeeMast.Lname as ServiceMan, 
                      ServiceDtls.ActualServiceDate, ServiceDtls.ServiceDoneDate, ServiceDtls.Remark, CityMast.CityName, AreaMast.Area
FROM         ServiceMast INNER JOIN
                      ServiceTypeMast ON ServiceMast.ServiceTypeID = ServiceTypeMast.ServiceTypeID INNER JOIN
                      ProductMast ON ServiceMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      ServiceDtls ON ServiceMast.ServiceID = ServiceDtls.ServiceID INNER JOIN
                      EmployeeMast ON ServiceDtls.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast ON CustomerMast.CityID = CityMast.CityID INNER JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID 
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SalesPersonRpt]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_SalesPersonRpt]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    SELECT     CustomerMast.Fname + SPACE(1) + CustomerMast.Mname + SPACE(1) + CustomerMast.Lname AS CustName, ProductMast.Product, 
                      ProductBrandMast.BrandName, ServiceTypeMast.ServiceType, ServiceDtls.ServiceNumb, EmployeeMast.Fname + SPACE(1) 
                      + EmployeeMast.Mname + SPACE(1) + EmployeeMast.Lname AS ServiceMan, ServiceDtls.ActualServiceDate, ServiceDtls.ServiceDoneDate, 
                      ServiceDtls.Remark, CityMast.CityName, AreaMast.Area, EmployeeMast.EmpUsrTypeID, EmployeeMast.Address
FROM         ServiceMast INNER JOIN
                      ServiceTypeMast ON ServiceMast.ServiceTypeID = ServiceTypeMast.ServiceTypeID INNER JOIN
                      ProductMast ON ServiceMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      ServiceDtls ON ServiceMast.ServiceID = ServiceDtls.ServiceID INNER JOIN
                      EmployeeMast ON ServiceDtls.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast ON CustomerMast.CityID = CityMast.CityID INNER JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_All_COmplaints]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_Select_All_COmplaints]

AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, CustomerComplaintMast.CustomerComplaintID, 
                      ProductMast.Product, ProductBrandMast.BrandName, CustomerComplaintMast.SerialNo, CustomerComplaintMast.Descriptn, 
                      CustomerComplaintMast.ComplaintDate, CustomerMast.CustomerID, ProductMast.ProductID
FROM         CustomerMast INNER JOIN
                      CustomerComplaintMast ON CustomerMast.CustomerID = CustomerComplaintMast.CustomerID INNER JOIN
                      ProductMast ON CustomerComplaintMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_ComplaintDtls_By_CustomerID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Select_ComplaintDtls_By_CustomerID]
@CustomerID int
AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     CustomerComplaintMast.CustomerComplaintID,CustomerComplaintMast.ProductID, ProductMast.Product, CustomerComplaintMast.SerialNo, CustomerComplaintMast.Descriptn, 
                      CustomerComplaintMast.ComplaintDate,CustomerComplaintMast.ComplaintNo
FROM         CustomerMast INNER JOIN
                      CustomerComplaintMast ON CustomerMast.CustomerID = CustomerComplaintMast.CustomerID INNER JOIN
                      ProductMast ON CustomerComplaintMast.ProductID = ProductMast.ProductID
where CustomerMast.CustomerID=@CustomerID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_CustomerBankInfoMast_By_CustomerID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Select_CustomerBankInfoMast_By_CustomerID]
@CustomerID int
AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     BankInfoID, CustID, BankName, BranchAddress, AccNo
FROM         CustBankInfoMast
where CustID=@CustomerID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_CustomerMast_By_CustomerID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --exec UC_Select_CustomerMast_By_CustomerID 2
CREATE PROCEDURE [dbo].[UC_Select_CustomerMast_By_CustomerID] 
@CustomerID int
AS
BEGIN
	
SET NOCOUNT ON;
SELECT        CustomerMast.CustomerID, CustomerMast.CustomerName, CustomerMast.Address, CustomerMast.AreaID, CustomerMast.Mobile, CustomerMast.SalesPersonID, CustomerMast.VehicleID as VehicleID, AreaMast.Area, 
                         EmployeeMast.EmployeeName, VehicleMast.VechicleNo, ISNULL(CustomerMast.isBillRequired, 0) AS isBillRequired, ISNULL(CustomerMast.isActive, 0) AS isActive, CustomerType.CustomerType, 
                         CustomerMast.DeliveryCharges, CustomerMast.CustomerTypeId
FROM            CustomerMast Left Outer JOIN
                         CustomerType ON CustomerMast.CustomerTypeId = CustomerType.CustomerTypeId LEFT OUTER JOIN
                         VehicleMast ON CustomerMast.VehicleID = VehicleMast.VechicleID LEFT OUTER JOIN
                         EmployeeMast ON CustomerMast.SalesPersonID = EmployeeMast.EmployeeID LEFT OUTER JOIN
                         AreaMast ON CustomerMast.AreaID = AreaMast.AreaID
WHERE        (CustomerMast.CustomerID = @CustomerID)

END





GO
/****** Object:  StoredProcedure [dbo].[UC_Select_DateCount_By_DatiTimeCOuntID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_Select_DateCount_By_DatiTimeCOuntID]

AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     DateCount
FROM         DateCountMast
where DatetimeCountID=-1
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_DealerMast_By_DealerID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Dealer Details by IDs
-- =============================================

Create PROCEDURE [dbo].[UC_Select_DealerMast_By_DealerID]
@DealerID int
AS
BEGIN
	
	SET NOCOUNT ON;
	

  
SELECT     DealerID, DealerName, Address, AreaID, CityID, EmailID, OfficePhone, FaxNo, ContactPerson, PersonMobileNo, IsActive
FROM         DealerMast 
where  DealerID = @DealerID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_GatePass_By_GatePassID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Purchase Order Detail by PoID
-- =============================================

Create PROCEDURE [dbo].[UC_Select_GatePass_By_GatePassID]
@GatePassID int
AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     GatePassID, GatePassNumb, OwnerID, OwnerType, IssueDate, IssuedBy, TotalOutStandingAmt
FROM         GatePassMast
where GatePassID = @GatePassID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_GatePassDtls_By_GatePassID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Purchase Order Detail by PoID
-- =============================================

Create PROCEDURE [dbo].[UC_Select_GatePassDtls_By_GatePassID]
@GatePassID int
AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     GatePassDtls.GatePassDtlID, GatePassDtls.GatePassID, GatePassDtls.ProductID, ProductMast.Product, GatePassDtls.SerialNo, GatePassDtls.PerUnitPrice
FROM         GatePassDtls INNER JOIN
                      ProductMast ON GatePassDtls.ProductID = ProductMast.ProductID
WHERE     (GatePassDtls.GatePassID = @GatePassID)

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_GatePassNo_IssuedBy]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 24 2010 10:48AM
-- Description : Delete Procedure for GatePassMast
-- Exec [dbo].[UC_DeleteGatePassMast] @GatePassID  int
    
-- ============================================= */
create PROCEDURE [dbo].[UC_Select_GatePassNo_IssuedBy]
     @GatePassID  int
    
AS
BEGIN

begin transaction transDelete
BEGIN TRY
SELECT     GatePassNumb, IssuedBy
FROM         GatePassMast
    WHERE [GatePassID] = @GatePassID 

commit transaction transDelete;
END TRY

    BEGIN CATCH
rollback transaction transDelete;
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_IC_Customers]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_Select_IC_Customers]

@ServiceTypeID int
,@IsClose bit
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ProductMast.Product, ProductBrandMast.BrandName, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, 
                      ServiceMast.PurchaseDate, ServiceMast.ServiceEndDate, ServiceMast.NoOfService, ServiceMast.IsClose, ServiceTypeMast.ServiceType, 
                      ServiceMast.ServiceTypeID, ServiceMast.SerialNo, CustomerMast.CustomerID, ServiceMast.FreuencyInMonth, ServiceMast.NxtServiceDate, 
                      ServiceMast.ProductID, ServiceMast.ServiceID
FROM         ProductMast INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      ServiceMast ON ProductMast.ProductID = ServiceMast.ProductID INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      ServiceTypeMast ON ServiceMast.ServiceTypeID = ServiceTypeMast.ServiceTypeID	
WHERE ServiceMast.ServiceTypeID=@ServiceTypeID and ServiceMast.IsClose=@IsClose

--where ServiceMast.ServiceEndDate<=getdate()
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_InvoiceDtls_By_InvoiceID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_Select_InvoiceDtls_By_InvoiceID]

@InvoiceID int
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     InvoiceDtls.InvoiceID, InvoiceDtls.GatePassID, InvoiceDtls.ProductID, InvoiceDtls.SerialNo, InvoiceDtls.ActualPrice AS PerUnitPrice, 
                      InvoiceDtls.SoldPrice, ProductMast.Product
FROM         InvoiceDtls INNER JOIN
                      ProductMast ON InvoiceDtls.ProductID = ProductMast.ProductID
WHERE     (InvoiceDtls.InvoiceID = @InvoiceID)


END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_InVoiceMast_BY_InvoiceID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_Select_InVoiceMast_BY_InvoiceID]

@InvoiceID int
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     InvoiceNumber, InvoiceDate, CustomerID, OwnerID, OwnerType, IsWaranty, TotalAmt, NetAmt, VatAmt, VatPercent, PaymentModeID, ChequeNo, 
                      ChequeDate, BankName
FROM         InVoiceMast
where InvoiceID=@InvoiceID


END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_ItemsQuantity_By_POID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[UC_Select_ItemsQuantity_By_POID]
@PoID int

AS
begin
SELECT     Spare_PurchaseOrderMast.PoID, ProductMast.Product, Spare_PurchaseOrderDetail.ProductID, Spare_PurchaseOrderDetail.Quantity AS OrginalQuantity, 
                      ISNULL
                          ((SELECT     SUM(Spare_GRNDtls.Quantity) AS count
                              FROM         Spare_GRNDtls INNER JOIN
                                                    Spare_GRNMast ON Spare_GRNDtls.GRN_ID = Spare_GRNMast.GRN_ID
                              WHERE     (Spare_GRNMast.PoID = Spare_PurchaseOrderMast.PoID) AND (Spare_GRNDtls.ProductID = Spare_PurchaseOrderDetail.ProductID)
                              GROUP BY Spare_GRNDtls.ProductID), 0) AS RecieveQuanity, 0 AS Quantity, Spare_PurchaseOrderDetail.Quantity - ISNULL
                          ((SELECT     SUM(Spare_GRNDtls_1.Quantity) AS count
                              FROM         Spare_GRNDtls AS Spare_GRNDtls_1 INNER JOIN
                                                    Spare_GRNMast AS Spare_GRNMast_2 ON Spare_GRNDtls_1.GRN_ID = Spare_GRNMast_2.GRN_ID
                              WHERE     (Spare_GRNMast_2.PoID = Spare_PurchaseOrderMast.PoID) AND (Spare_GRNDtls_1.ProductID = Spare_PurchaseOrderDetail.ProductID)
                              GROUP BY Spare_GRNDtls_1.ProductID), 0) AS RemainingQuanity, ProductMast.SalePrice AS MRP, VendorMast.VendorID
FROM         Spare_PurchaseOrderMast INNER JOIN
                      Spare_PurchaseOrderDetail ON Spare_PurchaseOrderMast.PoID = Spare_PurchaseOrderDetail.PoID INNER JOIN
                      ProductMast ON Spare_PurchaseOrderDetail.ProductID = ProductMast.ProductID LEFT OUTER JOIN
                      VendorMast ON Spare_PurchaseOrderMast.VendorID = VendorMast.VendorID LEFT OUTER JOIN
                      Spare_GRNMast AS Spare_GRNMast_1 ON Spare_GRNMast_1.PoID = Spare_PurchaseOrderMast.PoID
WHERE     (Spare_PurchaseOrderMast.PoID = @PoID)
GROUP BY Spare_PurchaseOrderDetail.ProductID, Spare_PurchaseOrderMast.PoID, ProductMast.Product, Spare_PurchaseOrderDetail.Quantity, ProductMast.SalePrice, 
                      VendorMast.VendorID

end




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_NewGatePassQuantity]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UC_Select_NewGatePassQuantity]
as
begin

SELECT    (EmployeeMast.Fname+' '+EmployeeMast.Mname+' '+EmployeeMast.Lname)as EmpName, ProductMast.Product, SUM(SpareGatePassDtls.Quantity) 
                      AS NewGatepassQuantity, SpareGatePassMast.IssueDate
FROM         SpareGatePassMast INNER JOIN
                      SpareGatePassDtls ON SpareGatePassMast.GatePassID = SpareGatePassDtls.GatePassID LEFT OUTER JOIN
                      EmployeeMast ON SpareGatePassMast.ServicePersonID = EmployeeMast.EmployeeID LEFT OUTER JOIN
                      ProductMast ON SpareGatePassDtls.ProductID = ProductMast.ProductID
GROUP BY EmployeeMast.Fname, EmployeeMast.Mname, EmployeeMast.Lname, ProductMast.Product, SpareGatePassMast.IssueDate
HAVING      (DATEDIFF(day, SpareGatePassMast.IssueDate, GETDATE()) = 0)

end




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_OldGatePassQuantity]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[UC_Select_OldGatePassQuantity]
as
begin
SELECT      EmployeeMast.Lname, ProductMast.Product, SUM(SpareGatePassDtls.Quantity) 
                      AS OldGatepassQuantity, SpareGatePassMast.IssueDate
FROM         SpareGatePassMast INNER JOIN
                      SpareGatePassDtls ON SpareGatePassMast.GatePassID = SpareGatePassDtls.GatePassID LEFT OUTER JOIN
                      ProductMast ON SpareGatePassDtls.ProductID = ProductMast.ProductID LEFT OUTER JOIN
                      EmployeeMast ON SpareGatePassMast.ServicePersonID = EmployeeMast.EmployeeID
GROUP BY  EmployeeMast.Lname, ProductMast.Product, SpareGatePassMast.IssueDate
HAVING      (DATEDIFF(day, SpareGatePassMast.IssueDate, GETDATE()) = 1)
end




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_OutIfWarranty_Customers]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




Create PROCEDURE [dbo].[UC_Select_OutIfWarranty_Customers]

AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ProductMast.Product, ProductBrandMast.BrandName, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, 
                      ServiceMast.PurchaseDate, ServiceMast.ServiceEndDate, ServiceMast.NoOfService, ServiceMast.IsClose, ServiceTypeMast.ServiceType, 
                      ServiceMast.ServiceTypeID, ServiceMast.SerialNo, CustomerMast.CustomerID, ServiceMast.FreuencyInMonth, ServiceMast.NxtServiceDate, 
                      ServiceMast.ProductID, ServiceMast.ServiceID
FROM         ProductMast INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      ServiceMast ON ProductMast.ProductID = ServiceMast.ProductID INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      ServiceTypeMast ON ServiceMast.ServiceTypeID = ServiceTypeMast.ServiceTypeID	

where ServiceMast.ServiceEndDate<=getdate()
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_OutOf_Warrenty]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_Select_OutOf_Warrenty]


AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ProductMast.Product, ProductBrandMast.BrandName, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, 
                      ServiceMast.PurchaseDate, ServiceMast.ServiceEndDate, ServiceMast.NoOfService, ServiceMast.IsClose, ServiceTypeMast.ServiceType, 
                      ServiceMast.ServiceTypeID, ServiceMast.SerialNo, CustomerMast.CustomerID, ServiceMast.FreuencyInMonth, ServiceMast.NxtServiceDate, 
                      ServiceMast.ProductID, ServiceMast.ServiceID
FROM         ProductMast INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      ServiceMast ON ProductMast.ProductID = ServiceMast.ProductID INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      ServiceTypeMast ON ServiceMast.ServiceTypeID = ServiceTypeMast.ServiceTypeID	
--WHERE ServiceMast.ServiceTypeID=@ServiceTypeID and ServiceMast.IsClose=@IsClose

where ServiceMast.ServiceEndDate<=getdate()
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_Receipt_ByReceiptDate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[UC_Select_Receipt_ByReceiptDate]
@Date datetime 
AS
BEGIN
	
	SET NOCOUNT ON;

SELECT    EmployeeMast.Lname AS EmpName, 
                       CustomerMast.Lname AS CustName, SpareInvoiceMast.InvoiceNumber, 
                      SpareInvoiceMast.InvoiceDate, RecieptMast.TotalAmt, PaymentMode.ModeName, RecieptMast.CashAmt, RecieptMast.ChequeAmt, 
                      RecieptMast.ChequeNo, RecieptMast.ChequeDate, RecieptMast.BankName, RecieptMast.ChequeStatus, RecieptMast.ClearedDate, 
                      SpareInvoiceMast.BalanceAmt, RecieptMast.RecieptDate
FROM         RecieptMast LEFT OUTER JOIN
                      CustomerMast ON RecieptMast.CustomerID = CustomerMast.CustomerID LEFT OUTER JOIN
                      SpareInvoiceMast ON RecieptMast.InvoiceID = SpareInvoiceMast.InvoiceID LEFT OUTER JOIN
                      PaymentMode ON RecieptMast.PaymentModeID = PaymentMode.PaymentModeID LEFT OUTER JOIN
                      EmployeeMast ON RecieptMast.PartyID = EmployeeMast.EmployeeID
WHERE     (RecieptMast.RecieptDate = @Date)
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_Reconcilation_List]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Select_Reconcilation_List]

AS
BEGIN
	
	SET NOCOUNT ON;
SELECT DISTINCT 
                      CustomerMast.Lname AS CustName, PaymentMode.ModeName, Receipt.ReceiptID, Receipt.PaymentMode, Receipt.VoucherDate, Receipt.VoucherNo, Receipt.BankID, 
                      Receipt.Amount, Receipt.ChequeAmt, Receipt.ChequeNo, Receipt.ChequeDate, Receipt.Narration, Bank.BankName
FROM         Receipt LEFT OUTER JOIN
                      Bank ON Receipt.BankID = Bank.BankID LEFT OUTER JOIN
                      PaymentMode ON Receipt.PaymentMode = PaymentMode.PaymentModeID LEFT OUTER JOIN
                      CustomerMast ON Receipt.PartyID = CustomerMast.CustomerID
WHERE     (PaymentMode.PaymentModeID = 2 OR
                      PaymentMode.PaymentModeID = 3)
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_Reconcilation_List_By_Date]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Select_Reconcilation_List_By_Date]
@ChequeDate datetime
AS
BEGIN
	
	SET NOCOUNT ON;
/*and RecieptMast.ChequeStatus =0*/
SELECT DISTINCT 
                      CustomerMast.Lname AS CustName, PaymentMode.ModeName, Receipt.ReceiptID, Receipt.PaymentMode, Receipt.VoucherDate, Receipt.VoucherNo, Receipt.BankID, 
                      Receipt.Amount, Receipt.ChequeAmt, Receipt.ChequeNo, Receipt.ChequeDate, Receipt.Narration, Bank.BankName
FROM         Receipt LEFT OUTER JOIN
                      Bank ON Receipt.BankID = Bank.BankID LEFT OUTER JOIN
                      PaymentMode ON Receipt.PaymentMode = PaymentMode.PaymentModeID LEFT OUTER JOIN
                      CustomerMast ON Receipt.PartyID = CustomerMast.CustomerID
WHERE     (PaymentMode.PaymentModeID = 2 OR
                      PaymentMode.PaymentModeID = 3) AND (Receipt.ChequeDate = @ChequeDate)
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_Sales_Person_Report]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[UC_Select_Sales_Person_Report]
as
begin
SELECT     EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, ProductMast.Product, SpareInvoiceDtls.Quantity,SpareInvoiceMast.InvoiceDate, 
                      SpareInvoiceDtls.TotalPrice, CompanyProfileMast.Name, CompanyProfileMast.Address1, CompanyProfileMast.Address2, 
                      CompanyProfileMast.Address3, CompanyProfileMast.Phone, CompanyProfileMast.Mobile,(DocPathSettingsMast.Path+'\'+CompanyProfileMast.LogoFile)as LogoFile
FROM         SpareInvoiceMast INNER JOIN
                      SpareInvoiceDtls ON SpareInvoiceMast.InvoiceID = SpareInvoiceDtls.InvoiceID LEFT OUTER JOIN
                      EmployeeMast ON SpareInvoiceMast.OwnerID = EmployeeMast.EmployeeID LEFT OUTER JOIN
                      ProductMast ON SpareInvoiceDtls.ProductID = ProductMast.ProductID CROSS JOIN
                      CompanyProfileMast CROSS JOIN
                      DocPathSettingsMast
WHERE     (DATEDIFF(day, SpareInvoiceMast.InvoiceDate, GETDATE()) = 0)
end




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_ServiceDtls_By_ServiceID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_Select_ServiceDtls_By_ServiceID]
@ServiceID int
AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     ServiceDtls.ServicePersonID, EmployeeMast.Fname +' '+ EmployeeMast.Lname as ServicePersonName, ServiceDtls.ActualServiceDate, 
                      ServiceDtls.ServiceDoneDate, ServiceDtls.Remark, ServiceDtls.ServiceDtlsID
FROM         ServiceMast INNER JOIN
                      ServiceDtls ON ServiceMast.ServiceID = ServiceDtls.ServiceID INNER JOIN
                      EmployeeMast ON ServiceDtls.ServicePersonID = EmployeeMast.EmployeeID
where ServiceMast.ServiceID=@ServiceID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_ServiceMast_By_CustomerID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Vendor Details
-- =============================================

CREATE PROCEDURE [dbo].[UC_Select_ServiceMast_By_CustomerID]
@CustomerID int
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ServiceMast.ServiceID, ProductMast.Product, ProductBrandMast.BrandName, ServiceMast.SerialNo, ServiceMast.PurchaseDate, 
                      ServiceMast.NoOfService, ServiceMast.NxtServiceDate, ServiceMast.ServiceEndDate, ServiceMast.IsClose, ServiceTypeMast.ServiceType, 
                      ProductMast.ProductID,ServiceMast.ServiceTypeID
FROM         ServiceMast INNER JOIN
                      ServiceTypeMast ON ServiceMast.ServiceTypeID = ServiceTypeMast.ServiceTypeID INNER JOIN
                      ProductMast ON ServiceMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID
WHERE     (ServiceMast.CustomerID = @CustomerID)
END

select * from servicemast




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_SpareGatePassDtls_By_GatePassID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================



CREATE PROCEDURE [dbo].[UC_Select_SpareGatePassDtls_By_GatePassID]
@GatePassID int

AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ProductMast.Product, SpareGatePassDtls.Quantity, SpareGatePassDtls.PerUnitPrice, SpareGatePassDtls.ProductID
FROM         SpareGatePassMast INNER JOIN
                      SpareGatePassDtls ON SpareGatePassMast.GatePassID = SpareGatePassDtls.GatePassID INNER JOIN
                      ProductMast ON SpareGatePassDtls.ProductID = ProductMast.ProductID
where SpareGatePassMast.GatePassID=@GatePassID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_SpareGatePassMast_By_GatePassID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================



CREATE PROCEDURE [dbo].[UC_Select_SpareGatePassMast_By_GatePassID]
@GatePassID int

AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     SpareGatePassMast.GatePassNumb, SpareGatePassMast.GatePassID,SpareGatePassMast.ServicePersonID, 
                       EmployeeMast.Lname AS EmpName, SpareGatePassMast.IssueDate, 
                      SpareGatePassMast.IssuedBy, (UserMast.Fname+' '+UserMast.Mname +' '+ UserMast.Lname)as IssueByName
FROM         UserMast INNER JOIN
                      SpareGatePassMast ON UserMast.UserID = SpareGatePassMast.IssuedBy INNER JOIN
                      EmployeeMast ON SpareGatePassMast.ServicePersonID = EmployeeMast.EmployeeID
where SpareGatePassMast.GatePassID=@GatePassID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_SpareGatePassMast_By_ServicePersonID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================



CREATE PROCEDURE [dbo].[UC_Select_SpareGatePassMast_By_ServicePersonID]


AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     SpareGatePassMast.GatePassNumb, SpareGatePassMast.GatePassID, 
                      EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, SpareGatePassMast.IssueDate, 
                      SpareGatePassMast.IssuedBy, (UserMast.Fname+' '+UserMast.Mname +' '+ UserMast.Lname)as IssueByName
FROM         UserMast INNER JOIN
                      SpareGatePassMast ON UserMast.UserID = SpareGatePassMast.IssuedBy INNER JOIN
                      EmployeeMast ON SpareGatePassMast.ServicePersonID = EmployeeMast.EmployeeID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_SpareInvoiceDtls_By_InvoiceID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_Select_SpareInvoiceDtls_By_InvoiceID]

@InvoiceID int
AS
BEGIN
SELECT DISTINCT SpareInvoiceDtls.InvoiceID, ProductMast.Product, SpareInvoiceDtls.Quantity, SpareInvoiceDtls.ActualPrice, SpareInvoiceDtls.TotalPrice
FROM         SpareInvoiceDtls INNER JOIN
                      ProductMast ON SpareInvoiceDtls.ProductID = ProductMast.ProductID

WHERE     (SpareInvoiceDtls.InvoiceID = @InvoiceID )



	
	SET NOCOUNT ON;


END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_Unsold_SparesBy_ServicePersonID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Purchase Order Detail by PoID
-- =============================================

CREATE PROCEDURE [dbo].[UC_Select_Unsold_SparesBy_ServicePersonID]
@ServicePersonID int
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ProductMast.Product, SpareGatePassDtls.ProductID, SpareGatePassDtls.PerUnitPrice, SUM(SpareGatePassDtls.Quantity) AS ItemQuantity, 
                      SpareGatePassMast.GatePassID
FROM         SpareGatePassMast INNER JOIN
                      SpareGatePassDtls ON SpareGatePassMast.GatePassID = SpareGatePassDtls.GatePassID INNER JOIN
                      ProductMast ON SpareGatePassDtls.ProductID = ProductMast.ProductID
WHERE     (SpareGatePassMast.ServicePersonID = @ServicePersonID) and SpareGatePassDtls.IsSold=0
group by SpareGatePassDtls.ProductID,ProductMast.Product,SpareGatePassDtls.PerUnitPrice,SpareGatePassMast.GatePassID


END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_VendorMast_By_VendorID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Vendor Details
-- =============================================

CREATE PROCEDURE [dbo].[UC_Select_VendorMast_By_VendorID]
@VendorID int
AS
BEGIN
	
	SET NOCOUNT ON;
	

  
SELECT     VendorID, VendorName, Address, AreaID, CityID, EmailID, OfficePhone, FaxNo, ContactPerson, PersonMobileNo, IsActive
FROM         VendorMast
WHERE     (VendorID = @VendorID)

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Select_WarrantyExpirationList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================



CREATE PROCEDURE [dbo].[UC_Select_WarrantyExpirationList]

@DateCount int
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ProductMast.Product, ProductBrandMast.BrandName, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, 
                      ServiceMast.PurchaseDate, ServiceMast.ServiceEndDate, ServiceMast.NoOfService, ServiceMast.IsClose, ServiceTypeMast.ServiceType, 
                      ServiceMast.ServiceTypeID, ServiceMast.SerialNo, CustomerMast.CustomerID, ServiceMast.FreuencyInMonth, ServiceMast.NxtServiceDate, 
                      ServiceMast.ProductID, ServiceMast.ServiceID
FROM         ProductMast INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      ServiceMast ON ProductMast.ProductID = ServiceMast.ProductID INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      ServiceTypeMast ON ServiceMast.ServiceTypeID = ServiceTypeMast.ServiceTypeID	
where ServiceMast.ServiceEndDate<=dateadd(day,@DateCount,getdate())
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_AreaMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_SelectAll_AreaMast]

AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     AreaMast.AreaID, AreaMast.Area,AreaMast.CityID
FROM         AreaMast 
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_CityMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[UC_SelectAll_CityMast]

AS
BEGIN
	
	SET NOCOUNT ON;
	

  
SELECT     CityMast.CityID, CityMast.CityName, CityMast.CreateDate,CityMast.LastUpdatedDate,
                          (SELECT     UserMast.Fname + ' ' + UserMast.Lname 
                            FROM          UserMast INNER JOIN
                                                   CityMast p on UserMast.Userid=p.LastUpdatedBy where CityMast.CityID = p.CityID)AS LastUpdatedBy,
 (SELECT     UserMast.Fname + ' ' + UserMast.Lname 
                            FROM          UserMast INNER JOIN
                                                   CityMast p1 on UserMast.Userid=p1.CreatedBy where CityMast.CityID = p1.CityID)AS CreatedBy

                      FROM          CityMast INNER JOIN
                                             UserMast ON CityMast.LastUpdatedBy = UserMast.UserID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_CustomerMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Customer Details
-- UC_SelectAll_CustomerMast
-- =============================================

CREATE PROCEDURE [dbo].[UC_SelectAll_CustomerMast]

AS
BEGIN
	
	SET NOCOUNT ON;


	SELECT        CustomerMast.CustomerID, CustomerMast.CustomerName, CustomerMast.Address, CustomerMast.AreaID, CustomerMast.Mobile, CustomerMast.SalesPersonID, CustomerMast.VehicleID, AreaMast.Area, 
					VehicleMast.VechicleNo, EmployeeMast.EmployeeName, CustomerMast.isBillRequired, CustomerMast.isActive, CustomerType.CustomerType, CustomerMast.DeliveryCharges
	FROM            CustomerMast  LEFT OUTER JOIN
					CustomerType ON CustomerMast.CustomerTypeId = CustomerType.CustomerTypeId LEFT OUTER JOIN
					VehicleMast ON CustomerMast.VehicleID = VehicleMast.VechicleID LEFT OUTER JOIN
					EmployeeMast ON CustomerMast.SalesPersonID = EmployeeMast.EmployeeID LEFT OUTER JOIN
					AreaMast ON CustomerMast.AreaID = AreaMast.AreaID
order by AreaID asc

END





GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_DealerMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Dealer Details
-- =============================================

CREATE PROCEDURE [dbo].[UC_SelectAll_DealerMast]

AS
BEGIN
	
	SET NOCOUNT ON;
	

  
SELECT     DealerMast.DealerID, DealerMast.DealerName, DealerMast.Address, AreaMast.Area, CityMast.CityName, DealerMast.EmailID, DealerMast.OfficePhone, 
                      DealerMast.FaxNo, DealerMast.ContactPerson, DealerMast.PersonMobileNo, DealerMast.IsActive, ISNULL(UserMast.Fname, '') + ' ' + ISNULL(UserMast.Mname, '') 
                      + ' ' + ISNULL(UserMast.Lname, '') AS CreatedBy, ISNULL(UserMast_1.Fname, '') + ' ' + ISNULL(UserMast_1.Mname, '') + ' ' + ISNULL(UserMast_1.Lname, '') 
                      AS LastUpdatedBy
FROM         DealerMast INNER JOIN
                      AreaMast ON DealerMast.AreaID = AreaMast.AreaID INNER JOIN
                      CityMast ON DealerMast.CityID = CityMast.CityID INNER JOIN
                      UserMast ON DealerMast.CreatedBy = UserMast.UserID INNER JOIN
                      UserMast AS UserMast_1 ON DealerMast.LastUpdatedBy = UserMast_1.UserID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_DocSettingsMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_SelectAll_DocSettingsMast]

@DocID int	
AS
BEGIN

	SET NOCOUNT ON;
	
SELECT     [Path]
FROM         DocPathSettingsMast
where DocID=@DocID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_EmployeeMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Customer Details
-- =============================================

CREATE PROCEDURE [dbo].[UC_SelectAll_EmployeeMast]

AS
BEGIN
	
	SET NOCOUNT ON;

	SELECT  EmployeeMast.EmployeeID, EmployeeMast.EmployeeName, EmployeeMast.Address, AreaMast.Area, 
			EmployeeMast.Mobile  
	FROM    EmployeeMast INNER JOIN
			AreaMast ON EmployeeMast.AreaID = AreaMast.AreaID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_GatePassList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 24 Sep 2010
-- Description:	Store Procedure For getting Gatepass Details
-- =============================================

Create PROCEDURE [dbo].[UC_SelectAll_GatePassList]

AS
BEGIN
	
	SET NOCOUNT ON;
	

  
SELECT     GatePassMast.GatePassID, GatePassMast.GatePassNumb, GatePassMast.OwnerID, CASE WHEN GatePassMast.OwnerType = 'C' THEN IsNull(TitleMast.Title, '') 
                      + '. ' + IsNull(CustomerMast.Fname, '') + ' ' + IsNull(CustomerMast.Mname, '') + ' ' + IsNull(CustomerMast.Lname, '') 
                      WHEN GatePassMast.OwnerType = 'D' THEN DealerMast.DealerName WHEN GatePassMast.OwnerType = 'S' THEN IsNull(TitleMast_1.Title, '') 
                      + '. ' + IsNull(EmployeeMast.Fname, '') + ' ' + IsNull(EmployeeMast.Mname, '') + ' ' + IsNull(EmployeeMast.Lname, '') END AS OwnerName, 
                      CASE GatePassMast.OwnerType WHEN 'D' THEN 'Dealer' WHEN 'C' THEN 'Customer' WHEN 'S' THEN 'SalesExecutive' END AS OwnerType, 
                      GatePassMast.IssueDate, GatePassMast.IssuedBy, ISNULL(UserMast.Fname, '') + ' ' + ISNULL(UserMast.Mname, '') + ' ' + ISNULL(UserMast.Lname, '') 
                      AS IssueByName, GatePassMast.TotalOutStandingAmt, GatePassMast.CreatedBy, ISNULL(UserMast_1.Fname, '') + ' ' + ISNULL(UserMast_1.Mname, '') 
                      + ' ' + ISNULL(UserMast_1.Lname, '') AS GatePassCreatedBy
FROM         TitleMast AS TitleMast_1 INNER JOIN
                      EmployeeMast ON TitleMast_1.TitleID = EmployeeMast.TitleID RIGHT OUTER JOIN
                      GatePassMast INNER JOIN
                      UserMast ON GatePassMast.IssuedBy = UserMast.UserID INNER JOIN
                      UserMast AS UserMast_1 ON GatePassMast.CreatedBy = UserMast_1.UserID ON EmployeeMast.EmployeeID = GatePassMast.OwnerID LEFT OUTER JOIN
                      TitleMast INNER JOIN
                      CustomerMast ON TitleMast.TitleID = CustomerMast.TitleID ON GatePassMast.OwnerID = CustomerMast.CustomerID LEFT OUTER JOIN
                      DealerMast ON GatePassMast.OwnerID = DealerMast.DealerID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_GrnDtls_By_PoID_GRNID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 13 Sep 2010
-- Description:	Store Procedure For getting GRN Details by Poid and grnID
-- =============================================




Create PROCEDURE [dbo].[UC_SelectAll_GrnDtls_By_PoID_GRNID]
@PoID int,
@GRN_ID int

AS
BEGIN
	
	SET NOCOUNT ON;
	

SELECT     GRNDtls.GRNDtlID, GRNDtls.GRN_ID, GRNDtls.ProductID, GRNDtls.SerialNo, GRNDtls.Quantity
FROM         GRNDtls INNER JOIN
                      GRNMast ON GRNDtls.GRN_ID = GRNMast.GRN_ID
WHERE     (GRNMast.PoID = @PoID) AND (GRNDtls.GRN_ID = @GRN_ID)



END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_GrnItemList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_SelectAll_GrnItemList]


AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     Spare_GRNMast.GRN_ID, Spare_PurchaseOrderMast.POID, Spare_GRNMast.GRN_No, Spare_GRNMast.RecieveDate,Spare_PurchaseOrderMast.PoNumber, VendorMast.VendorName, Spare_GRNMast.CreatedBy,ISNULL(UserMast.Fname, '') + ' ' + ISNULL(UserMast.Mname, '') 
                      + ' ' + ISNULL(UserMast.Lname, '') AS CreatedBy, Spare_GRNMast.CreateDate, 
                      Spare_GRNMast.LastUpdatedDate, Spare_GRNMast.LastUpdatedBy, ISNULL(UserMast_1.Fname, '') 
                      + ' ' + ISNULL(UserMast_1.Mname, '') + ' ' + ISNULL(UserMast_1.Lname, '') AS LastUpdatedBy
FROM         Spare_GRNMast INNER JOIN
                      Spare_PurchaseOrderMast ON Spare_GRNMast.PoID = Spare_PurchaseOrderMast.PoID INNER JOIN
                      VendorMast ON Spare_PurchaseOrderMast.VendorID = VendorMast.VendorID INNER JOIN
                      UserMast ON Spare_GRNMast.CreatedBy = UserMast.UserID LEFT OUTER JOIN
                      UserMast AS UserMast_1 ON Spare_GRNMast.LastUpdatedBy = UserMast_1.UserID



END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_GrnList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_SelectAll_GrnList]


AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     GRNMast.GRN_ID, PurchaseOrderMast.POID, GRNMast.GRN_No, GRNMast.RecieveDate,PurchaseOrderMast.PoNumber, VendorMast.VendorName, GRNMast.CreatedBy,ISNULL(UserMast.Fname, '') + ' ' + ISNULL(UserMast.Mname, '') 
                      + ' ' + ISNULL(UserMast.Lname, '') AS CreatedBy, GRNMast.CreateDate, 
                      GRNMast.LastUpdatedDate, GRNMast.LastUpdatedBy, ISNULL(UserMast_1.Fname, '') 
                      + ' ' + ISNULL(UserMast_1.Mname, '') + ' ' + ISNULL(UserMast_1.Lname, '') AS LastUpdatedBy
FROM         GRNMast INNER JOIN
                      PurchaseOrderMast ON GRNMast.PoID = PurchaseOrderMast.PoID INNER JOIN
                      VendorMast ON PurchaseOrderMast.VendorID = VendorMast.VendorID INNER JOIN
                      UserMast ON GRNMast.CreatedBy = UserMast.UserID LEFT OUTER JOIN
                      UserMast AS UserMast_1 ON GRNMast.LastUpdatedBy = UserMast_1.UserID



END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_InvoiceList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_SelectAll_InvoiceList]


AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     InVoiceMast.InvoiceID, InVoiceMast.InvoiceNumber, InVoiceMast.InvoiceDate, InVoiceMast.OwnerType,InVoiceMast.IsWaranty,

CASE InVoiceMast.IsWaranty
WHEN 1 THEN 'IW'
WHEN 0 THEN 'OW'
WHEN '' THEN 'OC'
END AS ServiceType

,
CASE InVoiceMast.OwnerType
WHEN 'C' THEN 'Customer'
WHEN 'D' THEN 'Dealer'
WHEN 'S' THEN 'Sales Person'
END AS OwnerTypes

,
CASE InVoiceMast.OwnerType
WHEN 'C' THEN (SELECT DISTINCT C.Fname+' '+ C.Mname+' '+ C.Lname 
FROM         InVoiceMast AS I INNER JOIN
                      CustomerMast AS C ON I.CustomerID = C.CustomerID where I.InvoiceID = InVoiceMast.InvoiceID)
WHEN 'D' THEN (SELECT DISTINCT D.DealerName
FROM         InVoiceMast I INNER JOIN
                      DealerMast D ON I.OwnerID = D.DealerID WHERE I.InvoiceID = InVoiceMast.InvoiceID)
WHEN 'S' THEN (SELECT DISTINCT C.Fname+' '+ C.Mname+' '+ C.Lname 
FROM         InVoiceMast AS I INNER JOIN
                      CustomerMast AS C ON I.CustomerID = C.CustomerID where I.InvoiceID = InVoiceMast.InvoiceID)
END AS FullName
,

 InVoiceMast.TotalAmt, 
                      InVoiceMast.NetAmt, InVoiceMast.VatAmt, InVoiceMast.VatPercent, PaymentMode.ModeName
FROM         InVoiceMast INNER JOIN
                      PaymentMode ON InVoiceMast.PaymentModeID = PaymentMode.PaymentModeID


END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_Item_GrnDtls_By_PoID_GRNID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 13 Sep 2010
-- Description:	Store Procedure For getting GRN Details by Poid and grnID
-- =============================================




CREATE PROCEDURE [dbo].[UC_SelectAll_Item_GrnDtls_By_PoID_GRNID]
@PoID int,
@GRN_ID int

AS
BEGIN
	
	SET NOCOUNT ON;
	

SELECT     Spare_GRNDtls.GRNDtlID, Spare_GRNDtls.GRN_ID, Spare_GRNDtls.ProductID, Spare_GRNDtls.Quantity, ProductMast.Product
FROM         Spare_GRNDtls INNER JOIN
                      Spare_GRNMast ON Spare_GRNDtls.GRN_ID = Spare_GRNMast.GRN_ID INNER JOIN
                      ProductMast ON Spare_GRNDtls.ProductID = ProductMast.ProductID
WHERE     (Spare_GRNMast.PoID = @PoID) AND (Spare_GRNDtls.GRN_ID = @GRN_ID)



END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_PendingCallList_For_CallAssigning]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Customer Details
-- =============================================

create PROCEDURE [dbo].[UC_SelectAll_PendingCallList_For_CallAssigning]

AS
BEGIN
	
	SET NOCOUNT ON;
	

  
SELECT    ServiceMast.ServiceID as RecordID,'Service Call' as CallType,  CustomerMast.Fname+' '+ CustomerMast.Mname+' '+ CustomerMast.Lname as CustomerName, CityMast.CityName, AreaMast.Area, 
                    ProductMast.Product  , ProductBrandMast.BrandName
                      , ServiceMast.SerialNo,ServiceMast.NxtServiceDate as CallDate,datediff(day,ServiceMast.NxtServiceDate,getdate()) as daysDue
FROM         CustomerMast INNER JOIN
                      ServiceMast ON CustomerMast.CustomerID = ServiceMast.CustomerID INNER JOIN
                      CityMast ON CustomerMast.CityID = CityMast.CityID INNER JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID INNER JOIN
                      ProductMast ON ServiceMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID

where datediff(day,ServiceMast.NxtServiceDate,getdate())>=-1

and (ServiceMast.ServiceID not in(SELECT     ServiceMast.ServiceID
FROM         ServiceCallAsignMast INNER JOIN
                      ServiceMast ON ServiceCallAsignMast.RecordID = ServiceMast.ServiceID where ServiceCallAsignMast.CallType='Service Call' )   )
and ServiceMast.IsClose=0

union 




SELECT     CustomerComplaintMast.CustomerComplaintID as RecordID,'Complaint Call' as CallType, CustomerMast.Fname+' '+ CustomerMast.Mname+' '+ CustomerMast.Lname as CustomerName, CityMast.CityName, 
                      AreaMast.Area, ProductMast.Product, ProductBrandMast.BrandName, CustomerComplaintMast.SerialNo, CustomerComplaintMast.ComplaintDate as CallDate, 
                      datediff(day,CustomerComplaintMast.ComplaintDate,getdate()) as daysDue
FROM         CustomerComplaintMast INNER JOIN
                      CustomerMast ON CustomerComplaintMast.CustomerID = CustomerMast.CustomerID INNER JOIN
                      AreaMast ON CustomerMast.AreaID = AreaMast.AreaID INNER JOIN
                      CityMast ON CustomerMast.CityID = CityMast.CityID INNER JOIN
                      ProductMast ON CustomerComplaintMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID
where CustomerComplaintMast.IsClose=0
 and (CustomerComplaintMast.CustomerComplaintID not in(SELECT CustomerComplaintMast.CustomerComplaintID
FROM         ServiceCallAsignMast INNER JOIN
                      ServiceMast ON ServiceCallAsignMast.RecordID = CustomerComplaintMast.CustomerComplaintID where ServiceCallAsignMast.CallType='Complaint Call'  ))
order by CustomerName,CallDate desc
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_ProductBrandMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_SelectAll_ProductBrandMast]

AS
BEGIN
	
	SET NOCOUNT ON;
	

SELECT     ProductBrandMast.ProductBrandID, ProductBrandMast.BrandName, ProductBrandMast.CreateDate, ProductBrandMast.LastUpdatedDate,
                          (SELECT     UserMast.Fname + ' ' + UserMast.Lname AS Expr1
                            FROM          UserMast INNER JOIN
                                                   ProductBrandMast AS p ON UserMast.UserID = p.LastUpdatedBy
                            WHERE      (ProductBrandMast.ProductBrandID = p.ProductBrandID)) AS LastUpdatedBy,
                          (SELECT     UserMast_2.Fname + ' ' + UserMast_2.Lname AS Expr1
                            FROM          UserMast AS UserMast_2 INNER JOIN
                                                   ProductBrandMast AS p1 ON UserMast_2.UserID = p1.CreatedBy
                            WHERE      (ProductBrandMast.ProductBrandID = p1.ProductBrandID)) AS CreatedBy
FROM         ProductBrandMast INNER JOIN
                      UserMast AS UserMast_1 ON ProductBrandMast.LastUpdatedBy = UserMast_1.UserID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_ProductMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_SelectAll_ProductMast]

AS
BEGIN
	
	SET NOCOUNT ON;
	
--SELECT     ProductMast.ProductID, ProductMast.Product, ProductBrandMast.ProductBrandID, ProductMast.PurchasePrice, ProductMast.SalePrice, ProductMast.StockCount, 
--                  isActive,   ProductBrandMast.BrandName,
--                          (SELECT     UserMast.Fname + ' ' + UserMast.Lname AS Expr1
--                            FROM          UserMast INNER JOIN
--                                                   ProductMast AS p ON UserMast.UserID = p.LastUpdatedBy
--                            WHERE      (ProductMast.ProductID = p.ProductID)) AS LastUpdatedBy,
--                          (SELECT     UserMast_1.Fname + ' ' + UserMast_1.Lname AS Expr1
--                            FROM          UserMast AS UserMast_1 INNER JOIN
--                                                   ProductMast AS p1 ON UserMast_1.UserID = p1.CreatedBy
--                            WHERE      (ProductMast.ProductID = p1.ProductID)) AS CreatedBy, ProductMast.CreateDate, ProductMast.LastUpdatedDate
--FROM         ProductMast INNER JOIN
--                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID


SELECT        ProductMast.ProductID, ProductMast.Product, ProductMast.ProductBrandID, ProductMast.CreateDate, ProductMast.isActive, ISNULL(ProductBrandMast.BrandName, 'no Brand') AS BrandName, 
                         ProductMast.CrateSize, isnull(ProductMast.GST,0)GST, ProductBrandMast.BrandName AS BrandName
FROM            ProductMast LEFT OUTER JOIN
                         ProductBrandMast ON ProductMast.StockCount = ProductBrandMast.ProductBrandID
WHERE        (ProductMast.isActive = 1)

END





GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_ProductTypeMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_SelectAll_ProductTypeMast]

AS
BEGIN
	
	SET NOCOUNT ON;
	

  
SELECT     ProductTypeMast.ProductTypeID,ProductTypeMast.NumberOFService,
convert(varchar(50), ProductTypeMast.FrequencyInMonth)+' Month' as FrequencyInMonth , ProductTypeMast.ProductType, ProductTypeMast.CreateDate,ProductTypeMast.LastUpdatedDate,
                          (SELECT     UserMast.Fname + ' ' + UserMast.Lname 
                            FROM          UserMast INNER JOIN
                                                   ProductTypeMast p on UserMast.Userid=p.LastUpdatedBy where ProductTypeMast.ProductTypeID = p.ProductTypeID)AS LastUpdatedBy,
 (SELECT     UserMast.Fname + ' ' + UserMast.Lname 
                            FROM          UserMast INNER JOIN
                                                   ProductTypeMast p1 on UserMast.Userid=p1.CreatedBy where ProductTypeMast.ProductTypeID = p1.ProductTypeID)AS CreatedBy

                      FROM          ProductTypeMast INNER JOIN
                                             UserMast ON ProductTypeMast.LastUpdatedBy = UserMast.UserID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_SpareInvoiceList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_SelectAll_SpareInvoiceList]


AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     SpareInvoiceMast.InvoiceID, SpareInvoiceMast.InvoiceNumber, SpareInvoiceMast.InvoiceDate, SpareInvoiceMast.TotalAmt, 
                      EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, PaymentMode.ModeName
FROM         SpareInvoiceMast INNER JOIN
                      PaymentMode ON SpareInvoiceMast.PaymentModeID = PaymentMode.PaymentModeID INNER JOIN
                      EmployeeMast ON SpareInvoiceMast.OwnerID = EmployeeMast.EmployeeID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_SpareInvoiceList_By_InvoiceID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 08 Sep 2010
-- Description:	Store Procedure For getting Product recieved in GRN List
-- =============================================




CREATE PROCEDURE [dbo].[UC_SelectAll_SpareInvoiceList_By_InvoiceID]
@InvoiceID int

AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     SpareInvoiceMast.InvoiceID, SpareInvoiceMast.InvoiceNumber, SpareInvoiceMast.InvoiceDate, SpareInvoiceMast.TotalAmt, 
                      SpareInvoiceMast.PaymentModeID, EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, 
                      SpareInvoiceMast.CustomerID, SpareInvoiceMast.OwnerID, SpareInvoiceMast.ChequeNo, SpareInvoiceMast.ChequeDate, 
                      SpareInvoiceMast.BankName
FROM         SpareInvoiceMast INNER JOIN
                      PaymentMode ON SpareInvoiceMast.PaymentModeID = PaymentMode.PaymentModeID INNER JOIN
                      EmployeeMast ON SpareInvoiceMast.OwnerID = EmployeeMast.EmployeeID
WHERE     (SpareInvoiceMast.InvoiceID = @InvoiceID)
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_SpareStockList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_SelectAll_SpareStockList]


AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT DISTINCT 
                      ProductMast.Product, ProductBrandMast.BrandName, Spare_StockMast.Quantity, Spare_GRNDtls.PerUnitPrice, Spare_StockMast.StockID, 
                      Spare_StockMast.ProductID
FROM         Spare_StockMast INNER JOIN
                      ProductMast ON Spare_StockMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      Spare_GRNDtls ON ProductMast.ProductID = Spare_GRNDtls.ProductID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_UserMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_SelectAll_UserMast]

AS
BEGIN
	
	SET NOCOUNT ON;
	
SELECT     UserMast.UserID, UserMast.Fname + ' ' + UserMast.Mname + ' ' + UserMast.Lname AS FullName, UserTypeMast.UserType, UserMast.IsActive, 
                      UserMast.CreateDate
FROM         UserMast INNER JOIN
                      UserTypeMast ON UserMast.UserTypeID = UserTypeMast.UserTypeID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_VatMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_SelectAll_VatMast]

AS
BEGIN
	
	SET NOCOUNT ON;
	

  
SELECT     VatMast.VatID,convert(varchar(50), VatMast.Value)+' %' as vatAmt, VatMast.CreateDate,VatMast.LastUpdatedDate,
                          (SELECT     UserMast.Fname + ' ' + UserMast.Lname 
                            FROM          UserMast INNER JOIN
                                                   VatMast p on UserMast.Userid=p.LastUpdatedBy where VatMast.VatID = p.VatID)AS LastUpdatedBy,
 (SELECT     UserMast.Fname + ' ' + UserMast.Lname 
                            FROM          UserMast INNER JOIN
                                                   VatMast p1 on UserMast.Userid=p1.CreatedBy where VatMast.VatID = p1.VatID)AS CreatedBy

                      FROM          VatMast INNER JOIN
                                             UserMast ON VatMast.LastUpdatedBy = UserMast.UserID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAll_VendorMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Vendor Details
-- =============================================

CREATE PROCEDURE [dbo].[UC_SelectAll_VendorMast]

AS
BEGIN
	
	SET NOCOUNT ON;
	

  
SELECT     VendorID, VendorName, Address, EmailID, OfficePhone, FaxNo, ContactPerson, PersonMobileNo, IsActive, CreateDate, 
                      LastUpdatedBy AS LastUpdatedByID, LastUpdatedDate
FROM         VendorMast
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectAssignedCalls_By_ServicePersonID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Customer Details
-- =============================================

CREATE PROCEDURE [dbo].[UC_SelectAssignedCalls_By_ServicePersonID]
@ServicePersonID int
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ServiceCallAsignMast.CallDate, EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, CityMast.CityName, 
                      AreaMast.Area, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, CustomerMast.Address, 
                      ProductMast.Product, ServiceMast.SerialNo, ProductBrandMast.BrandName,ServiceCallAsignMast.CallType,ServiceCallAsignMast.RecordID,ProductMast.ProductID
					 ,CustomerMast.ZipCode,CustomerMast.EmailID,CustomerMast.Phone,CustomerMast.Mobile,EmployeeMast.EmployeeID, ServiceMast.ServiceTypeID,'' as ComplaintNo
					,CustomerMast.CustomerID,ServiceCallAsignMast.ServiceCallAsignID,ServiceMast.NxtServiceDate as ActualCallDate
FROM         ServiceCallAsignMast INNER JOIN
                      EmployeeMast ON ServiceCallAsignMast.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast INNER JOIN
                      AreaMast ON CityMast.CityID = AreaMast.CityID INNER JOIN
                      ServiceMast INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID ON CityMast.CityID = CustomerMast.CityID AND 
                      AreaMast.AreaID = CustomerMast.AreaID ON ServiceCallAsignMast.RecordID = ServiceMast.ServiceID INNER JOIN
                      ProductMast ON ServiceMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID
where ServiceCallAsignMast.CallType = 'Service Call' and ServiceCallAsignMast.IsClose=0 and ServiceCallAsignMast.ServicePersonID=@ServicePersonID

union all


SELECT     ServiceCallAsignMast.CallDate, EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, CityMast.CityName, 
                      AreaMast.Area, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, CustomerMast.Address, 
                      ProductMast.Product, CustomerComplaintMast.SerialNo, ProductBrandMast.BrandName, ServiceCallAsignMast.CallType,
                      ServiceCallAsignMast.RecordID, ProductMast.ProductID, CustomerMast.ZipCode, CustomerMast.EmailID, CustomerMast.Phone, CustomerMast.Mobile, 
                      EmployeeMast.EmployeeID, CustomerComplaintMast.ServiceTypeID, CustomerComplaintMast.ComplaintNo
					,CustomerMast.CustomerID,ServiceCallAsignMast.ServiceCallAsignID,CustomerComplaintMast.ComplaintDate as ActualCallDate
FROM         ServiceCallAsignMast INNER JOIN
                      EmployeeMast ON ServiceCallAsignMast.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast INNER JOIN
                      AreaMast ON CityMast.CityID = AreaMast.CityID INNER JOIN
                      CustomerComplaintMast INNER JOIN
                      CustomerMast ON CustomerComplaintMast.CustomerID = CustomerMast.CustomerID ON CityMast.CityID = CustomerMast.CityID AND 
                      AreaMast.AreaID = CustomerMast.AreaID ON ServiceCallAsignMast.RecordID = CustomerComplaintMast.CustomerComplaintID INNER JOIN
                      ProductMast ON CustomerComplaintMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductBrandMast.ProductBrandID = ProductMast.ProductBrandID
WHERE     ServiceCallAsignMast.CallType = 'Complaint Call' and ServiceCallAsignMast.IsClose=0 and ServiceCallAsignMast.ServicePersonID=@ServicePersonID
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectParts_by_SrvicePersonID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 16 2010  1:02PM
-- Description : Delete Procedure for StockMast
-- Exec [dbo].[UC_DeleteStockMast] @StockID  int
    
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_SelectParts_by_SrvicePersonID]
     @ServicePersonID  int,
@GatePassID int
    
AS
BEGIN


BEGIN TRY

   SELECT DISTINCT p.ProductID, (SELECT     SUM(s.Quantity) - SUM(s.UsedQty) 
                            FROM          SpareGatePassDtls AS s INNER JOIN
                                                   SpareGatePassMast AS sm ON sm.GatePassID = s.GatePassID
                            WHERE      (s.ProductID = p.ProductID) AND (sm.ServicePersonID = k.ServicePersonID)) AS Qty, ProductMast.Product
FROM         SpareGatePassMast AS k INNER JOIN
                      SpareGatePassDtls AS p ON k.GatePassID = p.GatePassID INNER JOIN
                      ProductMast ON p.ProductID = ProductMast.ProductID
WHERE     (k.ServicePersonID = @ServicePersonID)and(P.GatePassID=@GatePassID)


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectPaymentList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 18 2010  3:29PM
-- Description : Insert Procedure for tblPayMent
-- Exec [dbo].[UC_InserttblPayMent] [date],[partyname],[against],[Ammount],[comments],[PayType],[BankName],[chequeNo],[chequeDate]
-- ============================================= */
create PROCEDURE [dbo].[UC_SelectPaymentList]
   
AS
BEGIN

BEGIN TRY
SELECT     payID, date, voucherNo, partyname, against, Ammount,
 comments,

case PaymentModeID
when 0 then 'Cash'
when 1 then 'Cheque'
else 'Both'
end as PayMode



, BankName, chequeNo,
 chequeDate, cashAmt, chkAmt, 
                      partyType
FROM         tblPayMent
   

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectPaymentList_By_PayID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 18 2010  3:29PM
-- Description : Insert Procedure for tblPayMent
-- Exec [dbo].[UC_InserttblPayMent] [date],[partyname],[against],[Ammount],[comments],[PayType],[BankName],[chequeNo],[chequeDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_SelectPaymentList_By_PayID]
  @payID int 
AS
BEGIN

BEGIN TRY
SELECT     payID, date, voucherNo, partyname, against, Ammount,
 comments,PaymentModeID, BankName, chequeNo,
 chequeDate, cashAmt, chkAmt, 
                      partyType
FROM         tblPayMent
   
where payID=@payID
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectPendingCalls_By_ServicePersonID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Customer Details
-- =============================================

CREATE PROCEDURE [dbo].[UC_SelectPendingCalls_By_ServicePersonID]
@ServicePersonID int
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ServiceCallAsignMast.CallDate, EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, CityMast.CityName, 
                      AreaMast.Area, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, CustomerMast.Address, 
                      ProductMast.Product, ServiceMast.SerialNo, ProductBrandMast.BrandName,ServiceCallAsignMast.CallType,ServiceCallAsignMast.RecordID,ProductMast.ProductID
					 ,CustomerMast.ZipCode,CustomerMast.EmailID,CustomerMast.Phone,CustomerMast.Mobile,EmployeeMast.EmployeeID, ServiceMast.ServiceTypeID,'' as ComplaintNo
					,CustomerMast.CustomerID,ServiceCallAsignMast.ServiceCallAsignID,ServiceMast.NxtServiceDate as ActualCallDate
FROM         ServiceCallAsignMast INNER JOIN
                      EmployeeMast ON ServiceCallAsignMast.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast INNER JOIN
                      AreaMast ON CityMast.CityID = AreaMast.CityID INNER JOIN
                      ServiceMast INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID ON CityMast.CityID = CustomerMast.CityID AND 
                      AreaMast.AreaID = CustomerMast.AreaID ON ServiceCallAsignMast.RecordID = ServiceMast.ServiceID INNER JOIN
                      ProductMast ON ServiceMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID
where ServiceCallAsignMast.CallType = 'Service Call' and ServiceCallAsignMast.IsClose=0 and ServiceCallAsignMast.ServicePersonID=@ServicePersonID 

and ServiceCallAsignMast.CallDate<=getdate()

union all

SELECT     ServiceCallAsignMast.CallDate, EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, CityMast.CityName, 
                      AreaMast.Area, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, CustomerMast.Address, 
                      ProductMast.Product, CustomerComplaintMast.SerialNo, ProductBrandMast.BrandName, ServiceCallAsignMast.CallType,
                      ServiceCallAsignMast.RecordID, ProductMast.ProductID, CustomerMast.ZipCode, CustomerMast.EmailID, CustomerMast.Phone, CustomerMast.Mobile, 
                      EmployeeMast.EmployeeID, CustomerComplaintMast.ServiceTypeID, CustomerComplaintMast.ComplaintNo
					,CustomerMast.CustomerID,ServiceCallAsignMast.ServiceCallAsignID,CustomerComplaintMast.ComplaintDate as ActualCallDate
FROM         ServiceCallAsignMast INNER JOIN
                      EmployeeMast ON ServiceCallAsignMast.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast INNER JOIN
                      AreaMast ON CityMast.CityID = AreaMast.CityID INNER JOIN
                      CustomerComplaintMast INNER JOIN
                      CustomerMast ON CustomerComplaintMast.CustomerID = CustomerMast.CustomerID ON CityMast.CityID = CustomerMast.CityID AND 
                      AreaMast.AreaID = CustomerMast.AreaID ON ServiceCallAsignMast.RecordID = CustomerComplaintMast.CustomerComplaintID INNER JOIN
                      ProductMast ON CustomerComplaintMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductBrandMast.ProductBrandID = ProductMast.ProductBrandID
WHERE     ServiceCallAsignMast.CallType = 'Complaint Call' and ServiceCallAsignMast.IsClose=0 and ServiceCallAsignMast.ServicePersonID=@ServicePersonID
and ServiceCallAsignMast.CallDate<=getdate()
END


select * from ServiceCallAsignMast where ServiceCallAsignMast.CallDate<=getdate()




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectProductPrice]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UC_SelectProductPrice]
@ProductID int	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT     SalePrice, PurchasePrice, Product, StockCount,ProductID
FROM         ProductMast
Where ProductID =@ProductID
   
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectServiceCallAssignMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Customer Details
-- =============================================

CREATE PROCEDURE [dbo].[UC_SelectServiceCallAssignMast]

AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ServiceCallAsignMast.CallDate, EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, CityMast.CityName, 
                      AreaMast.Area, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, CustomerMast.Address, 
                      ProductMast.Product, ServiceMast.SerialNo, ProductBrandMast.BrandName,ServiceCallAsignMast.CallType,ServiceCallAsignMast.RecordID,ProductMast.ProductID
					 ,CustomerMast.ZipCode,CustomerMast.EmailID,CustomerMast.Phone,CustomerMast.Mobile,EmployeeMast.EmployeeID, ServiceMast.ServiceTypeID,'' as ComplaintNo
					,CustomerMast.CustomerID,ServiceCallAsignMast.ServiceCallAsignID,ServiceMast.NxtServiceDate as ActualCallDate
FROM         ServiceCallAsignMast INNER JOIN
                      EmployeeMast ON ServiceCallAsignMast.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast INNER JOIN
                      AreaMast ON CityMast.CityID = AreaMast.CityID INNER JOIN
                      ServiceMast INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID ON CityMast.CityID = CustomerMast.CityID AND 
                      AreaMast.AreaID = CustomerMast.AreaID ON ServiceCallAsignMast.RecordID = ServiceMast.ServiceID INNER JOIN
                      ProductMast ON ServiceMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID
where ServiceCallAsignMast.CallType = 'Service Call' and ServiceCallAsignMast.IsClose=0

union all

SELECT     ServiceCallAsignMast.CallDate, EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, CityMast.CityName, 
                      AreaMast.Area, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, CustomerMast.Address, 
                      ProductMast.Product, CustomerComplaintMast.SerialNo, ProductBrandMast.BrandName, ServiceCallAsignMast.CallType,
                      ServiceCallAsignMast.RecordID, ProductMast.ProductID, CustomerMast.ZipCode, CustomerMast.EmailID, CustomerMast.Phone, CustomerMast.Mobile, 
                      EmployeeMast.EmployeeID, CustomerComplaintMast.ServiceTypeID, CustomerComplaintMast.ComplaintNo
					,CustomerMast.CustomerID,ServiceCallAsignMast.ServiceCallAsignID,CustomerComplaintMast.ComplaintDate as ActualCallDate
FROM         ServiceCallAsignMast INNER JOIN
                      EmployeeMast ON ServiceCallAsignMast.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast INNER JOIN
                      AreaMast ON CityMast.CityID = AreaMast.CityID INNER JOIN
                      CustomerComplaintMast INNER JOIN
                      CustomerMast ON CustomerComplaintMast.CustomerID = CustomerMast.CustomerID ON CityMast.CityID = CustomerMast.CityID AND 
                      AreaMast.AreaID = CustomerMast.AreaID ON ServiceCallAsignMast.RecordID = CustomerComplaintMast.CustomerComplaintID INNER JOIN
                      ProductMast ON CustomerComplaintMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductBrandMast.ProductBrandID = ProductMast.ProductBrandID
WHERE     ServiceCallAsignMast.CallType = 'Complaint Call' and ServiceCallAsignMast.IsClose=0
END




GO
/****** Object:  StoredProcedure [dbo].[UC_SelectServiceDetails_By_ServicePersonID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Anupam Thomas
-- Create date: 03 Aug 2010
-- Description:	Store Procedure For getting Customer Details
-- =============================================

CREATE PROCEDURE [dbo].[UC_SelectServiceDetails_By_ServicePersonID]
@ServicePersonID int
AS
BEGIN
	
	SET NOCOUNT ON;
SELECT     ServiceCallAsignMast.CallDate, EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, CityMast.CityName, 
                      AreaMast.Area, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, CustomerMast.Address, 
                      ProductMast.Product, ServiceMast.SerialNo, ProductBrandMast.BrandName, ServiceCallAsignMast.CallType, ServiceCallAsignMast.RecordID, 
                      ProductMast.ProductID, CustomerMast.ZipCode, CustomerMast.EmailID, CustomerMast.Phone, CustomerMast.Mobile, EmployeeMast.EmployeeID, 
                      ServiceMast.ServiceTypeID, '' AS ComplaintNo, CustomerMast.CustomerID, ServiceCallAsignMast.ServiceCallAsignID, 
                      ServiceMast.NxtServiceDate AS ActualCallDate, ServiceCallAsignMast.CallCompletedDate, ServiceDtls.Remark
FROM         ServiceCallAsignMast INNER JOIN
                      EmployeeMast ON ServiceCallAsignMast.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast INNER JOIN
                      AreaMast ON CityMast.CityID = AreaMast.CityID INNER JOIN
                      ServiceMast INNER JOIN
                      CustomerMast ON ServiceMast.CustomerID = CustomerMast.CustomerID ON CityMast.CityID = CustomerMast.CityID AND 
                      AreaMast.AreaID = CustomerMast.AreaID ON ServiceCallAsignMast.RecordID = ServiceMast.ServiceID INNER JOIN
                      ProductMast ON ServiceMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductMast.ProductBrandID = ProductBrandMast.ProductBrandID INNER JOIN
                      ServiceDtls ON ServiceMast.ServiceID = ServiceDtls.ServiceID
where ServiceCallAsignMast.CallType = 'Service Call' and ServiceCallAsignMast.IsClose=1 and ServiceCallAsignMast.ServicePersonID=@ServicePersonID

union all

SELECT     ServiceCallAsignMast.CallDate, EmployeeMast.Fname + ' ' + EmployeeMast.Mname + ' ' + EmployeeMast.Lname AS EmpName, CityMast.CityName, 
                      AreaMast.Area, CustomerMast.Fname + ' ' + CustomerMast.Mname + ' ' + CustomerMast.Lname AS CustName, CustomerMast.Address, 
                      ProductMast.Product, CustomerComplaintMast.SerialNo, ProductBrandMast.BrandName, ServiceCallAsignMast.CallType, 
                      ServiceCallAsignMast.RecordID, ProductMast.ProductID, CustomerMast.ZipCode, CustomerMast.EmailID, CustomerMast.Phone, CustomerMast.Mobile, 
                      EmployeeMast.EmployeeID, CustomerComplaintMast.ServiceTypeID, CustomerComplaintMast.ComplaintNo, CustomerMast.CustomerID, 
                      ServiceCallAsignMast.ServiceCallAsignID, CustomerComplaintMast.ComplaintDate AS ActualCallDate, ServiceCallAsignMast.CallCompletedDate, 
                      CustomerComplaintDtls.Remark
FROM         ServiceCallAsignMast INNER JOIN
                      EmployeeMast ON ServiceCallAsignMast.ServicePersonID = EmployeeMast.EmployeeID INNER JOIN
                      CityMast INNER JOIN
                      AreaMast ON CityMast.CityID = AreaMast.CityID INNER JOIN
                      CustomerComplaintMast INNER JOIN
                      CustomerMast ON CustomerComplaintMast.CustomerID = CustomerMast.CustomerID ON CityMast.CityID = CustomerMast.CityID AND 
                      AreaMast.AreaID = CustomerMast.AreaID ON ServiceCallAsignMast.RecordID = CustomerComplaintMast.CustomerComplaintID INNER JOIN
                      ProductMast ON CustomerComplaintMast.ProductID = ProductMast.ProductID INNER JOIN
                      ProductBrandMast ON ProductBrandMast.ProductBrandID = ProductMast.ProductBrandID INNER JOIN
                      CustomerComplaintDtls ON CustomerComplaintMast.CustomerComplaintID = CustomerComplaintDtls.CustomerComplaintID
WHERE     ServiceCallAsignMast.CallType = 'Complaint Call' and ServiceCallAsignMast.IsClose=1 and ServiceCallAsignMast.ServicePersonID=@ServicePersonID

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Set_CallAsignMastToCompleted]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  6 2010  5:16PM
-- Description : Update Procedure for ServiceCallAsignMast
-- Exec [dbo].[UC_UpdateServiceCallAsignMast] [CallType],[RecordID],[CallDate],[CallCompletedDate],[ServicePersonID],[IsClose],[assignedBy],[CreateDate]
-- ============================================= */
create  PROCEDURE [dbo].[UC_Set_CallAsignMastToCompleted]
     
    @ServiceCallAsignID  int
    
    
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[ServiceCallAsignMast]
    SET 
       
        
        
       [IsClose] = 1
        
        
    WHERE [RecordID] = @ServiceCallAsignID

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateAreaMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      :Vinoad Sabbade
-- Create date : Sep  2 2010  5:06PM
-- Description : Update Procedure for AreaMast
-- Exec [dbo].[UC_UpdateAreaMast] [Area],[CityID],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateAreaMast]
     @AreaID  int
    , @Area  nvarchar(50)
    ,@CityID  int

    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[AreaMast]
    SET 
         [Area] = @Area
        ,[CityID] = @CityID
       
        
    WHERE [AreaID] = @AreaID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateCityMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  2 2010  4:28PM
-- Description : Update Procedure for CityMast
-- Exec [dbo].[UC_UpdateCityMast] [CityName],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateCityMast]
     @CityID  int
    ,@CityName  varchar(50)
 
    ,@LastUpdatedBy  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[CityMast]
    SET 
         [CityName] = @CityName
       
        ,[LastUpdatedDate] = getdate()
        ,[LastUpdatedBy] = @LastUpdatedBy
        
    WHERE [CityID] = @CityID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateCompanyProfileMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 15 2010 10:55AM
-- Description : Update Procedure for CompanyProfileMast
-- Exec [dbo].[UC_UpdateCompanyProfileMast] [Name],[Nickname],[Address1],[Address2],[Address3],[Phone],[Mobile],[LogoFile]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateCompanyProfileMast]
     @Name  nvarchar(max)
    ,@Nickname  nvarchar(max)
    ,@Address1  nvarchar(max)
    ,@Address2  nvarchar(max)
    ,@Address3  nvarchar(max)
    ,@Phone  nvarchar(max)
    ,@Mobile  nvarchar(max)
    ,@LogoFile  nvarchar(max)
    ,@CompanyID int
    ,@ReturnAmt decimal
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[CompanyProfileMast]
    SET 
         [Name] = @Name
        ,[Nickname] = @Nickname
        ,[Address1] = @Address1
        ,[Address2] = @Address2
        ,[Address3] = @Address3
        ,[Phone] = @Phone
        ,[Mobile] = @Mobile
        ,[LogoFile] = @LogoFile
		,[ReturnAmt]=@ReturnAmt
        
    where CompanyID=@CompanyID


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateCustBankInfoMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 25 2010  2:48PM
-- Description : Update Procedure for CustBankInfoMast
-- Exec [dbo].[UC_UpdateCustBankInfoMast] [CustID],[BankName],[BranchAddress],[AccNo]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateCustBankInfoMast]
     @BankInfoID  int
    ,@CustID  int
    ,@BankName  nvarchar(max)
    ,@BranchAddress  nvarchar(max)
    ,@AccNo  varchar(50)
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[CustBankInfoMast]
    SET 
         [CustID] = @CustID
        ,[BankName] = @BankName
        ,[BranchAddress] = @BranchAddress
        ,[AccNo] = @AccNo
        
    WHERE [BankInfoID] = @BankInfoID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateCustomerComplaintDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 13 2010  5:49PM
-- Description : Update Procedure for CustomerComplaintDtls
-- Exec [dbo].[UC_UpdateCustomerComplaintDtls] [CustomerComplaintID],[ServicePersonID],[ActualComplaintDate],[ComplaintDoneDate],[Remark],[Document],[NetAmount],[VatPercent],[VatAmount],[TaxPercent],[TaxAmount],[ServiceCharge],[TotalAmount],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateCustomerComplaintDtls]
     @CustomerComplntDtlID  int
    ,@CustomerComplaintID  int
    ,@ServicePersonID  int
    ,@ActualComplaintDate  datetime
    ,@ComplaintDoneDate  datetime
    ,@Remark  nvarchar(150)
    ,@Document  nvarchar(max)
    ,@NetAmount  decimal
    ,@VatPercent  decimal
    ,@VatAmount  decimal
    ,@TaxPercent  decimal
    ,@TaxAmount  decimal
    ,@ServiceCharge  decimal
    ,@TotalAmount  decimal
    ,@CreateDate  datetime
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[CustomerComplaintDtls]
    SET 
         [CustomerComplaintID] = @CustomerComplaintID
        ,[ServicePersonID] = @ServicePersonID
        ,[ActualComplaintDate] = @ActualComplaintDate
        ,[ComplaintDoneDate] = @ComplaintDoneDate
        ,[Remark] = @Remark
        ,[Document] = @Document
        ,[NetAmount] = @NetAmount
        ,[VatPercent] = @VatPercent
        ,[VatAmount] = @VatAmount
        ,[TaxPercent] = @TaxPercent
        ,[TaxAmount] = @TaxAmount
        ,[ServiceCharge] = @ServiceCharge
        ,[TotalAmount] = @TotalAmount
        ,[CreateDate] = @CreateDate
        
    WHERE [CustomerComplntDtlID] = @CustomerComplntDtlID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateCustomerComplaintMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  2 2010 10:21AM
-- Description : Update Procedure for CustomerComplaintMast
-- Exec [dbo].[UC_UpdateCustomerComplaintMast] [CustomerComplaintID],[CustomerID],[ProductID],[SerialNo],[Descriptn],[ComplaintDate],[CreatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateCustomerComplaintMast]
     @CustomerComplaintID  int
    ,@CustomerID  int
    ,@ProductID  int
    ,@SerialNo  nvarchar(50)
    ,@Descriptn  nvarchar(max)
    ,@ComplaintDate  datetime
    ,@CreatedBy  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[CustomerComplaintMast]
    SET 
        
        [CustomerID] = @CustomerID
        ,[ProductID] = @ProductID
        ,[SerialNo] = @SerialNo
        ,[Descriptn] = @Descriptn
        ,[ComplaintDate] = @ComplaintDate
        ,[CreatedBy] = @CreatedBy
        
    where  CustomerComplaintID = @CustomerComplaintID


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateCustomerMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[UC_UpdateCustomerMast] 
	(
		@CustomerID int,
		@CustomerName nvarchar(50),
		@Address nvarchar(350),
		@AreaID int=null,
		@Mobile nvarchar(50),
		@EmployeeId int=null,
		@VehicleID int=null,
		@isActive int,
		@BillRequired int,
		@DeliveryCharges decimal(9,2),
		@CustomerTypeId int=1
		)
		AS
		Update  CustomerMast Set 
		[CustomerName]=@CustomerName,
		[Address]=@Address,
		[AreaID]=@AreaID,
		[Mobile]=@Mobile,
		[SalesPersonID]=@EmployeeId,
		[VehicleID]=@VehicleID,
		[isBillRequired] = @BillRequired,
		[isActive]=@isActive,
		[DeliveryCharges]=@DeliveryCharges,
		[CustomerTypeId]=@CustomerTypeId
 
		where 
		[CustomerID]=@CustomerID


Return
select * from CustomerMast

GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateDateCountMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 18 2010  1:26PM
-- Description : Update Procedure for DateCountMast
-- Exec [dbo].[UC_UpdateDateCountMast] [DateCount]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateDateCountMast]
     @DatetimeCountID  int
    ,@DateCount  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[DateCountMast]
    SET 
         [DateCount] = @DateCount
        
    WHERE [DatetimeCountID] = @DatetimeCountID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateDealerMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  3 2010  4:14PM
-- Description : Update Procedure for DealerMast
-- Exec [dbo].[UC_UpdateDealerMast] [DealerName],[Address],[AreaID],[CityID],[EmailID],[OfficePhone],[FaxNo],[ContactPerson],[PersonMobileNo],[IsActive],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateDealerMast]
     @DealerID  int
    ,@DealerName  varchar(50)
    ,@Address  nvarchar(250)
    ,@AreaID  int
    ,@CityID  int
    ,@EmailID  nvarchar(50)
    ,@OfficePhone  nvarchar(50)
    ,@FaxNo  nvarchar(50)
    ,@ContactPerson  varchar(50)
    ,@PersonMobileNo  varchar(20)
    ,@IsActive  bit
    , @LastUpdatedBy int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[DealerMast]
    SET 
         [DealerName] = @DealerName
        ,[Address] = @Address
        ,[AreaID] = @AreaID
        ,[CityID] = @CityID
        ,[EmailID] = @EmailID
        ,[OfficePhone] = @OfficePhone
        ,[FaxNo] = @FaxNo
        ,[ContactPerson] = @ContactPerson
        ,[PersonMobileNo] = @PersonMobileNo
        ,[IsActive] = @IsActive
        ,[LastUpdatedDate] =  getdate()
        ,[LastUpdatedBy] = @LastUpdatedBy
        
    WHERE [DealerID] = @DealerID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateDocPathSettingsMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 14 2010  1:58PM
-- Description : Update Procedure for DocPathSettingsMast
-- Exec [dbo].[UC_UpdateDocPathSettingsMast] [DocID],[DocType],[Path]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateDocPathSettingsMast]
     @DocID  int
    ,@DocType  varchar(50)
    ,@Path  nvarchar(max)
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[DocPathSettingsMast]
    SET 
        [DocType] = @DocType
        ,[Path] = @Path
        
    where [DocID]=@DocID


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateGateDtls_IsSold_AfterInvoice]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 24 2010 10:48AM
-- Description : Update Procedure for GatePassMast
-- Exec [dbo].[UC_UpdateGatePassMast] [GatePassNumb],[OwnerID],[OwnerType],[IssueDate],[IssuedBy],[TotalOutStandingAmt],[CreatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateGateDtls_IsSold_AfterInvoice]
     @GatePassID  int
    ,@ProductID  int
    ,@SerialNo  nvarchar(50)
    ,@IsSold bit
    ,@PerUnitPrice decimal(18,2)
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[GatePassDtls]
    SET 
         IsSold=@IsSold
       
    WHERE [GatePassID] = @GatePassID and ProductID=@ProductID and SerialNo=@SerialNo
-- if	(@IsSold =1)
--begin
--
--update OutStandingMast set TotalOutStandingAmt=TotalOutStandingAmt-@PerUnitPrice
--WHERE [GatePassID] = @GatePassID
--end 
--else
--begin
--update OutStandingMast set TotalOutStandingAmt=TotalOutStandingAmt+@PerUnitPrice
--WHERE [GatePassID] = @GatePassID
--end
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateGatePassMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 24 2010 10:48AM
-- Description : Update Procedure for GatePassMast
-- Exec [dbo].[UC_UpdateGatePassMast] [GatePassNumb],[OwnerID],[OwnerType],[IssueDate],[IssuedBy],[TotalOutStandingAmt],[CreatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateGatePassMast]
     @GatePassID  int
    ,@GatePassNumb  nvarchar(50)
    ,@OwnerID  int
    ,@OwnerType  char(1)
    ,@IssueDate  datetime
    ,@IssuedBy  int
    ,@TotalOutStandingAmt  decimal(18,2)
    ,@CreatedBy  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[GatePassMast]
    SET 
         [GatePassNumb] = @GatePassNumb
        ,[OwnerID] = @OwnerID
        ,[OwnerType] = @OwnerType
        ,[IssueDate] = @IssueDate
        ,[IssuedBy] = @IssuedBy
        ,[TotalOutStandingAmt] = @TotalOutStandingAmt
        ,[CreatedBy] = @CreatedBy
        
    WHERE [GatePassID] = @GatePassID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateGRNMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 13 2010 12:51PM
-- Description : Update Procedure for GRNMast
-- Exec [dbo].[UC_UpdateGRNMast] [PoID],[GRN_No],[RecieveDate],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateGRNMast]
     @GRN_ID  int
    ,@PoID  int
    ,@GRN_No  nvarchar(50)
    ,@RecieveDate  datetime
    ,@LastUpdatedBy  int
 
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[GRNMast]
    SET 
         [PoID] = @PoID
        ,[GRN_No] = @GRN_No
        ,[RecieveDate] = @RecieveDate
        ,[LastUpdatedDate] = getdate()
        ,[LastUpdatedBy] = @LastUpdatedBy
        
    WHERE [GRN_ID] = @GRN_ID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateInvoiceDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 27 2010  6:21PM
-- Description : Update Procedure for InvoiceDtls
-- Exec [dbo].[UC_UpdateInvoiceDtls] [InvoiceID],[GatePassID],[ProductID],[SerialNo],[ActualPrice],[SoldPrice]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateInvoiceDtls]
     @InvoiceDtlID  int
    ,@InvoiceID  int
    ,@GatePassID  int
    ,@ProductID  int
    ,@SerialNo  nvarchar(50)
    ,@ActualPrice  decimal
    ,@SoldPrice  decimal
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[InvoiceDtls]
    SET 
         [InvoiceID] = @InvoiceID
        ,[GatePassID] = @GatePassID
        ,[ProductID] = @ProductID
        ,[SerialNo] = @SerialNo
        ,[ActualPrice] = @ActualPrice
        ,[SoldPrice] = @SoldPrice
        
    WHERE [InvoiceDtlID] = @InvoiceDtlID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateInVoiceMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep 27 2010  6:21PM
-- Description : Update Procedure for InVoiceMast
-- Exec [dbo].[UC_UpdateInVoiceMast] [InvoiceNumber],[InvoiceDate],[CustomerID],[OwnerID],[OwnerType],[IsWaranty],[TotalAmt],[NetAmt],[VatAmt],[VatPercent],[PaymentModeID],[ChequeNo],[ChequeDate],[BankName],[CreatedBy],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateInVoiceMast]
     @InvoiceID  int
    ,@InvoiceNumber  nvarchar(50)
    ,@InvoiceDate  datetime
    ,@CustomerID  int
    ,@OwnerID  int
    ,@OwnerType  char(1)
    ,@IsWaranty  bit
    ,@TotalAmt  decimal
    ,@NetAmt  decimal
    ,@VatAmt  decimal
    ,@VatPercent  decimal
    ,@PaymentModeID  int
    ,@ChequeNo  nvarchar(50)
    ,@ChequeDate  datetime
    ,@BankName  varchar(50)
    ,@CreatedBy  int
  
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[InVoiceMast]
    SET 
         [InvoiceNumber] = @InvoiceNumber
        ,[InvoiceDate] = @InvoiceDate
        ,[CustomerID] = @CustomerID
        ,[OwnerID] = @OwnerID
        ,[OwnerType] = @OwnerType
        ,[IsWaranty] = @IsWaranty
        ,[TotalAmt] = @TotalAmt
        ,[NetAmt] = @NetAmt
        ,[VatAmt] = @VatAmt
        ,[VatPercent] = @VatPercent
        ,[PaymentModeID] = @PaymentModeID
        ,[ChequeNo] = @ChequeNo
        ,[ChequeDate] = @ChequeDate
        ,[BankName] = @BankName
        ,[CreatedBy] = @CreatedBy
        
        
    WHERE [InvoiceID] = @InvoiceID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateNumberSettingsMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 14 2010  2:47PM
-- Description : Update Procedure for NumberSettingsMast
-- Exec [dbo].[UC_UpdateNumberSettingsMast] [DocID],[DocType],[Prefix],[StartNumber]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateNumberSettingsMast]
     @DocID  int
   
    ,@Prefix  varchar(50)
    ,@StartNumber  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[NumberSettingsMast]
    SET 
         
        
        [Prefix] = @Prefix
        ,[StartNumber] = @StartNumber
        
where [DocID] = @DocID
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateOutStanding]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_UpdateOutStanding]
@CustomerID  int,
@LastPaymentDate datetime =null,
@LastPayment  decimal(18,2)=0,
--@PaidAmount decimal(18,2)=0,
@UnPaidAmount decimal(18,2)=0
   
AS
BEGIN

BEGIN TRY

	IF EXISTS (SELECT CustomerID FROM dbo.CustomerPayment WHERE CustomerID = @CustomerID)
		BEGIN
			UPDATE    CustomerPayment
			SET LastPayment=@LastPayment , LastPaymentDate=@LastPaymentDate,
			PaidAmount=(SELECT  PaidAmount FROM CustomerPayment where CustomerID=@CustomerID)+@LastPayment,
			UnPaidAmount=(SELECT  UnPaidAmount FROM CustomerPayment where CustomerID=@CustomerID)+@UnPaidAmount
			where CustomerID=@CustomerID

		END
	ELSE
		BEGIN
		   -- INSERT HERE
			INSERT INTO [dbo].[CustomerPayment]
						([CustomerID]
						,[PaidAmount]
						,[UnPaidAmount]
						,LastPaymentDate
						,LastPayment)
				 VALUES
						(@CustomerID,
						0,
						@UnPaidAmount,
						@LastPaymentDate,
						@LastPayment)
	END

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdatePartDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 13 2010  4:42PM
-- Description : Update Procedure for PartDtls
-- Exec [dbo].[UC_UpdatePartDtls] [ServiceDtlsID],[ParID],[Quantity],[PerUnitPrice],[TotalAmount]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdatePartDtls]
     @ServiceDtlsID  int
    ,@ParID  int
    ,@Quantity  int
    ,@PerUnitPrice  decimal
    ,@TotalAmount  decimal
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[PartDtls]
    SET 
         [ServiceDtlsID] = @ServiceDtlsID
        ,[ParID] = @ParID
        ,[Quantity] = @Quantity
        ,[PerUnitPrice] = @PerUnitPrice
        ,[TotalAmount] = @TotalAmount
        
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdatePayment]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : May 23 2012  2:08PM
-- Description : Update Procedure for Payment
-- Exec [dbo].[UC_UpdatePayment] [PaymentMode],[VoucherNo],[VoucherDate],[BankID],[Amount],[ChequeAmt],[ChequeNo],[ChequeDate],[Narration],[PartyID]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdatePayment]
     @PaymentID  int
    ,@PaymentMode  int
    ,@VoucherNo  int
    ,@VoucherDate  datetime
    ,@BankID  int
    ,@Amount  money
    ,@ChequeAmt  decimal
    ,@ChequeNo  varchar(20)
    ,@ChequeDate  datetime
    ,@Narration  varchar(150)
    ,@PartyID  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[Payment]
    SET 
         [PaymentMode] = @PaymentMode
        ,[VoucherNo] = @VoucherNo
        ,[VoucherDate] = @VoucherDate
        ,[BankID] = @BankID
        ,[Amount] = @Amount
        ,[ChequeAmt] = @ChequeAmt
        ,[ChequeNo] = @ChequeNo
        ,[ChequeDate] = @ChequeDate
        ,[Narration] = @Narration
        ,[PartyID] = @PartyID
        
    WHERE [PaymentID] = @PaymentID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateProductBrandMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Update Procedure for ProductBrandMast
-- Exec [dbo].[UC_UpdateProductBrandMast] [BrandName],[CreateDate],[CreatedBy],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateProductBrandMast]
     @ProductBrandID  int
    ,@BrandName  varchar(50)
    ,@LastUpdatedBy  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[ProductBrandMast]
    SET 
         [BrandName] = @BrandName
        ,[LastUpdatedDate] = getdate()
        ,[LastUpdatedBy] = @LastUpdatedBy
        
    WHERE [ProductBrandID] = @ProductBrandID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateProductMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Update Procedure for ProductMast
-- Exec [dbo].[UC_UpdateProductMast] [Product],[ProductTypeID],[ProductBrandID],[CreateDate],[CreatedBy],[LastUpdatedDate],[LastUpdatedBy]
--  Exec [dbo].[UC_UpdateProductMast] 15,'AM',7,7,12

-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateProductMast]
     @ProductID  int
    ,@Product  nvarchar(50)
    ,@ProductBrandID  int
    ,@StockCount int
	,@SalePrice decimal (18,2)
    ,@CrateSize  int
	,@GST Decimal(9,2)
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[ProductMast]
    SET 
         [Product] = @Product
		,[ProductBrandID] = @ProductBrandID
		,[StockCount]=@StockCount
		,[SalePrice]=@SalePrice
		,[LastUpdatedDate] = getdate()
		,CrateSize = @CrateSize
		,GST=@GST
        
    WHERE [ProductID] = @ProductID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END






GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateProductTypeMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Aug 31 2010  5:31PM
-- Description : Update Procedure for ProductTypeMast
-- Exec [dbo].[UC_UpdateProductTypeMast] [ProductType],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateProductTypeMast]
     @ProductTypeID  int
    ,@ProductType  varchar(50),

@FrequencyInMonth int,
@NumberOFService int
     ,@LastUpdatedBy  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[ProductTypeMast]
    SET 
         [ProductType] = @ProductType
,
[FrequencyInMonth]=@FrequencyInMonth,
[NumberOFService]=@NumberOFService


        ,[LastUpdatedDate] = getdate()
        ,[LastUpdatedBy] = @LastUpdatedBy
        
    WHERE [ProductTypeID] = @ProductTypeID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateRecieptMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 21 2010 10:37AM
-- Description : Update Procedure for RecieptMast
-- Exec [dbo].[UC_UpdateRecieptMast] [InvoiceID],[TotalAmt],[RecieptDate],[PaymentModeID],[ChequeNo],[ChequeDate],[BankName],[ChequeStatus],[ClearedDate],[CashAmt],[ChequeAmt],[BalanceAmt]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateRecieptMast]
     @RecieptID  int
    ,@ChequeStatus  bit
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[RecieptMast]
    SET 
       
        [ChequeStatus] = @ChequeStatus
        ,[ClearedDate] = getdate()
    WHERE [RecieptID] = @RecieptID 

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateServiceCallAsignMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  6 2010  5:16PM
-- Description : Update Procedure for ServiceCallAsignMast
-- Exec [dbo].[UC_UpdateServiceCallAsignMast] [CallType],[RecordID],[CallDate],[CallCompletedDate],[ServicePersonID],[IsClose],[assignedBy],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateServiceCallAsignMast]
     
    @RecordID  int
    
    ,@CallCompletedDate  datetime
    ,@ServicePersonID  int
    ,@IsClose  bit
    
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[ServiceCallAsignMast]
    SET 
       
        
        
        [CallCompletedDate] = @CallCompletedDate
        ,[ServicePersonID] = @ServicePersonID
        ,[IsClose] = @IsClose
        
        
    WHERE [RecordID] = @RecordID

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateServiceDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 13 2010  2:42PM
-- Description : Update Procedure for ServiceDtls
-- Exec [dbo].[UC_UpdateServiceDtls] [ServiceID],[ServiceTypeID],[ServiceNumb],[ServicePersonID],[ActualServiceDate],[ServiceDoneDate],[Remark],[Document],[NetAmount],[VatPercent],[VatAmount],[TaxPercent],[TaxAmount],[ServiceCharge],[TotalAmount]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateServiceDtls]
     @ServiceDtlsID  int
    ,@ServiceID  int
    ,@ServiceTypeID  int
    ,@ServiceNumb  int
    ,@ServicePersonID  int
    ,@ActualServiceDate  datetime
    ,@ServiceDoneDate  datetime
    ,@Remark  nvarchar(150)
    ,@Document  nvarchar(max)
    ,@NetAmount  decimal
    ,@VatPercent  decimal
    ,@VatAmount  decimal
    ,@TaxPercent  decimal
    ,@TaxAmount  decimal
    ,@ServiceCharge  decimal
    ,@TotalAmount  decimal
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[ServiceDtls]
    SET 
         [ServiceID] = @ServiceID
        ,[ServiceTypeID] = @ServiceTypeID
        ,[ServiceNumb] = @ServiceNumb
        ,[ServicePersonID] = @ServicePersonID
        ,[ActualServiceDate] = @ActualServiceDate
        ,[ServiceDoneDate] = @ServiceDoneDate
        ,[Remark] = @Remark
        ,[Document] = @Document
        ,[NetAmount] = @NetAmount
        ,[VatPercent] = @VatPercent
        ,[VatAmount] = @VatAmount
        ,[TaxPercent] = @TaxPercent
        ,[TaxAmount] = @TaxAmount
        ,[ServiceCharge] = @ServiceCharge
        ,[TotalAmount] = @TotalAmount
        
    WHERE [ServiceDtlsID] = @ServiceDtlsID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateServiceMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  1 2010  5:19PM
-- Description : Update Procedure for ServiceMast
-- Exec [dbo].[UC_UpdateServiceMast] [ServiceTypeID],[CustomerID],[ProductID],[SerialNo],[PurchaseDate],[NxtServiceDate],[NoOfService],[ServiceEndDate],[IsClose]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateServiceMast]
     @ServiceID  int
    ,@ServiceTypeID  int
    ,@CustomerID  int
    ,@ProductID  int
    ,@SerialNo  nvarchar(50)
    ,@PurchaseDate  datetime
    ,@NxtServiceDate  datetime
    ,@NoOfService  int
,@Frequency int    
,@ServiceEndDate  datetime
    ,@IsClose  bit
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[ServiceMast]
    SET 
         [ServiceTypeID] = @ServiceTypeID
        ,[CustomerID] = @CustomerID
        ,[ProductID] = @ProductID
        ,[SerialNo] = @SerialNo
        ,[PurchaseDate] = @PurchaseDate
        ,[NxtServiceDate] = @NxtServiceDate
        ,[NoOfService] = @NoOfService
		,[FreuencyInMonth]=@Frequency
        ,[ServiceEndDate] = @ServiceEndDate
        ,[IsClose] = @IsClose
        
    WHERE [ServiceID] = @ServiceID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareGateDtls_IsSold_AfterInvoice]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_UpdateSpareGateDtls_IsSold_AfterInvoice]
     @GatePassID  int
    ,@ProductID  int
	,@Quantity int
    ,@IsSold bit
    ,@UsedQty int
   
AS
BEGIN


BEGIN TRY

  UPDATE    SpareGatePassDtls
SET              IsSold = @IsSold, Quantity = @Quantity, UsedQty =@UsedQty
WHERE     (GatePassID = @GatePassID) AND (ProductID = @ProductID)

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareGateDtls_IsSold_AfterReturn]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_UpdateSpareGateDtls_IsSold_AfterReturn]

    @ProductID  int
	,@Quantity int
    ,@IsSold bit
    ,@UsedQty int
	,@ServicePersonID int
   
AS
BEGIN


BEGIN TRY

UPDATE    SpareGatePassDtls
SET              Quantity =@Quantity, IsSold =@IsSold, UsedQty =@UsedQty
FROM         SpareGatePassDtls INNER JOIN
                      SpareGatePassMast ON SpareGatePassDtls.GatePassID = SpareGatePassMast.GatePassID 
where (SpareGatePassDtls.ProductID=@ProductID) and (SpareGatePassMast.ServicePersonID=@ServicePersonID)

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareGatePassDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 16 2010  6:17PM
-- Description : Update Procedure for SpareGatePassDtls
-- Exec [dbo].[UC_UpdateSpareGatePassDtls] [GatePassID],[ProductID],[Quantity],[PerUnitPrice],[IsSold],[UsedQty]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateSpareGatePassDtls]
     @GatePassDtlID  int
    ,@GatePassID  int
    ,@ProductID  int
    ,@Quantity  int
    ,@PerUnitPrice  decimal
    ,@IsSold  bit
    ,@UsedQty  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[SpareGatePassDtls]
    SET 
         [GatePassID] = @GatePassID
        ,[ProductID] = @ProductID
        ,[Quantity] = @Quantity
        ,[PerUnitPrice] = @PerUnitPrice
        ,[IsSold] = @IsSold
        ,[UsedQty] = @UsedQty
        
    WHERE [GatePassDtlID] = @GatePassDtlID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareGatePassMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 16 2010  3:04PM
-- Description : Update Procedure for SpareGatePassMast
-- Exec [dbo].[UC_UpdateSpareGatePassMast] [GatePassNumb],[ServicePersonID],[IssueDate],[IssuedBy],[TotalOutStandingAmt],[CreatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateSpareGatePassMast]
     @GatePassID  int
    ,@GatePassNumb  nvarchar(50)
    ,@ServicePersonID  int
    ,@IssueDate  datetime
    ,@IssuedBy  int
    ,@TotalOutStandingAmt  decimal
    ,@CreatedBy  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[SpareGatePassMast]
    SET 
         [GatePassNumb] = @GatePassNumb
        ,[ServicePersonID] = @ServicePersonID
        ,[IssueDate] = @IssueDate
        ,[IssuedBy] = @IssuedBy
        ,[TotalOutStandingAmt] = @TotalOutStandingAmt
        ,[CreatedBy] = @CreatedBy
        
    WHERE [GatePassID] = @GatePassID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareGatePassMast_outStanding_AfterInvoice]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_UpdateSpareGatePassMast_outStanding_AfterInvoice]
@GatePassID  int
,@TotalOutStandingAmt decimal(18,2)
   
AS
BEGIN


BEGIN TRY

  UPDATE    SpareGatePassMast
SET              TotalOutStandingAmt =@TotalOutStandingAmt
where GatePassID=@GatePassID

--UPDATE OutStandingMast
--SET TotalOutStandingAmt =(SELECT     TotalOutStandingAmt
--FROM OutStandingMast where CustomerID=@CustomerID)-@TotalOutStandingAmt
--where CustomerID=@CustomerID

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareGRNDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 15 2010  5:58PM
-- Description : Update Procedure for Spare_GRNDtls
-- Exec [dbo].[UC_UpdateSpareGRNDtls] [GRN_ID],[ProductID],[PerUnitPrice],[Quantity]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateSpareGRNDtls]
     @GRNDtlID  int
    ,@GRN_ID  int
    ,@ProductID  int
    ,@PerUnitPrice  decimal
    ,@Quantity  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[Spare_GRNDtls]
    SET 
         [GRN_ID] = @GRN_ID
        ,[ProductID] = @ProductID
        ,[PerUnitPrice] = @PerUnitPrice
        ,[Quantity] = @Quantity
        
    WHERE [GRNDtlID] = @GRNDtlID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareGRNMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 15 2010  5:57PM
-- Description : Update Procedure for Spare_GRNMast
-- Exec [dbo].[UC_UpdateSpareGRNMast] [PoID],[GRN_No],[RecieveDate],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateSpareGRNMast]
     @GRN_ID  int
    ,@PoID  int
    ,@GRN_No  nvarchar(50)
    ,@RecieveDate  datetime
    ,@CreatedBy  int

    ,@LastUpdatedBy  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[Spare_GRNMast]
    SET 
         [PoID] = @PoID
        ,[GRN_No] = @GRN_No
        ,[RecieveDate] = @RecieveDate
        ,[CreatedBy] = @CreatedBy
        ,[CreateDate] = getdate()
        ,[LastUpdatedDate] =getdate()
        ,[LastUpdatedBy] = @LastUpdatedBy
        
    WHERE [GRN_ID] = @GRN_ID 
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareInvoiceDtls]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 20 2010  1:51PM
-- Description : Update Procedure for SpareInvoiceDtls
-- Exec [dbo].[UC_UpdateSpareInvoiceDtls] [InvoiceDtlID],[InvoiceID],[GatePassID],[ProductID],[Quantity],[ActualPrice],[TotalPrice]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateSpareInvoiceDtls]
     @InvoiceDtlID  int
    ,@InvoiceID  int
    ,@GatePassID  int
    ,@ProductID  int
    ,@Quantity  int
    ,@ActualPrice  decimal
    ,@TotalPrice  decimal
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[SpareInvoiceDtls]
    SET 
         [InvoiceDtlID] = @InvoiceDtlID
        ,[InvoiceID] = @InvoiceID
        ,[GatePassID] = @GatePassID
        ,[ProductID] = @ProductID
        ,[Quantity] = @Quantity
        ,[ActualPrice] = @ActualPrice
        ,[TotalPrice] = @TotalPrice
        
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareInvoiceMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 20 2010  1:12PM
-- Description : Update Procedure for SpareInvoiceMast
-- Exec [dbo].[UC_UpdateSpareInvoiceMast] [InvoiceID],[InvoiceNumber],[InvoiceDate],[CustomerID],[OwnerID],[OwnerType],[TotalAmt],[PaymentModeID],[ChequeNo],[ChequeDate],[BankName],[CreatedBy],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateSpareInvoiceMast]
     @InvoiceID  int
    ,@InvoiceNumber  nvarchar(50)
    ,@InvoiceDate  datetime
    ,@CustomerID  int
    ,@OwnerID  int
    ,@OwnerType  char(1)
    ,@TotalAmt  decimal
    ,@PaymentModeID  int
    ,@ChequeNo  nvarchar(50)
    ,@ChequeDate  datetime
    ,@BankName  varchar(50)
    ,@CreatedBy  int
    ,@CreateDate  datetime
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[SpareInvoiceMast]
    SET 
         [InvoiceID] = @InvoiceID
        ,[InvoiceNumber] = @InvoiceNumber
        ,[InvoiceDate] = @InvoiceDate
        ,[CustomerID] = @CustomerID
        ,[OwnerID] = @OwnerID
        ,[OwnerType] = @OwnerType
        ,[TotalAmt] = @TotalAmt
        ,[PaymentModeID] = @PaymentModeID
        ,[ChequeNo] = @ChequeNo
        ,[ChequeDate] = @ChequeDate
        ,[BankName] = @BankName
        ,[CreatedBy] = @CreatedBy
        ,[CreateDate] = @CreateDate
        
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareInvoiceMast_By_InvoiceID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 20 2010  1:12PM
-- Description : Update Procedure for SpareInvoiceMast
-- Exec [dbo].[UC_UpdateSpareInvoiceMast] [InvoiceID],[InvoiceNumber],[InvoiceDate],[CustomerID],[OwnerID],[OwnerType],[TotalAmt],[PaymentModeID],[ChequeNo],[ChequeDate],[BankName],[CreatedBy],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateSpareInvoiceMast_By_InvoiceID]
     @InvoiceID  int
    ,@ChequeNo  nvarchar(50)
    ,@ChequeDate  datetime
    ,@BankName  varchar(50)
    ,@BalanceAmt decimal(18,2)
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[SpareInvoiceMast]
    SET 
        
        
        [ChequeNo] = @ChequeNo
        ,[ChequeDate] = @ChequeDate
        ,[BankName] = @BankName  
		,[BalanceAmt]= @BalanceAmt
where  [InvoiceID] = @InvoiceID

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareInvoiceMastTotalAmt_By InvoiceID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct 20 2010  1:12PM
-- Description : Update Procedure for SpareInvoiceMast
-- Exec [dbo].[UC_UpdateSpareInvoiceMast] [InvoiceID],[InvoiceNumber],[InvoiceDate],[CustomerID],[OwnerID],[OwnerType],[TotalAmt],[PaymentModeID],[ChequeNo],[ChequeDate],[BankName],[CreatedBy],[CreateDate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateSpareInvoiceMastTotalAmt_By InvoiceID]
     @InvoiceID  int
    ,@TotalAmt  decimal
   
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[SpareInvoiceMast]
    SET  
        [TotalAmt] = @TotalAmt
     where [InvoiceID] = @InvoiceID   
    


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareStockMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  1 2010  5:20PM
-- Description : Update Procedure for vatmast
-- Exec [dbo].[UC_Updatevatmast] [Value],[CreateDate],[CreatedBy],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateSpareStockMast]
@ProductID int
,@Quantity int
    
AS
BEGIN


BEGIN TRY

UPDATE    Spare_StockMast
SET       Quantity =(SELECT     Quantity
FROM      Spare_StockMast where ProductID=@ProductID)-@Quantity 
where ProductID=@ProductID



END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateSpareStockMastQuantity]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Oct  1 2010  5:19PM
-- Description : Update Procedure for ServiceMast
-- Exec [dbo].[UC_UpdateServiceMast] [ServiceTypeID],[CustomerID],[ProductID],[SerialNo],[PurchaseDate],[NxtServiceDate],[NoOfService],[ServiceEndDate],[IsClose]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateSpareStockMastQuantity]
@Quantity int
,@ProductID int
AS
BEGIN


BEGIN TRY

    UPDATE    Spare_StockMast
SET              Quantity =@Quantity
where ProductID=@ProductID

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_Updatevatmast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  1 2010  5:20PM
-- Description : Update Procedure for vatmast
-- Exec [dbo].[UC_Updatevatmast] [Value],[CreateDate],[CreatedBy],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_Updatevatmast]
     @VatID  int
    ,@Value  decimal(18,2)
   
    
    ,@LastUpdatedBy  int
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[vatmast]
    SET 
         [Value] = @Value
      
        ,[LastUpdatedDate] = getdate()
        ,[LastUpdatedBy] = @LastUpdatedBy
        
    WHERE [VatID] = @VatID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateVendorMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Sep  3 2010  1:18PM
-- Description : Update Procedure for VendorMast
-- Exec [dbo].[UC_UpdateVendorMast] [VendorName],[Address],[AreaID],[CityID],[EmailID],[OfficePhone],[FaxNo],[ContactPerson],[PersonMobileNo],[IsActive],[CreatedBy],[CreateDate],[LastUpdatedDate],[LastUpdatedBy]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateVendorMast]
     @VendorID  int
    ,@VendorName  nvarchar(50)
    ,@Address  nvarchar(250)
--    ,@AreaID  int
--    ,@CityID  int
    ,@EmailID  nvarchar(50)
    ,@OfficePhone  nvarchar(50)
    ,@FaxNo  nvarchar(50)
    ,@ContactPerson  varchar(50)
    ,@PersonMobileNo  varchar(20)
    ,@IsActive  bit
    ,@LastUpdatedBy  int
  
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[VendorMast]
    SET 
         [VendorName] = @VendorName
        ,[Address] = @Address
--        ,[AreaID] = @AreaID
--        ,[CityID] = @CityID
        ,[EmailID] = @EmailID
        ,[OfficePhone] = @OfficePhone
        ,[FaxNo] = @FaxNo
        ,[ContactPerson] = @ContactPerson
        ,[PersonMobileNo] = @PersonMobileNo
        ,[IsActive] = @IsActive
        ,[LastUpdatedDate] = getdate()
        ,[LastUpdatedBy] = @LastUpdatedBy
        
    WHERE [VendorID] = @VendorID 

select scope_identity() as ERROR_NUMBER,'Updated' as ERROR_MESSAGE

END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_UpdateVendorProducts]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Anupam Thomas
-- Create date : Jun 29 2012  3:04PM
-- Description : Update Procedure for VendorProducts
-- Exec [dbo].[UC_UpdateVendorProducts] [VendorID],[productId],[Rate]
-- ============================================= */
CREATE PROCEDURE [dbo].[UC_UpdateVendorProducts]
     @VendorProductID  int
    ,@VendorID  int
    ,@productId  int
    ,@Rate  decimal
    
AS
BEGIN


BEGIN TRY

    UPDATE [dbo].[VendorProducts]
    SET 
         [VendorID] = @VendorID
        ,[productId] = @productId
        ,[Rate] = @Rate
        
    WHERE [VendorProductID] = @VendorProductID 


END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[UC_VehicleMast_GetAll]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_VehicleMast_GetAll] 
AS
Select 
[VechicleID],
[Transport],
[Owner],
[Address],
[Mobile],
[VechicleNo],
[Marathi],
[RatePerTrip],
[PrintOrder]

from 
VehicleMast
Return




GO
/****** Object:  StoredProcedure [dbo].[UC_VehicleMast_GetByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



Create PROCEDURE [dbo].[UC_VehicleMast_GetByPK] 
	(
@VechicleID int
)
AS
SELECT	 
[VechicleID],
[Transport],
[Owner],
[Address],
[Mobile],
[VechicleNo],
[RatePerTrip],
[Marathi],
[PrintOrder]

FROM 
VehicleMast  
WHERE 
[VechicleID]=@VechicleID


RETURN







GO
/****** Object:  StoredProcedure [dbo].[UC_VehicleMast_Insert]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UC_VehicleMast_Insert] 
	(
@Transport varchar(50)=null,
@Owner varchar(50)=null,
@Address varchar(50)=null,
@Mobile varchar(50)=null,
@VechicleNo varchar(15)=null,
@RatePerTrip decimal (9,2),
@Marathi varchar (50),
@PrintOrder int
)
AS
Insert Into 
VehicleMast 
(
[Transport],
[Owner],
[Address],
[Mobile],
[VechicleNo],
[Marathi],
[RatePerTrip],
[PrintOrder]
) 
values(
@Transport,
@Owner,
@Address,
@Mobile,
@VechicleNo,
@Marathi,
@RatePerTrip,
@PrintOrder
)
RETURN Scope_identity()




GO
/****** Object:  StoredProcedure [dbo].[UC_VehicleMast_UpdateByPK]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[UC_VehicleMast_UpdateByPK] 
	(
@VechicleID int,
@Transport varchar(50)=null,
@Owner varchar(50)=null,
@Address varchar(50)=null,
@Mobile varchar(50)=null,
@VechicleNo varchar(15)=null,
@RatePerTrip decimal(8,2)=null,
@Marathi Varchar(100)=null,
@PrintOrder int
)
AS
Update  VehicleMast Set 
[Transport]=@Transport,
[Owner]=@Owner,
[Address]=@Address,
[Mobile]=@Mobile,
[VechicleNo]=@VechicleNo,
[RatePerTrip]=@RatePerTrip,
[Marathi]=@Marathi,
[PrintOrder]=@PrintOrder
 
where 
[VechicleID]=@VechicleID


Return







GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomerPayment]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCustomerPayment]
 
	
@CustomerID int,
@CashAmount decimal (10,2)

AS
BEGIN
 
	SET NOCOUNT ON;

		Update  CustomerPaymentDetail
		Set     CashAmount = @CashAmount
		WHERE	CustPaymentDetailID = (
		SELECT  TOP (1) CustomerPaymentDetail.CustPaymentDetailID 
		FROM    CustomerPaymentDetail INNER JOIN
				CustomerMast ON CustomerPaymentDetail.CustomerId = CustomerMast.CustomerID
		WHERE   (CustomerPaymentDetail.CustomerId = @CustomerID)
		ORDER BY CustomerPaymentDetail.BillDate DESC)


END




GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomerPayment_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- UpdateCustomerPayment_MobileApp 13,1, 101,151,'1234567890'
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCustomerPayment_MobileApp]
 
@BillId int,	
@CustomerID int,
@CashAmount decimal (10,2),
@ChequeAmount  decimal (10,2),
@ChequeNo varchar(25)
--@Comment Varchar(50)
AS
BEGIN
 
	SET NOCOUNT ON;

		Update  CustomerPaymentDetail
		Set     CashAmount = @CashAmount , ChequeAmount = @ChequeAmount
		, ChequeNo=@ChequeNo --,ChqComment=@Comment
		WHERE	BillID= @BillId
		and CustomerId = @CustomerID


	exec	uspCalculateBalances @CustomerID
END


GO
/****** Object:  StoredProcedure [dbo].[UpdateCustomerPaymentFromServer]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateCustomerPaymentFromServer]  

@PaymentDate datetime ,
@PaymentMode int,
@CashAmount decimal(10,2),
@ChequeAmount decimal(10,2),
@ChequeNo varchar(15),
@CustPaymentDetailID int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		Update CustomerPaymentDetail
		Set PaymentDate =@PaymentDate, PaymentMode=@PaymentMode, CashAmount=@CashAmount, ChequeAmount=@ChequeAmount, ChequeNo=@ChequeNo
		Where CustPaymentDetailID=@CustPaymentDetailID

END




GO
/****** Object:  StoredProcedure [dbo].[upsRepeatCustomerOrder]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[upsRepeatCustomerOrder] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @BillDate datetime
	declare @mBillId int
	declare @TotalQty decimal(9,2)
	Declare @TotalAmount decimal(9,2)

		set @BillDate = ( Select top 1 billdate from CustomerBillMast order by BillID desc)
		set @TotalQty = ( Select top 1 TotalQty from CustomerBillMast order by BillID desc)
		set @TotalAmount= ( Select top 1 TotalAmount from CustomerBillMast order by BillID desc)

		set @BillDate = dateadd(d,1,@BillDate)


		  INSERT INTO [dbo].[customerbillmast] 
					  ([billdate],TotalQty,TotalAmount,LastUpdatedDate) 
		  VALUES      (@BillDate,0,0,getdate()) 
		

			SELECT @mBillId=Scope_identity() 

			UPDATE     CustomerBillMast
			SET      TotalQty =@TotalQty, TotalAmount = @TotalAmount
			WHERE        (BillId = @mBillId-1) 

 
			INSERT INTO CustomerBillDetails 
			(BillID, CustomerId, ProductID, Quantity, Amount,LastUpdatedDate)

			SELECT         @mBillId,  CustomerId, ProductID, Quantity,Amount,getdate()                        
			FROM            CustomerBillDetails 
			WHERE        (BillId = @mBillId-1) Order By CustomerID,ProductID asc

			Select @mBillId
END




GO
/****** Object:  StoredProcedure [dbo].[USP_BindDropDown]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--exec USP_BindDropDown VendorList
CREATE PROCEDURE  [dbo].[USP_BindDropDown] 
@action Varchar(100),
@val  INT=NULL,
@GrouId int=null

AS
BEGIN
 IF(@action='Area')
 BEGIN
 SELECT Cast([AreaID] as NVARCHAR(100)) AS Value,[Area] AS Text FROM  [AreaMast] D WHERE  (AreaID =@val OR AreaID=D.AreaID) Order by AreaID
 END
 
 IF(@action='Employee')
 BEGIN
 SELECT Cast([EmployeeID] as NVARCHAR(100)) AS Value,[EmployeeName] AS Text FROM  [EmployeeMast] D WHERE  (EmployeeID =@val OR EmployeeID=D.EmployeeID) Order by EmployeeID
 END 

  IF(@action='SalesPersonId')
 BEGIN
 SELECT Cast(UserID as NVARCHAR(100)) AS Value,[EmployeeName] AS Text FROM  [EmployeeMast] D WHERE  (UserID =@val OR UserID=D.UserID) Order by UserID
 END 

 IF(@action='Vehicle')
 BEGIN
 SELECT Cast([VechicleID] as NVARCHAR(100)) AS Value,[VechicleNo] AS Text FROM  [VehicleMast] D WHERE  (VechicleID =@val OR VechicleID=D.VechicleID) Order by VechicleID
 END
 
 IF(@action='CustomerList')
 BEGIN
 SELECT Cast(CustomerID as NVARCHAR(100)) AS Value,CustomerName AS Text FROM  CustomerMast D WHERE  (CustomerID =@val OR CustomerID=D.CustomerID) Order by CustomerID
 END  

  IF(@action='VendorList')
 BEGIN
 SELECT Cast(VendorID as NVARCHAR(100)) AS Value,VendorName AS Text FROM  VendorMast D WHERE  (VendorID =@val OR VendorID=D.VendorID) Order by VendorID
 END 

  IF(@action='CustomerRateCopyList')
 BEGIN
 SELECT  DISTINCT     Cast(CustomerRates.CustomerID  as NVARCHAR(100)) AS Value,  CustomerMast.CustomerName AS Text 
	FROM    CustomerRates LEFT OUTER JOIN
			CustomerMast ON CustomerRates.CustomerID = CustomerMast.CustomerID
	Where	Enddate ='9999-01-01'  
	END 

	IF(@action='ProductList')
 BEGIN
 SELECT Cast(ProductID as NVARCHAR(100)) AS Value,Product AS Text FROM  ProductMast D WHERE  (ProductID =@val OR ProductID=D.ProductID) Order by ProductID
 END 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_create_sps_for_table]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =======================================================================================
-- Author      : Vinoad Sabbade
-- Createdn On : 12 July 2010  3:42PM
-- Modified On : Nov 19 2009
-- Description : Generate the Insert / Update/ Delete Stored procedure script of any table  
--				 by passing the table name
--	Exec [dbo].[usp_create_sps_for_table] 'et_application'
--
-- ========================================================================================= 



CREATE PROCEDURE [dbo].[usp_create_sps_for_table]-- 'Ph_PolicyDtls'
	@tblName Varchar(50) 
AS
BEGIN

	Declare @dbName Varchar(50) 
	Declare @insertSPName Varchar(50), @updateSPName Varchar(50), @deleteSPName Varchar(50) ;
	Declare @tablColumnParameters   Varchar(max);
	Declare @tableColumns           Varchar(max)
	Declare @tableColumnVariables   Varchar(max);
	Declare @tablColumnParametersUpdate Varchar(max);
	Declare @tableCols	    Varchar(max);
	Declare @space			Varchar(50)  ;
	Declare @colName 		Varchar(100) ;
	Declare @colVariable	Varchar(100) ;
	Declare @colParameter	Varchar(100) ;
	Declare @colIdentity	bit			 ;
	Declare @strSpText		Varchar(max);
	Declare @updCols		Varchar(max);
	Declare @delParamCols	Varchar(max);
	Declare @whereCols		Varchar(max);
	Set		@tblName		   =  SubString(@tblName,CharIndex('.',@tblName)+1, Len(@tblName))

	Set		@insertSPName      = '[dbo].[uspInsert' + Replace(@tblName,'_','') +']' ;
	Set		@updateSPName      = '[dbo].[uspUpdate' + Replace(@tblName,'_','') +']' ;
	Set		@deleteSPName      = '[dbo].[uspDelete' + Replace(@tblName,'_','') +']' ;

	Set		@space				  = REPLICATE(' ', 4)  ;
	Set		@tablColumnParameters = '' ;
	Set		@tableColumns		  = '' ;
	Set		@tableColumnVariables = '' ;
	Set		@strSPText			  = '' ;
	Set		@tableCols			  = '' ;
	Set		@updCols			  = '' ;
	Set		@delParamCols		  = '' ;
	Set		@whereCols			  = '' ;
	Set		@tablColumnParametersUpdate = '' ;
	SET NOCOUNT ON 

	-- Get all columns & data types for a table 
	SELECT distinct
			COLUMNPROPERTY(syscolumns.id, syscolumns.name, 'IsIdentity') as 'IsIdentity',
			sysobjects.name as 'Table', 
			syscolumns.colid ,
			'[' + syscolumns.name + ']' as 'ColumnName',
			'@'+syscolumns.name  as 'ColumnVariable',
			systypes.name + 
	Case  When  systypes.xusertype in (165,167,175,231,239 ) Then '(' + REPLACE(Convert(varchar(10),syscolumns.prec),'-1','max')  +')' Else '' end as 'DataType' ,
			'@'+syscolumns.name  + '  ' + systypes.name + 
	Case  When  systypes.xusertype in (165,167,175,231,239 ) Then '(' + REPLACE(Convert(varchar(10),syscolumns.prec),'-1','max') +')' Else '' end as 'ColumnParameter'
	Into	#tmp_Structure	
	From	sysobjects , syscolumns ,  systypes
	Where	sysobjects.id			 = syscolumns.id
			and syscolumns.xusertype = systypes.xusertype
			and sysobjects.xtype	 = 'u'
			and sysobjects.name		 = @tblName
			and systypes.xusertype not in (189)
	Order by syscolumns.colid

	-- Get all Primary KEY columns & data types for a table 
	SELECT		t.name as 'Table', 
				c.colid ,
				'[' + c.name + ']' as 'ColumnName',
				'@'+c.name  as 'ColumnVariable',
				systypes.name + 
		Case  When  systypes.xusertype in (165,167,175,231,239 ) Then '(' + Convert(varchar(10),c.length) +')' Else '' end as 'DataType' ,
				'@'+c.name  + '  ' + systypes.name + 
		Case  When  systypes.xusertype in (165,167,175,231,239 ) Then '(' + Convert(varchar(10),c.length) +')' Else '' end as 'ColumnParameter'
	Into	#tmp_PK_Structure	
	FROM    sysindexes i, sysobjects t, sysindexkeys k, syscolumns c, systypes
	WHERE	i.id = t.id	 AND
			i.indid = k.indid  AND i.id = k.ID And
			c.id = t.id    AND c.colid = k.colid AND  
			i.indid BETWEEN 1 And 254  AND 
			c.xusertype = systypes.xusertype AND
			(i.status & 2048) = 2048 AND t.id = OBJECT_ID(@tblName)

	/* Read the table structure and populate variables*/
	Declare SpText_Cursor Cursor For
		Select ColumnName, ColumnVariable, ColumnParameter, IsIdentity
		From #tmp_Structure 

	Open SpText_Cursor

	Fetch Next From SpText_Cursor Into @colName,  @colVariable, @colParameter, @colIdentity
	While @@FETCH_STATUS = 0
	Begin
		If (@colIdentity=0)
		Begin
			Set @tablColumnParameters   = @tablColumnParameters + @colParameter + CHAR(13) + @space + ',' ; 
			Set @tableCols				= @tableCols + @colName +  ',' ; 		
			Set @tableColumns			= @tableColumns + @colName + CHAR(13) + @space + @space + ',' ; 		
			Set @tableColumnVariables   = @tableColumnVariables + @colVariable + CHAR(13) + @space + @space + ',' ; 
			Set @updCols				= @updCols + @colName + ' = ' + @colVariable + CHAR(13) + @space + @space + ',' ; 
		End
		
		Set @tablColumnParametersUpdate   = @tablColumnParametersUpdate + @colParameter + CHAR(13) + @space + ',' ; 

	    Fetch Next From SpText_Cursor Into @colName,  @colVariable, @colParameter , @colIdentity
	End

	Close SpText_Cursor
	Deallocate SpText_Cursor

	/* Read the Primary Keys from the table and populate variables*/
	Declare SpPKText_Cursor Cursor For
		Select ColumnName, ColumnVariable, ColumnParameter
		From #tmp_PK_Structure 

	Open SpPKText_Cursor

	Fetch Next From SpPKText_Cursor Into @colName,  @colVariable, @colParameter
	While @@FETCH_STATUS = 0
	Begin
		Set @delParamCols   = @delParamCols + @colParameter + CHAR(13) + @space + ',' ; 
		Set @whereCols		= @whereCols + @colName + ' = ' + @colVariable + ' AND '  ; 
	    Fetch Next From SpPKText_Cursor Into @colName,  @colVariable, @colParameter 
	End

	Close SpPKText_Cursor
	Deallocate SpPKText_Cursor

	-- Stored procedure scripts starts here
	If (LEN(@tablColumnParameters)>0)
	Begin 
		Set @tablColumnParameters	= LEFT(@tablColumnParameters,LEN(@tablColumnParameters)-1) ;
		Set @tablColumnParametersUpdate	= LEFT(@tablColumnParametersUpdate,LEN(@tablColumnParametersUpdate)-1) ;
		Set @tableColumnVariables	= LEFT(@tableColumnVariables,LEN(@tableColumnVariables)-1) ;
		Set @tableColumns			= LEFT(@tableColumns,LEN(@tableColumns)-1) ;
		Set @tableCols				= LEFT(@tableCols,LEN(@tableCols)-1) ;
		Set @updCols				= LEFT(@updCols,LEN(@updCols)-1) ;

		If (LEN(@whereCols)>0)
		Begin 
			Set @whereCols			= 'WHERE ' + LEFT(@whereCols,LEN(@whereCols)-4) ;
			Set @delParamCols		= LEFT(@delParamCols,LEN(@delParamCols)-1) ;
		End

		/*  Create INSERT stored procedure for the table if it does not exist */
		IF  Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(@insertSPName) AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
		Begin
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + '/*-- ============================================='
			Set @strSPText = @strSPText +  CHAR(13) + '-- Author      : Vinoad Sabbade'
			Set @strSPText = @strSPText +  CHAR(13) + '-- Create date : ' + Convert(varchar(20),Getdate())
			Set @strSPText = @strSPText +  CHAR(13) + '-- Description : Insert Procedure for ' + @tblName
			Set @strSPText = @strSPText +  CHAR(13) + '-- Exec ' + @insertSPName + ' ' + @tableCols
			Set @strSPText = @strSPText +  CHAR(13) + '-- ============================================= */'
			Set @strSPText = @strSPText +  CHAR(13) + 'CREATE PROCEDURE ' + @insertSPName
			Set @strSPText = @strSPText +  CHAR(13) + @space + ' ' + @tablColumnParameters
			Set @strSPText = @strSPText +  CHAR(13) + 'AS'
			Set @strSPText = @strSPText +  CHAR(13) + 'BEGIN'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'BEGIN TRY'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'INSERT INTO [dbo].['+@tblName +']' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + '( ' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + @space + ' ' + @tableColumns  
			Set @strSPText = @strSPText +  CHAR(13) + @space + ')'
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'VALUES'
			Set @strSPText = @strSPText +  CHAR(13) + @space + '('
			Set @strSPText = @strSPText +  CHAR(13) + @space + @space + ' ' + @tableColumnVariables
			Set @strSPText = @strSPText +  CHAR(13) + @space + ')'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'END TRY'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'BEGIN CATCH' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'SELECT '
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'ERROR_NUMBER() as ERROR_NUMBER,'
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'ERROR_MESSAGE() as ERROR_MESSAGE;'
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'END CATCH;'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'END'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
--			Print @strSPText ;

			Exec(@strSPText);

			if (@@ERROR=0) 
				Print 'Procedure ' + @insertSPName + ' Created Successfully '

		End
		Else
		Begin
			Print 'Sorry!!  ' + @insertSPName + ' Already exists in the database. '
		End
		/*  Create UPDATE stored procedure for the table if it does not exist */
		IF  Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(@updateSPName) AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
		Begin
			Set @strSPText = ''
			Set @strSPText = @strSPText +  CHAR(13) + '/*-- ============================================='
			Set @strSPText = @strSPText +  CHAR(13) + '-- Author      : Vinoad Sabbade'
			Set @strSPText = @strSPText +  CHAR(13) + '-- Create date : ' + Convert(varchar(20),Getdate())
			Set @strSPText = @strSPText +  CHAR(13) + '-- Description : Update Procedure for ' + @tblName
			Set @strSPText = @strSPText +  CHAR(13) + '-- Exec ' + @updateSPName + ' ' + @tableCols
			Set @strSPText = @strSPText +  CHAR(13) + '-- ============================================= */'
			Set @strSPText = @strSPText +  CHAR(13) + 'CREATE PROCEDURE ' + @updateSPName
			Set @strSPText = @strSPText +  CHAR(13) + @space + ' ' + @tablColumnParametersUpdate
			Set @strSPText = @strSPText +  CHAR(13) + 'AS'
			Set @strSPText = @strSPText +  CHAR(13) + 'BEGIN'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'BEGIN TRY'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'UPDATE [dbo].['+@tblName +']' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'SET ' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + @space + ' ' + @updCols  
			Set @strSPText = @strSPText +  CHAR(13) + @space + @whereCols
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'END TRY'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'BEGIN CATCH' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'SELECT '
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'ERROR_NUMBER() as ERROR_NUMBER,'
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'ERROR_MESSAGE() as ERROR_MESSAGE;'
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'END CATCH;'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'END'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
--			Print @strSPText ;
			Exec(@strSPText);

			if (@@ERROR=0) 
				Print 'Procedure ' + @updateSPName + ' Created Successfully '
		End
		Else
		Begin
			Print 'Sorry!!  ' + @updateSPName + ' Already exists in the database. '
		End
		/*  Create DELETE stored procedure for the table if it does not exist */
		IF  Not EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(@deleteSPName) AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
		Begin
			Set @strSPText = ''
			Set @strSPText = @strSPText +  CHAR(13) + '/*-- ============================================='
			Set @strSPText = @strSPText +  CHAR(13) + '-- Author      : Vinoad Sabbade'
			Set @strSPText = @strSPText +  CHAR(13) + '-- Create date : ' + Convert(varchar(20),Getdate())
			Set @strSPText = @strSPText +  CHAR(13) + '-- Description : Delete Procedure for ' + @tblName
			Set @strSPText = @strSPText +  CHAR(13) + '-- Exec ' + @deleteSPName + ' ' + @delParamCols
			Set @strSPText = @strSPText +  CHAR(13) + '-- ============================================= */'
			Set @strSPText = @strSPText +  CHAR(13) + 'CREATE PROCEDURE ' + @deleteSPName
			Set @strSPText = @strSPText +  CHAR(13) + @space + ' ' + @delParamCols
			Set @strSPText = @strSPText +  CHAR(13) + 'AS'
			Set @strSPText = @strSPText +  CHAR(13) + 'BEGIN'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'BEGIN TRY'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'DELETE FROM [dbo].['+@tblName +']' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + @whereCols
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'END TRY'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'BEGIN CATCH' 
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'SELECT '
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'ERROR_NUMBER() as ERROR_NUMBER,'
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'ERROR_MESSAGE() as ERROR_MESSAGE;'
			Set @strSPText = @strSPText +  CHAR(13) + @space + 'END CATCH;'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + 'END'
			Set @strSPText = @strSPText +  CHAR(13) + ''
			Set @strSPText = @strSPText +  CHAR(13) + ''
--			Print @strSPText ;
			Exec(@strSPText);

			if (@@ERROR=0) 
				Print 'Procedure ' + @deleteSPName + ' Created Successfully '
		End
		Else
		Begin
			Print 'Sorry!!  ' + @deleteSPName + ' Already exists in the database. '
		End
	End
	Drop table #tmp_Structure
	Drop table #tmp_PK_Structure

END




GO
/****** Object:  StoredProcedure [dbo].[USP_InsertExcelData_AeraMaster]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_InsertExcelData_AeraMaster](@Area_name UT_AeraMaster1 readonly)  
AS  
BEGIN  
  
INSERT INTO dbo.[AreaMast]  
(  
Area,CityID 
)  
SELECT Area,CityID FROM @Area_name  
END

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertExcelData_CustomerMaster]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[USP_InsertExcelData_CustomerMaster](@CustomerParameters UT_CustomerMaster readonly)  
AS  
BEGIN  

 SET IDENTITY_INSERT CustomerMast off 
INSERT INTO dbo.CustomerMast  
(   
CustomerName,
Address,
Mobile,
AreaID,
SalesPersonID,
VehicleID,
CustomerTypeId,
CustomerNameEnglish,
LastUpdatedDate,
isBillRequired,
isActive,
DeliveryCharges

)  
SELECT  
CustomerName,
Address,
Mobile,
AreaID,
SalesPersonID,
VehicleID,
CustomerTypeId,
CustomerNameEnglish,
LastUpdatedDate,
isBillRequired,
isActive,
DeliveryCharges

FROM @CustomerParameters  

SET IDENTITY_INSERT CustomerMast off
END

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertExcelData_EmployeeMaster]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_InsertExcelData_EmployeeMaster](@EmployeeParameters UT_EmployeeMasters readonly)  
AS  
BEGIN  
  
INSERT INTO dbo.EmployeeMast  
(   
[EmployeeName] ,
[Address] ,
[AreaID] ,
[Mobile] ,
[UserId]
)  
SELECT  
[EmployeeName] ,
[Address] ,
2 ,
[Mobile] ,
1
FROM @EmployeeParameters  
END

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertExcelData_ProductMaster]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_InsertExcelData_ProductMaster](@ProductParameters UT_ProductMaster readonly)  
AS  
BEGIN  
  
INSERT INTO dbo.ProductMast  
(   
[Product] ,
[ProductBrandID] ,
[CreateDate] ,
[CreatedBy] ,
[LastUpdatedDate],
[LastUpdatedBy] ,
[isActive] ,
[CrateSize] ,
[GST] 
)  
SELECT  
[Product] ,
[ProductBrandID] ,
getdate() ,
1 ,
getdate(),
1 ,
1 ,
[CrateSize] ,
[GST]
FROM @ProductParameters  
END

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertExcelData_SupplierMaster]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_InsertExcelData_SupplierMaster](@SupplierParameters UT_SupplierMaster readonly)  
AS  
BEGIN  
  
INSERT INTO dbo.VendorMast  
(
[VendorName]
,[Address]
,[AreaID]
,[CityID]
,[EmailID]
,[OfficePhone]
,[FaxNo]
,[ContactPerson]
,[PersonMobileNo]
,[IsActive]
,[CreatedBy]
,[CreateDate]
,[LastUpdatedDate]
,[LastUpdatedBy]   
)  
SELECT  
[VendorName]
,[Address]
,[AreaID]
,[CityID]
,[EmailID]
,[OfficePhone]
,[FaxNo]
,[ContactPerson]
,[PersonMobileNo]
,[IsActive]
,[CreatedBy]
,[CreateDate]
,[LastUpdatedDate]
,[LastUpdatedBy]
FROM @SupplierParameters  
END

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertExcelData_VehicalMaster]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[USP_InsertExcelData_VehicalMaster](@VehicalParameters UT_VehicalMaster readonly)  
AS  
BEGIN  
  
INSERT INTO dbo.VehicleMast  
(   
[Transport] ,
[Owner] ,
[Address] ,
[Mobile] ,
[VechicleNo],
[Marathi],
[RatePerTrip],
[PrintOrder]
)  
SELECT  
[Transport] ,
[Owner] ,
[Address] ,
[Mobile] ,
[VechicleNo],
[Marathi],
[RatePerTrip],
[PrintOrder]
FROM @VehicalParameters  
END

GO
/****** Object:  StoredProcedure [dbo].[usp_login]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[usp_login]
(@username nvarchar(150),
@password nvarchar(150))
as
begin

select username,password from login where username = @username and password = @password

end

GO
/****** Object:  StoredProcedure [dbo].[usp_reportSalesChallan]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- usp_reportSalesChallan '2017-09-15'
-- =============================================
CREATE PROCEDURE [dbo].[usp_reportSalesChallan]
  @OrderDate datetime
AS
BEGIN
 
	SET NOCOUNT ON;

	Declare @mDayNo int =DATEPART(dd,@OrderDate)
	Declare @mMonthNo int =DATEPART(mm,@OrderDate)
	Declare @mYear int =DATEPART(yyyy,@OrderDate)
	Declare @BillId int 

	Select @BillId=BillId from CustomerBillMast 
	Where
		(CONVERT(varchar(10), DATEPART(Day,  BillDate)) =  convert(varchar(2),@mDayNo) )
		and (CONVERT(varchar(10), DATEPART(month,  BillDate)) =  convert(varchar(2),@mMonthNo) )
		AND (CONVERT(varchar(10), DATEPART(year,  BillDate)) =  convert(varchar(4),@mYear) )


	Select  OrderDet.* ,PaymentDet.*,CratesDet.* From

	(
		SELECT distinct (CONVERT(varchar, CustomerBillMast.BillDate, 103)) as BillDate , CustomerMast.CustomerName, ProductMast.Product, CustomerBillDetails.Quantity, CustomerBillDetails.Amount, 
				 CustomerBillMast.BillID,CustomerBillDetails.CustomerID 
		FROM    CustomerBillDetails Inner JOIN
				CustomerMast ON CustomerBillDetails.CustomerId = CustomerMast.CustomerID Inner JOIN
				ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID Inner JOIN
				CustomerBillMast ON CustomerBillDetails.BillID = CustomerBillMast.BillID Inner JOIN
				CustomerPaymentDetail ON CustomerMast.CustomerID = CustomerPaymentDetail.CustomerId
		WHERE   CustomerBillMast.BillID = @BillId
		GROUP BY CustomerBillMast.BillDate, CustomerMast.CustomerName, ProductMast.Product, CustomerBillDetails.Quantity, CustomerBillDetails.Amount, 
				CustomerBillDetails.ProductID,PreviousBalance,CustomerBillMast.BillID,CustomerBillDetails.CustomerID
	) OrderDet

	Left Outer Join

	(
		Select	BillId,CustomerId,PreviousBalance From CustomerPaymentDetail where BillId = 2
	) PaymentDet  on OrderDet.BillID=PaymentDet.BillID and OrderDet.CustomerId=PaymentDet.CustomerId

	Left Outer Join
	(
	
		Select BillId,CustomerID,CratesIn,CratesOut,Balance from CratesCustomer where BillId = 2
	) CratesDet On  OrderDet.BillID=CratesDet.BillID and OrderDet.CustomerId=CratesDet.CustomerId

	--Order by RowNo asc
END





GO
/****** Object:  StoredProcedure [dbo].[usp_reportSalesChallanGroupWise]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- usp_reportSalesChallanGroupWise '2017-10-09'
-- =============================================
CREATE PROCEDURE [dbo].[usp_reportSalesChallanGroupWise]
  @OrderDate datetime
AS
BEGIN
 
	SET NOCOUNT ON;
--SELECT        CONVERT(varchar, CustomerBillMast.BillDate, 103) AS BillDate, CustomerMast.CustomerName, ProductMast.Product, CustomerBillDetails.Quantity, CustomerBillDetails.Amount, 
--                         ProductBrandMast.BrandName
--FROM            CustomerBillDetails INNER JOIN
--                         CustomerMast ON CustomerBillDetails.CustomerId = CustomerMast.CustomerID INNER JOIN
--                         ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID INNER JOIN
--                         CustomerBillMast ON CustomerBillDetails.BillID = CustomerBillMast.BillID INNER JOIN
--                         ProductBrandMast ON ProductMast.StockCount = ProductBrandMast.ProductBrandID
--WHERE        (CONVERT(varchar, CustomerBillMast.BillDate, 101) = CONVERT(VARCHAR, @OrderDate, 101)) AND (CustomerMast.isBillRequired = 1)
--GROUP BY ProductBrandMast.BrandName,CustomerBillMast.BillDate, CustomerMast.CustomerName, ProductMast.Product, CustomerBillDetails.Quantity, CustomerBillDetails.Amount, CustomerBillDetails.ProductID 
SELECT        SUM(CustomerBillDetails.Quantity) AS Quantity, SUM(CustomerBillDetails.Amount) AS Amount, ProductBrandMast.BrandName Product, CustomerBillDetails.CustomerId, CustomerMast.CustomerName, 
                        CONVERT(varchar, CustomerBillMast.BillDate, 103) AS BillDate
FROM            CustomerBillDetails Left Outer JOIN
                         ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID Left Outer JOIN
                         ProductBrandMast ON ProductMast.StockCount = ProductBrandMast.ProductBrandID Left Outer JOIN
                         CustomerMast ON CustomerBillDetails.CustomerId = CustomerMast.CustomerID Left Outer JOIN
                         CustomerBillMast ON CustomerBillDetails.BillID = CustomerBillMast.BillID
WHERE        (CONVERT(varchar, CustomerBillMast.BillDate, 101) = CONVERT(VARCHAR, @OrderDate, 101)) --AND (CustomerMast.isBillRequired = 1)
GROUP BY ProductBrandMast.BrandName, CustomerBillDetails.CustomerId, CustomerMast.CustomerName, CustomerBillMast.BillDate
ORDER BY CustomerBillDetails.CustomerId

END

  --ROW_NUMBER() OVER(PARTITION BY CustomerMast.CustomerName ORDER BY CustomerBillDetails.ProductID asc) AS SrNo 



GO
/****** Object:  StoredProcedure [dbo].[USPAddVendor]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
 -- exec USPAddVendor 3
  
 CREATE PROCEDURE [dbo].[USPAddVendor] 
  @NotificationId nvarchar(100)
  AS
 BEGIN
 Declare @pDBName Nvarchar(100) ,@sSql  Nvarchar(max),@sSql2  Nvarchar(max),@pFromDbName Nvarchar(max),@pToDbName Nvarchar(max)  
 declare @pFromTenantID Nvarchar(100),@pToTenantID Nvarchar(100) 

 set @pFromTenantID = (select FromTenantID from mDistributor.dbo.NotificationAll where NotificationID = @NotificationId)
 set @pToTenantID = (select ToTenantID from mDistributor.dbo.NotificationAll where NotificationID = @NotificationId)

 set @pFromDbName = (select Dbname from mDistributor.dbo.Tenants where  TenantID = @pFromTenantID)
 set @pToDbName = (select Dbname from mDistributor.dbo.Tenants where  TenantID = @pToTenantID)
 
 
 set @sSql2 =  '
 
 IF NOT EXISTS(SELECT top 1 * FROM '+@pFromDbName+'.dbo.VendorMast  WHERE TenantID = '+@pToTenantID+')
 BEGIN
 INSERT INTO '+@pFromDbName+'.dbo.VendorMast
    ( 
         VendorName
        ,Address
        ,AreaID
        ,CityID
        ,EmailID
        ,OfficePhone
        ,FaxNo
        ,ContactPerson
        ,PersonMobileNo
        ,IsActive
        ,CreatedBy
        ,CreateDate
        ,LastUpdatedDate
        ,LastUpdatedBy
		,TenantID
        
    )
    SELECT 
	   Name AS VendorName
        ,'''' AS Address
        ,'''' AS AreaID
        ,'''' AS CityID
        ,'''' AS EmailID
        ,'''' AS OfficePhone
        ,'''' AS FaxNo
        ,Name AS ContactPerson
        ,Mobile AS PersonMobileNo
        ,1 AS IsActive
        ,'''' AS CreatedBy
        ,GETDATE() AS CreateDate
        ,GETDATE() AS LastUpdatedDate
        ,'''' AS LastUpdatedBy
		,'+@pToTenantID+'
	    from mDistributor.dbo.Tenants  where  tenantid='+@pToTenantID+' and isactive=1
		   
		

		INSERT INTO '+rtrim(@pToDbName)+'.dbo.customermast 
                    (customername,    address,    areaid,    mobile,   SalesPersonID,  VehicleID  , isBillRequired, isActive  ,DeliveryCharges,TenantID)
					  select	
		Name AS customername,  
		address,   
		0 AS areaid,  
		mobile, 
		0 AS SalesPersonID, 
		0 AS VehicleID  , 
		0 AS isBillRequired, 
		1 As isActive  ,
		0 AS DeliveryCharges,'+@pFromTenantID+'
		from  mDistributor.dbo.Tenants Where  tenantid='+  @pFromTenantID +' 

		END'


	Print(@sSql2)
    EXEC(@sSql2)
	
END

GO
/****** Object:  StoredProcedure [dbo].[uspAreaOrderReport]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- uspAreaOrderReport '06/26/2017'  
CREATE Procedure [dbo].[uspAreaOrderReport]
@pDate datetime  
--,@AreaID int
as
Begin

Declare @mDayNo int =DATEPART(dd,@pDate)
Declare @mMonthNo int =DATEPART(mm,@pDate)
Declare @mYear int =DATEPART(yyyy,@pDate)

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P order by ProductBrandID asc


Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from  ProductMast P where isActive=1 order by ProductBrandID asc


set @vSQLText=
	'
	Select Convert(Varchar(10),BillDate,103) BillDate, Area, Qty.*,CustAmt.BillAmount [Bill Amount],CustAmt.PreviousBalance [Previous Balance] , (CustAmt.BillAmount+CustAmt.PreviousBalance) Total--,CAST ( CustAmt.PaidAmount AS Varchar(25) )[Paid Amount],BalanceAmount [Balance Amount] 
	from 
	(
	(Select 
		AreaMast.Area,
		Convert(date,Amt.BillDate) BillDate,
		ROUND(CAST (sum(BillAmount) AS decimal (6,0)),0) BillAmount,
		ROUND(CAST (Sum(Amount)  AS decimal (6,0)),0) PaidAmount,
		ROUND(CAST (Sum(PreviousBalance)  AS decimal (6,0)),0) PreviousBalance,
		ROUND(CAST (Sum(BalanceDue)  AS decimal (6,0)),0) BalanceAmount 
	from [dbo].[CustomerPaymentDetail] Amt
		INNER JOIN
		CustomerMast ON Amt.CustomerId = CustomerMast.CustomerID INNER JOIN
		AreaMast ON CustomerMast.AreaID = AreaMast.AreaID
	where 
		(CONVERT(varchar(10), DATEPART(day,  Amt.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
		And (CONVERT(varchar(10), DATEPART(month,  Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
		AND (CONVERT(varchar(10), DATEPART(year,  Amt.BillDate)) = '+ convert(varchar(4),@mYear) + ')
		And Amt.Billdate is NOT NULL
		Group by Convert(date,Amt.BillDate),AreaMast.Area
	) CustAmt

	outer Apply

	(Select ' + @vProductCol +
	'From
	(Select 
		Convert(date,CO.BillDate) BillDate,P.Product,ROUND(CAST (Sum(B.Quantity)AS decimal (6,0)),0)as Quantity 
		from [dbo].[CustomerBillDetails] B 
		inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
		inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
		INNER JOIN AreaMast ON C.AreaID = AreaMast.AreaID
		INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	where 
		(CONVERT(varchar(10), DATEPART(Day,  CO.BillDate)) ='+ convert(varchar(2),@mDayNo) + ')  
		AND (CONVERT(varchar(10), DATEPART(month,  CO.BillDate)) =  '+ convert(varchar(2),@mMonthNo) + ')
		AND (CONVERT(varchar(10), DATEPART(year,  CO.BillDate)) =  '+ convert(varchar(4),@mYear) + ')
		and Convert(date,CO.BillDate)=Convert(date,CustAmt.BillDate)
		and AreaMast.Area=custamt.Area
		Group by P.Product,Convert(date,CO.BillDate)

	UNION ALL -- Used This for removing ''Null''
		Select 
		'''+convert(varchar(10),@pDate,101)+''' BillDate,''No Product'' Product, convert(Varchar,0) as Quantity 
		from [dbo].[CustomerBillDetails] B 
		inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
		inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
		INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	) P
	pivot
	( 
	Max(Quantity) 
		for [Product] in (' + @vProductList +') 
	) pvt
		Group by BillDate ) Qty
	)
	  '


	print @vSQLText

exec (@vSQLText)
End




GO
/****** Object:  StoredProcedure [dbo].[uspAreaSales]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspAreaSales '10/09/2017',1
-- =============================================
CREATE PROCEDURE [dbo].[uspAreaSales]
@pDate Datetime
,@AreaId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @mDayNo int =DATEPART(dd,@pDate)
Declare @mMonthNo int =DATEPART(mm,@pDate)
Declare @mYear int =DATEPART(yyyy,@pDate)


DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P where isActive=1 order by ProductBrandID asc

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max([' + Product + ']) as ' + '[' + Product + ']' from ProductMast P  where isActive=1 order by ProductBrandID asc

set @vSQLText=
	'
		Select Convert(Varchar(10),BillDate,103) BillDate, Area, CustomerName, Qty.*,CustAmt.BillAmount [Bill Amount],CustAmt.PreviousBalance [Previous Balance] , (CustAmt.BillAmount+CustAmt.PreviousBalance) Total--,CAST ( CustAmt.PaidAmount AS Varchar(25) )[Paid Amount],BalanceAmount [Balance Amount] 
	from 
	(
	(Select 
		CustomerMast.CustomerID,CustomerMast.CustomerName,AreaMast.Area,
		Convert(date,Amt.BillDate) BillDate,
		sum(BillAmount) AS BillAmount,
		Sum(Amount)  AS PaidAmount,
		Sum(PreviousBalance)  AS PreviousBalance,
		Sum(BalanceDue)  AS  BalanceAmount 
	from [dbo].[CustomerPaymentDetail] Amt
	INNER JOIN
    CustomerMast ON Amt.CustomerId = CustomerMast.CustomerID INNER JOIN
                         AreaMast ON CustomerMast.AreaId = AreaMast.AreaId
	where AreaMast.AreaID ='+ convert(varchar,@AreaId)+ '
	
	And	 (CONVERT(varchar(10), DATEPART(day,  Amt.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
	And (CONVERT(varchar(10), DATEPART(month,  Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	AND (CONVERT(varchar(10), DATEPART(year,  Amt.BillDate)) = '+ convert(varchar(4),@mYear) + ')
	And Amt.Billdate is NOT NULL
	Group by CustomerMast.CustomerID,Convert(date,Amt.BillDate),CustomerMast.CustomerName,AreaMast.Area
	) CustAmt
	outer Apply
	(Select ' + @vProductCol +
	'From
	(Select 
	Convert(date,CO.BillDate) BillDate,P.Product,ROUND(CAST (Sum(B.Quantity)AS decimal (6,0)),0) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	where 
	  (CONVERT(varchar(10), DATEPART(Day,  CO.BillDate)) ='+ convert(varchar(2),@mDayNo) + ')  
	 AND (CONVERT(varchar(10), DATEPART(month,  CO.BillDate)) =  '+ convert(varchar(2),@mMonthNo) + ')
	AND (CONVERT(varchar(10), DATEPART(year,  CO.BillDate)) =  '+ convert(varchar(4),@mYear) + ')
	and Convert(date,CO.BillDate)=Convert(date,CustAmt.BillDate)
	and c.CustomerID=custamt.CustomerId
	 Group by P.Product,Convert(date,CO.BillDate)
	) P
	pivot
	( 
	Max(Quantity) 
	for [Product] in (' + @vProductList +') 
	) pvt
	Group by BillDate ) Qty
	)

	'

--print @vSQLText

exec (@vSQLText)


END




GO
/****** Object:  StoredProcedure [dbo].[uspBalaceReport]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[uspBalaceReport]
as
Begin

IF OBJECT_ID('tempdb..#test') IS NOT NULL
  DROP TABLE #test 

Create table #test (Id int, Name varchar(50))

select * from #test
Declare @vstr nvarchar(max)
set @vstr='alter table #test add prod1 int,prod2 int'

EXEC sp_executesql @vstr

select * from #test

End




GO
/****** Object:  StoredProcedure [dbo].[uspCalculateAndUpadteOpeningBalances]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinod Sabade
-- Create date: 10 June 2016
-- Description:	<Description,,>
-- Drop Table tempPayDate
-- uspCalculateAndUpadteOpeningBalances 500,5
-- =============================================
CREATE PROCEDURE [dbo].[uspCalculateAndUpadteOpeningBalances] 

@OpBal decimal(18,2),
@CustomerID int 

AS
BEGIN
 
	SET NOCOUNT ON;

    Declare @updateCnt int
    Declare @recCnt int
    set @updateCnt = 1
    
    declare @tempCustPayId int
    
    declare @custRecCnt int 

	declare @CustIdToReplace int 
	declare @i int 
	declare @BalanceCF decimal(18,2)


	set @i=2
    
	update CustomerPaymentDetail set PreviousBalance = @OpBal where CustomerId= @CustomerID and   BillID=1
	set @BalanceCF = (select (isnull(BillAmount,0) +isnull(PreviousBalance,0))-isnull(CashAmount,0) from CustomerPaymentDetail 
	where CustomerId= @CustomerID and BillID=1)
	
	select ROW_NUMBER() OVER(ORDER BY CustPaymentDetailID asc) AS RowNo,CustPaymentDetailID,Billid,CustomerId,PreviousBalance,CashAmount,BalanceDue 
	into tempPayDate from CustomerPaymentDetail      Where CustomerId=@CustomerID and BillAmount >0 --order by BillID asc

	SET @recCnt = (SELECT COUNT(*) FROM tempPayDate WHERE CustomerId=@CustomerID)
	set @tempCustPayId =(select CustPaymentDetailID from tempPayDate Where BillID=2 and CustomerId=@CustomerID)

		While (@i<=@recCnt)

			Begin

				update CustomerPaymentDetail set PreviousBalance = @BalanceCF where CustPaymentDetailID= @tempCustPayId --CustomerId= @CustIdToReplace and BillID = @i
				 
				  set @BalanceCF = ( select (isnull(BillAmount,0) +isnull(PreviousBalance,0))-isnull(CashAmount,0) from CustomerPaymentDetail 
									where CustomerId= @CustomerID and BillID=@i)
				  set @i=@i+1
				  set @tempCustPayId =(select CustPaymentDetailID from tempPayDate Where BillID=@i and CustomerId=@CustomerID)
				  --print @i
				  --print @BalanceCF
			End
 
		   
Drop Table tempPayDate
END












GO
/****** Object:  StoredProcedure [dbo].[uspCalculateBalances]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinod Sabade
-- Create date: 10 June 2016
-- Description:	<Description,,>
-- Drop Table tempPayDate
-- uspCalculateBalances 1

-- Drop Table tempPayDate
-- ============================================= uspCalculateBalances 3
CREATE PROCEDURE [dbo].[uspCalculateBalances] 

@CustomerID int 

AS
BEGIN
 
	SET NOCOUNT ON;

--    Declare @updateCnt int
--    Declare @recCnt int
--    set @updateCnt = 1
    
--    declare @tempCustPayId int
    
--    declare @custRecCnt int 

--	declare @CustIdToReplace int 
--	declare @i int 
--	declare @BalanceCF decimal(18,2)


--	set @i=2
    
--	--update CustomerPaymentDetail set PreviousBalance = @OpBal where CustomerId= @CustomerID and   BillID=1
--	set @BalanceCF = (select (isnull(BillAmount,0) +isnull(PreviousBalance,0))-isnull(CashAmount,0) from CustomerPaymentDetail 
--	where CustomerId= @CustomerID and BillID=1)
--	--print  @BalanceCF  
	
--	select ROW_NUMBER() OVER(ORDER BY CustPaymentDetailID asc) AS RowNo,CustPaymentDetailID,Billid,CustomerId,PreviousBalance,CashAmount,BalanceDue 
--	into tempPayDate from CustomerPaymentDetail      Where CustomerId=@CustomerID --and BillAmount >0 --order by BillID asc

--	SET @recCnt = (SELECT COUNT(*) FROM tempPayDate WHERE CustomerId=@CustomerID)
--	set @tempCustPayId =(select CustPaymentDetailID from tempPayDate Where BillID>1 and CustomerId=@CustomerID)
----	print @tempCustPayId
--		While (@i<=@recCnt+1)

--			Begin

--				update CustomerPaymentDetail set PreviousBalance = @BalanceCF where CustPaymentDetailID= @tempCustPayId --CustomerId= @CustIdToReplace and BillID = @i
				 
--				  set @BalanceCF = ( select (isnull(BillAmount,0) +isnull(PreviousBalance,0))-isnull(CashAmount,0) from CustomerPaymentDetail 
--									where CustomerId= @CustomerID and BillID=@i)
--				  set @i=@i+1
--				  set @tempCustPayId =(select CustPaymentDetailID from tempPayDate Where BillID=@i and CustomerId=@CustomerID)
--				  print @i
--				  print @BalanceCF
--			End
 
--select * from  tempPayDate		   
--Drop Table tempPayDate


Declare @recCnt int 
Declare @i int 
Declare @PrevBal int
Declare @mBillId int 


Select   ROW_NUMBER() OVER(ORDER BY BillId ASC) AS RowNo,  CustomerID,BillId , PreviousBalance ,BillAmount , CashAmount,ChequeAmount,BalanceDue
into TempPay from CustomerPaymentDetail where CustomerID = @CustomerID and BillId >1 order by BillId asc
-- 



 set @PrevBal = (Select  top 1 ( PreviousBalance +BillAmount -(CashAmount+ChequeAmount))
from CustomerPaymentDetail where CustomerID = @CustomerID and BillId =1
Order by BIllId asc)

set @mBillId= (Select top 1 BillId from TempPay where RowNo=1)

	set @i=2

set @recCnt=(Select count(*) from TempPay)

	While (@i<=@recCnt+1)
	Begin

	UPDATE CustomerPaymentDetail set PreviousBalance = @PrevBal where Billid = @mBillId and  CustomerID = @CustomerID  

		

	 set @PrevBal = (Select    (PreviousBalance +BillAmount -(CashAmount+ChequeAmount))
from CustomerPaymentDetail where CustomerID = @CustomerID and BillId =@mBillId
 )

 set @mBillId= (Select  BillId from TempPay where RowNo= @i)

--Print @mBillId
--print @PrevBal

set @i=@i+1

	End
	  
Drop Table tempPay

END












GO
/****** Object:  StoredProcedure [dbo].[uspCalculateCustomerCratesBalances]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspCalculateCustomerCratesBalances 12
-- =============================================
CREATE PROCEDURE [dbo].[uspCalculateCustomerCratesBalances] 

@CustomerID int 

AS
BEGIN


	SET NOCOUNT ON;

	Declare @recCnt int 
	Declare @i int 
	Declare @PrevCrates int
	Declare @mBillID int 


	Select   ROW_NUMBER() OVER(ORDER BY BillId ASC) AS RowNo,  CustomerID,BillId , CratesOut ,CratesIn , Balance
	into TempCrates from CratesCustomer where CustomerID = @CustomerID and BillId >1

	order by BillId

	set @PrevCrates = (Select  top 1 (isnull(PreBalance,0)+CratesOut-CratesIn)
	from CratesCustomer where CustomerID = @CustomerID and BillId =1
	Order by BIllId asc)

	set @mBillID= (Select top 1 BillId from TempCrates where RowNo=1)

	set @i=1

	set @recCnt=(Select count(*) from TempCrates)


	While (@i<=@recCnt+1)
	Begin

		UPDATE CratesCustomer set PreBalance = @PrevCrates where Billid = @mBillID and  CustomerID = @CustomerID  
		
		set @PrevCrates = (Select    (isnull(PreBalance,0)+CratesOut-CratesIn)
		from CratesCustomer where CustomerID = @CustomerID and BillId =@mBillID)

		set @mBillID= (Select  BillId from TempCrates where RowNo= @i)

		--Print @mBillID
		--print @PrevCrates

		set @i=@i+1

	End
--	Select * from TempCrates
	Drop table TempCrates
END




GO
/****** Object:  StoredProcedure [dbo].[uspCalculateSupplierBalances]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinod Sabade
-- Create date: 10 June 2016
-- Description:	<Description,,>
-- Drop Table tempSupPayData
-- uspCalculateSupplierBalances 1
-- =============================================
CREATE PROCEDURE [dbo].[uspCalculateSupplierBalances] 

@SupplierId int 

AS
BEGIN
 
	SET NOCOUNT ON;

    Declare @updateCnt int
    Declare @recCnt int
    set @updateCnt = 1
    
    declare @tempSupPayId int
    
    declare @SupRecCnt int 

	declare @SupIdToReplace int 
	declare @i int 
	declare @BalanceCF decimal(18,2)


	set @i=2
    
	--update SupplierPaymentDetail set PreviousBalance = @OpBal where SupplierId= @SupplierId and   BillID=1
	set @BalanceCF = (select (isnull(BillAmount,0) +isnull(PreviousBalance,0))-isnull(CashAmount,0) from SupplierPaymentDetail 
	where SupplierId= @SupplierId and BillID=1)
	
	select ROW_NUMBER() OVER(ORDER BY SupplierPaymentDetailID asc) AS RowNo,SupplierPaymentDetailID,Billid,SupplierId,isnull(PreviousBalance,0)As PreviousBalance,CashAmount,BalanceDue 
	into tempSupPayData from SupplierPaymentDetail      Where SupplierId=@SupplierId and BillAmount >0 --order by BillID asc

	SET @recCnt = (SELECT COUNT(*) FROM tempSupPayData WHERE SupplierId=@SupplierId)
	set @tempSupPayId =(select SupplierPaymentDetailID from tempSupPayData Where BillID=2 and SupplierId=@SupplierId)

		While (@i<=@recCnt)

			Begin

				update SupplierPaymentDetail set PreviousBalance = @BalanceCF where SupplierPaymentDetailID= @tempSupPayId --SupplierId= @CustIdToReplace and BillID = @i
				 
				  set @BalanceCF = ( select (isnull(BillAmount,0) +isnull(PreviousBalance,0))-isnull(CashAmount,0) from SupplierPaymentDetail 
									where SupplierId= @SupplierId and BillID=@i)
				  set @i=@i+1
				  set @tempSupPayId =(select SupplierPaymentDetailID from tempSupPayData Where BillID=@i and SupplierId=@SupplierId)
				  --print @i
				  --print @BalanceCF
			End
 
		   
Drop Table tempSupPayData
--select * from tempSupPayData
END












GO
/****** Object:  StoredProcedure [dbo].[uspCheckSync]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspCheckSync 'CustomerMast'
-- =============================================
CREATE PROCEDURE [dbo].[uspCheckSync]
@TableName Varchar(50)	
AS
BEGIN

	SET NOCOUNT ON;

		SELECT SyncDate,isSync FROM [dbo].[SyncObject] where TableName=@TableName and isSync=0

END




GO
/****** Object:  StoredProcedure [dbo].[uspConfirmPurchaseOrder_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 

--uspConfirmPurchaseOrder_MobileApp  '2019-04-10' ,38
CREATE Proc [dbo].[uspConfirmPurchaseOrder_MobileApp]
@OrderDate datetime = '2019-04-06 00:00:00.000' ,
@pVendorID int =38
AS
BEGIN

  Declare @OrderDate1 Nvarchar(12) =Cast(@OrderDate as date)  
    Declare @pDBName varchar(100),@sSql  Nvarchar(max),@sSql1  Nvarchar(max),@sSql2  Nvarchar(max) ,@sSql3 Nvarchar(max),@ssql4 NVarchar(max)  ,@pBillID INT,@pBillID1 INT ,@pTenantID bigint ,@pCustomerID bigint
  
   
  select   @pDBName =  RTrim(DbName)   from mDistributor.dbo.Tenants where  tenantID = (select  tenantid from dbo.VendorMast where vendorid=@pVendorID )
  	 
	 

	SET @sSql = 'IF NOT EXISTS (select TOP 1 BillId  from '+@pDBName+'.dbo.CustomerBillMast where billdate='''+@OrderDate1+''')
				BEGIN 
  				exec  '+@pDBName+'.dbo.uspCreateCutomerOrderForDate_MobileApp'''+@OrderDate1+''' ,''N''
				END'
				
	  --print @sSql
	  exec (@sSql)
	select @pBillID=BillId   from Purchase where 
	billdate= @OrderDate1
	 
	        
	SET @sSql1 = 'WITH CTE
     AS (select
	   P.BillID 
	  ,C.BillID AS  _BillID 
      ,P.ProductID
	  ,C.ProductID AS  _ProductID
      ,P.Quantity
      ,P.Amount 
	  ,C.Quantity AS _Quantity
      ,C.Amount AS _Amount
      ,C.LastUpdatedDate
	   From Purchase P 
	  INNER JOIN ProductMapping PM ON PM.CustomerProductID=P.ProductID
	  inner join '+@pDBName+'.dbo.CustomerBillDetails C ON C.Productid=PM.SupplierProductID  
	  WHERE P.BillId='+Cast (@pBillID AS Nvarchar(10)) +'  and  P.VendorID ='+Cast (@pVendorID AS Nvarchar(10))+')    
	    UPDATE CTE
		 SET  _Quantity =  Quantity ,
		 	  _Amount = Amount '

			   print @sSql1
			  exec(@sSql1)
			   
     SET @sSql2 = ' UPDATE '+@pDBName+'.dbo.CustomerBillMast  SET TotalQty = (select sum(Quantity)  from '+@pDBName+'.dbo.CustomerBillDetails where 
	 BillID = (select BillId   from '+@pDBName+'.dbo.CustomerBillMast   where   Cast(BillDate AS date) = '''+@OrderDate1+''')),
	 TotalAmount =(select sum(Amount)  from '+@pDBName+'.dbo.CustomerBillDetails where billid = (select BillId   from '+@pDBName+'.dbo.CustomerBillMast   where   Cast(BillDate AS date) = '''+@OrderDate1+'''))
	   where BillID= (select BillId   from '+@pDBName+'.dbo.CustomerBillMast   where   Cast(BillDate AS date) = '''+@OrderDate1+''') '
	 print @sSql2
	 exec(@sSql2)
	 
	  SET @sSql4 = 'select TOP 1 @pBillID1= BillId  from '+@pDBName+'.dbo.CustomerBillMast where billdate='''+@OrderDate1+''''
	  select TOP 1 @pBillID1= BillId  from test.dbo.CustomerBillMast where billdate= @OrderDate1 
	  --exec(@sSql4)
 
	select @pCustomerID=CustomerID from test.dbo.customermast where TenantID=(select TenantID   from mDistributor.dbo.Tenants where DbName=  DB_NAME() )
    
	  SET @sSql1 =''
	
	 
	
	  declare @mBillAmount decimal(9,2)

	 set @mBillAmount = (Select sum(Amount)  from [test].[dbo].CustomerBillDetails CBD
							WHERE   (CBD.CustomerId = @pCustomerID) AND (CBD.BillID = @pBillID1)) 

if exists (select billid from [test].[dbo].CustomerPaymentDetail where billid = @pBillID1 and [CustomerId] = @pCustomerID)
begin

	 update [test].[dbo].CustomerPaymentDetail set BillAmount = @mBillAmount where  [CustomerId] = @pCustomerID and [BillID] =@pBillID1 
	 
	 end
	 else
	 begin
	 insert into [test].[dbo].CustomerPaymentDetail
	 (
	 [CustomerId]
      ,[PreviousBalance]
      ,[BillID]
      ,[BillDate]
      ,[BillAmount]
      ,[PaymentDate]
      ,[PaymentMode]
      ,[CashAmount]
      ,[ChequeAmount]
      ,[ChequeNo]
       
      ,[LastUpdatedDate]
	  )
	  values
	  (
	  @pCustomerID,
	  0,
	  @pBillID1,
	  (select billdate from [test].[dbo].customerbillmast where billid = @pBillID1),
	  @mBillAmount,null,null,0,0,0,getdate()

	  )
	  	
	 end
	 exec test.dbo.uspCalculateBalances @pCustomerID
	   select 'Success' As Message
	 END
	 
GO
/****** Object:  StoredProcedure [dbo].[uspCreateCutomerOrderForDate_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspCreateCutomerOrderForDate_MobileApp '05-03-2019','N'
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateCutomerOrderForDate_MobileApp]

@OrderDate Datetime
,@OrderFlag char(1) -- N- NewOrder , R- RepeatOrder

AS
BEGIN
 
	SET NOCOUNT ON;
 Declare @mDayNo int =DATEPART(dd,@OrderDate)
Declare @mMonthNo int =DATEPART(mm,@OrderDate)
Declare @mYear int =DATEPART(yyyy,@OrderDate)

			IF  exists(SELECT  BillID FROM   CustomerBillMast where  

		   	 (CONVERT(varchar(10), DATEPART(Day,  BillDate)) = @mDayNo) 
	 and (CONVERT(varchar(10), DATEPART(month,  BillDate)) = @mMonthNo) 
	 AND (CONVERT(varchar(10), DATEPART(year,  BillDate)) = @mYear)  )

				Begin
					Select  BillId from CustomerBillMast  WHERE 	 (CONVERT(varchar(10), DATEPART(Day,  BillDate)) = @mDayNo) 
	 and (CONVERT(varchar(10), DATEPART(month,  BillDate)) = @mMonthNo) 
	 AND (CONVERT(varchar(10), DATEPART(year,  BillDate)) = @mYear)  
				End
			Else
				Begin

					Declare @mBillId int 

					if (@OrderFlag ='N')
						Begin 			
							exec uspCreateNewOrder_MobileApp @OrderDate 
							set @mBillId =  (Select  isnull(max(BillID),0)   from CustomerBillMast)


							INSERT INTO CustomerBillDetails 
							(BillID, CustomerId, ProductID, Quantity, Amount,LastUpdatedDate)
							SELECT  @mBillId,   CustomerID,ProductID,0 ,0,Getdate() from CustomerRates where EndDate ='9999-01-01' 
							Order By CustomerID,ProductID

							 
							 
						End 
					Else
						Begin 			
							exec uspCreateNewOrder_MobileApp @OrderDate 
							set @mBillId =  (Select  isnull(max(BillID),0)   from CustomerBillMast)



							INSERT INTO CustomerBillDetails 
							(BillID, CustomerId, ProductID, Quantity, Amount,LastUpdatedDate)

							SELECT         @mBillId,  CustomerId, ProductID, Quantity,Amount,getdate()                        
							FROM            CustomerBillDetails 
							WHERE        (BillId = @mBillId-1) Order By CustomerID,ProductID asc

							--INSERT INTO CustomerPaymentDetail
							 
							 INSERT INTO [dbo].[CustomerPaymentDetail] 
						  (CustomerId,PreviousBalance,BillId,BillDate,BillAmount,PaymentDate, 
						   PaymentMode, 
						   CashAmount,ChequeAmount,ChequeNo,LastUpdatedDate) 
							SELECT CustomerId
								  ,BalanceDue
								  ,@mBillId
								  ,@OrderDate AS BillDate
								  ,BillAmount
								  ,GETDATE()
								  ,PaymentMode
								  ,0
								  ,0
								  ,0
								  ,GETDATE()
								   from  CustomerPaymentDetail C where BillID= @mBillId -1  

						End 
					Select @mBillId as BillID
				End


END




GO
/****** Object:  StoredProcedure [dbo].[uspCreateNewOrder]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspCreateNewOrder '05-28-2016'
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateNewOrder]

--@BillDate datetime

AS
BEGIN 
    -- SET NOCOUNT ON added to prevent extra result sets from 
    -- interfering with SELECT statements. 
    SET nocount ON; 
	--declare @BillDate datetime
	--IF EXISTS (select BillID from customerBillMast WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105)) 
	--  BEGIN 
	--	  update customerBillMast 
	--	  set BillDate =@BillDate
	--	  WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105)
		  
	--	  IF @@ROWCOUNT = 0
	--	   INSERT INTO [dbo].[customerbillmast] 
	--				  ([billdate]) 
	--	  VALUES      (@BillDate) 
	--	else 
		
	--	return @@ROWCOUNT 

	--  END 
	--ELSE 
	--  BEGIN 
	--	  INSERT INTO [dbo].[customerbillmast] 
	--				  ([billdate]) 
	--	  VALUES      (@BillDate) 

	--	  SELECT Scope_identity() AS BillId 
	--  END 
	
	
--	Declare @Result int 
	
	
declare @BillDate datetime
----set @BillDate ='05-28-2016'

--	set @Result =( select BillID from customerBillMast WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105) )

--	if @Result = 0
		BEGIN 
		set @BillDate = ( Select top 1 billdate from CustomerBillMast order by BillID desc)
		set @BillDate = dateadd(d,1,@BillDate)


		  INSERT INTO [dbo].[customerbillmast] 
					  ([billdate],TotalQty,TotalAmount,LastUpdatedDate) 
		  VALUES      (isnull(@BillDate,getdate()),0,0,getdate()) 
		

		  SELECT Scope_identity() 
		  		
		END 
	--Else 
	--	BEGIN
	--		Select  '0' as BillID
			
	--	END  
END



GO
/****** Object:  StoredProcedure [dbo].[uspCreateNewOrder_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspCreateNewOrder_MobileApp '05-28-2016'
-- =============================================
CREATE PROCEDURE [dbo].[uspCreateNewOrder_MobileApp]

@BillDate datetime

AS
BEGIN 
    -- SET NOCOUNT ON added to prevent extra result sets from 
    -- interfering with SELECT statements. 
    SET nocount ON; 
	--declare @BillDate datetime
	--IF EXISTS (select BillID from customerBillMast WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105)) 
	--  BEGIN 
	--	  update customerBillMast 
	--	  set BillDate =@BillDate
	--	  WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105)
		  
	--	  IF @@ROWCOUNT = 0
	--	   INSERT INTO [dbo].[customerbillmast] 
	--				  ([billdate]) 
	--	  VALUES      (@BillDate) 
	--	else 
		
	--	return @@ROWCOUNT 

	--  END 
	--ELSE 
	--  BEGIN 
	--	  INSERT INTO [dbo].[customerbillmast] 
	--				  ([billdate]) 
	--	  VALUES      (@BillDate) 

	--	  SELECT Scope_identity() AS BillId 
	--  END 
	
	
--	Declare @Result int 
	
	
--declare @BillDate datetime
----set @BillDate ='05-28-2016'

--	set @Result =( select BillID from customerBillMast WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105) )

--	if @Result = 0
		BEGIN 
		--set @BillDate = ( Select top 1 billdate from CustomerBillMast order by BillID desc)
		--set @BillDate = dateadd(d,1,@BillDate)


		  INSERT INTO [dbo].[customerbillmast] 
					  ([billdate],TotalQty,TotalAmount,LastUpdatedDate) 
		  VALUES      (isnull(@BillDate,getdate()),0,0,getdate()) 
		

		  SELECT Scope_identity() 
		  		
		END 
	--Else 
	--	BEGIN
	--		Select  '0' as BillID
			
	--	END  
END



GO
/****** Object:  StoredProcedure [dbo].[uspCreatePurchaseOrderForDate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspCreatePurchaseOrderForDate '05-26-2017'
 --uspCreatePurchaseOrderForDate '05-09-2019' ,'R'
-- =============================================
CREATE PROCEDURE [dbo].[uspCreatePurchaseOrderForDate] 
@OrderDate datetime,
@OrderFlag char(1) -- N- NewOrder , R- RepeatOrder

AS
BEGIN
	 
	SET NOCOUNT ON;

		IF  exists(SELECT  BillID
					FROM   Purchase 
					 WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@OrderDate,105))
			Begin
				Select  BillId from Purchase  WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@OrderDate,105)
			End

		Else
			Begin
				--Select  isnull(max(BillID),0)+1 as BillId from Purchase
				declare @mBillId int 

				if (@OrderFlag ='N')
					Begin 			
					
						set @mBillId = (Select  isnull(max(BillID),0)+1   from Purchase)


						INSERT INTO [dbo].[Purchase]
						([BillId],[BillDate],[VendorId],[ProductID],[ProductRate],[Quantity],[PaidAmount])
				

						SELECT  @mBillId, @OrderDate,  VendorMast.VendorID, ProductMast.ProductID, VendorProducts.Rate ,
								0 as Quantity, 0 AS PaidAmount
						FROM    VendorProducts INNER JOIN
								VendorMast ON VendorProducts.VendorID = VendorMast.VendorID INNER JOIN
								ProductMast ON VendorProducts.ProductId = ProductMast.ProductID
						Order By VendorMast.VendorID

					End 
				Else
					Begin 			
						--declare @mBillId int 
						set @mBillId = (Select  isnull(max(BillID),0)+1   from Purchase)


						INSERT INTO [dbo].[Purchase]
						([BillId],[BillDate],[VendorId],[ProductID],[ProductRate],[Quantity],[PaidAmount])
				

						SELECT         @mBillId, @OrderDate, Purchase.VendorId, Purchase.ProductID,  VendorProducts.Rate, Purchase.Quantity,  0 as PaidAmount
                        
						FROM            ProductMast INNER JOIN
												 VendorProducts INNER JOIN
												 Purchase INNER JOIN
												 VendorMast ON Purchase.VendorId = VendorMast.VendorID ON VendorProducts.VendorID = Purchase.VendorId AND VendorProducts.ProductId = Purchase.ProductID ON 
												 ProductMast.ProductID = Purchase.ProductID
						WHERE        (Purchase.BillId = @mBillId-1) Order By VendorMast.VendorID,Purchase.ProductID asc


						INSERT INTO [dbo].[SupplierPaymentDetail]
							([SupplierId],[PreviousBalance],[BillID],[BillDate],[BillAmount],[PaymentDate],[PaymentMode],[CashAmount],[ChequeAmount],[ChequeNo],[LastUpdatedDate])
						

						SELECT [SupplierId]
							  ,[PreviousBalance]
							  ,@mBillId
							  ,@OrderDate
							  ,[BillAmount]
							  ,Null
							  ,null
							  ,0
							  ,0
							  ,0
							  ,[LastUpdatedDate]
						  FROM [dbo].[SupplierPaymentDetail] 
						  Where Billid = @mBillId-1


						  -- Csalculate Balances for every Supplier for Repeat Order
					 
							select  distinct VendorID into #Vendors from VendorProducts
							ALTER TABLE #Vendors ADD id INT IDENTITY(1,1) 
					
							Declare @VendorId bigint
							select * from #Vendors
							DECLARE @site_value INT;
							SET @site_value = 0;
					 
							WHILE @site_value <= (select max(id) from #Vendors )
							BEGIN
								 SELECT   @VendorId =VendorID FROM #Vendors 
								 SELECT   @VendorId ,@site_value
								 Exec uspCalculateSupplierBalances @VendorId
								  SET @site_value = @site_value + 1;
							END
					  

					End 
				Select @mBillId as BillID
			End

END

GO
/****** Object:  StoredProcedure [dbo].[uspCustomerCratesLedger]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- uspCustomerCratesLedger 1,2,2017

CREATE Procedure [dbo].[uspCustomerCratesLedger]
@pCustomerID int,
@mMonthNo int,
@mYear int 
  
as
Begin

--Declare @mMonthNo int =DATEPART(mm,@pDate)
--Declare @mYear int =DATEPART(yyyy,@pDate)

SELECT  CustomerMast.CustomerName, AreaMast.Area,  CratesCustomer.CustomerID, CratesCustomer.Date, 
		CratesCustomer.CratesIn, CratesCustomer.CratesOut, CratesCustomer.Balance
                        
FROM    CratesCustomer INNER JOIN
        CustomerMast ON CratesCustomer.CustomerID = CustomerMast.CustomerID INNER JOIN
        AreaMast ON CustomerMast.AreaID = AreaMast.AreaID

		Where CustomerMast.CustomerID=@pCustomerID and 
		CONVERT(varchar(10), DATEPART(month,  Date)) =  convert(varchar(2),@mMonthNo)
		AND CONVERT(varchar(10), DATEPART(year, Date)) = convert(varchar(5),@mYear) 

End



GO
/****** Object:  StoredProcedure [dbo].[uspcustomerLeadger]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspcustomerLeadger 1,5

-- =============================================
CREATE PROCEDURE [dbo].[uspcustomerLeadger]
 
@CustomerID int,
@MonthNo int

AS
BEGIN
		DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max),@vProductfieldList nvarchar(max)
		DECLARE @vSQLText nvarchar(max)

		Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' 
		from ProductMast P  where   ProductID >0 order by ProductBrandID asc



		Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max([' + Product + ']) as ' + '[' + Product + ']' 
		from ProductMast P where   ProductID >0 order by ProductBrandID asc


		DECLARE @vFinalSQLText nvarchar(max)

	Select @vProductfieldList= coalesce(@vProductfieldList + ',','') + '[' + Product + '] decimal(9,2) ' 
	from ProductMast P  where   ProductID >0 order by ProductBrandID asc

	IF OBJECT_ID('tempdb..#test') IS NOT NULL
	 DROP TABLE #test 

	Create table #test(OrderDate varchar(10))
	Declare @vstr nvarchar(max)
	set @vstr='Alter table #test Add ' +  @vProductfieldList + ',BillAmount decimal(9,2),PreviousBalance decimal(9,2),CashAmount decimal(9,2),BalanceDue decimal(9,2)'
	print @vstr

	EXEC sp_executesql @vstr




		set @vSQLText=
		'insert into #test(OrderDate,'+ @vProductList + ')
		SELECT OrderDate,' + @vProductCol + '
		FROM(
			SELECT 
					CustomerBillDetails.CustomerId, CustomerBillDetails.ProductID AS ProductId, convert(varchar(10),
					CustomerBillMast.BillDate,105) AS OrderDate, sum(Quantity) As Quantity, ProductMast.Product as Product
			FROM    CustomerBillDetails INNER JOIN
					ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID 
					inner join CustomerBillMast on CustomerBillMast.BillID  = CustomerBillDetails.BillID
					Where  Month(CustomerBillMast.BillDate) =  ' + convert(varchar(100),@MonthNo	)+' and CustomerBillDetails.CustomerId= ' + convert(varchar(100),@CustomerID) +  '
					GROUP BY CustomerBillDetails.CustomerId,CustomerBillMast.BillDate, CustomerBillDetails.ProductID, ProductMast.Product
			)  as s 
		PIVOT
		(
			SUM(Quantity)
			FOR Product IN (' + @vProductList + ') 
		)AS pvt GROUP BY OrderDate '
		
	--print (@vSQLText)

	EXEC (@vSQLText)

		update #test
		set
		BillAmount =t2.BillAmount,PreviousBalance=t2.PreviousBalance,CashAmount=t2.CashAmount,BalanceDue=t2.BalanceDue
		from #test t1
		inner join(select convert(varchar(10),BillDate,105) as OrderDate,sum(BillAmount) as BillAmount ,
		sum(PreviousBalance) as PreviousBalance,Sum(CashAmount) as CashAmount,sum(BalanceDue) as BalanceDue 
		from CustomerPaymentDetail where month(BillDate) = @MonthNo and CustomerId=@CustomerID
		group by CustomerId,convert(varchar(10),BillDate,105))t2 on t1.OrderDate=t2.OrderDate
		


	Select * from #test

		
END




GO
/****** Object:  StoredProcedure [dbo].[uspCustomerListForOrder]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspCustomerListForOrder]
--uspCustomerListForOrder

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
		declare @cnt varchar(max) 
		DECLARE @parm NVARCHAR(100)
			Select a.CustomerID,min(balanceDue) PreviousBalance into  CntFile from CustomerPaymentDetail a 
			Cross apply ( Select max(billid) billid from customerpaymentdetail b where a.customerID= b.customerID
			)amount  where a.billid=amount.billid Group by a.customerID

			set @parm = (select count(*) FROM CntFile)
			Drop table CntFile

		IF @parm IS NULL
			BEGIN
				SELECT     CustomerPaymentDetail.CustomerId, CustomerMast.CustomerName, MIN(CustomerPaymentDetail.BalanceDue) AS PreviousBalance
				FROM         CustomerPaymentDetail INNER JOIN CustomerMast ON CustomerPaymentDetail.CustomerId = CustomerMast.CustomerID
				Cross apply ( Select max(billid) billid from customerpaymentdetail b where CustomerPaymentDetail.customerID= b.customerID
				)amount  where CustomerPaymentDetail.billid=amount.billid Group by CustomerPaymentDetail.customerID, CustomerMast.CustomerName
			END
		ELSE
			BEGIN
				SELECT CustomerMast.CustomerID, CustomerMast.CustomerName , 0 as PreviousBalance from CustomerMast
			END
END




GO
/****** Object:  StoredProcedure [dbo].[uspCustomerPaymentHistory_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspCustomerPaymentHistory_MobileApp 3
-- =============================================
CREATE PROCEDURE [dbo].[uspCustomerPaymentHistory_MobileApp]
@CustomerID int
AS
BEGIN
 
	SET NOCOUNT ON;

	SELECT  DATENAME(MONTH, BillDate)  +' '+DATENAME(yyyy, BillDate) AS OrderMonth, 
	convert(varchar ,Datepart(DAY,BillDate ))  +' '+ Convert(Varchar(3),DATENAME(MOnth, BillDate)) AS OrderDate,
	CustomerId, PreviousBalance,  BillAmount, CashAmount, ChequeAmount, isnull(ChequeNo,'') as ChequeNo, Amount, BalanceDue
	FROM            CustomerPaymentDetail
	Where CustomerId=@CustomerID order by BillDate asc


END




GO
/****** Object:  StoredProcedure [dbo].[uspCustomerRateChangeHistory]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspCustomerRateChangeHistory 'Where (CustomerMast.CustomerID = 1) AND (ProductMast.ProductID = 7) '
-- =============================================
CREATE PROCEDURE [dbo].[uspCustomerRateChangeHistory]

@whereclause nvarchar(1000)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN TRY

			Declare @SQuery varchar(MAX)
			set @SQuery ='
				SELECT      ROW_NUMBER() OVER(ORDER BY CustomerMast.CustomerID ASC) AS RowNo,    CustomerMast.CustomerName, ProductMast.Product, CustomerRates.Rate, CustomerRates.StartDate as FromDate, 
							Case when 
							convert ( Varchar (12),CustomerRates.EndDate) = ''9999-01-01'' then '''' else convert ( Varchar (12),CustomerRates.EndDate) end  as ToDate ,
							CustomerRates.LastUpdatedDate UpdatedOn, CustomerRates.ProductID
				FROM		CustomerMast INNER JOIN
							CustomerRates ON CustomerMast.CustomerID = CustomerRates.CustomerID INNER JOIN
							ProductMast ON CustomerRates.ProductID = ProductMast.ProductID '
			set @SQuery=@SQuery+@whereclause +' order by	ProductMast.ProductID,CustomerRates.StartDate asc'

			--print @SQuery

			EXEC(@SQuery)
						
			SELECT	ERROR_NUMBER='0'
          
	END TRY

	BEGIN CATCH
		 SELECT
			  ERROR_NUMBER() as ERROR_NUMBER,
			  ERROR_MESSAGE() as ERROR_MESSAGE;
	END CATCH;
END	







GO
/****** Object:  StoredProcedure [dbo].[uspCustomerWiseDailySalesReport]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspCustomerWiseDailySalesReport 3
-- =============================================
CREATE PROCEDURE [dbo].[uspCustomerWiseDailySalesReport]

@CustomerID int 

AS
BEGIN

	SET NOCOUNT ON;

	SELECT	Distinct   CustomerMast.CustomerID, CustomerMast.CustomerName, CustomerPaymentDetail.BillDate,
			(SELECT     SUM(Quantity) FROM          CustomerBillDetails  WHERE      (CustomerId = @CustomerID)) AS TotalQuanity,
			(SELECT     SUM(Amount) FROM          CustomerBillDetails WHERE      (CustomerId = @CustomerID)) AS TotalAmount, CustomerPaymentDetail.PreviousBalance, CustomerPaymentDetail.BillAmount, 
			CustomerPaymentDetail.Amount AS PaidAmount, CustomerPaymentDetail.BalanceDue
	FROM    CustomerMast LEFT OUTER JOIN
			CustomerBillDetails ON CustomerMast.CustomerID = CustomerBillDetails.CustomerId LEFT OUTER JOIN
			CustomerPaymentDetail ON CustomerMast.CustomerID = CustomerPaymentDetail.CustomerId
	WHERE   (CustomerMast.CustomerID =@CustomerID) 


END




GO
/****** Object:  StoredProcedure [dbo].[uspCustomerWiseMonthlySalesRegister]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Execute uspCustomerWiseMonthlySalesRegister 2,2017
CREATE Procedure [dbo].[uspCustomerWiseMonthlySalesRegister]
--@pCustomerID int,
@mMonthNo int,
@mYear int  

as
Begin


--Declare @mMonthNo int =DATEPART(mm,@pDate)
--Declare @mYear int =DATEPART(yyyy,@pDate)

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P order by ProductBrandID
--inner join (Select Productid from customerRates where customerID=@pCustomerID Group by Productid) CP on (CP.ProductID=P.ProductID)

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P order by ProductBrandID
--inner join (Select Productid from customerRates where customerID=@pCustomerID Group by Productid) CP on (CP.ProductID=P.ProductID)

-- Amt.CustomerID= ' + convert(varchar(100),@pCustomerID) + ' and
-- C.CustomerID= ' + convert(varchar(100),@pCustomerID) + ' and

set @vSQLText=
	'
	Select 
	convert(varchar(10),BillDate,103) [Date],Qty.*,CustAmt.BillAmount [Bill Amount]--,CustAmt.PreviousBalance [Previous Balance] , (CustAmt.BillAmount+CustAmt.PreviousBalance) Total,CAST ( CustAmt.PaidAmount AS Varchar(25) )[Paid Amount],BalanceAmount [Balance Amount] 

	from
	(
	(Select 
		Convert(date,Amt.BillDate) BillDate,
		sum(BillAmount) BillAmount
		--Sum(Amount) PaidAmount,
		--Sum(PreviousBalance) PreviousBalance,
		--Sum(BalanceDue) BalanceAmount 
	from [dbo].[CustomerPaymentDetail] Amt
	where
	 (CONVERT(varchar(10), DATEPART(month,  Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	AND (CONVERT(varchar(10), DATEPART(year,  Amt.BillDate)) = '+ convert(varchar(5),@mYear) + ')
	and Amt.Billdate is NOT NULL
	Group by Convert(date,Amt.BillDate)
	) CustAmt
	outer Apply
	(Select ' + @vProductCol +
	'From
	(Select 
	Convert(date,CO.BillDate) BillDate,P.Product,Sum(B.Quantity) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	where

	  (CONVERT(varchar(10), DATEPART(month,  CO.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	 AND (CONVERT(varchar(10), DATEPART(year,  CO.BillDate)) = '+ convert(varchar(5),@mYear) + ')
	and Convert(date,CO.BillDate)=Convert(date,CustAmt.BillDate)
	Group by P.Product,Convert(date,CO.BillDate)
	) P
	pivot
	( 
	Max(Quantity) 
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate ) Qty
	)'

print @vSQLText

exec (@vSQLText)
End





GO
/****** Object:  StoredProcedure [dbo].[uspCustomoerLedger]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[uspCustomoerLedger]
@pCustomerID int,
--@pDate Datetime  
@mMonthNo int,
@mYear int 
  
as
Begin
---Execute Rpt_CustomerWiseQtyAmount 1,'02/01/2017'

--Declare @mMonthNo int =DATEPART(mm,@pDate)
--Declare @mYear int =DATEPART(yyyy,@pDate)

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P 
inner join (Select Productid from customerRates where customerID=@pCustomerID Group by Productid) CP on (CP.ProductID=P.ProductID) order by ProductBrandID

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P 
inner join (Select Productid from customerRates where customerID=@pCustomerID Group by Productid) CP on (CP.ProductID=P.ProductID)  order by ProductBrandID



set @vSQLText=
	'
	Select 
	convert(varchar(10),BillDate,103) [Date],Qty.*,CustAmt.BillAmount [Bill Amount],CustAmt.PreviousBalance [Previous Balance] , (CustAmt.BillAmount+CustAmt.PreviousBalance) Total,CAST ( CustAmt.PaidAmount AS Varchar(25) )[Paid Amount],BalanceAmount [Balance Amount] 

	from
	(
	(Select 
		Amt.CustomerID,
		Convert(date,Amt.BillDate) BillDate,
		sum(BillAmount) BillAmount,
		Sum(Amount) PaidAmount,
		Sum(PreviousBalance) PreviousBalance,
		Sum(BalanceDue) BalanceAmount 
	from [dbo].[CustomerPaymentDetail] Amt
	where Amt.CustomerID= ' + convert(varchar(100),@pCustomerID) + ' and
	 (CONVERT(varchar(10), DATEPART(month,  Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	AND (CONVERT(varchar(10), DATEPART(year,  Amt.BillDate)) = '+ convert(varchar(5),@mYear) + ')
	and Amt.Billdate is NOT NULL
	Group by Amt.CustomerID,Convert(date,Amt.BillDate)
	) CustAmt
	outer Apply
	(Select ' + @vProductCol +
	'From
	(Select 
	Convert(date,CO.BillDate) BillDate,P.Product,Sum(B.Quantity) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	where C.CustomerID= ' + convert(varchar(100),@pCustomerID) + 
	'
	 and (CONVERT(varchar(10), DATEPART(month,  CO.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	 AND (CONVERT(varchar(10), DATEPART(year,  CO.BillDate)) = '+ convert(varchar(5),@mYear) + ')
	and Convert(date,CO.BillDate)=Convert(date,CustAmt.BillDate)
	 Group by P.Product,Convert(date,CO.BillDate)
	) P
	pivot
	( 
	Max(Quantity) 
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate ) Qty
	)'

print @vSQLText

exec (@vSQLText)
End





GO
/****** Object:  StoredProcedure [dbo].[uspDailyBusinessProfit]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--uspDailyBusinessProfit '10-09-2017'
-- =============================================
CREATE PROCEDURE [dbo].[uspDailyBusinessProfit] 
	 
@pDate Datetime 

AS
BEGIN

	SET NOCOUNT ON;
	Declare @mBillid int
	Declare @mDayNo int =DATEPART(dd,@pDate)
	Declare @mMonthNo int =DATEPART(mm,@pDate)
	Declare @mYear int =DATEPART(yyyy,@pDate)
	Select @mBillid = Billid from CustomerBillMast 
	where 
	CONVERT(varchar(10), DATEPART(Day,  BillDate)) = convert(varchar(2),@mDayNo) 
	And  CONVERT(varchar(10), DATEPART(month,  BillDate)) = convert(varchar(2),@mMonthNo) 
	And  CONVERT(varchar(10), DATEPART(year,  BillDate)) = convert(varchar(4),@mYear) 

	SELECT Pur.Product ,Pur.PurchaseAmount,Sale.SaleAmount,isnull(Pur.PurchaseAmount-Sale.SaleAmount,0) as Diff
	from 
	(SELECT Purchase.ProductID, ProductMast.Product,  isnull(Sum (Purchase.Amount),0) PurchaseAmount
	FROM    Purchase left outer JOIN
			ProductMast ON Purchase.ProductID = ProductMast.ProductID
	WHERE   
	CONVERT(varchar(10), DATEPART(Day,  Purchase.BillDate)) = convert(varchar(2),@mDayNo) 
	And  CONVERT(varchar(10), DATEPART(month,  Purchase.BillDate)) = convert(varchar(2),@mMonthNo) 
	And  CONVERT(varchar(10), DATEPART(year,  Purchase.BillDate)) = convert(varchar(4),@mYear) 
	Group by  Purchase.ProductID, ProductMast.Product) as Pur
	left join
	(SELECT CustomerBillDetails.ProductID, ProductMast.Product,  Sum(CustomerBillDetails.Amount) SaleAmount
	FROM    CustomerBillDetails INNER JOIN
			ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID
	WHERE   (CustomerBillDetails.BillID = @mBillid)
	Group by  CustomerBillDetails.ProductID, ProductMast.Product)  Sale
	on
	Pur.ProductID = sale.ProductID
	order by Pur.ProductID

END



GO
/****** Object:  StoredProcedure [dbo].[uspDailyPurchase]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspDailyPurchase
-- =============================================
CREATE PROCEDURE [dbo].[uspDailyPurchase]

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DECLARE @vProductList NVARCHAR(max), 
				@vProductCol  NVARCHAR(max) 
		DECLARE @vSQLText NVARCHAR(max) 

		SELECT @vProductList = COALESCE(@vProductList + ',', '') + '[' 
							   + product + ']' 
		FROM   productmast P where   ProductID >0

		SELECT @vProductCol = COALESCE(@vProductCol + ',', '') + 'Max([' 
							  + product + ']) as ' + '[' + product + ']' 
		FROM   productmast P where   ProductID >0

		SET @vSQLText= 'SELECT PurcahseDate,' + @vProductCol 
					   + ' FROM ( SELECT     Purchase.ProductID AS ProductId, convert(varchar(10),BillDate,103) AS PurcahseDate,
					   Quantity, ProductMast.Product as Product 
					   FROM         Purchase INNER JOIN   ProductMast ON Purchase.ProductID = ProductMast.ProductID  )  as s 
					   PIVOT ( SUM(Quantity) FOR Product IN (' + @vProductList 
					   + ')  )AS pvt group by PurcahseDate' 

		EXEC (@vSQLText) 


	
END




GO
/****** Object:  StoredProcedure [dbo].[uspDailyPurchaseReport]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[uspDailyPurchaseReport]
@BillID int
 
as
Begin


DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P
--inner join (Select Productid from customerRates where customerID=@pCustomerID Group by Productid) CP on (CP.ProductID=P.ProductID)

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max([' + Product + ']) as ' + '[' + Product + ']' from ProductMast P
--inner join (Select Productid from customerRates where customerID=@pCustomerID Group by Productid) CP on (CP.ProductID=P.ProductID)



set @vSQLText='


Select  '+ @vProductCol+' From
(Select 
Convert(date,B.BillDate) BillDate,P.Product,Sum(B.Quantity) as Quantity 
from [dbo].[purchase] B 
inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
inner join [dbo].[VendorMast] C on (C.VendorID=B.VendorID)


 Group by P.Product,Convert(date,B.BillDate)
) P
pivot
( 
Max(Quantity) 
for [Product] in ('+@vProductList+') ) pvt
Group by BillDate '

print @vSQLText

exec (@vSQLText)
End



GO
/****** Object:  StoredProcedure [dbo].[uspDailySalesReport]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- uspDailySalesReport 1
CREATE Procedure [dbo].[uspDailySalesReport]
@BillID int
 
as
Begin


DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P
--inner join (Select Productid from customerRates where customerID=@pCustomerID Group by Productid) CP on (CP.ProductID=P.ProductID)

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max([' + Product + ']) as ' + '[' + Product + ']' from ProductMast P
--inner join (Select Productid from customerRates where customerID=@pCustomerID Group by Productid) CP on (CP.ProductID=P.ProductID)



set @vSQLText=
	'Select '+ @vProductCol+'
	From
	(Select 
	Convert(date,CO.BillDate) BillDate,P.Product,Sum(isnull(B.Quantity,0)) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	where CO.BillID= ' + convert(varchar(100),@BillID) + '
	 Group by P.Product,Convert(date,CO.BillDate)
	) P
	pivot
	( 
	Max(Quantity) 
	for [Product] in ('+@vProductList+') ) pvt
	Group by BillDate 
	'

print @vSQLText

exec (@vSQLText)
End





GO
/****** Object:  StoredProcedure [dbo].[uspDashboardAreaSales]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspDashboardAreaSales '10/10/2017'
-- =============================================
CREATE PROCEDURE [dbo].[uspDashboardAreaSales]
@pDate Datetime
--,@AreaId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

Declare @mDayNo int =DATEPART(dd,@pDate)
Declare @mMonthNo int =DATEPART(mm,@pDate)
Declare @mYear int =DATEPART(yyyy,@pDate)


DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P order by ProductBrandID asc

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P order by productid asc

set @vSQLText=
	'
	Select AreaID,Area AS Route,' + @vProductCol +
	'From
	(Select  AreaMast.Area,AreaMast.AreaID,
	Convert(date,CO.BillDate) BillDate,P.Product, convert(Varchar,Sum(isnull(B.Quantity,0))) as Quantity 
	from CustomerBillDetails AS B INNER JOIN
        ProductMast AS P ON P.ProductID = B.ProductID INNER JOIN
        CustomerMast AS C ON C.CustomerID = B.CustomerId INNER JOIN
        CustomerBillMast AS CO ON B.BillID = CO.BillID INNER JOIN
        AreaMast ON C.AreaID = AreaMast.AreaID
	where 
	
	 (CONVERT(varchar(10), DATEPART(Day,  CO.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
	 and (CONVERT(varchar(10), DATEPART(month,  CO.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	 AND (CONVERT(varchar(10), DATEPART(year,  CO.BillDate)) = '+ convert(varchar(4),@mYear) + ')
	
	 Group by P.Product,Convert(date,CO.BillDate), AreaMast.Area,AreaMast.AreaID
	) P
	pivot
	( 
	Max(Quantity )
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate  ,Area ,AreaID  order by AreaID

	'

print @vSQLText

exec (@vSQLText)


END



GO
/****** Object:  StoredProcedure [dbo].[uspDashboardCustomerOutstanding]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinod Sabade
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspDashboardCustomerOutstanding]
AS
BEGIN
 
	SET NOCOUNT ON;


SELECT  CustomerMast.CustomerName, CustomerPaymentDetail.CustomerId, CustomerPaymentDetail.BillID, CustomerPaymentDetail.BalanceDue
FROM    CustomerPaymentDetail INNER JOIN
        CustomerMast ON CustomerPaymentDetail.CustomerId = CustomerMast.CustomerID
WHERE   (CustomerPaymentDetail.BillID =
        (SELECT DISTINCT TOP (1) BillID
        FROM            CustomerPaymentDetail AS CustomerPaymentDetail_1
        ORDER BY BillID DESC)) AND (CustomerPaymentDetail.BalanceDue <> 0)

END




GO
/****** Object:  StoredProcedure [dbo].[uspDayBusiness]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- uspDayBusiness '06/07/2017'
CREATE Procedure [dbo].[uspDayBusiness]
@pDate Datetime  
as
Begin

Declare @mDayNo int =DATEPART(dd,@pDate)
Declare @mMonthNo int =DATEPART(mm,@pDate)
Declare @mYear int =DATEPART(yyyy,@pDate)

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P  where isActive=1 order by ProductBrandID asc

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P where isActive=1 order by productid asc

set @vSQLText=
	'
	Select  ''2'' AS No,''Sale'' AS DayTrans,' + @vProductCol +
	'From
	(Select 
	Convert(date,CO.BillDate) BillDate,P.Product, convert(Varchar,Sum(isnull(B.Quantity,0))) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	where 
	
	 (CONVERT(varchar(10), DATEPART(Day,  CO.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
	 and (CONVERT(varchar(10), DATEPART(month,  CO.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	 AND (CONVERT(varchar(10), DATEPART(year,  CO.BillDate)) = '+ convert(varchar(4),@mYear) + ')

	 Group by P.Product,Convert(date,CO.BillDate)
	 UNION ALL 
	 Select 
	'''+convert(varchar(10),@pDate,101)+''' BillDate,''No Product'' Product, convert(Varchar,0) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	) P
	pivot
	( 
	Max(Quantity )
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate   
	
	 Union

	 Select   ''3'' AS No,''Lickage'' AS DayTrans,' + @vProductCol +
	'From
		(Select 
		Convert(date,B.BillDate) BillDate,P.Product,convert(Varchar,Sum(B.Likage)) as Quantity 
		from [dbo].[VendorLikages] B 
		inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
		-- INNER JOIN [dbo].[CustomerLikages] CO ON B.BillID = CO.BillID

		where
		 (CONVERT(varchar(10), DATEPART(DAY,  B.BillDate)) = '+ convert(varchar(2),@mDayNo) + ')
		 and (CONVERT(varchar(10), DATEPART(month,  B.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
		 AND (CONVERT(varchar(10), DATEPART(year,  B.BillDate)) = '+ convert(varchar(4),@mYear) + ')
		Group by P.Product,Convert(date,B.BillDate)
		UNION ALL 
	 Select 
	'''+convert(varchar(10),@pDate,101)+''' BillDate,''No Product'' Product, convert(Varchar,0) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	) P
	pivot
	( 
	Max(Quantity) 
	
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate

	Union 
	
	Select   ''1'' AS No,''Purchase'' AS DayTrans,' + @vProductCol +
	'From
		(Select
		Convert(date,B.BillDate) BillDate,P.Product,Sum(isnull(B.Quantity,0)) as Quantity 
		from [dbo].[purchase] B 
		inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
		inner join [dbo].[VendorMast] C on (C.VendorID=B.VendorID)
		where 
		(CONVERT(varchar(10), DATEPART(Day,  B.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
		and (CONVERT(varchar(10), DATEPART(month,  B.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
		AND (CONVERT(varchar(10), DATEPART(year,  B.BillDate)) = '+ convert(varchar(4),@mYear) + ')

		Group by P.Product,Convert(date,B.BillDate)
		UNION ALL 
	 Select 
	'''+convert(varchar(10),@pDate,101)+''' BillDate,''No Product'' Product, convert(Varchar,0) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	) P
	pivot
	( 
	Max(Quantity) 
	
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate

	/* Union
	
	Select   ''0'' AS No,''Stock Balance'' AS DayTrans,' + @vProductCol +
	'From
		(Select
		Convert(date,B.BillDate) BillDate,P.Product,Sum(isnull(B.Quantity,0)) as Quantity 
		from [dbo].[purchase] B 
		inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
		inner join [dbo].[VendorMast] C on (C.VendorID=B.VendorID)
		where 
		(CONVERT(varchar(10), DATEPART(Day,  B.BillDate)) = '+ convert(varchar(2),@mDayNo-1) + ') 
		and (CONVERT(varchar(10), DATEPART(month,  B.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
		AND (CONVERT(varchar(10), DATEPART(year,  B.BillDate)) = '+ convert(varchar(4),@mYear) + ')

		Group by P.Product,Convert(date,B.BillDate)
	) P
	pivot
	( 
	Max(Quantity) 
	
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate*/



	'

print @vSQLText

exec (@vSQLText)
End





GO
/****** Object:  StoredProcedure [dbo].[uspDayStockBalance]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- uspDayStockBalance '10/10/2017'
CREATE Procedure [dbo].[uspDayStockBalance]
@pDate Datetime  
as
Begin

set @pDate= DATEADD(d,-1,@pDate)

Declare @mDayNo int =DATEPART(dd,@pDate)
Declare @mMonthNo int =DATEPART(mm,@pDate)
Declare @mYear int =DATEPART(yyyy,@pDate)

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P  where isActive=1 order by ProductBrandID asc

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P where isActive=1 order by productid asc

set @vSQLText=
	'
	Select  ''2'' AS No,''Sale'' AS DayTrans,' + @vProductCol +
	'From
	(Select 
	Convert(date,CO.BillDate) BillDate,P.Product, convert(Varchar,Sum(isnull(B.Quantity,0))) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	where 
	
	 (CONVERT(varchar(10), DATEPART(Day,  CO.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
	 and (CONVERT(varchar(10), DATEPART(month,  CO.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	 AND (CONVERT(varchar(10), DATEPART(year,  CO.BillDate)) = '+ convert(varchar(4),@mYear) + ')

	 Group by P.Product,Convert(date,CO.BillDate)
	 UNION ALL 
	 Select 
	'''+convert(varchar(10),@pDate,101)+''' BillDate,''No Product'' Product, convert(Varchar,0) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	) P
	pivot
	( 
	Max(Quantity )
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate   
	
	 Union

	 Select   ''3'' AS No,''Lickage'' AS DayTrans,' + @vProductCol +
	'From
		(Select 
		Convert(date,B.BillDate) BillDate,P.Product,convert(Varchar,Sum(B.Likage)) as Quantity 
		from [dbo].[VendorLikages] B 
		inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
		-- INNER JOIN [dbo].[CustomerLikages] CO ON B.BillID = CO.BillID

		where
		 (CONVERT(varchar(10), DATEPART(DAY,  B.BillDate)) = '+ convert(varchar(2),@mDayNo) + ')
		 and (CONVERT(varchar(10), DATEPART(month,  B.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
		 AND (CONVERT(varchar(10), DATEPART(year,  B.BillDate)) = '+ convert(varchar(4),@mYear) + ')
		Group by P.Product,Convert(date,B.BillDate)
		UNION ALL 
	 Select 
	'''+convert(varchar(10),@pDate,101)+''' BillDate,''No Product'' Product, convert(Varchar,0) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	) P
	pivot
	( 
	Max(Quantity) 
	
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate

	Union 
	
	Select   ''1'' AS No,''Purchase'' AS DayTrans,' + @vProductCol +
	'From
		(Select
		Convert(date,B.BillDate) BillDate,P.Product,Sum(isnull(B.Quantity,0)) as Quantity 
		from [dbo].[purchase] B 
		inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
		inner join [dbo].[VendorMast] C on (C.VendorID=B.VendorID)
		where 
		(CONVERT(varchar(10), DATEPART(Day,  B.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
		and (CONVERT(varchar(10), DATEPART(month,  B.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
		AND (CONVERT(varchar(10), DATEPART(year,  B.BillDate)) = '+ convert(varchar(4),@mYear) + ')

		Group by P.Product,Convert(date,B.BillDate)
		UNION ALL 
	 Select 
	'''+convert(varchar(10),@pDate,101)+''' BillDate,''No Product'' Product, convert(Varchar,0) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	) P
	pivot
	( 
	Max(Quantity) 
	
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate

	/* Union
	
	Select   ''0'' AS No,''Stock Balance'' AS DayTrans,' + @vProductCol +
	'From
		(Select
		Convert(date,B.BillDate) BillDate,P.Product,Sum(isnull(B.Quantity,0)) as Quantity 
		from [dbo].[purchase] B 
		inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
		inner join [dbo].[VendorMast] C on (C.VendorID=B.VendorID)
		where 
		(CONVERT(varchar(10), DATEPART(Day,  B.BillDate)) = '+ convert(varchar(2),@mDayNo-1) + ') 
		and (CONVERT(varchar(10), DATEPART(month,  B.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
		AND (CONVERT(varchar(10), DATEPART(year,  B.BillDate)) = '+ convert(varchar(4),@mYear) + ')

		Group by P.Product,Convert(date,B.BillDate)
	) P
	pivot
	( 
	Max(Quantity) 
	
	for [Product] in (' + @vProductList + ') ) pvt
	Group by BillDate*/



	'

print @vSQLText

exec (@vSQLText)
End




GO
/****** Object:  StoredProcedure [dbo].[uspEmployeeDataCount]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[uspEmployeeDataCount]
AS
BEGIN
 
	SET NOCOUNT ON;

 Select Count(EmployeeId) from EmployeeMast

END




GO
/****** Object:  StoredProcedure [dbo].[uspEmployeeOrderReport]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- uspEmployeeOrderReport '02/14/2017' ,1
CREATE Procedure [dbo].[uspEmployeeOrderReport]
@pDate datetime  
,@EmployeeID int
as
Begin

Declare @mDayNo int =DATEPART(dd,@pDate)
Declare @mMonthNo int =DATEPART(mm,@pDate)
Declare @mYear int =DATEPART(yyyy,@pDate)

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P

set @vSQLText=
	'
	Select BillDate, EmployeeName, CustomerName, Qty.*,CustAmt.BillAmount [Bill Amount],CustAmt.PreviousBalance [Previous Balance] , (CustAmt.BillAmount+CustAmt.PreviousBalance) Total--,CAST ( CustAmt.PaidAmount AS Varchar(25) )[Paid Amount],BalanceAmount [Balance Amount] 
	from 
	(
	(Select 
		CustomerMast.CustomerID,CustomerMast.CustomerName,EmployeeMast.EmployeeName,
		Convert(date,Amt.BillDate) BillDate,
		sum(BillAmount) BillAmount,
		Sum(Amount) PaidAmount,
		Sum(PreviousBalance) PreviousBalance,
		Sum(BalanceDue) BalanceAmount 
	from [dbo].[CustomerPaymentDetail] Amt
	INNER JOIN
    CustomerMast ON Amt.CustomerId = CustomerMast.CustomerID INNER JOIN
                         EmployeeMast ON CustomerMast.SalesPersonID = EmployeeMast.EmployeeID
	where 
	CustomerMast.SalesPersonID = '+ convert(varchar,@EmployeeID )+'
	AND	 (CONVERT(varchar(10), DATEPART(day,  Amt.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
	And (CONVERT(varchar(10), DATEPART(month,  Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	AND (CONVERT(varchar(10), DATEPART(year,  Amt.BillDate)) = '+ convert(varchar(4),@mYear) + ')
	And Amt.Billdate is NOT NULL
	Group by CustomerMast.CustomerID,Convert(date,Amt.BillDate),CustomerMast.CustomerName,EmployeeMast.EmployeeName
	) CustAmt
	outer Apply
	(Select ' + @vProductCol +
	'From
	(Select 
	Convert(date,CO.BillDate) BillDate,P.Product,Sum(B.Quantity) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	where 
	  (CONVERT(varchar(10), DATEPART(Day,  CO.BillDate)) ='+ convert(varchar(2),@mDayNo) + ')  
	 AND (CONVERT(varchar(10), DATEPART(month,  CO.BillDate)) =  '+ convert(varchar(2),@mMonthNo) + ')
	AND (CONVERT(varchar(10), DATEPART(year,  CO.BillDate)) =  '+ convert(varchar(4),@mYear) + ')
	and Convert(date,CO.BillDate)=Convert(date,CustAmt.BillDate)
	and c.CustomerID=custamt.CustomerId
	 Group by P.Product,Convert(date,CO.BillDate)
	) P
	pivot
	( 
	Max(Quantity) 
	for [Product] in (' + @vProductList +') 
	) pvt
	Group by BillDate ) Qty
	)
	  '


	print @vSQLText

exec (@vSQLText)
End



GO
/****** Object:  StoredProcedure [dbo].[uspGenerateBillIdForPurchase]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGenerateBillIdForPurchase '03-20-2017'
-- =============================================
CREATE PROCEDURE [dbo].[uspGenerateBillIdForPurchase] 
@BillDate datetime

AS
BEGIN
	 
	SET NOCOUNT ON;

		IF  exists(SELECT  BillID
					FROM   Purchase 
					 WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105))
			Begin
				Select  BillId from Purchase  WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105)
			End

		Else
			Begin
				Select  isnull(max(BillID),0)+1 as BillId from Purchase
			End

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetAreaDataCount]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE  [dbo].[uspGetAreaDataCount]
AS
BEGIN
 
	SET NOCOUNT ON;
 	Select count(*) from AreaMast

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCrateSizeByProductName]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetCrateSizeByProductName 'थोरात'
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCrateSizeByProductName] 
 @ProductName nvarchar(50)
AS
BEGIN


	SET NOCOUNT ON;
	--set @ProductName = 'N'+@ProductName
	--print @ProductName
	select isnull(Cratesize,0) as Cratesize from ProductMast where Product=@ProductName
 


END





GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerCrates]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetCustomerCrates 37,1
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerCrates]
@BillId int ,
@CustomerId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
SELECT        CratesCustomer.CratesCustID, CratesCustomer.BillId, CratesCustomer.CustomerID, CratesCustomer.Date, CratesCustomer.CratesIn, CratesCustomer.CratesOut, CratesCustomer.Balance, 
                         CustomerMast.CustomerName, AreaMast.Area
FROM            CratesCustomer INNER JOIN
                         CustomerMast ON CratesCustomer.CustomerID = CustomerMast.CustomerID INNER JOIN
                         AreaMast ON CustomerMast.AreaID = AreaMast.AreaID
WHERE        (CratesCustomer.BillId = @BillId) and   (CratesCustomer.CustomerID = @CustomerId)

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerLedgerFooter]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetCustomerLedgerFooter 1,'02/01/2017'
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerLedgerFooter] 
@CustomerId int ,
@mMonthNo int,
@mYear int 
  

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--	Declare @mMonthNo int =DATEPART(mm,@pDate)
--Declare @mYear int =DATEPART(yyyy,@pDate)

declare @mTemp1 decimal(18,2)
declare @mTemp2 decimal(18,2)
Declare @mTotalPaidAmt Decimal(18,0)
Declare @mTotalBillAmt Decimal(18,0)

	Select top 1  @mTemp1 = PreviousBalance  from CustomerPaymentDetail 
	where CustomerId=@CustomerId and DATEPART(MM,Billdate)=@mMonthNo and DATEPART(YYYY,Billdate) = @mYear
	

	Select top 1  @mTemp2 = BalanceDue from CustomerPaymentDetail 
	where CustomerId=@CustomerId and DATEPART(MM,Billdate)=@mMonthNo and DATEPART(YYYY,Billdate) = @mYear
	order by BillDate desc
	  

	select @mTotalPaidAmt=Sum(CashAmount),@mTotalBillAmt=sum(BillAmount) from CustomerPaymentDetail 
	where CustomerId=@CustomerId and DATEPART(MM,Billdate)=@mMonthNo and DATEPART(YYYY,Billdate) = @mYear

	Select  @mTemp1 as [Balance C/F],@mTemp2 as [Total Balance Due], @mTotalPaidAmt AS [Paid Amount],@mTotalBillAmt AS [Total Bill Amount  for Month]
END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerLickage]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinod Sabade
-- Create date: 28 Feb 2017
-- Description:	<Description,,>
-- uspGetCustomerLickage 1,1,1
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerLickage] 
@CustomerID int,
@BillID int,
@ProductID int
AS
BEGIN
 
	SET NOCOUNT ON;


	SELECT     isnull(Likage,0) as Likage,  CustomerID, BillId, ProductID
	FROM        CustomerLikages
	WHERE		CustomerID  = @CustomerID   AND BillID = @BillID AND ProductID = @ProductID

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerListForUser_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
--  uspGetCustomerListForUser_MobileApp 50
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerListForUser_MobileApp] 
 @UserId int
AS
BEGIN
 
	SET NOCOUNT ON;
	CREATE TABLE  #Temptbl( 
	CustomerName nvarchar(50) NOT NULL,
	Address nvarchar(350) NOT NULL,
	CustomerId BIGINT,
	BillID BIGINT,
	BalanceDue decimal(9, 2) NULL,
	CashAmount decimal(9, 2) NULL,
	TotalDue  decimal(9, 2) NULL,
	Area nvarchar(350),
	PaymentStatus nvarchar(350) 
	)
	 

	declare @mBillId  bigint
	set @mBillId= (SELECT top 1 BillID FROM   CustomerBillMast order by billid desc)

	IF  exists(SELECT  BillID
					FROM   CustomerBillMast 
					 WHERE   billid >0 ) --CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105))
			Begin

			IF  exists(SELECT  BillID
					FROM   CustomerPaymentDetail 
					 WHERE   billid >0 ) 
					begin
				INSERT INTO	#Temptbl
					SELECT        CustomerMast.CustomerName, CustomerMast.Address, CustomerPaymentDetail.CustomerId, CustomerPaymentDetail.BillID, CustomerPaymentDetail.BalanceDue,CashAmount,
					(Select isnull(sum(CustomerPaymentDetail.BalanceDue),0) from CustomerPaymentDetail where CustomerPaymentDetail.BillID =
								(SELECT DISTINCT TOP (1) BillID
								FROM            CustomerPaymentDetail AS CustomerPaymentDetail_1
								ORDER BY BillID DESC) ) AS TotalDue, AreaMast.Area,
								PaymentStatus =
								CASE    
								 WHEN CashAmount >0 then 'Paid'
								 ELSE 'Not Paid' End 
					
					FROM            CustomerMast  
					Left  JOIN  AreaMast   ON CustomerMast.AreaID = AreaMast.AreaID
					LEFT  Join CustomerPaymentDetail   On CustomerPaymentDetail.CustomerId =CustomerMast.CustomerID
						WHERE   
						(CustomerPaymentDetail.BillID =
								(SELECT DISTINCT TOP (1) BillID
								FROM            CustomerPaymentDetail AS CustomerPaymentDetail_1
								ORDER BY BillID DESC)) -- AND (CustomerPaymentDetail.BalanceDue <> 0) 
								and CustomerMast.SalesPersonID =@UserId


					  INSERT INTO	#Temptbl
						SELECT   distinct     CustomerMast.CustomerName, CustomerMast.Address, CustomerMast.CustomerID, 0 AS BillID, 0 AS BalanceDue, 0 AS CashAmount, 0 AS TotalDue, AreaMast.Area, 'No Order' AS PaymentStatus
						FROM            CustomerMast LEFT OUTER JOIN
												 AreaMast ON AreaMast.AreaID = CustomerMast.AreaID RIGHT OUTER JOIN
												 CustomerBillDetails ON CustomerMast.CustomerID = CustomerBillDetails.CustomerId
						WHERE        (CustomerMast.SalesPersonID = @UserId) AND (CustomerBillDetails.BillID = @mBillId)	AND ( CustomerMast.CustomerID not in (Select customerid from #Temptbl ))-- where billid = @mBillId))

						select  * from #Temptbl
				End
				Else
				Begin
				
			SELECT        CustomerMast.CustomerName, CustomerMast.Address, CustomerMast.CustomerId, 0  as BillID,0 as BalanceDue, 0 CashAmount,
					(0 ) AS TotalDue, AreaMast.Area,
								'No Order' PaymentStatus
		
		         From CustomerMast inner join AreaMast on AreaMast.AreaId = CustomerMast.areaId 
                 Where  CustomerMast.SalesPersonID =@UserId Order by CustomerMast.CustomerID asc
				End
			END
			Else
			Begin
			
			SELECT        CustomerMast.CustomerName, CustomerMast.Address, CustomerMast.CustomerId, 0  as BillID,0 as BalanceDue, 0 CashAmount,
					(0 ) AS TotalDue, AreaMast.Area,
								'No Order' PaymentStatus
		
		From CustomerMast inner join AreaMast on AreaMast.AreaId = CustomerMast.areaId
											
Where  CustomerMast.SalesPersonID =@UserId Order by CustomerMast.CustomerID asc

			END


END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerListToCopyRate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerListToCopyRate] 
 
AS
BEGIN
 
	SET NOCOUNT ON;

	SELECT  DISTINCT     CustomerRates.CustomerID,  CustomerMast.CustomerName
	FROM    CustomerRates LEFT OUTER JOIN
			CustomerMast ON CustomerRates.CustomerID = CustomerMast.CustomerID
	Where	Enddate ='9999-01-01'  

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerOrderDetails_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinod Sabade
-- Create date: <Create Date,,>
-- This sp will get order details of a customer for mobile app
 -- uspGetCustomerOrderDetails_MobileApp 2,'2019-03-15'
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerOrderDetails_MobileApp]
@CustomerId int,
--@BillID int,
 @BillDate datetime

 
AS
BEGIN
 
-- Declare @BillDate datetime

--Set  @BillDate = (Select Billdate from CustomerBillMast where billid = @BillID) 


Declare @mDayNo int =DATEPART(dd,@BillDate)
Declare @mMonthNo int =DATEPART(mm,@BillDate)
Declare @mYear int =DATEPART(yyyy,@BillDate)

	Declare @BillID int
	Set  @BillID = (Select BillID from CustomerBillMast where  

		   	 (CONVERT(varchar(10), DATEPART(Day,  BillDate)) = @mDayNo) 
	 and (CONVERT(varchar(10), DATEPART(month,  BillDate)) = @mMonthNo) 
	 AND (CONVERT(varchar(10), DATEPART(year,  BillDate)) = @mYear)  )


	   
	SET NOCOUNT ON;

	 		IF  exists(SELECT  BillID
					FROM   CustomerBillMast 
					 WHERE   billid = @BillID ) --CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105))
			Begin
	
					SELECT   CustomerBillDetails.BillDtlsID, CustomerBillDetails.BillID, CustomerBillDetails.CustomerId, ProductMast.ProductID, 
							isnull(CustomerBillDetails.Quantity,0)Quantity, CustomerBillDetails.Amount, ProductMast.Product, 
							 isnull(CustomerRates.Rate,0) as Rate 
							,
							Total=(Select sum(Amount)  from CustomerBillDetails CBD inner join CustomerRates CR on CBD.CustomerId = CR.CustomerId 
							and CBD.ProductID = CR.ProductID 
							WHERE   (CustomerBillDetails.CustomerId = @CustomerId) AND (CustomerBillDetails.BillID = @BillID)) 
							, PreviousBalance
							= isnull((Select top 1 PreviousBalance from CustomerPaymentDetail
							WHERE        (CustomerPaymentDetail.CustomerId = @CustomerId) AND (CustomerPaymentDetail.BillID = @BillID)),0)	
							, CashAmount =isnull((Select top 1 CashAmount from CustomerPaymentDetail
							WHERE        (CustomerPaymentDetail.CustomerId = @CustomerId) AND (CustomerPaymentDetail.BillID = @BillID)),0)
							,ChequeAmount		=		isnull((Select top 1 ChequeAmount from CustomerPaymentDetail
							WHERE        (CustomerPaymentDetail.CustomerId = @CustomerId) AND (CustomerPaymentDetail.BillID = @BillID)),0)
							,BalanceDue = isnull((Select top 1 BalanceDue from CustomerPaymentDetail
							WHERE        (CustomerPaymentDetail.CustomerId = @CustomerId) AND (CustomerPaymentDetail.BillID = @BillID)),0)				
							,	 Lickage = isnull((select Likage from CustomerLikages where CustomerID = @CustomerId and BillId = @BillID ),0)
					FROM    CustomerBillDetails left outer JOIN
									 ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID left outer JOIN
									 CustomerRates ON CustomerBillDetails.ProductID = CustomerRates.ProductID AND CustomerBillDetails.CustomerId = CustomerRates.CustomerID
					Where CustomerBillDetails.BillID = @BillID and  CustomerBillDetails.CustomerId=@CustomerId  and  CustomerRates.EndDate ='9999-01-01'
					--and  @BillDate between CustomerRates.StartDate  and CustomerRates.EndDate  
			End
	Else
			Begin
			Select 'No Orders Found' as Messsage

			END


END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerOrderDetailsByDate_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinod Sabade
-- Create date: <Create Date,,>
-- This sp will get order details of a customer for mobile app
 -- uspGetCustomerOrderDetailsByDate_MobileApp 1,'2017-05-10'
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerOrderDetailsByDate_MobileApp]
@CustomerId int,
@BillDate Datetime

 
AS
BEGIN
 
 Declare @BillID datetime

Set  @BillID = (Select BillID from CustomerBillMast where BillDate = @BillDate) 


	SET NOCOUNT ON;
	
		SELECT  CustomerBillDetails.BillDtlsID, CustomerBillDetails.BillID, CustomerBillDetails.CustomerId, CustomerBillDetails.ProductID, 
				CustomerBillDetails.Quantity, CustomerBillDetails.Amount, ProductMast.Product, 
				CustomerRates.Rate
				,
				Total=(Select sum(Amount)  from CustomerBillDetails 
				WHERE   (CustomerBillDetails.CustomerId = @CustomerId) AND (CustomerBillDetails.BillID = @BillID)) 
				, PreviousBalance
				= (Select top 1 PreviousBalance from CustomerPaymentDetail
				WHERE        (CustomerPaymentDetail.CustomerId = @CustomerId) AND (CustomerPaymentDetail.BillID = @BillID))	
					, CashAmount =(Select top 1 CashAmount from CustomerPaymentDetail
				WHERE        (CustomerPaymentDetail.CustomerId = @CustomerId) AND (CustomerPaymentDetail.BillID = @BillID))
				,ChequeAmount		=		(Select top 1 ChequeAmount from CustomerPaymentDetail
				WHERE        (CustomerPaymentDetail.CustomerId = @CustomerId) AND (CustomerPaymentDetail.BillID = @BillID))
				,BalanceDue = (Select top 1 BalanceDue from CustomerPaymentDetail
				WHERE        (CustomerPaymentDetail.CustomerId = @CustomerId) AND (CustomerPaymentDetail.BillID = @BillID))	
				,	 Lickage = isnull((select Likage from CustomerLikages where CustomerID = @CustomerId and BillId = @BillID ),0)

		FROM    CustomerBillDetails LEFT OUTER JOIN
                         ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID LEFT OUTER JOIN
                         CustomerRates ON CustomerBillDetails.ProductID = CustomerRates.ProductID AND CustomerBillDetails.CustomerId = CustomerRates.CustomerID
		Where CustomerBillDetails.BillID = @BillID and  CustomerBillDetails.CustomerId=@CustomerId and  CustomerRates.EndDate ='9999-01-01'
		-- @BillDate between CustomerRates.StartDate  and CustomerRates.EndDate  
	



END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerOrderList]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetCustomerOrderList
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerOrderList] 
 
AS
BEGIN
 
	SET NOCOUNT ON;

 
 Select BillID, convert(varchar(10),BillDate,103)BillDate, TotalQty, TotalAmount, 
 convert(varchar(10),LastUpdatedDate,103) LastUpdatedDate ,(  datename(month,BillDate )  +' '+ convert(varchar(10),Datepart(year,BillDate)) )OrderMonth
 ,DATEPART(m,BillDate) as MonthNo
 from [dbo].[CustomerBillMast] order by BillID desc

END





GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerOutstanding]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerOutstanding]  -- [uspGetCustomerOutstanding]  1,2
@CustomerID int,
--@BillDate datetime
@Billid int

AS
BEGIN

	SET NOCOUNT ON;

	IF  exists(SELECT  0 
					FROM   CustomerPaymentDetail 
					WHERE  Billid =@Billid and  CustomerID = @CustomerID)
	                
			  BEGIN 
				  SELECT CustomerID, 
						 Isnull(previousbalance, 0) PreviousBalance, 
						 Isnull(CashAmount, 0)      AS CashAmount 
				  FROM   CustomerPaymentDetail 
				  WHERE  CustomerID = @CustomerID  and Billid =@Billid
			  END 

	ELSE


			  
			Begin 
					SELECT top 1 customerid, Isnull(BalanceDue, 0) PreviousBalance ,0 AS CashAmount 
					FROM   CustomerPaymentDetail 
					WHERE  CustomerId =@CustomerID 				 and Billid  not in			 
					( SELECT TOP (1) BillID FROM   CustomerPaymentDetail  where Billid = @Billid ORDER  BY BillID DESC)
					ORDER  BY BillID DESC
			End
	END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerOutstandingForNewOrder]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerOutstandingForNewOrder] 
--uspGetCustomerOutstandingForNewOrder 1
@CustomerID int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		SELECT  CustomerMast.CustomerID,ISNULL( 
				CustomerPaymentDetail.BalanceDue, 0) AS PreviousBalance,

				--ISNULL(CustomerPaymentDetail.CashAmount, 0)
				0 AS CashAmount
				
		FROM	CustomerMast 
				LEFT OUTER JOIN CustomerPayment 
				ON CustomerMast.CustomerID = CustomerPayment.CustomerId 
				LEFT OUTER JOIN CustomerPaymentDetail 
				ON CustomerMast.CustomerID = 
				CustomerPaymentDetail.CustomerId 
				
		WHERE  
				CustomerMast.CustomerID=@CustomerID 
				 and 
						 
( CustomerPaymentDetail.BillID = (SELECT TOP (1) BillID FROM   CustomerPaymentDetail ORDER  BY BillID DESC) ) 
END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerPaymentDetailsByCustomerID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetCustomerPaymentDetailsByCustomerID 2
-- =============================================
CREATE PROCEDURE [dbo].[uspGetCustomerPaymentDetailsByCustomerID] 
@Customerid Int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT   ROW_NUMBER() OVER(ORDER BY CustomerPaymentDetail.BillID ) AS 'Sr|No', CustomerMast.CustomerName,  CustomerPaymentDetail.BillID, CustomerPaymentDetail.BillDate, CustomerPaymentDetail.BillAmount, isnull(CustomerPaymentDetail.PreviousBalance,0) as 'Balance C/F', 
CustomerPaymentDetail.BillAmount+ isnull(CustomerPaymentDetail.PreviousBalance,0) as TotalDueAmont, 
 CustomerPaymentDetail.CashAmount as PaidAmount, (isnull(CustomerPaymentDetail.BillAmount,0)+ isnull(CustomerPaymentDetail.PreviousBalance,0))-isnull(CustomerPaymentDetail.CashAmount,0) as DayBalance,  CustomerPaymentDetail.BalanceDue,  CustomerPaymentDetail.PaymentDate
FROM         CustomerPaymentDetail INNER JOIN
                      CustomerMast ON CustomerPaymentDetail.CustomerId = CustomerMast.CustomerID
WHERE     (CustomerPaymentDetail.CustomerId =  @Customerid ) 
	
END




GO
/****** Object:  StoredProcedure [dbo].[uspGetCustomerRate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --uspGetCustomerRate '8237175481'
 
 CREATE Proc [dbo].[uspGetCustomerRate]
 @pMobileNo Nvarchar(12)
 AS
 BEGIN

 Declare @pDBName Nvarchar(100),@sSql  Nvarchar(max) ,@pMobileCurrentDB Nvarchar(12)
   

	select   @pDBName=DbName   from mDistributor.dbo.Tenants  where  Mobile=@pMobileNo
	select   @pMobileCurrentDB=Mobile   from mDistributor.dbo.Tenants  where  dbname=DB_Name()
		    
	SET @sSql = 'select R.CustRateID,R.Customerid,P.ProductID,Product,Rate,CrateSize from  '+RTRIM(@pDBName)+'.dbo.CustomerRates  R INNER JOIN '+RTRIM(@pDBName)+'.dbo.ProductMast P ON P.ProductID=R.ProductID 
	Inner Join '+RTRIM(@pDBName)+'.dbo.CustomerMast M On M.CustomerID=R.CustomerID  where Mobile = '''+@pMobileCurrentDB+''''
	 
      Print(@sSql)
	 EXEC(@sSql)
END
	-- select   DbName  from mDistributor.dbo.Tenants  where  Mobile='9765656256'

GO
/****** Object:  StoredProcedure [dbo].[uspGetDailyCollectionReportAreaWise]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetDailyCollectionReportAreaWise 2
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDailyCollectionReportAreaWise] 
--@AreaID int,
--@BillDate varchar(10)
@BillId int 

AS
BEGIN

	SET NOCOUNT ON;
--Declare @BillId int 

--select @BillId = billid from CustomerBillMast where convert(varchar(10),BillDate,101) = @BillDate

 
--	SELECT	ROW_NUMBER() over (ORDER BY CustomerMast.CustomerID) AS Number,CustomerMast.CustomerID, CustomerMast.CustomerName, AreaMast.Area, 
--			sum(CustomerBillDetails.Quantity) Quantity , sum(CustomerBillDetails.Amount) Amount,sum(PreviousBalance) as PreviousBalance,
--			(SELECT SUM(CustomerBillDetails.Amount) 
--	FROM    CustomerMast INNER JOIN
--			AreaMast ON CustomerMast.AreaID = AreaMast.AreaID INNER JOIN
--			CustomerBillDetails ON CustomerMast.CustomerID = CustomerBillDetails.CustomerId
--	WHERE    CustomerBillDetails.BillID=1 ) AS AreaTotalAmount
--	FROM    CustomerMast INNER JOIN
--			AreaMast ON CustomerMast.AreaID = AreaMast.AreaID INNER JOIN
--			CustomerPaymentDetail ON CustomerMast.CustomerID = CustomerPaymentDetail.CustomerId INNER JOIN
--			CustomerBillDetails ON CustomerMast.CustomerID = CustomerBillDetails.CustomerId
--	Where	  CustomerBillDetails.BillID=1
--	Group by CustomerMast.CustomerID, CustomerMast.CustomerName, AreaMast.Area  
	
	
	
--	SELECT     ROW_NUMBER() over (ORDER BY CustomerMast.CustomerID) AS Number,  CustomerMast.CustomerName,  
--	convert(varchar(10),P.BillDate,103) OrderDate, 
--P.CustomerId,P.BillAmount, P.PreviousBalance, (P.BillAmount+P.PreviousBalance) AS Total,P.CashAmount,  
--                         P.BalanceDue,CQty.Qty as Quantity
--FROM            CustomerPaymentDetail P INNER JOIN
--                         CustomerMast ON P.CustomerId = CustomerMast.CustomerID 
--cross apply (
--    select top 1 sum(Quantity) as Qty from CustomerBillDetails  where
--  CustomerBillDetails.CustomerId =p.CustomerId and p.BillID=1   group by BillID, CustomerId
   
--) CQty  

--- updated By Vinod on 01 March 2017
		--SELECT     ROW_NUMBER() over (ORDER BY CustomerMast.CustomerID) AS Number,   CustomerMast.CustomerName, 
		--convert(varchar(10),CustomerPaymentDetail.BillDate,103) OrderDate, CustomerPaymentDetail.CustomerId, 
		--CustomerPaymentDetail.BillAmount, CustomerPaymentDetail.PreviousBalance, 
		--						(CustomerPaymentDetail.BillAmount+ CustomerPaymentDetail.PreviousBalance) Amount, 
		--						AreaMast.Area,CQty.Qty as Quantity
		--FROM            CustomerPaymentDetail INNER JOIN
		--						 CustomerMast ON CustomerPaymentDetail.CustomerId = CustomerMast.CustomerID INNER JOIN
		--						 AreaMast ON CustomerMast.AreaID = AreaMast.AreaID
		--cross apply (
		--	select top 1 sum(Quantity) as Qty from CustomerBillDetails  where
		--  CustomerBillDetails.CustomerId =CustomerPaymentDetail.CustomerId and CustomerPaymentDetail.BillID=5   group by BillID, CustomerId
  ---- order by CustomerBillDetails.Billid desc
		--) CQty 

--- updated By Vinod on 09 March 2017
	SELECT  ROW_NUMBER() over (ORDER BY CustomerMast.CustomerID) AS Number,   CustomerMast.CustomerName, 
			convert(varchar(10),CustomerPaymentDetail.BillDate,103) OrderDate, CustomerPaymentDetail.CustomerId, 
			CustomerPaymentDetail.BillAmount, CustomerPaymentDetail.PreviousBalance, 
			CustomerPaymentDetail.BillID, CustomerPaymentDetail.BalanceDue as Amount, AreaMast.Area, 
			SUM(CustomerBillDetails.Quantity) AS Quantity
	FROM    CustomerPaymentDetail INNER JOIN
			CustomerMast ON CustomerPaymentDetail.CustomerId = CustomerMast.CustomerID INNER JOIN
			AreaMast ON CustomerMast.AreaID = AreaMast.AreaID INNER JOIN
			CustomerBillDetails ON CustomerMast.CustomerID = CustomerBillDetails.CustomerId AND 
			CustomerPaymentDetail.BillID = CustomerBillDetails.BillID
	GROUP BY CustomerMast.CustomerID,CustomerMast.CustomerName, CustomerPaymentDetail.BillDate, 
			CustomerPaymentDetail.CustomerId,CustomerPaymentDetail.BillAmount, CustomerPaymentDetail.PreviousBalance, 
			CustomerPaymentDetail.BillID, CustomerPaymentDetail.BalanceDue, AreaMast.Area
	HAVING  (CustomerPaymentDetail.BillID =@BillId)

END






GO
/****** Object:  StoredProcedure [dbo].[USPGetDashboardCounts]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 CREATE Proc [dbo].[USPGetDashboardCounts]
 AS
 BEGIN
 
 Declare @PurchaseAmount Bigint, @salesAmount Bigint, @CustomerCount Bigint ,@vendorCount Bigint
 select @salesAmount=sum(TotalAmount)  from customerbillMast 
  select @PurchaseAmount=sum(Amount)  from Purchase  
 
 select @CustomerCount=count(CustomerID)  from customerMast    
 select @vendorCount=count(vendorid)  from VendorMast  
 
 select isnull(@PurchaseAmount , 0) AS PurchaseAmount ,isnull(@salesAmount, 0) as salesAmount ,isnull(@CustomerCount, 0) AS CustomerCount , isnull(@vendorCount, 0)  AS vendorCount  
 END
 
GO
/****** Object:  StoredProcedure [dbo].[uspGetDateWiseCustomerOrderDetails_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinod Sabade
-- Create date: <Create Date,,>
-- This sp will get order details of a customer for mobile app
-- =============================================
Create PROCEDURE [dbo].[uspGetDateWiseCustomerOrderDetails_MobileApp]
@CustomerId int,
@OrderDate datetime

 
AS
BEGIN
 
 Declare @BillID int

 set @BillID = (select Billid from CustomerBillMast Where BillDate =@OrderDate )

	SET NOCOUNT ON;

	SELECT  CustomerBillDetails.BillDtlsID, CustomerBillDetails.BillID, CustomerBillDetails.CustomerId, CustomerBillDetails.ProductID, 
	CustomerBillDetails.Quantity, CustomerBillDetails.Amount, 
			CustomerBillDetails.LastUpdatedDate, ProductMast.Product , (Select sum(Amount)  from CustomerBillDetails 
			WHERE        (CustomerBillDetails.CustomerId = @CustomerId) AND (CustomerBillDetails.BillID = @BillID))as Total,
			(Select sum(PreviousBalance)  from CustomerPaymentDetail
			 WHERE        (CustomerPaymentDetail.CustomerId = @CustomerId) AND (CustomerPaymentDetail.BillID = @BillID)) as  PreviousBalance
	FROM    CustomerBillDetails INNER JOIN
			ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID
	WHERE   (CustomerBillDetails.CustomerId = @CustomerId) AND (CustomerBillDetails.BillID = @BillID)

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetDeliveryDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetDeliveryDetails '2017-02-14',1
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDeliveryDetails] 

@BillDate datetime
,@CustomerId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		DEclare @mBillID int 

	Set @mBillID=(SELECT  BillID FROM   CustomerBillMast 
	WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105))

	IF  exists(SELECT  BillID
					FROM   CustomerBillMast 
					 WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105))
			Begin

		SELECT      ProductMast.Product, CustomerBillDetails.Quantity, CustomerBillDetails.Amount, 
					CustomerBillDetails.BillID, CustomerBillDetails.ProductID
		FROM        CustomerBillDetails INNER JOIN
					ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID
		WHERE       (CustomerBillDetails.BillID =@mBillID) AND (CustomerBillDetails.CustomerId = @CustomerId) 
					--AND (CustomerBillDetails.Quantity > 0) and (CustomerBillDetails.Amount>0)
End
	Else
			Begin
			Select 'No Orders Found' as Messsage

			END

END

GO
/****** Object:  StoredProcedure [dbo].[uspGetDeliveryList_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetDeliveryList_MobileApp  '2017-05-10',14
-- =============================================
CREATE PROCEDURE [dbo].[uspGetDeliveryList_MobileApp] 

@BillDate Datetime,
@UserID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DEclare @mBillID int 

	Set @mBillID=(SELECT  BillID FROM   CustomerBillMast 
	WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@BillDate,105))

	SELECT        CustomerBillDetails.CustomerId, SUM(CustomerBillDetails.Quantity) AS Quantity, SUM(CustomerBillDetails.Amount) AS Amount, CustomerMast.CustomerName, 
							 CustomerMast.Address + ' | ' + CustomerMast.Mobile AS AddressDetails, AreaMast.Area As Route,@mBillID as BillId
	FROM            CustomerBillDetails Left Outer JOIN
							 CustomerMast ON CustomerBillDetails.CustomerId = CustomerMast.CustomerID Left Outer JOIN
							 AreaMast ON CustomerMast.AreaID = AreaMast.AreaID
	WHERE        (CustomerMast.SalesPersonID = @UserID) AND (CustomerBillDetails.BillID =@mBillID)
                            
	GROUP BY CustomerBillDetails.CustomerId, CustomerMast.CustomerName, CustomerMast.Address, CustomerMast.Mobile, AreaMast.Area
	ORDER BY CustomerBillDetails.CustomerID

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetHomeDeliveryDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetHomeDeliveryDetails 1,7,2017
-- =============================================
CREATE PROCEDURE [dbo].[uspGetHomeDeliveryDetails]
@Customerid int
,@mMonthNo int
,@mYear int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--SELECT        SUM(CustomerBillDetails.Quantity) AS Quantity , CustomerBillMast.BillDate AS Date
--FROM            CustomerBillDetails INNER JOIN
--                         CustomerBillMast ON CustomerBillDetails.BillID = CustomerBillMast.BillID
--WHERE        (CustomerBillDetails.CustomerId = @Customerid)
--GROUP BY CustomerBillMast.BillDate

	SELECT ProductID,isnull([1],0) As [1],isnull([2],0) As[2],isnull([3],0) As[3],isnull([4],0) As[4],isnull([5],0) As[5],isnull([6],0) As[6],
	isnull([7],0) As[7],isnull([8],0) As[8],isnull([9],0) As[9],isnull([10],0) As[10],isnull([11],0) As[11],isnull([12],0) As[12],
	isnull([13],0) As[13],isnull([4],0) As[14],isnull([15],0) As[15]
	,isnull([16],0) As[16],isnull([17],0) As[17],isnull([18],0) As[18],isnull([19],0) As[19],isnull([20],0) As[20],isnull([21],0) As[21],
	isnull([22],0) As[22],isnull([23],0) As[23],isnull([24],0) As[24],isnull([25],0) As[25],isnull([26],0) As[26],isnull([27],0) As[27],
	isnull([28],0) As[28],isnull([29],0) As[29],isnull([30],0) As[30],isnull([31],0) As[31]
	FROM (
			  SELECT    CustomerBillDetails.ProductID,    CustomerBillDetails.Quantity , convert(varchar(10),datepart(day,BillDate))  As BillDate
	FROM            CustomerBillDetails INNER JOIN
							 CustomerBillMast ON CustomerBillDetails.BillID = CustomerBillMast.BillID
	WHERE        (CustomerBillDetails.CustomerId = @Customerid) 
				AND CONVERT(varchar(10), DATEPART(month,  CustomerBillMast.BillDate)) =  convert(varchar(2),@mMonthNo)
		AND CONVERT(varchar(10), DATEPART(year, CustomerBillMast.BillDate)) = convert(varchar(5),@mYear) 
	
	) P

				PIVOT ( sum(Quantity) FOR BillDate in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31] ))AS pvt
END




GO
/****** Object:  StoredProcedure [dbo].[uspGetOrderForDate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetOrderForDate '14 Feb 2017'
-- =============================================
CREATE PROCEDURE [dbo].[uspGetOrderForDate]
	-- Add the parameters for the stored procedure here
	  @OrderDate datetime
AS
BEGIN

	SET NOCOUNT ON;

	Declare @mDayNo int =DATEPART(dd,@OrderDate)
	Declare @mMonthNo int =DATEPART(mm,@OrderDate)
	Declare @mYear int =DATEPART(yyyy,@OrderDate)


	Select BillID from dbo.CustomerBillMast
	WHERE 
	(CONVERT(varchar(10), DATEPART(Day, BillDate)) =  convert(varchar(2),@mDayNo))
	and (CONVERT(varchar(10), DATEPART(month,  BillDate)) =  convert(varchar(2),@mMonthNo)) 
	AND (CONVERT(varchar(10), DATEPART(year,  BillDate)) =  convert(varchar(4),@mYear) )

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetProductRateForVendor]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetProductRateForVendor 1,1
-- =============================================
CREATE PROCEDURE [dbo].[uspGetProductRateForVendor] 
@VendorId int,
@ProductId int
AS
BEGIN

	SET NOCOUNT ON;
	
		SELECT     Rate
		FROM         VendorProducts
		Where VendorID=@VendorId and ProductId=@ProductId
 
END





GO
/****** Object:  StoredProcedure [dbo].[uspGetPurchaseForDate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetPurchaseForDate '05-29-2017',1,1
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPurchaseForDate]
	  @OrderDate Datetime,
	  @ProductID int,
	  @VendorId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--select PurchaseId, BillDate, VendorId, ProductID, ProductRate, Quantity, Amount from dbo.Purchase
----where BillDate = @OrderDate
-- WHERE  CONVERT(VARCHAR(10) ,BillDate,105) 	=  CONVERT(VARCHAR(10) ,@OrderDate,105)


--select PurchaseId, BillDate, VendorId, ProductID, ProductRate, Quantity, Amount as BillAmount--,isnull(PaidAmount,0) as PaidAmount,isnull(PreviousBalance,0)PreviousBalance  
--from dbo.Purchase
--SELECT        Purchase.PurchaseId, Purchase.BillDate, Purchase.VendorId, Purchase.ProductID, Purchase.ProductRate, Purchase.Quantity, Purchase.Amount AS BillAmount, ISNULL(CratesVendor.CratesIn, 0) AS CratesIn, 
--                         ISNULL(CratesVendor.CratesOut, 0) AS CratesOut, isnull(SupplierPaymentDetail.ChequeNo,0) AS LickageAmount
----FROM            Purchase Left Outer JOIN
----                         SupplierPaymentDetail ON Purchase.BillId = SupplierPaymentDetail.BillID AND Purchase.VendorId = SupplierPaymentDetail.SupplierId LEFT OUTER JOIN
----                         CratesVendor ON Purchase.BillDate = CratesVendor.OrderDate AND Purchase.VendorId = CratesVendor.VendorID AND Purchase.BillId = CratesVendor.BillId
--FROM            Purchase INNER JOIN
--                         SupplierPaymentDetail ON Purchase.BillId = SupplierPaymentDetail.BillID AND Purchase.VendorId = SupplierPaymentDetail.SupplierId INNER JOIN
--                         CratesVendor ON Purchase.BillId = CratesVendor.BillId AND Purchase.VendorId = CratesVendor.VendorID

SELECT        Purchase.BillId, Purchase.BillDate, Purchase.ProductID, Purchase.Quantity, Purchase.Amount, SupplierPaymentDetail.PreviousBalance, SupplierPaymentDetail.BillAmount, SupplierPaymentDetail.CashAmount, 
                         isnull(SupplierPaymentDetail.ChequeAmount,0) as LickageAmount, SupplierPaymentDetail.BalanceDue, CratesVendor.CratesIn, CratesVendor.CratesOut
FROM            Purchase INNER JOIN
                         SupplierPaymentDetail ON Purchase.BillId = SupplierPaymentDetail.BillID AND Purchase.VendorId = SupplierPaymentDetail.SupplierId INNER JOIN
                         CratesVendor ON Purchase.BillId = CratesVendor.BillId AND Purchase.VendorId = CratesVendor.VendorID
WHERE        (CONVERT(varchar(10), Purchase.BillDate, 105) = CONVERT(varchar(10), @OrderDate, 105)) 
AND (Purchase.ProductID = @ProductID)
 AND (Purchase.VendorId = @VendorId)


 
--SELECT        Purchase.PurchaseId, Purchase.BillDate, Purchase.VendorId, Purchase.ProductID, Purchase.ProductRate, Purchase.Quantity, Purchase.Amount AS BillAmount, ISNULL(SupplierPaymentDetail.PreviousBalance, 0) 
--                         AS PreviousBalance, SupplierPaymentDetail.Amount AS PaidAmount, SupplierPaymentDetail.BalanceDue
--FROM            Purchase LEFT OUTER JOIN
--                         SupplierPaymentDetail ON Purchase.BillId = SupplierPaymentDetail.BillID
--WHERE        (CONVERT(varchar(10), Purchase.BillDate, 105) = CONVERT(varchar(10), @OrderDate, 105)) AND (Purchase.ProductID = @ProductID) AND (Purchase.VendorId = @VendorId)


 
END




GO
/****** Object:  StoredProcedure [dbo].[uspGetPurchaseForDate_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetPurchaseForDate_MobileApp '05-24-2017',6
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPurchaseForDate_MobileApp]
	  @OrderDate Datetime,
	  @VendorId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF  exists(SELECT  BillID FROM   Purchase 
					 WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@OrderDate,105))
			Begin

				SELECT  Purchase.BillId, Purchase.BillDate, Purchase.ProductID, Purchase.Quantity, Purchase.Amount, Purchase.ProductRate,
						isnull(CratesVendor.CratesIn,0)CratesIn, isnull(CratesVendor.CratesOut,0)CratesOut,
						isnull(Purchase.PaidAmount,0)PaidAmount,  isnull(Purchase.PreviousBalance, 0)PreviousBalance,
						isnull(Purchase.BalanceDue,0)BalanceDue,ProductMast.Product, VendorMast.VendorName, VendorMast.VendorID
				FROM    Purchase LEFT OUTER JOIN
						VendorMast ON Purchase.VendorId = VendorMast.VendorID LEFT OUTER JOIN
						CratesVendor ON Purchase.BillId = CratesVendor.BillId AND Purchase.VendorId = CratesVendor.VendorID LEFT OUTER JOIN
						ProductMast ON Purchase.ProductID = ProductMast.ProductID
				WHERE	(CONVERT(varchar(10), Purchase.BillDate, 105) = CONVERT(varchar(10), @OrderDate, 105))
						AND (Purchase.VendorId = @VendorId)
			End

		Else
			Begin
			
				declare @mBillId int 
				set @mBillId = (Select  isnull(max(BillID),0)+1   from Purchase)


				--INSERT INTO [dbo].[Purchase]
				--([BillId],[BillDate],[VendorId],[ProductID],[ProductRate],[Quantity],[PaidAmount])
				

				--SELECT  @mBillId, @OrderDate,  VendorMast.VendorID, ProductMast.ProductID, VendorProducts.Rate ,
				--		0 as Quantity, 0 AS PaidAmount
				--FROM    VendorProducts INNER JOIN
				--		VendorMast ON VendorProducts.VendorID = VendorMast.VendorID INNER JOIN
				--		ProductMast ON VendorProducts.ProductId = ProductMast.ProductID
				--Order By VendorMast.VendorID



				SELECT  @mBillId as BillId,VendorMast.VendorID, VendorMast.VendorName,  ProductMast.Product,
						0 as Amount, 0 as CratesIn,0 as CratesOut
				FROM    VendorProducts INNER JOIN
						VendorMast ON VendorProducts.VendorID = VendorMast.VendorID INNER JOIN
						ProductMast ON VendorProducts.ProductId = ProductMast.ProductID

				Where VendorMast.VendorID =@VendorId

			End


END




GO
/****** Object:  StoredProcedure [dbo].[uspGetPurchaseForDateforSales]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetPurchaseForDateforSales '05-31-2016'
-- =============================================
CREATE PROCEDURE [dbo].[uspGetPurchaseForDateforSales]
 @BillDate datetime
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

--declare @BillDate datetime
--set @BillDate ='06-01-2016'

SELECT     Purchase.BillDate, Purchase.ProductID, Purchase.ProductRate, Purchase.Quantity*-1 as Quantity, Purchase.Amount, ProductMast.Product
FROM         Purchase INNER JOIN
                      ProductMast ON Purchase.ProductID = ProductMast.ProductID
WHERE     (CONVERT(Varchar(10), Purchase.BillDate, 105) = CONVERT(Varchar(10), @BillDate, 105))
Order by ProductBrandID asc

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetRepeatOrderForDate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetRepeatOrderForDate
-- =============================================
Create PROCEDURE [dbo].[uspGetRepeatOrderForDate]
	-- Add the parameters for the stored procedure here
	  @OrderDate datetime
AS
BEGIN

	SET NOCOUNT ON;

	set @OrderDate = dateadd(dd,-1,@OrderDate)
	Declare @mDayNo int =DATEPART(dd,@OrderDate)
	Declare @mMonthNo int =DATEPART(mm,@OrderDate)
	Declare @mYear int =DATEPART(yyyy,@OrderDate)


	Select BillID from dbo.CustomerBillMast
	WHERE 
	(CONVERT(varchar(10), DATEPART(Day, BillDate)) =  convert(varchar(2),@mDayNo)) 
	and (CONVERT(varchar(10), DATEPART(month,  BillDate)) =  convert(varchar(2),@mMonthNo)) 
	AND (CONVERT(varchar(10), DATEPART(year,  BillDate)) =  convert(varchar(4),@mYear) )

END



GO
/****** Object:  StoredProcedure [dbo].[uspGetSupplierLickage]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinoad Sabbade	
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetSupplierLickage 1,1,9
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSupplierLickage]
@BillId Datetime  ,
@SupplierId int,
@ProductId int
AS
BEGIN
 
	SET NOCOUNT ON;

	select  isnull(Likage,0) as Lickage, BillId, BillDate, VendorID, ProductID from VendorLikages
	where Billid = @BillId and VendorID=@SupplierId and ProductID=@ProductId
 
END




GO
/****** Object:  StoredProcedure [dbo].[uspGetSupplierOutstanding]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspGetSupplierOutstanding  1,4
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSupplierOutstanding]  
@SupplierId int,
@BillID int

AS
BEGIN

	SET NOCOUNT ON;

	declare @SuppId int
	Declare @PreviousBalance decimal(9,2)
	Declare @CashAmount decimal(9,2)

	SELECT top 1 @SuppId = SupplierId, @PreviousBalance=Isnull(BalanceDue, 0) 
	FROM   SupplierPaymentDetail 
	WHERE  SupplierId =@SupplierId  				 and Billid  <@Billid
	ORDER  BY BillID desc

	SELECT @CashAmount = Isnull(CashAmount,0)
	FROM   SupplierPaymentDetail 
	WHERE  SupplierId =@SupplierId  				 and Billid  = @Billid
	ORDER  BY BillID desc

	Select @SuppId SupplierId ,isnull(@PreviousBalance,0) PreviousBalance , Isnull(@CashAmount,0) CashAmount

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetSupplierPaymentDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspGetSupplierPaymentDetails]

AS
BEGIN
	
	SET NOCOUNT ON;

SELECT    SupplierPaymentDetail.SupplierPaymentDetailID, VendorMast.VendorName, SupplierPaymentDetail.SupplierId, isnull(SupplierPaymentDetail.PreviousBalance,0)PreviousBalance, 
          SupplierPaymentDetail.BillID, SupplierPaymentDetail.BillDate, isnull(SupplierPaymentDetail.BillAmount,0)BillAmount, SupplierPaymentDetail.PaymentDate, 
          SupplierPaymentDetail.PaymentMode, isnull(SupplierPaymentDetail.CashAmount,0)CashAmount, 
          isnull(SupplierPaymentDetail.ChequeAmount,0)ChequeAmount, SupplierPaymentDetail.ChequeNo, 
          isnull(SupplierPaymentDetail.BalanceDue,0)TotalDue, ISNULL(SupplierPaymentDetail.BalanceDue,0)BalanceDue
FROM      SupplierPaymentDetail INNER JOIN
          VendorMast ON SupplierPaymentDetail.SupplierId = VendorMast.VendorID
	WHERE  ( SupplierPaymentDetail.BillDate = (SELECT TOP (1) BillDate FROM   SupplierPaymentDetail ORDER  BY BillDate DESC) ) 

END




GO
/****** Object:  StoredProcedure [dbo].[uspGetVendorOutstanding]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- [uspGetVendorOutstanding]  1,'06/01/2016'
-- =============================================
CREATE PROCEDURE [dbo].[uspGetVendorOutstanding] 
@SupplierId int,
@BillDate datetime

AS
BEGIN

	SET NOCOUNT ON;

	IF not exists(SELECT  0 
					FROM   SupplierPaymentDetail 
					WHERE  CONVERT(VARCHAR(10), BillDate, 105)=convert(varchar(10),@BillDate,105) and  SupplierId = @SupplierId)
	                

			Begin 
					SELECT top 1 SupplierId, Isnull(BalanceDue, 0) PreviousBalance ,0 AS CashAmount 
					FROM   SupplierPaymentDetail 
					WHERE  SupplierId = @SupplierId
					order by BillDate desc 
			End

	ELSE
			  BEGIN 
				  SELECT SupplierId, 
						 Isnull(previousbalance, 0) PreviousBalance, 
						 Isnull(CashAmount, 0)      AS CashAmount 
				  FROM   SupplierPaymentDetail 
				  WHERE  SupplierId = @SupplierId and CONVERT(VARCHAR(10), BillDate, 105)=convert(varchar(10),@BillDate,105)
			  END 

	END




GO
/****** Object:  StoredProcedure [dbo].[uspHomeDeliveryInvoice]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspHomeDeliveryInvoice 1,6,2017
-- =============================================
Create PROCEDURE [dbo].[uspHomeDeliveryInvoice] 
@CustomerId int
,@mMonthNo int
,@mYear int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
--SELECT        CustomerBillDetails.CustomerId, CustomerBillDetails.ProductID, CustomerMast.CustomerName, ProductMast.Product, CustomerRates.Rate, SUM(CustomerBillDetails.Amount) AS Amount, 
--                         SUM(CustomerBillDetails.Quantity) AS TotalQuantity
--FROM            CustomerBillDetails INNER JOIN
--                         ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID INNER JOIN
--                         CustomerMast ON CustomerBillDetails.CustomerId = CustomerMast.CustomerID INNER JOIN
--                         CustomerRates ON ProductMast.ProductID = CustomerRates.ProductID INNER JOIN
--                         CustomerBillMast ON CustomerBillDetails.BillID = CustomerBillMast.BillID
--GROUP BY CustomerBillDetails.CustomerId, CustomerBillDetails.ProductID, CustomerMast.CustomerName, ProductMast.Product, CustomerRates.Rate
--HAVING        (CustomerBillDetails.CustomerId = 1)



			SELECT        SUM(CustomerBillDetails.Quantity) AS TotalQuantity, CustomerMast.CustomerName, ProductMast.Product, CustomerRates.Rate
			, (SUM(CustomerBillDetails.Quantity) *CustomerRates.Rate) AS Amount, CustomerMast.DeliveryCharges
			FROM            CustomerBillDetails INNER JOIN
									 CustomerBillMast ON CustomerBillDetails.BillID = CustomerBillMast.BillID INNER JOIN
									 ProductMast ON CustomerBillDetails.ProductID = ProductMast.ProductID INNER JOIN
									 CustomerMast ON CustomerBillDetails.CustomerId = CustomerMast.CustomerID INNER JOIN
									 CustomerRates ON ProductMast.ProductID = CustomerRates.ProductID
			WHERE        (CustomerBillDetails.CustomerId = @CustomerId) 
			And CONVERT(varchar(10), DATEPART(month,  CustomerBillMast.BillDate)) =  convert(varchar(2),@mMonthNo)
					AND CONVERT(varchar(10), DATEPART(year, CustomerBillMast.BillDate)) = convert(varchar(5),@mYear) 
					AND (CustomerRates.EndDate = '9999-01-01') And CustomerRates.CustomerID =@CustomerId
			GROUP BY CustomerMast.CustomerName, ProductMast.Product, CustomerRates.Rate, CustomerMast.DeliveryCharges

END





GO
/****** Object:  StoredProcedure [dbo].[uspInsertAllCustomersFromLocal]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[uspInsertAllCustomersFromLocal]

	        @CustomerID int 
           ,@CustomerName varchar(50)
           ,@Address varchar(150)
           ,@Mobile varchar(20)
           ,@AreaID int
           ,@SalesPersonID int
           ,@VehicleID int
           ,@CustomerNameEnglish varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT INTO [dbo].[CustomerMast]
           ([CustomerID]
           ,[CustomerName]
           ,[Address]
           ,[Mobile]
           ,[AreaID]
           ,[SalesPersonID]
           ,[VehicleID]
           ,[CustomerNameEnglish])
     VALUES
           (@CustomerID
           ,@CustomerName
           ,@Address
           ,@Mobile
           ,@AreaID
           ,@SalesPersonID
           ,@VehicleID
           ,@CustomerNameEnglish)

END




GO
/****** Object:  StoredProcedure [dbo].[uspInsertAllProductsFromLocal]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertAllProductsFromLocal]
@ProductID int,
@Product varCHar(50),
@ProductBrandID int,
@PurchasePrice decimal(9,0),
@SalePrice  decimal(9,0),
@isActive bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


		IF EXISTS (SELECT 1 FROM ProductMast WHERE ProductID=@ProductID)
		BEGIN
		  UPDATE  [ProductMast]
		  set [Product]=@Product
				,[ProductBrandID]=@ProductBrandID
				,[isActive]=@isActive
				Where ProductID=@ProductID
		END
		ELSE
		BEGIN
		 INSERT INTO [dbo].[ProductMast]
				([Product]
				,[ProductBrandID]
				,[isActive])
			VALUES
				(
				@Product,
				@ProductBrandID,
				@isActive)

		END

	




END




GO
/****** Object:  StoredProcedure [dbo].[uspInsertCustomerLickage]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-- =============================================
-- Author      : Vinod Sabade
-- Create date : 17/02/2017
-- Description : Insert Procedure for CratesCustomer
-- Exec [dbo].[UC_InsertCratesCustomer] [CustomerID],[Date],[CratesIn],[CratesOut],[Balance]
-- ============================================= */
Create PROCEDURE [dbo].[uspInsertCustomerLickage]
     @CustomerID  int
    ,@BillId int
	,@ProductID  int
	,@Likage decimal (18,2)


    
AS
BEGIN

BEGIN TRY


		IF  EXISTS (SELECT 1 FROM   CustomerLikages WHERE  CustomerID  = @CustomerID   AND BillID = @BillID and ProductID = @ProductID) 
		  BEGIN 

		  Update CustomerLikages 
		  Set	 [Likage]=@Likage
				 ,[LastUpdatedDate]=GETDATE()
		  Where  CustomerID  = @CustomerID   AND BillID = @BillID AND ProductID = @ProductID
		  End

		Else

			Begin
				INSERT INTO [dbo].[CustomerLikages]
					([BillId]
					,[CustomerID]
					,[ProductID]
					,[Likage]
					,[LastUpdatedDate]
					)
				VALUES
					(
					 @BillId     
					,@CustomerID  
					,@ProductID  
					,@Likage 
					,GETDATE()
					)
			End
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[uspInsertCustomerPaymentDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinoad Sabbade
-- Create date: <Create Date,,>
-- Description: Update Customer payment and carry forward the balance due amount to next order date
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertCustomerPaymentDetails]

 @CustPaymentID INT 
--,@BillDate DATETIME
,@BillId int
,@BillAmount decimal(18,2)
,@PaymentDate datetime = null
,@PaymentMode int = null
,@CashAmount decimal(18,2) = 0
,@ChequeAmount decimal(18,2) = 0
,@ChequeNo Varchar(15) = 0

AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		BEGIN 
			DECLARE @BillDate DATETIME 

			SELECT @BillDate = BillDate FROM   CustomerBillMast 
			WHERE  BillID = @BillId --and CustomerID = @CustPaymentID 
		END 
			
		IF EXISTS (SELECT 1 FROM   CustomerPaymentDetail WHERE  CustomerId = @CustPaymentID 
				   AND BillID = @BillID) 
		  BEGIN 
			  --Delete from  CustomerPaymentDetail 
			  
			  UPDATE CustomerPaymentDetail 
			  SET    [BillAmount] = @BillAmount,
					 CashAmount = @CashAmount
			  WHERE  CustomerID = @CustPaymentID AND BillID = @BillID 
			  
			  --CONVERT(VARCHAR(10),BillDate,112) = convert(varchar , convert(datetime,@BillDate, 111),112)  
		  END 
		ELSE 
		  BEGIN 
			  INSERT INTO [dbo].[CustomerPaymentDetail] 
						  ([CustomerId],[BillId],[BillDate],[BillAmount],[PaymentDate], 
						   [PaymentMode], 
						   [CashAmount]) 
			  VALUES      ( @CustPaymentID,@BillId,@BillDate,@BillAmount,@PaymentDate, 
							@PaymentMode, 
							@CashAmount) 
		  END 
		
		BEGIN 
			DECLARE @BalDue DECIMAL(18, 2) 
			DECLARE @bDate DATETIME 

			SELECT @bDate = BillDate 
			FROM   CustomerPaymentDetail 
			WHERE  BillDate NOT IN (SELECT TOP (1) CustomerPaymentDetail. BillDate 
									FROM   CustomerPaymentDetail 
										   INNER JOIN CustomerMast ON CustomerPaymentDetail.CustomerId = 
										   CustomerMast.CustomerID 
									WHERE  CustomerPaymentDetail.CustomerId = @CustPaymentID 
									ORDER  BY CustomerPaymentDetail.BillDate DESC) 
				   AND CustomerId = @CustPaymentID 
			ORDER  BY CustomerPaymentDetail.BillDate ASC 

			SELECT @BalDue = BalanceDue FROM   dbo.CustomerPaymentDetail 
			WHERE  CONVERT(date, BillDate, 101) =  CONVERT(Date, @bDate, 101) 
				   AND Customerid = @CustPaymentID 

			--UPDATE CustomerPaymentDetail 
			--SET    PreviousBalance = @BalDue 
			--WHERE  CustomerId = @CustPaymentID AND CONVERT(Date, BillDate, 101) = CONVERT(Date, @BillDate,  101) 
		END 

	END TRY

    BEGIN CATCH
		SELECT 
		ERROR_NUMBER() as ERROR_NUMBER,
		ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[uspInsertEmployee]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertEmployee] 
 
 @EmployeeName nVarchar(100)
,@Address nVarchar(250)
,@AreaID int
,@Mobile nvarchar(10)


AS
BEGIN
if not exists(select MobileNo from users where MobileNo = @Mobile)
begin

 INSERT INTO  mDistributor.dbo.Users  
		( TenantID   
		    ,Name
           , MobileNo
           , UserName
           , Password
           , DeviceID
           , UserTypeID
           , isActive
           , isApproved
           , ApprovedDate
           , isDeleted)
		Values
		(
		(Select Top 1 TenantID FROM mDistributor.dbo.Tenants   where DbName= DB_NAME()),    
		   @EmployeeName,
		     @Mobile
           , DB_NAME() +'_'+@EmployeeName
           , '12345'
           , 0
           , 2
           , 1
           , 1
           , GetDate()
           , 0
		) 

if not exists(select mobile from employeemast where mobile = @Mobile)
begin
Declare  @pUserID BIGINT
SET @pUserID= @@identity
	INSERT INTO [dbo].[EmployeeMast]
		([EmployeeID],
		[EmployeeName]
		,[Address]
		,[AreaID]
		,[Mobile]
		)
	VALUES
		(@pUserID,
		 @EmployeeName 
		,@Address 
		,@AreaID 
		,@Mobile 
		)
		
end

end
	   else
	   begin
	   return 'Not Exist' 
	   end
 
--ALTER TABLE [EmployeeMast] DROP CONSTRAINT PK_EmployeeMast;
--ALTER TABLE [EmployeeMast] ADD CONSTRAINT PK_EmployeeMast PRIMARY KEY ([EmployeeID])



		
END



GO
/****** Object:  StoredProcedure [dbo].[uspInsertPurchaseDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertPurchaseDetails]


 @BillDate datetime
,@VendorId int 
,@ProductID int
,@ProductRate decimal(18,2)
,@Quantity decimal(18,2)
,@PaidAmount  decimal(18,2)
,@BillId int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


 if exists (select 1 from Purchase where [VendorId]=@VendorId and [ProductID]=@ProductID and convert(Varchar(10),[BillDate],105) =convert(Varchar(10),@BillDate,105))
	 Begin 
			UPdate[dbo].[Purchase]
			Set    
			[ProductRate]=@ProductRate
			,[Quantity]=@Quantity
			,[PaidAmount]=@PaidAmount
			,[BalanceDue]=(@ProductRate*@Quantity)-@PaidAmount
			Where [VendorId]=@VendorId and [ProductID]=@ProductID and BillId=@BillId--convert(Varchar(10),[BillDate],105) =convert(Varchar(10),@BillDate,105)
	 End
 Else
 
	 Begin 
		  INSERT INTO [dbo].[Purchase]
				   (
					  [BillId]
					   ,[BillDate]
					   ,[VendorId]
					   ,[ProductID]
					   ,[ProductRate]
					   ,[Quantity]
					   ,[PaidAmount]
					   ,[BalanceDue]
				   )
			 VALUES
					(
						@BillId
						,@BillDate  
						,@VendorId   
						,@ProductID  
						,@ProductRate  
						,@Quantity 
						,@PaidAmount
						, (@ProductRate*@Quantity)-@PaidAmount
					)
				
	 End

End






GO
/****** Object:  StoredProcedure [dbo].[uspInsertPurchaseFromMobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspInsertPurchaseFromMobileApp 10,1,1,100.5,0.5
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertPurchaseFromMobileApp]
     @BillId  int 
	,@VendorId int
	,@ProductID int
	,@PurchaseQty decimal(9,2)
	,@lickageQty decimal (9,2)

AS
BEGIN
 
	SET NOCOUNT ON;

		declare @mBillAmount decimal(9,2)


		UPDATE [dbo].[Purchase]
		Set
				[VendorId]=@VendorId
				,[ProductID]=@ProductID
				,[Quantity]=@PurchaseQty
			
		Where BillId= @BillId and ProductID=@ProductID AND VendorId=@VendorId

		Set @mBillAmount  = (Select Sum(Amount) from Purchase where BillId= @BillId AND VendorId=@VendorId)
		--  
		Begin
			if exists (Select 1 from SupplierPaymentDetail where BillId= @BillId AND SupplierId=@VendorId)
				BEGIN
				
					Update SupplierPaymentDetail 
					Set BillAmount = @mBillAmount
					where BillId= @BillId AND SupplierId=@VendorId

				End

				Else

					Begin

						INSERT INTO [dbo].[SupplierPaymentDetail]
							([SupplierId],[PreviousBalance],[BillID],[BillDate],[BillAmount],[PaymentDate],[PaymentMode],[CashAmount],[ChequeAmount],[ChequeNo],[LastUpdatedDate])
						VALUES
							(@VendorId,0,@BillId,null,@mBillAmount,getdate(),1,0,0,0,getdate())

						Exec uspCalculateSupplierBalances @VendorId

					End

		End



		-- Insert/Update the purchase lickage for the product
		Begin
			if exists (Select 1 from VendorLikages where BillId= @BillId and ProductID=@ProductID AND VendorId=@VendorId)
				BEGIN
					Update VendorLikages Set Likage = @lickageQty  
					where BillId= @BillId and ProductID=@ProductID AND VendorId=@VendorId
				End
			else 
				Begin
					INSERT INTO [VendorLikages]
						([BillId],[BillDate],[VendorID],[ProductID],[Likage],[LastUpdatedDate])
					VALUES
						(@BillId,(Select top 1 BillDate from Purchase  where BillId= @BillId ),@VendorId,@ProductID,@lickageQty,getdate())
				End
		End

		--


 
END



GO
/****** Object:  StoredProcedure [dbo].[uspInsertSupplierPayment]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertSupplierPayment] 
 
 @SupplierId int 
,@BillID int
,@BillDate datetime
,@BillAmount decimal(9,2)
 
AS
BEGIN
 
	SET NOCOUNT ON;

 
INSERT INTO [dbo].[SupplierPaymentDetail]
           ([SupplierId]
           ,[BillID]
           ,[BillDate]
           ,[BillAmount]
			)
     VALUES
           (@SupplierId
           ,@BillID
           ,@BillDate 
           ,@BillAmount
           )
 
 
 
END




GO
/****** Object:  StoredProcedure [dbo].[uspInsertSupplierPaymentDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinoad Sabbade
-- Create date: <Create Date,,>
-- Description: Update Customer payment and carry forward the balance due amount to next order date
-- =============================================
CREATE PROCEDURE [dbo].[uspInsertSupplierPaymentDetails]

 @SupplierId INT 
,@BillDate DATETIME
,@BillId int
--,@BillAmount decimal(18,2)
,@PaymentDate datetime = null
,@PaymentMode int = null
,@CashAmount decimal(18,2)
,@ChequeAmount decimal(18,2) = 0
,@ChequeNo Varchar(15) = 0
--,@PreviousBalance decimal(18,2)


AS
BEGIN
	BEGIN TRY
		SET NOCOUNT ON;
		BEGIN 

		declare @BillAmount decimal(9,2)
		SELECT @BillAmount=SUM(Amount) FROM Purchase
		where VendorId = @SupplierId  and convert(varchar(10),BillDate,121)=Convert(varchar(10),@BillDate,121)
		Group by BillDate ,vendorid
		END 
			
		IF  EXISTS (SELECT 1 FROM   SupplierPaymentDetail WHERE  SupplierId  = @SupplierId 
				  -- AND convert(varchar,BillDate,121)=Convert(varchar,@BillDate,121))--
				  And BillID = @BillID) 
		  BEGIN 
			  --Delete from  SupplierPaymentDetail 
			 UPDATE SupplierPaymentDetail 
			  SET    [BillAmount] = @BillAmount,
					 CashAmount = @CashAmount
			  WHERE  SupplierId  = @SupplierId  --and convert(varchar(10),BillDate,121)=Convert(varchar(10),@BillDate,121)
			  AND BillID = @BillID 

			 exec uspCalculateSupplierBalances  @SupplierId
			  
			  --CONVERT(VARCHAR(10),BillDate,112) = convert(varchar , convert(datetime,@BillDate, 111),112)  
		  END 
		ELSE 
		  BEGIN 
			  

			  INSERT INTO [dbo].[SupplierPaymentDetail] 
						  ([SupplierId],[BillId],[BillDate],[BillAmount],[PaymentDate], 
						   [PaymentMode], 
						   [CashAmount]) 
			  VALUES      ( @SupplierId,@BillId,@BillDate,@BillAmount,@PaymentDate, 
							@PaymentMode, 
							@CashAmount) 
			 
		  END 
		
		BEGIN 
			
			 exec uspCalculateSupplierBalances  @SupplierId
			--UPDATE SupplierPaymentDetail 
			--SET    PreviousBalance = @BalDue 
			--WHERE  CustomerId = @SupplierId AND CONVERT(Date, BillDate, 101) = CONVERT(Date, @BillDate,  101) 
		END 

	END TRY

    BEGIN CATCH
		SELECT 
		ERROR_NUMBER() as ERROR_NUMBER,
		ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END




GO
/****** Object:  StoredProcedure [dbo].[uspInsertVendorCrates]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[uspInsertVendorCrates]
 @VendorID  int
    ,@BillId int
	,@BillDate  datetime
    ,@CratesIn  int
    ,@CratesOut  int


    
AS
BEGIN

BEGIN TRY


		IF  EXISTS (SELECT 1 FROM   CratesVendor WHERE  VendorID  =@VendorID   AND BillID = @BillID) 
		  BEGIN 

		  Update CratesVendor 
		  Set	 [CratesOut] = @CratesOut,
				 [CratesIn]=@CratesIn,
				 [LastUpdatedDate]=@BillDate
		  Where  VendorID  =@VendorID   AND BillID = @BillID
		  End

		Else

			Begin
					INSERT INTO [dbo].[CratesVendor]
					( 
						 [VendorID]
						,[BillId]
						,[OrderDate]
						,[CratesIn]
						,[CratesOut]
						,[LastUpdatedDate]
					)
					VALUES
					(
						@VendorID
						,@BillId
						,@BillDate
						,@CratesIn
						,@CratesOut
						,@BillDate
					)

			End
END TRY

    BEGIN CATCH
    SELECT 
    ERROR_NUMBER() as ERROR_NUMBER,
    ERROR_MESSAGE() as ERROR_MESSAGE;
    END CATCH;

END



GO
/****** Object:  StoredProcedure [dbo].[uspLickageReportSupplier]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--- Execute uspLickageReportSupplier 2,3,2017

CREATE Procedure [dbo].[uspLickageReportSupplier]
@VendorId int,
@mMonthNo int,
@mYear int  

as
Begin

	DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
	DECLARE @vSQLText nvarchar(max)

	Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P
	inner join (Select Productid from VendorProducts where VendorID=@VendorId Group by Productid) CP on (CP.ProductID=P.ProductID)

	Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P
	inner join (Select Productid from VendorProducts where VendorID=@VendorId Group by Productid) CP on (CP.ProductID=P.ProductID)
	set @vSQLText=
		'

	Select   BillDate,' + @vProductCol +
		'From
			(Select 
			convert (Varchar(10),Convert(date,B.BillDate),105) BillDate,P.Product,''-''+ convert(Varchar,Sum(B.Likage)) as Quantity 
			from [dbo].[VendorLikages] B 
			inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
			-- INNER JOIN [dbo].[CustomerLikages] CO ON B.BillID = CO.BillID

			Where 
		VendorID='+Convert(varchar(10),@VendorId)+'

			 and (CONVERT(varchar(10), DATEPART(month,  B.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
			 AND (CONVERT(varchar(10), DATEPART(year,  B.BillDate)) = '+ convert(varchar(4),@mYear) + ')
			Group by P.Product,Convert(date,B.BillDate)
		) P
		pivot
		( 
		Max(Quantity) 
	
		for [Product] in (' + @vProductList + ') ) pvt
		Group by BillDate
		'

	print @vSQLText

	exec (@vSQLText)
End





GO
/****** Object:  StoredProcedure [dbo].[uspLoadCustomerPaymentDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspLoadCustomerPaymentDetails 5
-- =============================================
CREATE PROCEDURE  [dbo].[uspLoadCustomerPaymentDetails]
@AreaID int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	If @AreaID>0
	Begin

			SELECT CustomerMast.CustomerID,CustomerMast.CustomerName,AreaMast.Area,ISNULL( 
				   CustomerPaymentDetail.PreviousBalance, 0) AS OpeningBalance,ISNULL( 
				   CustomerPaymentDetail.BillAmount, 0) AS BillAmount, 
				   ISNULL(ISNULL(CustomerPaymentDetail.PreviousBalance, 0) 
				   + ISNULL(CustomerPaymentDetail.BillAmount, 0), 0) AS TotalDue, 
				   ISNULL(CustomerPaymentDetail.CashAmount, 0) AS CashAmount,ISNULL( 
				   CustomerPaymentDetail.ChequeAmount, 0) AS ChqAmount, 
				   CustomerPaymentDetail.ChequeNo AS chqNo, 
					ISNULL(ISNULL(ISNULL(CustomerPaymentDetail.PreviousBalance, 0) + ISNULL(CustomerPaymentDetail.BillAmount, 0), 0) - 
					ISNULL(ISNULL(CustomerPaymentDetail.CashAmount, 0) + ISNULL(CustomerPaymentDetail.ChequeAmount, 
					0), 0), 0) AS BalanceDue,CustomerPaymentDetail.BillDate, 
				   CustomerPaymentDetail.BillID 
			FROM   CustomerMast 
				   LEFT OUTER JOIN AreaMast 
								ON CustomerMast.AreaID = AreaMast.AreaID 
				   LEFT OUTER JOIN CustomerPayment 
								ON CustomerMast.CustomerID = CustomerPayment.CustomerId 
				   LEFT OUTER JOIN CustomerPaymentDetail 
								ON CustomerMast.CustomerID = 
								   CustomerPaymentDetail.CustomerId 
			WHERE  ( CustomerPaymentDetail.BillID = (SELECT TOP (1) BillID FROM   CustomerPaymentDetail ORDER  BY BillID DESC) ) 
			And CustomerMast.AreaID=@AreaID
		End
	ELSE
		Begin
		
			SELECT CustomerMast.CustomerID,CustomerMast.CustomerName,AreaMast.Area,ISNULL( 
				   CustomerPaymentDetail.PreviousBalance, 0) AS OpeningBalance,ISNULL( 
				   CustomerPaymentDetail.BillAmount, 0) AS BillAmount, 
				   ISNULL(ISNULL(CustomerPaymentDetail.PreviousBalance, 0) 
				   + ISNULL(CustomerPaymentDetail.BillAmount, 0), 0) AS TotalDue, 
				   ISNULL(CustomerPaymentDetail.CashAmount, 0) AS CashAmount,ISNULL( 
				   CustomerPaymentDetail.ChequeAmount, 0) AS ChqAmount, 
				   CustomerPaymentDetail.ChequeNo AS chqNo, 
					ISNULL(ISNULL(ISNULL(CustomerPaymentDetail.PreviousBalance, 0) + ISNULL(CustomerPaymentDetail.BillAmount, 0), 0) - 
					ISNULL(ISNULL(CustomerPaymentDetail.CashAmount, 0) + ISNULL(CustomerPaymentDetail.ChequeAmount, 
					0), 0), 0) AS BalanceDue,CustomerPaymentDetail.BillDate, 
				   CustomerPaymentDetail.BillID 
			FROM   CustomerMast 
				   LEFT OUTER JOIN AreaMast 
								ON CustomerMast.AreaID = AreaMast.AreaID 
				   LEFT OUTER JOIN CustomerPayment 
								ON CustomerMast.CustomerID = CustomerPayment.CustomerId 
				   LEFT OUTER JOIN CustomerPaymentDetail 
								ON CustomerMast.CustomerID = 
								   CustomerPaymentDetail.CustomerId 
			WHERE  ( CustomerPaymentDetail.BillID = (SELECT TOP (1) BillID FROM   CustomerPaymentDetail ORDER  BY BillID DESC) ) 
			
		End


END




GO
/****** Object:  StoredProcedure [dbo].[uspManageCrates]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Proc [dbo].[uspManageCrates]
@OrderDate date ='2019-04-10' ,
@CratesIn int ,
@CratesOut int ,
@UserID BIGINT ,
@CustomerID BIGINT 
AS
BEGIN
Declare @OrderDate1 Nvarchar(12) =Cast(@OrderDate as date) 
Declare @BillID Bigint ,@PreBalance   Bigint =0
select @BillID=BillID from CustomerBillMast where BillDate=@OrderDate
  
Set @PreBalance =(Select  Balance  FROM CratesCustomer where Date= (SELECT DATEADD(dd, -1, DATEDIFF(dd, 0, @OrderDate)))   and CustomerID =@CustomerID)
Set @PreBalance =isnull(@PreBalance,0)
IF NOT EXISTS (SELECT * FROM CratesCustomer WHERE BillId=@BillID AND CustomerID =@CustomerID)
		BEGIN
		Insert Into CratesCustomer 
				(BillId
			  , CustomerID
			  , Date
			  , PreBalance
			  , CratesIn
			  , CratesOut
			  , Balance
			  , LastUpdatedDate)
		Values 
		 (      @BillId
			  , @CustomerID
			  , @OrderDate
			  , @PreBalance
			  , @CratesIn
			  , @CratesOut
			  , (@PreBalance -@CratesIn + @CratesOut)
			  , GETDATE())
			  END
	  ELSE
	  BEGIN

		Update CratesCustomer
		SET PreBalance=@PreBalance ,
		CratesIn =@CratesIn ,
		CratesOut= @CratesOut ,
		Balance = (@PreBalance -@CratesIn + @CratesOut)
		WHERE  BillId=@BillID AND CustomerID =@CustomerID
	  END
set @BillId=0


 Declare @TenantID Bigint , @DbName NVARCHAR(200) ,@VendorID Bigint , @sql nvarchar(max)

 select @TenantID=TenantID  From CustomerMast  Where CustomerID=@CustomerID AND isactive = 1 and TenantID IS NOT NULL
 select @DbName=DbName from mDistributor.dbo.tenants Where TenantID=@TenantID

 Create Table #temp (VendorID bigint , PreBalance bigint,  BillID bigint)
 SET @sql =' Insert INTO  #temp (VendorID ,BillID )values( (select  VendorID  from '+@DbName+'.dbo.VendorMast where TenantID  =(select TenantID  from  mDistributor.dbo.tenants Where DBName=DB_Name()) )
   ,(select TOP 1 BillID from '+@DbName+'.dbo.Purchase where BillDate='''+@OrderDate1+''' ))'
  -- print @sql
	 exec (@sql)
	 Set @PreBalance=0
   SET @sql ='
   Update #temp  SET PreBalance =(Select Top 1 BalanceCrates  FROM '+@DbName+'.dbo.CratesVendor where OrderDate= (SELECT DATEADD(dd, -1, DATEDIFF(dd, 0, '''+@OrderDate1+''')))   and VendorID =(select vendorid from #temp))
     '
        
	 exec (@sql)

 SET @sql ='IF NOT EXISTS (SELECT * FROM '+@DbName+'.dbo.CratesVendor WHERE BillId= (select billid from #temp) AND VendorID = (select VendorID from #temp))
		    BEGIN
						   Insert Into vikram.dbo.CratesVendor 
						  (BillId
						  ,VendorID
						  ,OrderDate
						  ,PreBalance
						  ,CratesOut 
						  ,CratesIn 
						  ,LastUpdatedDate) 
				   
						  SELECT BillId
						  ,VendorID
						  ,'''+@OrderDate1+'''
						  ,PreBalance
						  , '+Cast (@CratesIn As Varchar(10))+' 
						  ,'+Cast (@CratesOut As Varchar(10))+' 
						  ,GETDATE()
						  FROM #Temp
				  
				  END
				  ELSE
				  BEGIN  
 
			      UPDATE '+@DbName+'.dbo.CratesVendor
								SET PreBalance=(SELECT PreBalance FROM #TEMP) ,
								CratesIn ='+Cast (@CratesOut As Varchar(10))+'  ,
								CratesOut= '+Cast (@CratesIn As Varchar(10)) +'
					 
								WHERE  BillId=(SELECT BillId FROM #TEMP) AND VendorID =(SELECT VendorID FROM #TEMP) 
				  
				END'

	  
	exec (@sql)
	  END
 
 
GO
/****** Object:  StoredProcedure [dbo].[USPPullSupplierRate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 --drop table  #Temp
 --USPPullSupplierRate '9890044316' ,'7,8'
 CREATE PROC [dbo].[USPPullSupplierRate]
 @pMobileNo  Nvarchar(12),
 @Values Nvarchar(max) 
 AS
 BEGIN
 --Declare @Values VARCHAR(MAX)='1,2',@pMobileNo  Nvarchar(12)='9765656256'
 Declare @pDBName Nvarchar(100),@sSql  Nvarchar(max),@sSql1  Nvarchar(max)   ,@VendorID bigint ,@pMobileCurrentDB Nvarchar(12)
   select   @pMobileCurrentDB=Mobile   from mDistributor.dbo.Tenants  where  dbname=DB_Name()
   CREATE Table #Temp
   (CustRateID BIGINT,Customerid BIGINT, ProductID BIGINT,Product Nvarchar(100),Rate decimal(18,2),CrateSize int,ProductBrandID int )
	select   @pDBName=DbName   from mDistributor.dbo.Tenants  where  Mobile=@pMobileNo
		   
	SET @sSql = 'select R.CustRateID,R.Customerid,P.ProductID,Product,Rate,CrateSize,ProductBrandID from  '+RTRIM(@pDBName)+'.dbo.CustomerRates  R INNER JOIN '+RTRIM(@pDBName)+'.dbo.ProductMast P ON P.ProductID=R.ProductID 
	Inner Join '+RTRIM(@pDBName)+'.dbo.CustomerMast M On M.CustomerID=R.CustomerID  where Mobile = '''+@pMobileCurrentDB+''' AND CustRateID in (select * from mDistributor.dbo.Split('''+@Values+'''))'
	 select * from test.dbo.ProductMast 
      Print(@sSql)
	 Insert Into  #Temp EXEC(@sSql)
	-- select ProductID from #Temp  

	
	set @sSql1= 'insert into ProductMast( 
	   Product 
      ,PurchasePrice
      ,SalePrice
      ,StockCount 
      ,isActive
      ,CrateSize
      ,GST
	  ,ProductBrandID
	   )
	 select   Product 
      ,PurchasePrice
      ,SalePrice
      ,StockCount 
      ,isActive
      ,CrateSize 
      ,GST
	  ,ProductBrandID
	   from '+RTRIM(@pDBName)+'.dbo.ProductMast  where ProductMast.ProductID in (select ProductID from #Temp) AND Product NOT IN (select Product from ProductMast) '
	  print @sSql1
	  EXEC(@sSql1)

	  INSERT INTO ProductMapping 
	   ( 
       CustomerTenantId
      ,SupplierTenantId
      ,CustomerDBNme
      ,SupplierDBName
      ,CustomerProductID
      ,SupplierProductID
	  )
	  select 
	   (select   TenantID   from mDistributor.dbo.Tenants where dbname=DB_Name())
      ,(select   TenantID   from mDistributor.dbo.Tenants where dbname=@pDBName)
      ,DB_Name()
      ,@pDBName
      ,P.ProductID
      ,T.ProductID
	  FROM   ProductMast P INNER JOIN #Temp T ON T.Product=P.Product AND
	  P.Productid NOT IN (SELECT CustomerProductID FROM  ProductMappimg WHERE CustomerDBNme=DB_Name())
	  
	 select @VendorID=VendorID from VendorMast where PersonMobileNo=@pMobileNo
	 INSERT INTO VendorProducts 
	 	select @VendorID as VendorID , P.ProductID,Rate,Getdate() from #Temp T
		INNER Join ProductMast P ON  P.Product =T.Product

		
	  END

GO
/****** Object:  StoredProcedure [dbo].[uspPurchaseDetailsMonthly]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinod Sabade
-- Create date: 11 June 2016
-- Description:	Monthly purchase register for the given month
-- Usage : uspPurchaseDetailsMonthly 5
-- =============================================
CREATE PROCEDURE [dbo].[uspPurchaseDetailsMonthly]
@MonthNo int
	 
AS
BEGIN
 
	SET NOCOUNT ON;

		DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
		DECLARE @vSQLText nvarchar(max)

		Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' 
		from ProductMast P  where   ProductID >0

		Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max([' + Product + ']) as ' + '[' + Product + ']' 
		from ProductMast P where   ProductID >0

		set @vSQLText=

		'SELECT PurcahseDate,' + @vProductCol + '
		FROM (
			SELECT 
			   Purchase.ProductID AS ProductId, convert(varchar(10),BillDate,103) AS PurcahseDate, isnull(Quantity,0) As Quantity, ProductMast.Product as Product
		FROM         Purchase INNER JOIN
							  ProductMast ON Purchase.ProductID = ProductMast.ProductID 
							  Where  Month(BillDate) =5
		)  as s 
		PIVOT
		(
			SUM(Quantity)
			FOR Product IN (' + @vProductList + ') 
		)AS pvt group by PurcahseDate'


		exec (@vSQLText)

END




GO
/****** Object:  StoredProcedure [dbo].[uspPurchaseRegister]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- uspPurchaseRegister 2,2017
CREATE Procedure [dbo].[uspPurchaseRegister]
@mMonthNo int,
@mYear int  
as
Begin
---Execute Rpt_VerdorWiseQtyAmount 10

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' 
from ProductMast P order by ProductBrandID
--inner join (Select Productid from VendorProducts where VendorID=@pVendorID Group by Productid) VP on (VP.ProductID=P.ProductID)

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max([' + Product + ']) as ' + '[' + Product + ']' 
from ProductMast P order by ProductBrandID
--inner join (Select Productid from VendorProducts where VendorID=@pVendorID Group by Productid) VP on (VP.ProductID=P.ProductID)

--Select @vProductList,@vProductCol

set @vSQLText=
'
Select 
VendorAmt.BillDate,
Qty.*,VendorAmt.BillAmount
from
(
(Select 
--Amt.SupplierID,
	Convert(date,Amt.BillDate) BillDate,
	sum(BillAmount) BillAmount

from [dbo].[SupplierPaymentDetail] Amt
where 
	 (CONVERT(varchar(10), DATEPART(month,  Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	AND (CONVERT(varchar(10), DATEPART(year,  Amt.BillDate)) = '+ convert(varchar(5),@mYear) + ')
and Amt.Billdate is NOT NULL
Group by Convert(date,Amt.BillDate)
) VendorAmt
outer Apply
(Select ' + @vProductCol +
'From
(Select 
Convert(date,B.BillDate) BillDate,P.Product,Sum(B.Quantity) as Quantity 
from [dbo].[purchase] B 
inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
inner join [dbo].[VendorMast] C on (C.VendorID=B.VendorID)
where 
(CONVERT(varchar(10), DATEPART(month,  B.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
AND (CONVERT(varchar(10), DATEPART(year,  B.BillDate)) = '+ convert(varchar(5),@mYear) + ')
and Convert(date,B.BillDate)=Convert(date,VendorAmt.BillDate)
 Group by P.Product,Convert(date,B.BillDate)
) P
pivot
( 
Max(Quantity) 
for [Product] in (' + @vProductList + ') ) pvt
Group by BillDate ) Qty
)'

print @vSQLText

exec (@vSQLText)
End




GO
/****** Object:  StoredProcedure [dbo].[uspSelectCustomerForRateUpdate]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSelectCustomerForRateUpdate]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
		SELECT      0 AS SelectCust, CustomerMast.CustomerID, CustomerMast.CustomerName,  CustomerMast.AreaID, CustomerMast.SalesPersonID, CustomerMast.VehicleID, AreaMast.Area, 
					EmployeeMast.EmployeeName, CustomerType.CustomerType
		FROM        CustomerMast  LEFT OUTER JOIN
					CustomerType ON CustomerMast.CustomerTypeId = CustomerType.CustomerTypeId LEFT OUTER JOIN
					EmployeeMast ON CustomerMast.SalesPersonID = EmployeeMast.EmployeeID LEFT OUTER JOIN
					AreaMast ON CustomerMast.AreaID = AreaMast.AreaID

		Order by	CustomerMast.CustomerID asc

END



GO
/****** Object:  StoredProcedure [dbo].[uspSelectCustomerRatesForupload]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinoad Sabbade
-- Create date: 03 mar 2015
-- Description:	Store Procedure For getting Customer Details
-- =============================================

Create PROCEDURE [dbo].[uspSelectCustomerRatesForupload]

AS
BEGIN
	
	SET NOCOUNT ON;

	Declare @SyncDate datetime
	SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='CustomerRates'

	 if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = null)
 		begin
			Select [CustRateID],[CustomerID],[ProductID],[Rate],[StartDate],[EndDate] from CustomerRates
		End
	else
		begin 
			SELECT  [CustRateID],[CustomerID],[ProductID],[Rate],[StartDate],[EndDate] from CustomerRates
			where CONVERT(VARCHAR(10),LastUpdatedDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112)
		end 

END




GO
/****** Object:  StoredProcedure [dbo].[uspSelectCustomersForupload]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinoad Sabbade
-- Create date: 03 mar 2015
-- Description:	Store Procedure For getting Customer Details
-- =============================================

CREATE PROCEDURE [dbo].[uspSelectCustomersForupload]

AS
BEGIN
	
	SET NOCOUNT ON;

	Declare @SyncDate datetime
	SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='CustomerMast'

	 if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = NULL)
 		begin
			SELECT  CustomerID, CustomerName, [Address], AreaID, Mobile, SalesPersonID, VehicleID, CustomerNameEnglish FROM    CustomerMast
		End
	else
		begin 
			SELECT  CustomerID, CustomerName, [Address], AreaID, Mobile, SalesPersonID, VehicleID, CustomerNameEnglish FROM    CustomerMast
			where CONVERT(VARCHAR(10),LastUpdatedDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112)
		end 

END




GO
/****** Object:  StoredProcedure [dbo].[uspSelectEmployeeMastByEmployeeID]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSelectEmployeeMastByEmployeeID]
@EmployeeID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

 Select EmployeeID, EmployeeName, Address, AreaID, Mobile, UserId from EmployeeMast
 Where EmployeeID = @EmployeeID

END




GO
/****** Object:  StoredProcedure [dbo].[uspSelectProductsForupload]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinoad Sabbade
-- Create date: 03 mar 2015
-- Description:	Store Procedure For getting Customer Details
-- =============================================

CREATE PROCEDURE [dbo].[uspSelectProductsForupload]

AS
BEGIN
	
	SET NOCOUNT ON;

	Declare @SyncDate datetime
	SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='ProductMast'

	 if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = null)
 		begin
			SELECT [ProductID],[Product],[ProductBrandID],[PurchasePrice],[SalePrice],[isActive] from [ProductMast]
		End
	else
		begin 
			SELECT [ProductID],[Product],[ProductBrandID],[PurchasePrice],[SalePrice],[isActive] from [ProductMast]
			where CONVERT(VARCHAR(10),LastUpdatedDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112)
		end 

END




GO
/****** Object:  StoredProcedure [dbo].[uspSelectVendorsForupload]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSelectVendorsForupload] 
	 
AS
BEGIN
	 
	SET NOCOUNT ON;
	Declare @SyncDate datetime
	SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='VendorMast'

	 if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = null)
 		begin
			Select VendorID,VendorName,Address,AreaID,CityID,PersonMobileNo,IsActive From [dbo].[VendorMast]
		End
	else
		begin 

			Select VendorID,VendorName,Address,AreaID,CityID,PersonMobileNo,IsActive From [dbo].[VendorMast] where CONVERT(VARCHAR(10),LastUpdatedDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112)
	
		end 
    
END




GO
/****** Object:  StoredProcedure [dbo].[uspSupplierOrderFor_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspSupplierOrderFor_MobileApp 1,'05-26-2017'
-- =============================================
CREATE PROCEDURE [dbo].[uspSupplierOrderFor_MobileApp]
 
 @VendorID int,
 @OrderDate datetime



AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
 
 		IF  exists(SELECT  BillID
					FROM   Purchase 
					 WHERE CONVERT(varchar(10),BillDate,105) = CONVERT(varchar(10),@OrderDate,105))
			Begin
					--SELECT      VendorMast.VendorID, VendorMast.VendorName, VendorMast.Address, Purchase_2.BillId, Convert(Varchar(10), Purchase_2.BillDate,103)BillDate, 
					--			ProductMast.ProductID,ProductMast.Product as ProductName, Purchase_2.Quantity, Lickage= ISNULL
					--			((SELECT VendorLikages. Likage FROM   VendorLikages WHERE        (VendorLikages.VendorID = @VendorID) 
					--			AND (BillId =  (SELECT        TOP (1) BillId  FROM            Purchase
					--			WHERE (VendorId = @VendorID) ORDER BY BillId DESC))), 0) , VendorProducts.Rate
					--FROM        Purchase AS Purchase_2 INNER JOIN
					--			ProductMast ON Purchase_2.ProductID = ProductMast.ProductID INNER JOIN
					--			VendorMast ON Purchase_2.VendorId = VendorMast.VendorID INNER JOIN
					--			VendorProducts ON ProductMast.ProductID = VendorProducts.ProductId
					--WHERE       (VendorMast.VendorID = @VendorID) AND (Purchase_2.BillId = (SELECT  TOP (1) BillId  FROM    Purchase AS Purchase_1
					--			WHERE (VendorId = @VendorID) ORDER BY BillId DESC))

					
				SELECT  Purchase.BillId, Purchase.BillDate, Purchase.ProductID, Purchase.Quantity, Purchase.Amount, Purchase.ProductRate,
						isnull(CratesVendor.CratesIn,0)CratesIn, isnull(CratesVendor.CratesOut,0)CratesOut,
						isnull(Purchase.PaidAmount,0)PaidAmount,  isnull(Purchase.PreviousBalance, 0)PreviousBalance,
						isnull(Purchase.BalanceDue,0)BalanceDue,ProductMast.Product, VendorMast.VendorName, VendorMast.VendorID
						
				FROM    Purchase LEFT OUTER JOIN
						VendorMast ON Purchase.VendorId = VendorMast.VendorID LEFT OUTER JOIN
						CratesVendor ON Purchase.BillId = CratesVendor.BillId AND Purchase.VendorId = CratesVendor.VendorID LEFT OUTER JOIN
						ProductMast ON Purchase.ProductID = ProductMast.ProductID
				WHERE	(CONVERT(varchar(10), Purchase.BillDate, 105) = CONVERT(varchar(10), @OrderDate, 105))
						AND (Purchase.VendorId = @VendorId)
			End

		Else
			Begin
			Select 'No Orders Found' as Messsage

			END

END




GO
/****** Object:  StoredProcedure [dbo].[uspSyncCustomerBillMast]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSyncCustomerBillMast] 
 @BillID int
 ,@BillDate datetime
AS
BEGIN
 
	SET NOCOUNT ON;
 

	 IF EXISTS (SELECT 1 FROM CustomerBillMast where BillID=@BillID)
		BEGIN
		  UPDATE  CustomerBillMast set BillDate=@BillDate where BillID=@BillID
		END
	ELSE
		BEGIN
		  SET IDENTITY_INSERT dbo.CustomerBillMast ON  

			INSERT INTO [dbo].[CustomerBillMast]([BillID],[BillDate])
			VALUES (@BillID,@BillDate)
   
		END




END




GO
/****** Object:  StoredProcedure [dbo].[uspSyncCustomerOrderDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSyncCustomerOrderDetails] 
 @BillID int
 ,@CustomerId int
,@ProductID int
,@Quantity decimal(9,2)
,@Amount decimal (9,2)
AS
BEGIN
 
	SET NOCOUNT ON;
	
	 IF EXISTS (SELECT 1 FROM CustomerBillDetails where BillID=@BillID)
		BEGIN

		  UPDATE  CustomerBillDetails set Quantity=@Quantity 
		  where BillID=@BillID and ProductID=@ProductID and Customerid=@CustomerId

		END
	ELSE
		BEGIN

			INSERT INTO [dbo].[CustomerBillDetails]
					   ([BillID]
					   ,[CustomerId]
					   ,[ProductID]
					   ,[Quantity]
					   ,[Amount]
					   )
			VALUES
					   (@BillID 
					   ,@CustomerId 
					   ,@ProductID 
					   ,@Quantity 
					   ,@Amount 
					  )
		End
 
END




GO
/****** Object:  StoredProcedure [dbo].[uspSyncCustomerPayment]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspSyncCustomerPayment
-- =============================================
CREATE PROCEDURE [dbo].[uspSyncCustomerPayment]
 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		Declare @SyncDate datetime
		SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='CustomerPaymentDetail'

		if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = NULL)
			begin
				SELECT CustPaymentDetailID, CustomerId, PreviousBalance, BillID, BillDate, BillAmount, isnull(PaymentDate,'01-01-1900')PaymentDate, PaymentMode,
				isnull(CashAmount,0)CashAmount, isnull(ChequeAmount,0)ChequeAmount, ChequeNo, isnull(Amount,0) Amount, isnull(BalanceDue,0) BalanceDue FROM    CustomerPaymentDetail
			End
		else
			begin 
				SELECT CustPaymentDetailID, CustomerId, PreviousBalance, BillID, BillDate, BillAmount, isnull(PaymentDate,'01-01-1900')PaymentDate, PaymentMode, 
				isnull(CashAmount,0)CashAmount, isnull(ChequeAmount,0)ChequeAmount, ChequeNo, isnull(Amount,0) Amount, isnull(BalanceDue,0) BalanceDue FROM    CustomerPaymentDetail
				where CONVERT(VARCHAR(10),LastUpdatedDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112)
			end 

END




GO
/****** Object:  StoredProcedure [dbo].[uspSyncCustomerpaymentDetailsToLocal]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSyncCustomerpaymentDetailsToLocal]


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		Declare @SyncDate datetime
	SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='CustomerPaymentDetail'

	 if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = NULL)
 		begin
			select CustPaymentDetailID,CashAmount,ChequeAmount,ChequeNo,PaymentDate,PaymentMode from CustomerPaymentDetail
		End
	else
		begin
			select CustPaymentDetailID,CashAmount,ChequeAmount,ChequeNo,PaymentDate,PaymentMode from CustomerPaymentDetail
			where CONVERT(VARCHAR(10),LastUpdatedDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112)
		end 

END





GO
/****** Object:  StoredProcedure [dbo].[uspSyncCustomerPaymentHeader]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspSyncCustomerPaymentHeader
-- =============================================
CREATE PROCEDURE [dbo].[uspSyncCustomerPaymentHeader]
 
AS
BEGIN
	 
	SET NOCOUNT ON;

		Declare @SyncDate datetime
		SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='CustomerPayment'

		if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = NULL)
			begin
				SELECT CustPaymentID, CustomerId,  isnull(OpBalAsOn,'01/01/2000')OpBalAsOn, OpeningBalance, isnull(BalanceCF,0) as BalanceCF, PaidAmount, UnPaidAmount, BalanceDue, LastPayment, LastPaymentDate FROM    CustomerPayment
			End
		else
			begin 
				SELECT CustPaymentID, CustomerId,  isnull(OpBalAsOn,'01/01/2000')OpBalAsOn, OpeningBalance,  isnull(BalanceCF,0) as BalanceCF, PaidAmount, UnPaidAmount, BalanceDue, 
				LastPayment, LastPaymentDate FROM    CustomerPayment
				where CONVERT(VARCHAR(10),LastUpdatedDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112)
			end 



END




GO
/****** Object:  StoredProcedure [dbo].[uspSyncOrderDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspSyncOrderDetails

-- =============================================
CREATE PROCEDURE [dbo].[uspSyncOrderDetails]


AS
BEGIN

	SET NOCOUNT ON;

		Declare @SyncDate datetime
		SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='CustomerBillDetails'

		if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = NULL)
			begin
				SELECT BillDtlsID, BillID, CustomerId, ProductID, Quantity, Amount, LastUpdatedDate  FROM    [CustomerBillDetails]
			End
		else
			begin 
				SELECT  BillDtlsID, BillID, CustomerId, ProductID, Quantity, Amount, LastUpdatedDate FROM    CustomerBillDetails
				where CONVERT(VARCHAR(10),LastUpdatedDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112) and Amount>0
			end 
END




GO
/****** Object:  StoredProcedure [dbo].[uspSyncOrderHeader]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSyncOrderHeader]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		Declare @SyncDate datetime
		SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='CustomerBillMast'

		if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = NULL)
			begin
				SELECT BillID, BillDate  FROM    CustomerBillMast
			End
		else
			begin 
				SELECT BillID, BillDate  FROM    CustomerBillMast
				where CONVERT(VARCHAR(10),BillDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112)
			end 

END




GO
/****** Object:  StoredProcedure [dbo].[uspSyncPurchaseDetailsToLocal]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspSyncPurchaseDetailsToLocal] 


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @SyncDate datetime
	SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='Purchase'

	 if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = NULL)
 		begin
			select BillId, BillDate, VendorId, ProductID, ProductRate, Quantity, Amount, PaidAmount, BalanceDue, PreviousBalance  from Purchase
		End
	else
		begin
			select BillId, BillDate, VendorId, ProductID, ProductRate, Quantity, Amount, PaidAmount, BalanceDue, PreviousBalance  from Purchase
			where CONVERT(VARCHAR(10),LastUpdatedDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112)
		end 
END




GO
/****** Object:  StoredProcedure [dbo].[uspSyncPurchaseOrder]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspSyncPurchaseOrder
-- =============================================
CREATE PROCEDURE [dbo].[uspSyncPurchaseOrder] 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	Declare @SyncDate datetime
	SELECT @SyncDate=SyncDate FROM [dbo].[SyncObject] where TableName='Purchase'

	if (@SyncDate ='1900-01-01 00:00:00.000' or @SyncDate = NULL)
		begin
			SELECT        BillId, BillDate, ProductID, Quantity, Amount, ProductRate, VendorId
			FROM            Purchase		End
	else
		begin 
			SELECT        BillId, BillDate, ProductID, Quantity, Amount, ProductRate, VendorId
			FROM            Purchase			where CONVERT(VARCHAR(10),BillDate,112) >= CONVERT(VARCHAR(10),@SyncDate,112)
		end 


END




GO
/****** Object:  StoredProcedure [dbo].[uspUpdateCustomerBillDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinoad Sabbade
-- Create date: <Create Date,,>
-- Description:	Update customer Bill Details 
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateCustomerBillDetails] 
@CustomerId int , @BillID int, @ProductId int, @Quantity decimal(9,2), @Amount decimal(9,2) 

AS
BEGIN
SET nocount ON;

	IF EXISTS 
	  ( 
			 SELECT 1 
			 FROM   customerbilldetails 
			 WHERE  customerid =@CustomerId 
			 AND    billid = @BillID and [PRODUCTID]= @ProductId
	   ) 
	 
		  BEGIN 
				UPDATE dbo.CustomerBillDetails 
				SET    [PRODUCTID]=@ProductId, 
					   [QUANTITY]=@Quantity, 
					   [AMOUNT]=@Amount,
					   [LastUpdatedDate]=GETDATE()
				WHERE  CUSTOMERID =@CustomerId 
				AND    BILLID = @BillID 
				AND	   [ProductID]= @ProductId
		  END 
	  ELSE 
		  BEGIN 
				INSERT INTO CustomerBillDetails 
							( 
								[BILLID], 
								[CUSTOMERID], 
								[PRODUCTID], 
								[QUANTITY], 
								[AMOUNT],
								[LASTUPDATEDDATE]
							) 
							VALUES 
							( 
								@BillID, 
								@CustomerId, 
								@ProductId, 
								@Quantity,
								@Amount,
								GETDATE()
							) 
		  END
END




GO
/****** Object:  StoredProcedure [dbo].[uspUpdateCustomerOrder_ForMobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
--exec uspUpdateCustomerOrder_ForMobileApp 6,3,1,67,37,0
CREATE PROCEDURE [dbo].[uspUpdateCustomerOrder_ForMobileApp]
@BillID int
,@CustomerId int
,@ProductID int
,@Quantity decimal (9,2)
,@Rate decimal(9,2)
,@Lickage decimal (9,2)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @mRate decimal(9,2)
	set @mRate = (select rate from CustomerRates where CustomerID =@CustomerId and ProductID =  @ProductID and EndDate = '9999-01-01')
	
	UPDATE [dbo].[CustomerBillDetails]
	   SET 
		   [Quantity] = @Quantity
		  ,[Amount] = @Quantity*@mRate
		  ,[LastUpdatedDate] = getdate()

	 WHERE [BillID] =@BillID and [CustomerId] = @CustomerId and [ProductID] = @ProductID

	 declare @mBillAmount decimal(9,2)

	 set @mBillAmount = (Select sum(Amount)  from CustomerBillDetails CBD
							WHERE   (CBD.CustomerId = @CustomerId) AND (CBD.BillID = @BillID)) 

if exists (select billid from CustomerPaymentDetail where billid = @BillID and [CustomerId] = @CustomerId)
begin

	 update CustomerPaymentDetail set BillAmount = @mBillAmount where  [CustomerId] = @CustomerId and [BillID] =@BillID 
	 
	 end
	 else
	 begin
	 insert into CustomerPaymentDetail
	 (
	 [CustomerId]
      ,[PreviousBalance]
      ,[BillID]
      ,[BillDate]
      ,[BillAmount]
      ,[PaymentDate]
      ,[PaymentMode]
      ,[CashAmount]
      ,[ChequeAmount]
      ,[ChequeNo]
       
      ,[LastUpdatedDate]
	  )
	  values
	  (
	  @CustomerId,
	  0,
	  @BillID,
	  (select billdate from customerbillmast where billid = @BillID),
	  @mBillAmount,null,null,0,0,0,getdate()

	  )
	  	
	 end


	
END

GO
/****** Object:  StoredProcedure [dbo].[uspUpdateCustomerPaymentDetails]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinoad Sabbade
-- Create date: <Create Date,,>
-- Description:	Update customer Payments
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateCustomerPaymentDetails] 


@CustomerId int , 
@BillDate datetime,
@PaymentDate datetime, 
@PaymentMode int , 
@CashAmount decimal(18,0), 
@ChequeAmount decimal(18,0), 
@ChequeNo varchar(15) 

AS
BEGIN

	SET NOCOUNT ON;

	Update dbo.CustomerPaymentDetail
	SET
			PaymentDate =@PaymentDate, 
			PaymentMode = @PaymentMode, 
			CashAmount =@CashAmount, 
			ChequeAmount =@ChequeAmount, 
			ChequeNo =@ChequeNo

	Where	CustomerId =@CustomerId and  --CONVERT(VARCHAR(10),BillDate,112) = convert(varchar , convert(datetime,@BillDate, 111),112) 
	CONVERT(VARCHAR(10),BillDate,105) = CONVERT(VARCHAR(10),@BillDate,105)

END





GO
/****** Object:  StoredProcedure [dbo].[uspUpdateCustomerQuantityAndAmount]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateCustomerQuantityAndAmount]
@BillId int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @TotalQuantity decimal (9,2)
	Declare @TotalAmount Decimal(9,2)


	set @TotalQuantity=(Select Sum(Quantity) from CustomerBillDetails where BillID=@BillId)
	set @TotalAmount=(Select Sum(Amount) from CustomerBillDetails where BillID=@BillId)
 

	update	CustomerBillMast  
	set
			TotalQty=@TotalQuantity
			,TotalAmount=@TotalAmount
	Where	BillID=@BillId

END




GO
/****** Object:  StoredProcedure [dbo].[uspUpdateEmployee]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateEmployee]
 
  @EmployeeID int
 ,@EmployeeName nVarchar(100)
 ,@Address nVarchar(250)
 ,@AreaID int
 ,@Mobile nVarchar(10)
 

AS
BEGIN
 
	SET NOCOUNT ON;
 
 
	UPDATE  EmployeeMast 

		SET  
			EmployeeName = @EmployeeName 
			,Address    = @Address 
			,AreaID     = @AreaID 
			,Mobile     = @Mobile 

		WHERE EmployeeID=@EmployeeID 
 
  
 
 Update U
 set U.Name=@EmployeeName ,
 U.MobileNo=@Mobile

 from 	 mDistributor.dbo.Users U 
 INNER JOIN EmployeeMast E ON E.UserID=U.UserID  WHERE E.EmployeeID= @EmployeeID
 

END

GO
/****** Object:  StoredProcedure [dbo].[uspUpdateOpeniningBalance]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateOpeniningBalance]
@PreviousBalance decimal(9,2),
@CustomerId int

AS
BEGIN
 
	SET NOCOUNT ON;

 
		UPDATE    CustomerPaymentDetail
		SET              PreviousBalance =@PreviousBalance
		where CustomerId = @CustomerId and BillId = 1

END




GO
/****** Object:  StoredProcedure [dbo].[uspUpdatePurchaseFromServer]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinoad Sabbade
-- Create date: <Create Date,,>
-- Description:	insert purchase data from server to local Database using sync
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdatePurchaseFromServer]
 @BillId  int 
,@BillDate Datetime
,@VendorId int
,@ProductID int
,@ProductRate decimal(9,2)
,@Quantity decimal(9,2)
--,@lickageQty decimal (9,2)

AS
BEGIN
 
	SET NOCOUNT ON;
	 IF NOT EXISTS(Select 1 from Purchase  where Billid = @BillId )
			BEGIN

				INSERT INTO [dbo].[Purchase]
					(
					[BillDate],[VendorId],[ProductID],[ProductRate],[Quantity],[PaidAmount],[LastUpdatedDate])
				VALUES
					(@BillDate,@VendorId,@ProductID,@ProductRate,@Quantity,0,Getdate())
			END
	ELSE
			BEGIN
				UPDATE [dbo].[Purchase]
				Set
					[BillDate]=@BillDate
					,[VendorId]=@VendorId
					,[ProductID]=@ProductID
					,[ProductRate]=@ProductRate
					,[Quantity]=@Quantity
				Where BillId= @BillId and ProductID=@ProductID AND VendorId=@VendorId

			END
	END




GO
/****** Object:  StoredProcedure [dbo].[uspUpdateSupplierLickage]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Vinoad Sabbade
-- Create date: 07 March 2017
-- Description:	insert / update supplier lickage
-- uspUpdateSupplierLickage
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateSupplierLickage]
     @BillId int
	,@BillDate datetime
	,@VendorID int 
	,@ProductID int
	,@Likage decimal (9,2)
	
AS
BEGIN

	SET NOCOUNT ON;

	

	IF EXISTS (SELECT 1 FROM   VendorLikages WHERE  VendorID = @VendorID AND Productid = @ProductID and BillId=@BillId) 
	  BEGIN 
		  UPDATE VendorLikages 
		  SET    Likage = @Likage 
		  WHERE  VendorID = @VendorID AND Productid = @ProductID and BillId=@BillId
	  END 
	ELSE 
	  BEGIN
	INSERT INTO [dbo].[VendorLikages]
           ([BillId]
           ,[BillDate]
           ,[VendorID]
           ,[ProductID]
           ,[Likage]
           ,[LastUpdatedDate])
     VALUES
           (@BillId
           ,@BillDate
           ,@VendorID 
           ,@ProductID 
           ,@Likage
           ,getdate())
	END

END




GO
/****** Object:  StoredProcedure [dbo].[uspUpdateSupplierLickageAmount]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateSupplierLickageAmount]
@SupplierID int
,@BillId Int
,@LickageAmount decimal(9,2)

AS
BEGIN
 
	SET NOCOUNT ON;
	Update SupplierPaymentDetail set ChequeAmount=@LickageAmount where SupplierId=@SupplierID and BillID=@BillId

	exec uspCalculateSupplierBalances @SupplierID

END




GO
/****** Object:  StoredProcedure [dbo].[uspUpdateSupplierOutstanding]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspUpdateSupplierOutstanding 3
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateSupplierOutstanding]
@SupplierId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

			DECLARE @BalDue DECIMAL(18, 2) 
			DECLARE @bDate DATETIME 

			SELECT @bDate = BillDate 
			FROM   Purchase 
			WHERE  BillDate NOT IN (SELECT TOP (1) Purchase. BillDate 
									FROM   Purchase 
										   INNER JOIN CustomerMast ON Purchase.VendorId  = 
										   CustomerMast.CustomerID 
									WHERE  Purchase.VendorId  = @SupplierId 
									ORDER  BY Purchase.BillDate DESC) 
				   AND VendorId  = @SupplierId 
			ORDER  BY Purchase.BillDate ASC 

			SELECT @BalDue = BalanceDue FROM   dbo.Purchase 
			WHERE  CONVERT(date, BillDate, 101) =  CONVERT(Date, @bDate, 101) 
				   AND VendorId  = @SupplierId 
END




GO
/****** Object:  StoredProcedure [dbo].[uspUpdateSync]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:update the SyncObject Table after synchronization completed
-- uspUpdateSync 'CustomerMast'
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateSync]
	-- Add the parameters for the stored procedure here
	@TableName Varchar(50),
	@isSync int
AS
BEGIN
 
	SET NOCOUNT ON;

 	Update SyncObject set SyncDate = getdate(),
	isSync = @isSync where TableName=@TableName

END




GO
/****** Object:  StoredProcedure [dbo].[uspUpdateTenantId]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspUpdateTenantId]
 @TenantId int 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update [Users] set TenantID = @TenantId where UserID  = (
	
	Select top 1 UserId from Users order by UserID desc
	)


END




GO
/****** Object:  StoredProcedure [dbo].[uspUserProfile_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- uspUserProfile_MobileApp 14
-- =============================================
CREATE PROCEDURE [dbo].[uspUserProfile_MobileApp] 
@UserId int 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT  EmployeeMast.EmployeeID, EmployeeMast.EmployeeName as FullName, EmployeeMast.Mobile, AreaMast.Area, 'datta@vitarak.in' as Email,
				EmployeeMast.UserId
		FROM    EmployeeMast INNER JOIN
				AreaMast ON EmployeeMast.AreaID = AreaMast.AreaID
		Where	UserId =@UserId
END




GO
/****** Object:  StoredProcedure [dbo].[uspVehicleOrderReport]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- uspVehicleOrderReport '03/16/2017' ,1
CREATE Procedure [dbo].[uspVehicleOrderReport]
@pDate Datetime  
,@VehicleID int
as
Begin

Declare @mDayNo int =DATEPART(dd,@pDate)
Declare @mMonthNo int =DATEPART(mm,@pDate)
Declare @mYear int =DATEPART(yyyy,@pDate)

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' from ProductMast P

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max(isnull([' + Product + '],0)) as ' + '[' + Product + ']' from ProductMast P

set @vSQLText=
	'
	Select BillDate, VechicleNo, CustomerName, Qty.*,CustAmt.BillAmount [Bill Amount],CustAmt.PreviousBalance [Previous Balance] , (CustAmt.BillAmount+CustAmt.PreviousBalance) Total--,CAST ( CustAmt.PaidAmount AS Varchar(25) )[Paid Amount],BalanceAmount [Balance Amount] 
	from 
	(
	(Select 
		CustomerMast.CustomerID,CustomerMast.CustomerName,VehicleMast.VechicleNo,
		Convert(date,Amt.BillDate) BillDate,
		sum(BillAmount) BillAmount,
		Sum(Amount) PaidAmount,
		Sum(PreviousBalance) PreviousBalance,
		Sum(BalanceDue) BalanceAmount 
	from [dbo].[CustomerPaymentDetail] Amt
	INNER JOIN
    CustomerMast ON Amt.CustomerId = CustomerMast.CustomerID INNER JOIN
                         VehicleMast ON CustomerMast.VehicleID = VehicleMast.VechicleID
	where 
	CustomerMast.VehicleID ='+Convert(Varchar,@VehicleID)+'
	AND	 (CONVERT(varchar(10), DATEPART(day,  Amt.BillDate)) = '+ convert(varchar(2),@mDayNo) + ') 
	And (CONVERT(varchar(10), DATEPART(month,  Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	AND (CONVERT(varchar(10), DATEPART(year,  Amt.BillDate)) = '+ convert(varchar(4),@mYear) + ')
	And Amt.Billdate is NOT NULL
	Group by CustomerMast.CustomerID,Convert(date,Amt.BillDate),CustomerMast.CustomerName,VehicleMast.VechicleNo
	) CustAmt
	outer Apply
	(Select ' + @vProductCol +
	'From
	(Select 
	Convert(date,CO.BillDate) BillDate,P.Product,Sum(B.Quantity) as Quantity 
	from [dbo].[CustomerBillDetails] B 
	inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
	inner join [dbo].[CustomerMast] C on (C.CustomerID=B.CustomerID)
	 INNER JOIN [dbo].[CustomerBillMast] CO ON B.BillID = CO.BillID
	where 
	  (CONVERT(varchar(10), DATEPART(Day,  CO.BillDate)) ='+ convert(varchar(2),@mDayNo) + ')  
	 AND (CONVERT(varchar(10), DATEPART(month,  CO.BillDate)) =  '+ convert(varchar(2),@mMonthNo) + ')
	AND (CONVERT(varchar(10), DATEPART(year,  CO.BillDate)) =  '+ convert(varchar(4),@mYear) + ')
	and Convert(date,CO.BillDate)=Convert(date,CustAmt.BillDate)
	and c.CustomerID=custamt.CustomerId
	 Group by P.Product,Convert(date,CO.BillDate)
	) P
	pivot
	( 
	Max(Quantity) 
	for [Product] in (' + @vProductList +') 
	) pvt
	Group by BillDate ) Qty
	)
	  '


	print @vSQLText

exec (@vSQLText)
End



GO
/****** Object:  StoredProcedure [dbo].[uspVendorCratesLedger]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- uspVendorCratesLedger 1,2,2017

CREATE Procedure [dbo].[uspVendorCratesLedger]
@pVendorID int,
@mMonthNo int,
@mYear int 
  
as
Begin

	SELECT  VendorMast.VendorName, CratesVendor.BillId, CratesVendor.VendorID, CratesVendor.OrderDate, isnull(CratesVendor.CratesIn,0)CratesIn, isnull(CratesVendor.CratesOut,0) CratesOut,  CratesVendor.BalanceCrates, 
			CratesVendor.LastUpdatedDate
	FROM    VendorMast INNER JOIN
			CratesVendor ON VendorMast.VendorID = CratesVendor.VendorID
			and 
			CONVERT(varchar(10), DATEPART(month,  OrderDate)) =  convert(varchar(2),@mMonthNo)
			AND CONVERT(varchar(10), DATEPART(year, OrderDate)) = convert(varchar(5),@mYear) 

End



GO
/****** Object:  StoredProcedure [dbo].[uspVendorLedgerMonthly]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--- Execute uspVendorLedgerMonthly 1,3,2017

CREATE Procedure [dbo].[uspVendorLedgerMonthly]
@pVendorID int,
@mMonthNo int,
@mYear int 
--@pDate Datetime 
as
Begin


--Declare @mMonthNo int =DATEPART(mm,@pDate)
--Declare @mYear int =DATEPART(yyyy,@pDate)

DECLARE @vProductList nvarchar(max) , @vProductCol nvarchar(max)
DECLARE @vSQLText nvarchar(max)

Select @vProductList= coalesce(@vProductList + ',','') + '[' + Product + ']' 
from ProductMast P
inner join (Select Productid from VendorProducts where VendorID=@pVendorID Group by Productid) VP on (VP.ProductID=P.ProductID)

Select @vProductCol= coalesce(@vProductCol + ',','') + 'Max([' + Product + ']) as ' + '[' + Product + ']' 
from ProductMast P
inner join (Select Productid from VendorProducts where VendorID=@pVendorID Group by Productid) VP on (VP.ProductID=P.ProductID)

--Select @vProductList,@vProductCol

set @vSQLText=
'
Select 
VendorAmt.BillDate [Date],
Qty.*,VendorAmt.BillAmount [Bill Amount],isnull(VendorAmt.PreviousBalance,0) [Previous Balance],isnull(VendorAmt.ChequeAmount,0) [Lickage Amount] ,VendorAmt.PaidAmount [Paid Amount],VendorAmt.BalanceAmount [Balance]
from
(
(Select 
--Amt.SupplierID,
	Convert(date,Amt.BillDate) BillDate,
	sum(BillAmount) BillAmount,
	Sum(PreviousBalance) PreviousBalance,
	Sum(ChequeAmount) ChequeAmount,
	Sum(CashAmount) PaidAmount,
	Sum(BalanceDue) BalanceAmount 
from [dbo].[SupplierPaymentDetail] Amt
where Amt.SupplierID= ' + convert(varchar(100),@pVendorID) + '
And (CONVERT(varchar(10), DATEPART(month,  Amt.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
 AND (CONVERT(varchar(10), DATEPART(year,  Amt.BillDate)) = '+ convert(varchar(5),@mYear) + ')
and Amt.Billdate is NOT NULL
Group by Amt.SupplierID,Convert(date,Amt.BillDate)
) VendorAmt
outer Apply
(Select ' + @vProductCol +
'From
(Select 
Convert(date,B.BillDate) BillDate,P.Product,Sum(B.Quantity) as Quantity 
from [dbo].[purchase] B 
inner join [dbo].[ProductMast] P on (P.ProductID=B.ProductID)
inner join [dbo].[VendorMast] C on (C.VendorID=B.VendorID)
where C.VendorID= ' + convert(varchar(100),@pVendorID) + 
'And (CONVERT(varchar(10), DATEPART(month,  B.BillDate)) = '+ convert(varchar(2),@mMonthNo) + ') 
	AND (CONVERT(varchar(10), DATEPART(year,  B.BillDate)) = '+ convert(varchar(5),@mYear) + ')
and Convert(date,B.BillDate)=Convert(date,VendorAmt.BillDate)
 Group by P.Product,Convert(date,B.BillDate)
) P
pivot
( 
Max(Quantity) 
for [Product] in (' + @vProductList + ') ) pvt
Group by BillDate ) Qty
)'

print @vSQLText

exec (@vSQLText)
End




GO
/****** Object:  StoredProcedure [dbo].[uspVendorListFor_MobileApp]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspVendorListFor_MobileApp]


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT      VendorMast.VendorID, VendorMast.VendorName, VendorMast.Address 
	
	--SUM(Purchase.Amount) AS PurchaseAmount, 
	--			Convert(Varchar(10),Purchase.BillDate,103) as PurchaseDate, Purchase.BillId,
	--			CASE WHEN Purchase.PaidAmount >0 THEN 'Paid' 
	--			ELSE 'Not Paid' END as 'PaymentStatus' 
	FROM        VendorMast
	 --INNER JOIN
		--		Purchase ON VendorMast.VendorID = Purchase.VendorId
	WHERE       (VendorMast.IsActive = 1) 
	--AND (Purchase.BillId =(SELECT        TOP (1) BillId FROM Purchase AS Purchase_1
	--ORDER BY	BillId DESC))
	--GROUP BY	VendorMast.VendorID, VendorMast.VendorName, VendorMast.Address, Purchase.BillDate, 
	--			Purchase.BillId,Purchase.PaidAmount

END




GO
/****** Object:  StoredProcedure [dbo].[uspVendorPurchaseLedger]    Script Date: 12-04-2019 15:31:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[uspVendorPurchaseLedger]
@VendorId int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		SELECT		Purchase.VendorId, Purchase.ProductID, Purchase.BillDate, SUM(Purchase.Quantity) AS Qty, SUM(Purchase.Amount) AS Amt, VendorMast.VendorName, 
					ProductMast.Product
		FROM        Purchase INNER JOIN
					ProductMast ON Purchase.ProductID = ProductMast.ProductID INNER JOIN
					VendorMast ON Purchase.VendorId = VendorMast.VendorID
		Where		Purchase.VendorId = @VendorId                      
		GROUP BY	Purchase.BillDate, Purchase.VendorId, Purchase.ProductID, VendorMast.VendorName, ProductMast.Product
		ORDER BY	Purchase.ProductID DESC
END




GO