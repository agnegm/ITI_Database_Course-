
-------------------------------- ITI _ Stud _ User ------------------------------

select * from Stud_Access.Course			-- No Permission Error 
select * from Stud_Access.Student			-- No Permission Error 

insert into Stud_Access.Student(St_Id)
values(100)									-- No Permission Error

insert into Stud_Access.Course(Crs_Id)
values(1111)								-- No Permission Error 

update Stud_Access.Student
set St_Age = St_Age +1						-- Permission Error 


update Stud_Access.Course
set Crs_Duration = Crs_Duration +1			-- Permission Error 


delete from Stud_Access.Student
where St_Age = 20							-- Permission Error 


delete from Stud_Access.Course
where Crs_Duration = 20						-- Permission Error 