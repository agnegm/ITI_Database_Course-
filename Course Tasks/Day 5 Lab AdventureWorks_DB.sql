/*1.Display the SalesOrderID, ShipDate of the SalesOrderHeader table (Sales schema) 
to show SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’*/

select Sales.SalesOrderHeader.SalesOrderID , 
	   Sales.SalesOrderHeader.ShipDate
from Sales.SalesOrderHeader
where Sales.SalesOrderHeader.ShipDate between '7-28-2002' and '7-29-2014'

----------------------------------------------------------------------------------------
/*2.Display only Products(Production schema) with a StandardCost below $110.00 
(show ProductID, Name only)*/
select Product.ProductID , Product.Name
from Production.Product
where Production.Product.StandardCost < 110.00
----------------------------------------------------------------------------------------
/*3.Display ProductID, Name if its weight is unknown*/
select Product.ProductID , Product.Name , product.Weight
from Production.Product
where Product.Weight is NULL 
-----------------------------------------------------------------------------------------
/*4.Display all Products with a Silver, Black, or Red Color*/
select *
from Production.Product
where Product.Color in ('silver' , 'Black' , 'Red') 
----------------------------------------------------------------------------------------
/*5.Display any Product with a Name starting with the letter B*/
select *
from Production.Product
where Product.Name like 'B%'
----------------------------------------------------------------------------------------
/*6.Run the following Query
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3
Then write a query that displays any Product description with underscore value in its description.
*/
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

select *
from Production.ProductDescription
where Production.ProductDescription.Description like '%[_]%'
-------------------------------------------------------------------------------------------
/*7.Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table 
for the period between  '7/1/2001' and '7/31/2014'*/

select sum(Sales.SalesOrderHeader.TotalDue) as total_Due_for_each_OrderDate,
	   Sales.SalesOrderHeader.OrderDate  
from Sales.SalesOrderHeader
where Sales.SalesOrderHeader.OrderDate between '7-1-2001' and '7-31-2014'
group by Sales.SalesOrderHeader.OrderDate

--------------------------------------------------------------------------------------------
/*8.Display the Employees HireDate (note no repeated values are allowed)*/
select distinct Employee.HireDate
from HumanResources.Employee
--------------------------------------------------------------------------------------------
/*9.Calculate the average of the unique ListPrices in the Product table*/
select avg(distinct ListPrice)  
from Production.Product
-------------------------------------------------------------------------------------------
/*10.Display the Product Name and its ListPrice within the values of 100 and 120 the list 
should has the following format "The [product name] is only! [List price]" 
(the list will be sorted according to its ListPrice value)*/
select concat_Ws(' ','The',Name,'is only!',ListPrice)
from Production.Product
where ListPrice between 100 and 120 
order by ListPrice

------------------------------------------------------------------------------------------
/*
11.	
a)	 Transfer the rowguid ,Name, SalesPersonID, Demographics from Sales.Store table  
in a newly created table named [store_Archive]
Note: Check your database to see the new table and how many rows in it?

b)	Try the previous query but without transferring the data? 
*/

--------------------- A --------------------------------
select rowguid , Name , SalesPersonID , Demographics into [Sales.Store_Archive]
from Sales.Store 
-- 701 Rows Affected --
 
----------------------B --------------------------------
select rowguid , Name , SalesPersonID , Demographics into [dbo.Store_Archive]
from Sales.Store 
where 1 = 2 
-- 0 Rows Affected --
--------------------------------------------------------------------------------------
/*12.Using union statement, retrieve the today’s date in different styles 
using convert or format funtion.*/
-------- by using Convert Function -----------
select Convert(varchar(20),getdate(),101) as Today_date
union all 
select Convert(varchar(20),getdate(),103)
union all 
select Convert(varchar(20),getdate(),104)
union all 
select Convert(varchar(20),getdate(),107)
union all 
select Convert(varchar(20),getdate(),110)
union all 
select Convert(varchar(20),getdate(),115)
union all 
select Convert(varchar(20),getdate(),121) 
-- formats from 101 --> 121 
---------------- by using Format Function ----------------------
select format(getdate(), 'MM-dd-yyyy') as Today_date
union all
select format(getdate(), 'dd-MMM-yyyy')
union all
select format(getdate(), 'dddd-MMMM-yyyy hh:mm:ss')






 