-- Note: Use ITI DB
/* 1. Create a view that displays student full name, course name if the student has a grade more than 50. */
use ITI
create view Student_Info_if_Grades_More_than_50 
as 
	select CONCAT_WS(' ' , S.St_Fname , S.St_Fname) as Full_Name , C.Crs_Name , SC.Grade
	from Student as S inner join Stud_Course as SC
	on S.St_Id = SC.St_Id
	inner join Stud_Access.Course as C
	on C.Crs_Id = SC.Crs_Id and SC.Grade > 50

/*2.Create an Encrypted view that displays manager names and the topics they teach. */
alter view Manager_Cources 
with Encryption
as
	select I.Ins_Name , T.Top_Name
	from Department D inner join Instructor I
	on I.Ins_Id = D.Dept_Manager
	inner join Ins_Course IC
	on I.Ins_Id = IC.Ins_Id
	inner join Stud_Access.Course C
	on C.Crs_Id = IC.Crs_Id
	inner join Topic T
	on T.Top_Id = C.Top_Id


/*3.Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department */
create view InstructorInfo_in_SD_Java
as
select I.Ins_Name , D.Dept_Name 
from Department D inner join Instructor I
on D.Dept_Id = I.Dept_Id and D.Dept_Name in ('SD','Java') 

/*4.Create a view “V1” that displays student data for student who lives in Alex or Cairo. 
	Note: Prevent the users to run the following query 
	Update V1 set st_address=’tanta’
	Where st_address=’alex’;
*/
Create view V1 
as 
	select * from Student S
	where S.St_Address in ('Alex' , 'Cairo')
	with check option

Update V1 
set st_address= 'tanta'
Where st_address='Alex'

/*5.Create a view that will display the project name and the number of employees work on it.
“Use SD database”*/
use SD
create view Total_Employee_Number_in_Projects
as 
	select p.Project_Name ,sum ( E.Emp_Num ) as Number_of_Employee 
	from HumanResource.Employee E 
	inner join Works_On W
	on E.Emp_Num = W.Emp_Num
	inner join Company.Project P
	on P.Project_Num = W.Project_Num
	group by P.Project_Name

select * from Total_Employee_Number_in_Projects

/*6.Using Merge statement between the following two tables [User ID, Transaction Amount]
*/
create table Daily_Transaction 
(
UserID int , 
Transaction_Amount money
)
insert into Daily_Transaction (UserID , Transaction_Amount)
values (1,1000) , (2,2000) , (3,1000)

select * from Daily_Transaction

-------------------------------------------------------------------------
create table Last_Transaction 
(
UserID int , 
Transaction_Amount money
)
insert into Last_Transaction(UserID , Transaction_Amount)
values (1,4000) , (4,2000) , (2,10000 ) 

select * from Daily_Transaction
select * from Last_Transaction
------------------------------------------------------------------------
merge into Daily_Transaction as T
Using Last_Transaction  as S
on T.UserID = S.UserID
When Matched Then -- UserID : 1 and 2 
	Update
	set T.Transaction_Amount = S.Transaction_Amount  
When Not Matched  by Target Then -- UserID : 4 
	Insert 
	Values(S.UserID , S.Transaction_Amount)
when Not Matched by Source Then  -- UserID : 3 
	Delete											;
----------------------------------------------------------------------------------------------------------
/*7.Create a cursor for Employee table that increases Employee salary by 10% 
	if Salary <3000 and increases it by 20% if Salary >=3000. Use company DB */
use Company_SD

select * from Employee

-- 1- declare cursor ( Cursor_Name , Select , Privilige Update\ReadOnly ) 
declare  c1 cursor 
for select Employee.Salary from Employee
for Update
-- 2- declare Variable to hold Salary 
declare @Sal int 

-- 3- Open Cursor
open c1 
-- 4- Fetch Cursor 
fetch c1 into  @Sal -- counter points at 1st sal
-- 5- loop 
while @@FETCH_STATUS = 0 
	begin
		if @Sal < 3000 
			update Employee
			set Salary = Salary + (0.1 * Salary)
			where current of c1
		else 
			update Employee
			set Salary = Salary + (0.2 * Salary)
			where current of c1
		fetch c1 into @Sal -- increment cursor
	end 
-- 6-close cursor 
close c1 
-- 7- deallocate memory 
deallocate c1

------------------------------------------------------------------------------------------------------------
/*8.Display Department name with its manager name using cursor. Use ITI DB*/
use ITI

-- 1- Declare Cursor
declare c1 cursor
for select D.Dept_Name , I.Ins_Name as Manager_Name 
	from Department D inner join Instructor I 
	on I.Ins_Id = D.Dept_Manager
for read only

-- 2- declare variables to hold names 
declare @Dname nvarchar(50), @Mname nvarchar(50)

-- 3- open cursor 
open c1 
-- 4- fetch cursor 
fetch c1 into @Dname , @Mname

-- 5-loop 
while @@FETCH_STATUS = 0 
	begin
		select @Dname as Departement_Name, @Mname as Manager_Name
		fetch c1 into @Dname , @Mname
	end
