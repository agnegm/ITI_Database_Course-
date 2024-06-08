
/*1.Create index on column (Hiredate) that allow u to cluster the data in table Department.
What will happen?*/

create nonclustered index indx_1 on Department(Manager_hiredate) 

select * 
from Department
where Manager_hiredate = '1-1-2000'
-----------------------------------------------------------------------------------------
/*2.Create index that allow u to enter unique ages in student table. What will happen? */
alter schema dbo transfer Stud_Access.Student

Create Unique Index indeeex on Student(St_Age)

select * from Student
where St_Age = 24

------------------------------------------------------------------------------------------
/*3.Try to Create Login Named(ITIStud) who can access Only student and Course tables
from ITI DB then allow him to select and insert data into tables and deny Delete and update
.(Use ITI DB)*/

Create Schema Stud_Access 

alter Schema Stud_Access Transfer Student

alter Schema Stud_Access Transfer Course

