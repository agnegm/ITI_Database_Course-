/*1.Display (Using Union Function)
a.	 The name and the gender of the dependence that's gender is Female and depending on Female Employee.
b.	 And the male dependence that depends on Male Employee.
*/
select Dependent.Dependent_name , Dependent.Sex 
from Employee inner join  Dependent
on Employee.SSN = Dependent.ESSN and Dependent.Sex ='F' and Employee.Sex = 'F'
union all 
select Dependent.Dependent_name , Dependent.Sex
from Employee inner join Dependent
on Employee.SSN = Dependent.ESSN and Dependent.Sex = 'M' and  Employee.Sex = 'M'

select * from Employee
select * from Dependent
--------------------------------------------------------------------------------------

/*2.For each project, list the project name and the total hours per week
(for all employees) spent on that project.*/
select Project.Pname , Sum(Works_for.Hours) as Total_hours
from Project inner join Works_for
on Project.Pnumber = Works_for.Pno
group by Project.Pname

select * from Works_for
select * from Project
--------------------------------------------------------------------------------------
/*3.Display the data of the department which has the smallest employee ID over all employees' ID.*/
select Departments.* 
from Departments inner join Employee
on Departments.Dnum = Employee.Dno 
and Employee.SSN = (select min(Employee.SSN) from Employee) /*another ?? */
--------------------------------------------------------------------------------------
/*4. For each department, retrieve the department name and the maximum, minimum and average
salary of its employees.*/
select Departments.Dname , MAX(Employee.salary) as Max_EmpSal 
						 , Min(Employee.salary) as Min_Empsal
						 , AVG(Employee.salary) as AVG_Empsal
from Employee inner join Departments
on Departments.Dnum = Employee.Dno
group by Departments.Dname
---------------------------------------------------------------------------------------
/*5.List the full name of all managers who have no dependents.*/
select concat_ws (' ' , Employee.Fname , Employee.Lname) as Manager_FullName
from Employee 
where Employee.SSN in (select Employee.SSN 
					  from Departments inner join Employee
					  on Employee.SSN = Departments.MGRSSN
					  except 
					  select Dependent.ESSN
					  from Dependent)

select*
from Departments inner join Employee
on Employee.SSN = Departments.MGRSSN

--------------------------------------------------------------------------------------
/*6.For each department-- if its average salary is less than the average salary 
of all employees-- display its number, name and number of its employees.*/
select AVG(Employee.Salary) as Deptartement_AVG_Salary ,
	   COUNT(Employee.SSN) as Employee_Numbers,
	   Departments.Dnum , Departments.Dname 
from Departments inner join Employee
on Departments.Dnum = Employee.Dno
group by Departments.Dnum ,Departments.Dname
having AVG(Employee.salary) < (select AVG(Employee.Salary) from Employee)

--------------------------------------------------------------------------------------
/*7.Retrieve a list of employees names and the projects names they are working on ordered by
department number and within each department, ordered alphabetically by last name, first name.*/

select CONCAT_WS(' ' , Employee.Fname , Employee.Lname) as Employee_FullName , 
	   Project.Pname , Project.Dnum
from Employee inner join Works_for
on Employee.SSN = Works_for.ESSn
inner join Project
on Project.Pnumber = Works_for.Pno
order by Project.Dnum , Employee_FullName

--------------------------------------------------------------------------------------
/*8.Try to get the max 2 salaries using subquery*/

Select MAX(Employee.Salary) as Max_2_EMP_Salaries from Employee
union all  
select MAX(Employee.Salary) 
from Employee
where Employee.Salary < (Select MAX(Employee.Salary) from Employee)

--------------------------------------------------------------------------------------
/*9.Get the full name of employees that is similar to any dependent name*/

select CONCAT_WS(' ' , Employee.Fname , Employee.Lname) 
from Employee

intersect

select Dependent.Dependent_name
From Dependent

---------------------------------------------------------------------------------------
/*10.Display the employee number and name if at least one of them have dependents 
(use exists keyword) self-study.*/
select Employee.SSN , CONCAT_WS(' ' , Employee.Fname , Employee.Lname) as Parent_Name
from Employee inner join Dependent
on Employee.SSN = Dependent.ESSN

select Employee.SSN ,  CONCAT_WS(' ' , Employee.Fname , Employee.Lname) as Parent_Name
from Employee 
where Exists (	select *
				from Employee inner join Dependent
				on Employee.SSN = Dependent.ESSN) 
----------------------------------------------------------------------------------------
/*11.In the department table insert new department called "DEPT IT" ,
with id 100, employee with SSN = 112233 as a manager for this department.
The start date for this manager is '1-11-2006'*/

insert into Departments ( Dname , Dnum , MGRSSN , [MGRStart Date])
values ( 'DEPT IT' , 100 , 112233 , '1-11-2006')

select * from Employee

update  Employee
set Employee.Dno = 100 
where Employee.SSN = 112233


select * 
from Employee inner join Departments
on Employee.SSN = Departments.MGRSSN

-----------------------------------------------------------------------------
/*12.Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  
moved to be the manager of the new department (id = 100), and they give you
(your SSN =102672) her position (Dept. 20 manager)
a.	First try to update her record in the department table
b.	Update your record to be department 20 manager.
c.	Update the data of employee number=102660 to be in your teamwork 
	(he will be supervised by you) (your SSN =102672)
*/
---------------------- Update Mrs Noha -------------------------
update Departments
set Departments.MGRSSN = 968574 
where Departments.Dnum = 100

update Employee
set Employee.Dno = 100 
where Employee.SSN = 968574

---------------------- Update My record  ------------------------- 
update Departments
set Departments.MGRSSN = 102672 
where Departments.Dnum = 20

update Employee
set Employee.Dno = 20 
where Employee.SSN = 102672
---------------------- Update the data of reecord 102660 ------------------------- 
update Employee
set Employee.Superssn = 102672 
where Employee.SSN = 102660
---------------------------------------------------
select * from Departments
select * from Employee




--------------------------------------------------------------------------------------
/*13.Unfortunately the company ended the contract with Mr. Kamel Mohamed (SSN=223344) 
so try to delete his data from your database in case you know 
that you will be temporarily in his position.
Hint: (Check if Mr. Kamel has dependents, 
works as a department manager, supervises any employees or works in any projects and handle these cases).
*/
select * from Employee
where Employee.SSN = 223344

------ delete Dependants ---------
select * from Dependent
delete from Dependent
where Dependent.ESSN = 223344

--------- update Management --------
select * from Departments
update Departments
set Departments.MGRSSN = 102672
where Departments.MGRSSN = 223344

---------- update Supervision -------
select * from Employee 
update Employee
set Employee.Superssn = 102672
where Employee.Superssn = 223344

---------- update Projects -----------
select * from Works_for
update Works_for 
set Works_for.ESSn = 102672
where Works_for.ESSn = 223344
-------------Delete Kamel ---------------
delete from Employee
where Employee.SSN = 223344

select * from Employee


-------------------------------------------------------------------------------------
/*14.Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%*/
update Employee
set Employee.Salary = Employee.Salary * 1.3
from Employee inner join Works_for
on Employee.SSN = Works_for.ESSn
inner join Project 
on Project.Pnumber = Works_for.Pno and Project.Pname = 'Al Rabwah'

select * from Employee