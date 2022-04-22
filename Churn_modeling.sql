create function Fn_CustomerDetails(@customerId int)
returns table
as 
begin
declare @active_member int;
set @active_member=(select IsActiveMember from Churn_Modelling where CustomerId = @customerId);
	if (@active_member = 1)
		select Surname,Gender,Age from Churn_Modelling where CustomerId = @customerId and IsActiveMember = 1
	else
		print 'Please Active the member'
return @active_member
end

--8276006896

select * from Churn_Modelling


alter function Fn_CustomerDetailsByLocation(@location varchar(50))
returns @table table (
	Surname varchar(50),
	Cradit_Score int,	
	Gender varchar(50),
	Estimated_Salary money
	)
as
begin
insert into @table
	select Surname,CreditScore, Gender, EstimatedSalary from Churn_Modelling where Geography=@location and IsActiveMember = 1
	return
end

select * from Fn_CustomerDetailsByLocation('Spain')


alter function Fn_CustomerDetails(@customerId int)
returns @table table 
	(
		Surname varchar(50),
		Gender varchar(50),	
		Age varchar(50)
	)
as 
begin
declare @active_member int;
declare @result varchar(50);
set @active_member=(select IsActiveMember from Churn_Modelling where CustomerId = @customerId);
	if @active_member = 1
		insert into @table
		select Surname,Gender,Age from Churn_Modelling where CustomerId = @customerId and IsActiveMember = 1;
	else
		insert into @table
		select Surname,Gender,Age from Churn_Modelling where CustomerId = @customerId and IsActiveMember = 0
return
end 

select * from Fn_CustomerDetails(324523400435245)


---Cursor-----
DECLARE @Customer_id int  
DECLARE @surname varchar(80)  
DECLARE @gender varchar(80)
DECLARE @geography varchar(80)
DECLARE @estimatedSalary decimal
DECLARE customerDetails_CURSOR CURSOR  
FOR  SELECT   CustomerId,surname,gender,geography,estimatedSalary FROM Churn_Modelling
OPEN  customerDetails_CURSOR 
FETCH NEXT FROM customerDetails_CURSOR INTO  @Customer_id,@surname,@gender,@geography, @estimatedSalary
WHILE @@FETCH_STATUS = 0  
BEGIN  
PRINT  'CUSTOMER_ID: ' +CAST(@Customer_id AS varchar) +  '  SURNAME:' +@surname +'  GENDER:' +@gender+  ' GEOGRAPHY:' +@geography+  'ESTIMATED SALARY:' +CAST(@estimatedSalary AS varchar)
FETCH NEXT FROM customerDetails_CURSOR INTO  @Customer_id,@surname,@gender,@geography,@estimatedSalary 
END  
CLOSE customerDetails_CURSOR  
DEALLOCATE customerDetails_CURSOR


---View-----
CREATE VIEW vCustomerDetails
 As
 select CustomerID,Surname,Geography,Age,Gender,IsActiveMember from Churn_Modelling

 SELECT * FROM vCustomerDetails


----Stored Procedure----
  create procedure sp_customerDetailsIDWise (@customerID as int)
  AS
  BEGIN try 
   SELECT   CustomerId,surname,gender,geography,estimatedSalary FROM Churn_Modelling
   where CustomerId = @customerID
  END try
  begin catch
	SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_STATE() AS ErrorState,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage;
  end catch

 execute sp_customerDetailsIDWise
 @customerID= 15701354



 create procedure getDBStatus
@DatabaseID int 
as
begin
declare @DBStatus varchar(20)
set @DBStatus=(select state_desc from sys.databases where database_id=@DatabaseID)
if @DBStatus='ONLINE'
Print ' Database is ONLINE'
else
Print 'Database is in ERROR state.'
End

exec getDBStatus 8

select * from contacts



