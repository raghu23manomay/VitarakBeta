
GO
/****** Object:  UserDefinedTableType [dbo].[UT_AeraMaster]    Script Date: 21/02/2019 11:57:30 ******/
CREATE TYPE [dbo].[UT_AeraMaster] AS TABLE(
	[AreaID] [int] IDENTITY(1,1) NOT NULL,
	[Area] [nvarchar](50) NOT NULL,
	[CityID] [int] NOT NULL,
	[LastUpdatedDate] [datetime] NULL DEFAULT (getdate())
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_AeraMaster1]    Script Date: 21/02/2019 11:57:30 ******/
CREATE TYPE [dbo].[UT_AeraMaster1] AS TABLE(
	[AreaID] [int] NULL,
	[Area] [nvarchar](50) NOT NULL,
	[CityID] [int] NOT NULL,
	[LastUpdatedDate] [datetime] NULL DEFAULT (getdate())
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_CustomerMaster]    Script Date: 21/02/2019 11:57:31 ******/
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
/****** Object:  UserDefinedTableType [dbo].[UT_EmployeeMaster]    Script Date: 21/02/2019 11:57:32 ******/
CREATE TYPE [dbo].[UT_EmployeeMaster] AS TABLE(
	[EmployeeID] [int] NULL,
	[EmployeeName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](350) NOT NULL,
	[AreaID] [datetime] NULL,
	[Mobile] [int] NOT NULL,
	[UserId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_EmployeeMasters]    Script Date: 21/02/2019 11:57:32 ******/
CREATE TYPE [dbo].[UT_EmployeeMasters] AS TABLE(
	[EmployeeID] [int] NULL,
	[EmployeeName] [nvarchar](50) NOT NULL,
	[Address] [nvarchar](350) NOT NULL,
	[AreaID] [datetime] NULL,
	[Mobile] [nvarchar](10) NOT NULL,
	[UserId] [int] NULL
)
GO
/****** Object:  UserDefinedTableType [dbo].[UT_ProductMaster]    Script Date: 21/02/2019 11:57:32 ******/
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
/****** Object:  UserDefinedTableType [dbo].[UT_SupplierMaster]    Script Date: 21/02/2019 11:57:33 ******/
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
/****** Object:  UserDefinedTableType [dbo].[UT_VehicalMaster]    Script Date: 21/02/2019 11:57:34 ******/
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
/****** Object:  UserDefinedFunction [dbo].[properCase]    Script Date: 21/02/2019 11:57:34 ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_CusomerProductRate]    Script Date: 21/02/2019 11:57:34 ******/
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
/****** Object:  UserDefinedFunction [dbo].[udf_PutSpacesBetweenChars]    Script Date: 21/02/2019 11:57:34 ******/
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
/****** Object:  UserDefinedFunction [dbo].[ufnGetSupplierRate]    Script Date: 21/02/2019 11:57:34 ******/
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
/****** Object:  UserDefinedFunction [dbo].[udfGetProductRateForCustomer]    Script Date: 21/02/2019 11:57:34 ******/
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
