--BÀI THỰC HÀNH 5
--Chu Đình Đức 20194021
--10.Đưa ra danh sách các mặt hàng chưa từng được đặt hàng
select ct.* 
from Sales.Customer ct left outer join Sales.SalesOrderHeader ord on ct.CustomerID = ord.CustomerID
--where ord.SalesOrderID = null
group by ct.AccountNumber, ct.CustomerID, ct.ModifiedDate, ct.PersonID,ct.rowguid,ct.StoreID, ct.TerritoryID
having count(ord.SalesOrderID)=0

--9. Đưa ra danh sách các khách hàng có trên 10 đơn hàng
select ct.*, count(ord.SalesOrderID) as numberorder
from Sales.Customer ct, Sales.SalesOrderHeader ord
where ct.CustomerID = ord.CustomerID
group by ct.AccountNumber, ct.CustomerID, ct.ModifiedDate, ct.PersonID,ct.rowguid,ct.StoreID, ct.TerritoryID
having count(ord.SalesOrderID)>10

--8. Hiển thị tổng số nhân viên từ bảng HumanResources.Employee 
select count (LoginID) as EmployeeNumber
from HumanResources.Employee

--7. Hiển thị trung bình của tỷ giá (Rate) từ bảng 
--HumanResources.EmployeePayHistory. 
select avg(Rate) as AverageRate
from HumanResources.EmployeePayHistory

--6. Hiển thị chi tiết của 10 bảng ghi đầu tiên của bảng Person.Address. 
select top 10 * 
from Person.Address

--5. Liệt kê tên của các thành phố từ bảng Person.Address và bỏ đi phần lặp lại. 
select distinct City 
from Person.Address

--4. Hiển thị chi tiết địa chỉ của tất cả các nhân viên trong bảng Person.Address 
select *
from Person.Address

--3. Hiển thị Title, FirstName, LastName như là một chuỗi nối nhằm dễ đọc và cung 
--cấp tiêu đề cho cột tên (PersonName). 
select concat(ps.Title,' ',ps.FirstName,' ',ps.LastName) as 'PersonName'
from Person.Person ps

--2. Hiển thị Title, FirstName, MiddleName, LastName và EmailAddress từ bảng 
--Person.Contact 
select ps.Title, ps.FirstName, ps.MiddleName, ps.LastName, e.EmailAddress
from Person.Person ps, Person.EmailAddress e
where ps.BusinessEntityID = e.BusinessEntityID

--1. Hiển thị chi tiết của tất cả mọi người từ bảng Person.Person
select * 
from Person.Person