set nocount on
declare @DBCount int
declare @i int =0
declare @DBName varchar(200)
declare @SQLCommand nvarchar(max)
create table #Databases (name varchar(200))
insert into #Databases select name from sys.databases where database_id>4 
set @DBCount=(select count(1) from #Databases)
WHILE (@DBCount>@i)
Begin
set @DBName=(select top 1 name from #Databases)
set @SQLCommand = 'Backup database [' +@DBName+'] to disk =''D:\Backup\' + @DBName +'.bak'''
Print @SQLCommand
delete from #Databases where name=@DBName
set @I=@i + 1
End


set nocount on
declare @DBCount int
declare @i int =0
declare @DBName varchar(200)
declare @SQLCommand nvarchar(max)
create table #Databases (name varchar(200))
insert into #Databases select name from sys.databases where database_id>4 
set @DBCount=(select count(1) from #Databases)
WHILE (@DBCount>@i)
Begin
set @DBName=(select top 1 name from #Databases)
set @SQLCommand = 'Backup database [' +@DBName+'] to disk =''D:\Backup\' + @DBName +'.bak'''
Print @SQLCommand
delete from #Databases where name=@DBName
set @I=@i + 1
End

select * from Churn_Modelling

alter proc sp_CustomerByLocation
	@location varchar (50),
	@active int

as
begin
	if (@active = 1)
		select MIN(NumOfProducts) as minProduct, MAX(NumOfProducts) as maxProduct, 
		COUNT(NumOfProducts) as TotalProducts 
		from Churn_Modelling
		where Geography=@location and IsActiveMember=@active 
	else
		select MIN(NumOfProducts) as minProduct, MAX(NumOfProducts) as maxProduct ,
		COUNT(NumOfProducts) as TotalProducts 
		from Churn_Modelling
end


exec sp_CustomerByLocation 'France',1
exec sp_CustomerByLocation 'France',0

alter procedure AgeByScore
(
	@location varchar(50),
	@age int,
	@active int
)
as 
begin 
if(@age = 18 and @age < 40)
	begin
		select Surname, Age,CreditScore, EstimatedSalary as Age_Salary
		from Churn_Modelling where Geography=@location and IsActiveMember=@active and Age=@age
	end
else if (@age > 40 and @age < 90 )
	begin
		select Surname, Age,CreditScore, EstimatedSalary as Age_Salary
		from Churn_Modelling where Geography=@location and IsActiveMember=@active and Age=@age
	end
else
	begin
		select Surname, Age,CreditScore, EstimatedSalary as Age_Salary 
		from Churn_Modelling where Geography=@location and IsActiveMember=@active
	end
end

exec AgeByScore 'France',18,1

select * from Churn_Modelling

create procedure Fn_AgeByDetails
(
	@location varchar (50),
	@age int,
	@active int,
	@gender varchar(50),
	@exited int
)
as
begin
if(@age = 18 and @age < 40)
	begin
		select Surname, Age,CreditScore, EstimatedSalary as Age_Salary
		from Churn_Modelling where Geography=@location and IsActiveMember=@active and Age=@age 
		and Gender=@gender and Exited=@exited
	end
else if (@age > 40 and @age < 90 )
	begin
		select Surname, Age,CreditScore, EstimatedSalary as Age_Salary
		from Churn_Modelling where Geography=@location and IsActiveMember=@active and Age=@age
		and Gender=@gender and Exited=@exited
	end
else
	begin
		select Surname, Age,CreditScore, EstimatedSalary as Age_Salary 
		from Churn_Modelling where Geography=@location and IsActiveMember=@active
	end
end

exec Fn_AgeByDetails
'France',18,1,'Male',1

select MAX(CreditScore)as MaxCraditScore , AVG(cast(EstimatedSalary as decimal)) as Avg_Salary 
from Churn_Modelling group by Gender

alter function GetTotaldata(@location varchar(50),@gender varchar(50))
RETURNS decimal
As
BEGIN
Declare @result decimal
select @result= sum(CAST(EstimatedSalary as decimal)) from Churn_Modelling where Geography=@location
and Gender=@gender

RETURN @result
END

select dbo.GetTotaldata('France','Male')



----Example(Leet177)----
CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
        /* Write your T-SQL query statement below. */
        SELECT TOP 1
        salary as SecondHighestSalary 
        FROM 
        (SELECT 1 as one) oneRow 
        LEFT JOIN 
        (
            SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) rn FROM Employee
        ) inq ON inq.rn = @N
    );
END

Solution2:

CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
        /* Write your T-SQL query statement below. */
        select salary 
        from (select 'temp' as one) o
        left join
        (select distinct salary 
            from employee
            order by salary desc
            offset @N -1 rows
            fetch next 1 rows only) e
    
        on e.salary is not null
    );
END