-- 6- close cursor 
close c1
-- 7- deallocate cursor 
deallocate c1
----------------------------------------------------------------------------------------------------------------
/*9.Try to display all students first name in one cell separated by comma. Using Cursor */

-- 1- Declare Cursor
declare c1 cursor
for select Student.St_Fname from Student where Student.St_Fname is not null
for read only

-- 2- declare variables to hold names 
declare @Sname nvarchar(50), @Allnames nvarchar(1000)

-- 3- open cursor 
open c1 
-- 4- fetch cursor 
fetch c1 into @Sname 
-- 5-loop 
while @@FETCH_STATUS = 0 
	begin
		select @Allnames = CONCAT_WS(' , ' , @Allnames , @Sname)
		fetch c1 into @Sname 
	end
select @Allnames as All_Student_Names
-- 6- close cursor 
close c1
-- 7- deallocate cursor 
deallocate c1
-----------------------------------------------------------------------------------------------------------
/*10.Create full, differential Backup for SD DB. */
use SD
-- Full Backup
backup database SD
to disk = 'E:\Self Study\Data\Database SQL Server - Dr. Ramy\ITI_2024\Tasks\Day 8\SD_FULL.bak'

-- Differential Backup 
backup database SD
to disk = 'E:\Self Study\Data\Database SQL Server - Dr. Ramy\ITI_2024\Tasks\Day 8\SD_DIFF.bak'
with DIFFERENTIAL

-- Transaction log Backup 
backup log SD
to disk = 'E:\Self Study\Data\Database SQL Server - Dr. Ramy\ITI_2024\Tasks\Day 8\SD_LOG.bak'

----------------------------------------------------------------------------------------------------------------
/*11.Use import export wizard to display student’s data (ITI DB) in excel sheet*/
--Done
----------------------------------------------------------------------------------------------------------------
/*12.Try to generate script from DB ITI that describes all tables and views in this DB*/
----------------------------------------------------------------------------------------------------------------
/*13.Create a sequence object that allow values from 1 to 10 without cycling in a specific
column and test it.*/

Create sequence My_Sequence
    start with 1
    increment by 1
    minvalue 1
    maxvalue 10
    no cycle ;

create table test_sequence_table
(
sequence_val int 
)

insert into test_sequence_table
values  (Next Value For My_Sequence), -- 1
		(Next Value For My_Sequence), -- 2
		(Next Value For My_Sequence), -- 3
		(Next Value For My_Sequence), -- 4
		(Next Value For My_Sequence), -- 5
		(Next Value For My_Sequence), -- 6
		(Next Value For My_Sequence), -- 7
		(Next Value For My_Sequence), -- 8
		(Next Value For My_Sequence), -- 9
		(Next Value For My_Sequence) -- 10

select * from test_sequence_table

insert into test_sequence_table
values (next value for My_Sequence) -- error 

------------------------------------------------------------------------------------------------------------------
/*14.	Display all the data from the Employee table (HumanResources Schema) 
As an XML document “Use XML Raw”. “Use Adventure works DB” 
A)	Elements
B)	Attributes
*/
use AdventureWorks2012
-- Elements 
select * from HumanResources.Employee
for XML raw ('Employee'), Elements , root ('Employees')

-- Attributes 
select * from HumanResources.Employee
for XML raw ('Employee'), root ('Employees')

---------------------------------------------------------------------------------------------------------------
/*15.Display Each Department Name with its instructors. “Use ITI DB”
A)	Use XML Auto
B)	Use XML Path
*/
use ITI
-- auto
select D.Dept_Name as DepartmentName ,
	   I.Ins_Name  as InstructorName
from Department D inner join Instructor I 
on D.Dept_Id = I.Dept_Id
for XML auto , root('Departments') 

-- path 
select D.Dept_Name "DepartmentName" ,
	   I.Ins_Name  "DepartmentName/InstructorName"
from Department D inner join Instructor I 
on D.Dept_Id = I.Dept_Id
for XML path('Department') , root('Departments') 
----------------------------------------------------------------------------------------------------------------
/*16.	Use the following variable to create a new table “customers” inside the company DB.*/
use Company_SD

declare @docs xml =
	   '<customers>
              <customer FirstName="Bob" Zipcode="91126">
                     <order ID="12221">Laptop</order>
              </customer>
              <customer FirstName="Judy" Zipcode="23235">
                     <order ID="12221">Workstation</order>
              </customer>
              <customer FirstName="Howard" Zipcode="20009">
                     <order ID="3331122">Laptop</order>
              </customer>
              <customer FirstName="Mary" Zipcode="12345">
                     <order ID="555555">Server</order>
              </customer>
       </customers>'

-- declare Doc DHandler Variale 
declare @handler int

-- create memory Tree 
Exec sp_xml_preparedocument @handler output , @docs

-- read tree from memory using OpenXml 
select * 
from OpenXML (@handler , '//customer')
with (
		Customer_FirstName nvarchar(50) '@FirstName' ,
		Customer_ZipCode  int '@Zipcode' ,
		Customer_Order_ID int 'order/@ID' ,  
		Customer_Order_type nvarchar(50) 'order'  
	 )
-- remove tree from memory 
Exec sp_xml_removedocument @handler 