/*1.Retrieve number of students who have a value in their age. */
select count(Student.St_Age) as NO_Student_that_have_Age
from Student

---------------------------------------------------------------------------------
/*2.Get all instructors Names without repetition*/
select Distinct Instructor.Ins_Name
from Instructor
--------------------------------------------------------------------------------
/*3.Display student with the following Format (use isNull function)*
StudentID -- Student Full Name -- Department Name 
*/
select Student.St_Id ,
	  Concat_Ws(' ' , Student.St_Fname , Student.St_Lname ) as Stud_FullName,
      isnull(Department.Dept_Name , ' ' ) as Dept_Name
from Student inner join Department
on Department.Dept_Id = Student.Dept_Id


--------------------------------------------------------------------------------
/*4.Display instructor Name and Department Name 
Note: display all the instructors if they are attached to a department or not */

select Instructor.Ins_Name , Department.Dept_Name
from Instructor left outer join Department
on Department.Dept_Id = Instructor.Dept_Id
--------------------------------------------------------------------------------
/*5.Display student full name and the name of the course 
he is taking For only courses which have a grade  
*/
select CONCAT_WS( ' ' , Student.St_Fname , Student.St_Lname) as Student_FullName 
	  , Course.Crs_Name

from Student inner join Stud_Course
on Student.St_Id = Stud_Course.St_Id and Stud_Course.Grade is not NULL 
inner join Course
on Course.Crs_Id = Stud_Course.Crs_Id
-------------------------------------------------------------------------------
/*6.Display number of courses for each topic name*/

select  Topic.Top_Name , count(Crs_id) as Number_of_courses 
from Topic inner join Course
on Topic.Top_Id = Course.Top_Id
group by Topic.Top_Name
-------------------------------------------------------------------------------
/*7.Display max and min salary for instructors*/

select MAX(Instructor.Salary) as max_Inst_Salary ,
	   MIN(Instructor.Salary) as min_Inst_Salary
from Instructor
-------------------------------------------------------------------------------
/*8.Display instructors who have salaries less than the average salary of all instructors.*/
select * 
from Instructor
where Instructor.Salary < (select AVG(Instructor.Salary) from Instructor)
-------------------------------------------------------------------------------
/*9.Display the Department name that contains the instructor who receives the minimum salary.*/

select MIN(Instructor.Salary) as Min_Inst_Salary ,
	   Department.Dept_Name
from Instructor inner join Department
on Department.Dept_Id = Instructor.Dept_Id
group by Department.Dept_Name
having MIN(Instructor.Salary) = (select min(Instructor.Salary) from Instructor) 

select Department.Dept_Name
from Instructor inner join Department
on Department.Dept_Id = Instructor.Dept_Id
where Instructor.Salary = (select min(Instructor.Salary) from Instructor)
--------------------------------------------------------------------------------
/*10.Select max two salaries in instructor table. */
---- using subquery ----
select Max(Instructor.Salary) as Max_2_inst_salary 
from Instructor
union all
select Max(Instructor.Salary)  
from Instructor
where Instructor.Salary< (select Max(Instructor.Salary)  from Instructor)
------ using top with ordering ------

select top(2) *
from Instructor
order by Instructor.Salary desc

------ using Ranking Functions ( Dense rank ) -----
select * 
from (
select * , DENSE_RANK() over (order by Instructor.Salary desc) as DR
from Instructor ) as temp_table 
where DR in (1 , 2)
----------------------------------------------------------------------------
/*11.Select instructor name and his salary but if there is no salary 
display instructor bonus keyword. “use coalesce Function”*/
select Instructor.Ins_Name , 
	   Coalesce(convert(varchar(10) ,Instructor.Salary) ,'Instructor Bonus')

from Instructor
------------------------------------------------------------------------------
/*12.Select Average Salary for instructors */
select AVG(Instructor.salary) as Avg_Inst_Salary
from Instructor

-------------------------------------------------------------------------------
/*13.Select Student first name and the data of his supervisor */
select x.St_Fname , super.*
from Student x inner join Student super
on super.St_Id = x.St_super
-------------------------------------------------------------------------------
/*14.Write a query to select the highest two salaries in Each Department 
for instructors who have salaries. “using one of Ranking Functions”*/
select * 
from (
		select * , 
			   DENSE_RANK() over (partition by instructor.Dept_Id order by Instructor.Salary Desc) as  DR 
		from Instructor
		where Instructor.Salary is not null ) as temp_table 
where DR in (1 , 2)

-------------------------------------------------------------------------------
/*15.Write a query to select a random student from each department.
“using one of Ranking Functions”*/
select * 
from (
		select * , DENSE_RANK() over (partition by Student.Dept_Id order by newid()) as DR 
		from Student
		where Student.Dept_Id is not NULL ) as temp_table
where DR = 1 

---------------------------------------------------------------------------------

