/*
1.Create the following tables with all the required information and load the required data as specified
in each table using insert statements[at least two rows]
Tablename	Details										
Department	DeptNo (PK)	DeptName	Location
			d1			Research	NY
			d2			Accounting	DS
			d3			Markiting	KW
	1-Create it by code
2-Create a new user data type named loc with the following Criteria:
•	nchar(2)
•	default:NY 
•	create a rule for this Datatype :values in (NY,DS,KW)) and associate it to the location column  
*/
----------- Creat Loc Datatype ------------
Sp_addtype loc , 'nchar(2)'

Create Default Def_1 as 'NY'
sp_bindefault Def_1 , loc

Create rule R1 as @x in ('NY' , 'DS' , 'KW')
sp_bindrule R1 , loc 

---------------------------------------------------------
Create table Department
(
Dept_Num varchar(5) primary key ,
Dept_Name varchar(50) , 
Dept_Location loc , 
)
----------------------------------------------------------
insert into Department ( Dept_Num , Dept_Name , Dept_Location)
Values ('d1' , 'Research' , 'NY') , ('d2' , 'Accounting' , 'DS') ,('d3' , 'Marketing' , 'KW') 

--------------------------------------------------------------------------------------------------------------
/*
Employee			
		EmpNo (PK)	EmpFname	EmpLname	DeptNo	Salary
		25348		Mathew		Smith		d3		2500
		10102		Ann			Jones		d3		3000
		18316		John		Barrimore	d1		2400
		29346		James		James		d2		2800
		9031		Lisa		Bertoni		d2		4000
		2581		Elisa		Hansel		d2		3600
		28559		Sybl		Moser		d1		2900
1-Create it by code
2-PK constraint on EmpNo
3-FK constraint on DeptNo
4-Unique constraint on Salary
5-EmpFname, EmpLname don’t accept null values
6-Create a rule on Salary column to ensure that it is less than 6000 
*/
Create table Employee
(
	Emp_Num   int Primary Key ,
	Emp_Fname varchar(30)  not NULL , 
	Emp_Lname varchar(20)  not NULL , 
	Emp_Sal   int  unique ,
	Dept_Num  varchar(5) , 
	constraint Fk1 Foreign Key (Dept_Num) references Department(Dept_Num) , 
)

create rule R2 as @x < 6000 
sp_bindrule R2 , 'Employee.Emp_Sal'

insert into Employee (Emp_Num, Emp_Fname , Emp_Lname , Emp_Sal , Dept_Num)
Values  ( 25348 , 'Mathew' , 'Smith'     , 2500 , 'd3') , 
		( 10102 , 'Ann'    , 'Jones'     , 3000 , 'd3') , 
		( 18316 , 'John'   , 'Barrimore' , 2400 , 'd1') , 
		( 29346 , 'James'  , 'James'     , 2800 , 'd2') , 
		( 9031  , 'Lisa'   , 'Bertoni'   , 4000 , 'd2') , 
		( 2581  , 'Elisa'  , 'Hansel'    , 3600 , 'd2') , 
		( 28559 , 'Sybl'   , 'Moser'     , 2900 , 'd1') 
-----------------------------------------------------------------------------------------
/*
Project	
		ProjectNo(PK)	ProjectName		Budget
		p1				Apollo			120000
		p2				Gemini			95000
		p3				Mercury			185600
1-Create it using wizard
2-ProjectName can't contain null values
3-Budget allow null

*/
------------------------------------------------------------------------------------------
/*
Works_on	
			EmpNo (PK)	ProjectNo(PK)	Job			Enter_Date
			10102		p1				Analyst		2006.10.1
			10102		p3				Manager		2012.1.1
			25348		p2				Clerk		2007.2.15
			18316		p2				NULL		2007.6.1
			29346		p2				NULL		2006.12.15
			2581		p3				Analyst		2007.10.15
			9031		p1				Manager		2007.4.15
			28559		p1				NULL		2007.8.1
			28559		p2				Clerk		2012.2.1
			9031		p3				Clerk		2006.11.15
			29346		p1				Clerk		2007.1.4
1-Create it using wizard
2- EmpNo INTEGER NOT NULL
3-ProjectNo doesn't accept null values
4-Job can accept null
5-Enter_Date can’t accept null
and has the current system date as a default value[visually]
6-The primary key will be EmpNo,ProjectNo) 
7-there is a relation between works_on and employee, Project  tables
*/

