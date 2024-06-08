/*1.Create a stored procedure without parameters to show the number of students per department name.
[use ITI DB] */

use ITI

create proc Get_Num_Of_Stud_in_Dept 
as

	select D.Dept_Name , Count(S.St_Id) as Number_of_Student
	from Department D  inner join Student S
	on D.Dept_Id = S.Dept_Id
	group by D.Dept_Name

Execute Get_Num_Of_Stud_in_Dept
-----------------------------------------------------------------------------------------------------------
/*
2.Create a stored procedure that will check for the # of employees in the project p1
if they are more than 3 print message to the user “'The number of employees in the project p1 is 3 or more'”
if they are less display a message to the user “'The following employees work for the project p1'”
in addition to the first name and last name of each one.
[Company DB] 
*/

use SD

create Proc Check_P1_Emp_Num @x int
as
	if  @x>= 3 
		begin
		
			select 'The number of employees in the project p1 is 3 or more'
		
			select E.Emp_Fname , E.Emp_Lname 
			from HumanResource.Employee E inner join Works_On W
			on E.Emp_Num = W.Emp_Num and W.Project_Num = 'p1'
		end
	else 
		begin
			select 'The following employees work for the project p1'
		 
			select E.Emp_Fname , E.Emp_Lname 
			from HumanResource.Employee E inner join Works_On W
			on E.Emp_Num = W.Emp_Num and W.Project_Num = 'p1'
		end


declare @P1_Emp_Num int 
select @P1_Emp_Num = count(E.Emp_Num) 
	from HumanResource.Employee E inner join Works_On W
	on E.Emp_Num = W.Emp_Num and W.Project_Num = 'p1'

execute Check_P1_Emp_Num @P1_Emp_Num

--------------------------------------------------------------------------------------------------------------
/*
3.Create a stored procedure that will be used in case there is an old employee has left the project and 
a new one become instead of him. The procedure should take 3 parameters 
(old Emp. number, new Emp. number and the project number)
and it will be used to update works_on table. [Company DB]
*/
create Proc Replace_Emp_in_Proj @old_Emp_Num int , @new_Emp_Num int , @proj_Num varchar(5)
as
	-- check if the New_Employee Exist or not
	if not exists (select * from HumanResource.Employee E where E.Emp_Num = @new_Emp_Num )
		begin
			select 
			'The Employee is Not Exist and is going to be Inserted in Our Employees 
			and given the tole of ' + convert (varchar(10),@old_Emp_Num)  
			
			insert into HumanResource.Employee (Emp_Num)
			values (@new_Emp_Num)
			
			update Works_On
			set Emp_Num = @new_Emp_Num , Enter_Date = getdate() 
			where Project_Num = @proj_Num and Emp_Num = @old_Emp_Num
		end
	else 
		begin
			select 'The Employee is Exist and We will replace the Role of'
			+ convert (varchar(10),@old_Emp_Num) + 'To' + convert (varchar(10),@new_Emp_Num)
			
			update Works_On
			set Emp_Num = @new_Emp_Num , Enter_Date = getdate() 
			where Project_Num = @proj_Num and Emp_Num = @old_Emp_Num
		end


execute Replace_Emp_in_Proj @old_Emp_Num =22 , @new_Emp_Num = 1 , @proj_Num ='p3'


--DROP CONSTRAINT UQ__Employee__F6440669F83A91C1;	

select * 
from HumanResource.Employee E inner join Works_On W
on E.Emp_Num = W.Emp_Num 

select * from HumanResource.Employee
--------------------------------------------------------------------------------------------------------------
/*
4.add column budget in project table and insert any draft values in it 
then then Create an Audit table with the following structure 
ProjectNo 	UserName 	ModifiedDate 	Budget_Old 	Budget_New 
p2 			Dbo 		2008-01-31		95000 		200000 
This table will be used to audit the update trials on the Budget column (Project table, Company DB)
Example:
If a user updated the budget column then the project number, user name that made that update, the date of the modification and the value of the old and the new budget will be inserted into the Audit table
Note: This process will take place only if the user updated the budget column
*/
create table Audit_Table
(
projectNum			varchar(5),
username			varchar(100),
ModificationDate	date ,
Budget_Old			int,
Budget_New			int
)
create trigger Budget_Update
on [Company].[Project]
after update
as 
	select 'Update is stored in our Auditing'
	declare @PNum varchar(5) , @oldbudget int , @newbudget int 
	
	select  @PNum = Project_Num  , @newbudget = Project_Budget from inserted
	select  @oldbudget = Project_Budget from deleted
	
	insert into Audit_Table (projectNum , username , ModificationDate , Budget_Old , Budget_New)
	values ( @PNum , suser_name() , GETDATE() , @oldbudget , @newbudget)

	
select * from Audit_Table

---------------------------------------------------------------------------------------------------------------
/*
5.	Create a trigger to prevent anyone from inserting a new record in the Department table 
[ITI DB] “Print a message for user to tell him that he can’t insert a new record in that table”
*/
use ITI

create trigger Insert_Prevent
on [dbo].[Department]
instead of Insert
as 
	select 'Insert is Denied on that table'
	select * from inserted
	select * from deleted

insert into Department (Dept_Id)
values (100)

select * from Department

--------------------------------------------------------------------------------------------------------------
/*6.Create a trigger that prevents the insertion Process for Employee table in March [Company DB].*/

use Company_SD

create trigger March_insertion_prevent
on [dbo].[Employee]
instead of Insert 
as 
	if ( Month(getdate()) = 3)
		begin
			select 'March Insertion is prevented '
		end
	
	else 
		begin
			insert into Employee (Fname,Lname,SSN , Bdate , Address , Sex , Salary , Superssn, Dno)
			select Fname,Lname,SSN , Bdate , Address , Sex , Salary , Superssn, Dno 
			from inserted
			select * from inserted 
		end


insert into Employee (Fname , Lname , SSN)
values ('temp' , 'Employee' , 2000 )

------------------------------------------------------------------------------------------------------------------
/*
7.Create a trigger on student table after insert to add Row in Student Audit table 
(Server User Name , Date, Note) 
where note will be “[username] Insert New Row with Key=[Key Value] in table [table name]”
ServerUser Name		Date		Note 
*/
use ITI

select * from Student

create table Student_Audit
(
Server_User_Name varchar(100) , 
Insertion_Date date , 
Note nvarchar(2000)
)

create trigger Audit_Student
on [dbo].[Student]
after Insert 
as 
	declare @KeyValue int 
	select @KeyValue=St_Id from inserted
	insert into Student_Audit (Server_User_Name , Insertion_Date ,Note) 			
	select Suser_name() , getdate() ,
	'[' + suser_name() + ']Insert New Row with Key=['+convert(varchar(10),@KeyValue)+'] in table [Student] '

insert into Student(St_Id)
values (202)

select * from Student_Audit
----------------------------------------------------------------------------------------------------------------
/* 8.Create a trigger on student table instead of delete to add Row in
Student Audit table (Server User Name, Date, Note) where note will be“ try to delete Row with Key=[Key Value]”
*/

create trigger Delete_Audit_Student
on [dbo].[Student]
instead of delete
as 
	declare @KeyValue int 
	select @KeyValue=St_Id from deleted
	insert into Student_Audit (Server_User_Name , Insertion_Date ,Note) 			
	select Suser_name() , getdate() ,
	'[' + suser_name() + ']try to delete Row with Key=['+convert(varchar(10),@KeyValue)+'] in table [Student] '


select * from Student


delete from Student
where St_Id = 200
  
select * from Student_Audit
-----------------------------------------------------------------------------------------------------------------




