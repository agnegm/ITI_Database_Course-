use SD
/*1)Create view named   “v_clerk” that will display employee#,project#, 
the date of hiring of all the jobs of the type 'Clerk'.*/
create view v_clerk
as
	select  E.Emp_Num , CONCAT_WS(' ', E.Emp_Fname , E.Emp_Lname) as Emp_Name ,
			P.Project_Num, P.Project_Name ,
			W.Enter_Date as Hiring_Date
	from HumanResource.Employee E 
	inner join Works_On W
	on E.Emp_Num = w.Emp_Num
	inner join Company.Project P
	on P.Project_Num = W.Project_Num and W.Job = 'Clerk'

select * from v_clerk
-------------------------------------------------------------------------------
/*2) Create view named  “v_without_budget” that will display 
all the projects data  without budget */
create view v_without_budget
as
	select P.Project_Name , p.Project_Num 
	from Company.Project P

select * from v_without_budget 
-------------------------------------------------------------------------------
/*3)Create view named  “v_count 
“ that will display the project name and the # of jobs in it */
create view v_count
as
	select P.Project_Name , count(W.job) as Number_of_Jobs 
	from Company.Project P 
	inner join Works_On  W
	on P.Project_Num = W.Project_Num
	group by P.Project_Name

select * from v_count
-------------------------------------------------------------------------------
/*
4) Create view named ” v_project_p2” that will display the emp# 
for the project# ‘p2’ use the previously created view  “v_clerk”

*/
create view v_project_2 
as 
	select v.Emp_Num 
	from v_clerk V
	where V.Project_Num = 'p2'

select * from v_project_2

------------------------------------------------------------------------------
/*5)modifey the view named  “v_without_budget”  
to display all DATA in project p1 and p2  */
alter view v_without_budget
as
	select P.Project_Name , p.Project_Num 
	from Company.Project P
	where P.Project_Num in ('p1','p2')

select * from v_without_budget 
-------------------------------------------------------------------------------
/*6)Delete the views  “v_ clerk” and “v_count”*/
drop view v_clerk
drop view v_count
-------------------------------------------------------------------------------
/*7)Create view that will display 
the emp# and emp lastname who works on dept# is ‘d2’*/
Create view Emp_in_d2 
as 
	select E.Emp_Num , E.Emp_Lname 
	from Company.Department D
	inner join HumanResource.Employee E
	on D.Dept_Num = E.Dept_Num and D.Dept_Num = 'd2'

select * from Emp_in_d2

-------------------------------------------------------------------------------
/*8)Display the employee  lastname that contains letter “J”
	Use the previous view created in Q#7 */
	
select * 
from Emp_in_d2 V
where V.Emp_Lname like '%j%'
-----------------------------------------------------------------------------
/*9)Create view named “v_dept” that will
display the department# and department name.*/
create view v_dept
as 
	select  D.Dept_Num , D.Dept_Name
	from Company.Department D

select * from v_dept
-----------------------------------------------------------------------------
/*10)using the previous view try enter new department data 
where dept# is ’d4’ and dept name is ‘Development’
*/
insert into v_dept (Dept_Num , Dept_Name)
values ('d4' , 'Developement')

select * from v_dept

----------------------------------------------------------------------------------
/*
11)	Create view name “v_2006_check” that will 
display employee#, the project #where he works 
and the date of joining the project which must be from 
the first of January and the last of December 2006.
*/
create view v_2006_check
as
	select W.Emp_Num , W.Project_Num , W.Enter_Date
	from Works_On W
	where W.Enter_Date between '1-1-2006' and '12-31-2006'

select * from v_2006_check




