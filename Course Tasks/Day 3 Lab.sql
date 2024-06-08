/*1. Display the Department id, name and id 
and the name of its manager.*/
select Departments.Dnum , Departments.Dname ,
Employee.SSN , Concat_ws(' ', Employee.Fname , Employee.Lname) as MGR_Full_name
from Departments inner join Employee
on Employee.SSN = Departments.MGRSSN


/*2. Display the name of the departments and the name of the projects under its control.*/
select Departments.Dname , Project.Pname
from Departments inner join Project
on Departments.Dnum = Project.Dnum


/*3. Display the full data about all the dependence associated 
with the name of the employee they depend on him/her.*/

select Dependent.* ,Concat_ws(' ', Employee.Fname , Employee.Lname) as Parent_Full_name
from Employee inner join Dependent
on Employee.SSN = Dependent.ESSN



/*4. Display the Id, name and location of the projects in Cairo or Alex city.*/
select Project.Pnumber , Project.Pname , Project.Plocation
from Project
where Project.City in ( 'Cairo' , 'Alex' )




/*5.Display the Projects full data of the projects with a name starts with "a" letter.*/
select * 
from Project
where Project.Pname like 'a%'




/*6. display all the employees in department 30 whose salary from 1000 to 2000 LE monthly*/
select *
from Employee
where Employee.Dno = 30 and Employee.Salary  between 1000 and 2000
/* joins can be used */
select *
from Employee inner join Departments
on Departments.Dnum = Employee.Dno and  Employee.Dno = 30 and Employee.Salary  between 1000 and 2000



/*7. Retrieve the names of all employees in department 10 who works 
more than or equal10 hours per week on "AL Rabwah" project.*/

select Concat_ws(' ', Employee.Fname , Employee.Lname) as Emp_Full_Name
from Employee inner join Departments
on Departments.Dnum = Employee.Dno and Employee.Dno = 10
inner join Works_for
on Employee.SSN = Works_for.ESSn and Works_for.Hours >= 10 
inner join Project
on Project.Pnumber= Works_for.Pno and Project.Pname = 'Al Rabwah'



/*8. Find the names of the employees who directly supervised with Kamel Mohamed.*/
/*without Joins*/
select Concat_ws(' ', Employee.Fname , Employee.Lname) as Supervised_emp_Full_name
from Employee
where Employee.Superssn = 223344


/*with Joins*/
select  Concat_ws(' ', Y.Fname , Y.Lname) as Supervised_emp_Full_name
from Employee Y inner join Employee x 
on Y.Superssn = X.SSN and x.Fname+' '+x.Lname = 'Kamel Mohamed'



/*9. Retrieve the names of all employees and the names of the projects
they are working on, sorted by the project name.*/

select concat_ws(' ', Employee.Fname , Employee.Lname) as Emp_Full_name , Project.Pname
from Employee inner join Works_for
on Employee.SSN = Works_for.ESSn
inner join Project
on Project.Pnumber = Works_for.Pno
order by Project.Pname 



/*10. For each project located in Cairo City , find the project number, 
the controlling department name ,the department manager last name ,address and birthdate.*/

select Project.Pnumber , Departments.Dname , Employee.Lname , Employee.Address , Employee.Bdate
from Project inner join Departments
on Departments.Dnum = Project.Dnum and Project.City = 'Cairo'
inner join Employee
on Employee.SSN = Departments.MGRSSN

select * from project

/*11. Display All Data of the managers*/
select Employee.* 
from Employee inner join  Departments
on Employee.SSN = Departments.MGRSSN

/*12. Display All Employees data and the data of
their dependents even if they have no dependents*/
select * 
from Employee left outer join Dependent
on Employee.SSN = Dependent.ESSN


/*13.Insert your personal data to the employee table
as a new employee in department number 30, SSN = 102672, Superssn = 112233, salary=3000.*/
insert into Employee (Fname , Lname , Dno , SSN , Superssn , Salary , Address , Bdate , Sex )
values ('Ahmed' , 'Negm' , '30' , '102672' , 112233 , 3000 , 'Tala' , '4-23-1999' , 'M')

select * from Employee

/*14.Insert another employee with personal data your friend as new employee in department number 30
, SSN = 102660, but don’t enter any value for salary or supervisor number to him.*/
insert into Employee ( Fname , Lname , Dno , SSN , Address , Bdate , Sex)
values ('Mahmoud' , 'Shabaan' , 30 , 102660 , 'Tala', '9-25-1999', 'M')

select * from Employee

/*15.Upgrade your salary by 20 % of its last value.*/
update Employee
set Salary = Salary + (Salary * 0.2)
where Employee.SSN = 102672

select * from Employee

