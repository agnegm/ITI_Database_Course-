-------------------------------------------- ITI DB ------------------------------------------------------
/*1.Create a scalar function that takes date and returns Month name of that date.*/
Create Function Get_Month ( @Date date) 
returns varchar(20)
	begin
	declare @Month varchar(20) = Datename(month,@Date)
	return @Month
	end

select dbo.Get_Month ('5-5-2002')

--------------------------------------------------------------------------------------
/*2. Create a multi-statements table-valued function that takes 2 integers and returns 
the values between them.*/
Create Function Get_Between (@Val1 int , @Val2 int )
returns  @t table
			(
				Betweens int  
			)
as
	begin
		declare @iterator int = @Val1 +1 
		while (@iterator < @Val2)
			begin
				insert into @t 
				select @iterator
				set @iterator +=1
			end
		return
	end 

select * from dbo.Get_Between(1,10)
----------------------------------------------------------------------------------
/*Create inline function that takes Student No and returns Department Name with Student full name.*/
create Function Get_Student_info ( @Student_No int)
returns table 
as
return
(
	select CONCAT_WS(' ' , Student.St_Fname , Student.St_Lname) as Student_FullName,
		   Department.Dept_Name
	from Student inner join Department
	on Department.Dept_Id = Student.Dept_Id and Student.St_Id = @Student_No
)

select * from dbo.Get_Student_info(10)
-----------------------------------------------------------------------------------------------------
/*4.Create a scalar function that takes Student ID and returns a message to user 
a.	If first name and Last name are null then display 'First name & last name are null'
b.	If First name is null then display 'first name is null'
c.	If Last name is null then display 'last name is null'
d.	Else display 'First name & last name are not null'
*/
Create Function check_Null (@Student_No int)
returns varchar(50)
begin
	declare @result varchar(50)
	select @result = case	
		   when St_Fname IS NULL and St_Lname IS NULL then  'First Name & Last Name are NULL'
		   when St_Fname IS NULL  then						'First name Is NUll'
		   when St_Lname IS NULL  then						'Last name Is NUll'
		   else												'First name & Last name are not NUll'
		   end 
	from Student
	where Student.St_Id = @Student_No
	return @result
end
select dbo.check_null(14)
---------------------------------------------------------------------------------------
Create function Name_NULL_Check (@stuid int)
returns varchar(50)
begin
	declare @First_name_var varchar (20) , @Last_Name_Var varchar(20) , @Message varchar(50)
	select @First_name_var = Student.St_Fname , @Last_Name_Var = Student.St_Lname
	from Student
	where Student.St_Id = @stuid 
	------------------------------
	if @First_name_var is NULL  and @Last_Name_Var is NULL
		begin
			set @Message =  'Fisrt Name and last name are NULLs'
		end
	else if @First_name_var is NULL
		begin
			set @Message =  'Fisrt Name is NULL'
		end
	else if @Last_Name_Var is NULL
		begin
			set @Message = 'Last Name is NULL'
		end
	else
		begin
			set @Message =  'First and last name are not NULLs '
		end

return @message
end

select dbo.Name_NULL_Check(14)

---------------------------------------------------------------------------------------------------
/*5.Create inline function that takes integer which represents manager ID and displays
department name, Manager Name and hiring date */
Create Function Get_Manager_Info (@id int)
returns table 
as 
return
(
	select Department.Dept_Name , Instructor.Ins_Name , Department.Manager_hiredate 
	from Instructor inner join Department
	on Instructor.Ins_Id = Department.Dept_Manager and Department.Dept_Manager = @id
)
select * from dbo.Get_Manager_Info(1)
-----------------------------------------------------------------------------------------------
/*6.Create multi-statements table-valued function that takes a string
If string='first name' returns student first name
If string='last name' returns student last name 
If string='full name' returns Full Name from student table 
Note: Use “ISNULL” function
*/
Create function Get_name_via_keyword (@Keyword varchar(20))
returns @t table
	(
		[Student_Name] varchar(50)
	)
as 
Begin 
	if @Keyword = 'first name' or @Keyword = 'first' or @Keyword = 'fname'
		begin
			insert into @t
			select Student.St_Fname
			from Student
		end
	else if @Keyword = 'last name' or @Keyword = 'last' or @Keyword = 'lname'
		begin
			insert into @t
			select Student.St_Lname
			from Student
		end
	else if @Keyword = 'Full name' or @Keyword = 'Full' or @Keyword = 'name'
		begin
			insert into @t
			select concat_ws(' ' , Student.St_Fname ,Student.St_Lname)  
			from Student
		end 
	
	return  
End

select * from dbo.Get_name_via_keyword('last')
-------------------------------------------------------------------------------------------------
/*7.Write a query that returns the Student No and Student first name without the last char*/
select student.St_Id ,     
	   case  
	   when St_Fname IS NOT NULL Then SUBSTRING(St_Fname , 1 , Len(St_Fname) -1 ) /*ISNULL , Lenght*/
	   when St_Fname IS NULL Then 'Name is Unknown'
	   end as St_Fname_withoutLastChar 
from Student

--------------------------------------------------------------------------------------------------
/*8.Write query to delete all grades for the students Located in SD Department */


delete Stud_Course
from Student  inner join Department
on Department.Dept_Id = Student.Dept_Id and Department.Dept_Name = 'SD'
inner join Stud_Course
on Student.St_Id = Stud_Course.St_Id

select * from Stud_Course
where St_Id in (1,2,3,4,5)
----------------------------------------------------------------------------------------------------