-----------------------------------------------------------------------------------
/*
Testing Referential Integrity	
*/

-- 1-Add new employee with EmpNo =11111 In the works_on table [what will happen]
insert into Works_On (Emp_Num)
Values(11111)                 -- can't insert null value into column Project_Num


-- 2-Change the employee number 10102  to 11111  in the works on table [what will happen]
update Works_On 
set Emp_Num = 11111
where Emp_Num = 10102      -- Update Conflict 


-- 3-Modify the employee number 10102 in the employee table to 22222. [what will happen]
update Employee
set Emp_Num = 22222
where Emp_Num = 10102      -- Update Conflict 

-- 4-Delete the employee with id 10102 	
Delete from Employee
where Emp_Num = 10102		-- Delete Conflict 
---------------------------------------------------------------------------------------------
/*Table modification */

--1-Add  TelephoneNumber column to the employee table[programmatically]
alter table Employee add Telephone varchar(11)

select * from Employee


-- 2-drop this column[programmatically]
alter table Employee drop column Telephone

select * from Employee


-- 3- Bulid A diagram to show Relations between tables
-----------------------------------------------------------------------------------------------
/*
2.Create the following schema and transfer the following tables to it 
	a.	Company Schema 
		i.	Department table (Programmatically)
		ii.	Project table (using wizard)
	b.	Human Resource Schema
		i.Employee table (Programmatically)
*/

create Schema Company 
alter Schema Company Transfer Department

Create Schema HumanResource
alter Schema HumanResource Transfer Employee

------------------------------------------------------------------------------------------
/*3.Write query to display the constraints for the Employee table.*/
Select  TABLE_NAME,
		CONSTRAINT_NAME,
		CONSTRAINT_TYPE
FROM 
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE 
    TABLE_NAME = 'Employee';

sp_help 'HumanResource.Employee'
--------------------------------------------------------------------------------------------
/*
4.	Create Synonym for table Employee as Emp and then run the following queries and describe the results
	a.	Select * from Employee
	b.	Select * from [Human Resource].Employee
	c.	Select * from Emp
	d.	Select * from [Human Resource].Emp
*/
drop Synonym Emp
Create Synonym Emp for HumanResource.Employee

select * from Employee					-- Error : Employee in HumanResources not in Dbo ( Full path Error)

select * from HumanResource.Employee	-- No Error 

select * from Emp						-- No Error 

select * from HumanResourcec.Emp		-- Error : invalid Object Name ( Dbo.Emp) 

------------------------------------------------------------------------------------------
/*5.Increase the budget of the project where the manager number is 10102 by 10% .*/

update Company.Project 
set Project_Budget = Project_Budget * 1.1

from HumanResource.Employee HRE inner join Works_On
on HRE.Emp_Num = Works_On.Emp_Num and HRE.Emp_Num = 10102 and Works_On.job = 'Manager'
inner join Company.Project CP
on CP.Project_Num = Works_On.Project_Num

-------------------------------------------------------------------------------------------
/*6.Change the name of the department for which the employee named James works. 
The new department name is Sales.*/

update Company.Department
set Dept_Name = 'Sales'
from HumanResource.Employee HRE inner join Company.Department CD
on CD.Dept_Num = HRE.Dept_Num and (Emp_Fname = 'James' or Emp_Lname = 'James')

---------------------------------------------------------------------------------------------
/*7.Change the enter date for the projects for those employees who work in project p1 
and belong to department ‘Sales’. The new date is 12.12.2007.*/

Update Works_On
set Enter_Date = '12-12-2007'

from HumanResource.Employee HRE inner join Works_On
on HRE.Emp_Num = Works_On.Emp_Num and Works_On.Project_Num = 'p1'
inner join Company.Department CD
on CD.Dept_Num = HRE.Dept_Num and CD.Dept_Name = 'Sales'
----------------------------------------------------------------------------------------------------
/*8. Delete the information in the works_on table for all employees who work for 
the department located in KW.*/

Delete Works_on
from HumanResource.Employee HRE inner join Company.Department CD
on CD.Dept_Num = HRE.Dept_Num and CD.Dept_Location = 'KW'
inner join Works_on
on HRE.Emp_Num = Works_On.Emp_Num   -- 3 rows affected 

select * from Works_On

----------------------------------------------------------------------------------------------------------------------------