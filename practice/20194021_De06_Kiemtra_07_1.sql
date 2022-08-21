--Bài kiểm tra thực hành
--Chu Đình Đức 20194021


--2. Hãy thực hiện các ràng buộc toàn vẹn sau
--2.4. Kho: Loại kho gồm: Điện lạnh, Nhựa, Điện dân dụng
alter table Kho_DucCD
add constraint CK4 CHECK
(
Loaikho_4021 in (N'Điện lạnh', N'Điện dân dụng', N'Nhựa')
)
--2.3. Chi tiết xuất kho: số lượng xuất từ 10 đến 1000
alter table ChitietXuatkho_DucCD
add constraint CK3 CHECK
(
soluongxuat_4021 between 10 and 1000
)

--2.2. Kho: HotenQLKho: Gồm (Hoàng Văn An, Ngô Văn Minh, Trần Thị Thủy)
alter table Kho_DucCD
add constraint CK2 CHECK
(
HotenQLkho_4021 in (N'Hoàng Văn An', N'Ngô Văn Minh', N'Trần Thị Thủy')
)
--2.1. Vattu: Donvitinh:Mét, bộ, Cuộn; Dongia tư 100 đến 10000
alter table Vattu_DucCD
add constraint CK1 CHECK
(
donvitinh_4021 in (N'Mét', N'bộ', N'Cuộn')
and Dongia_4021 between 100 and 10000
)

--1. Tạo Cơ sở dữ liệu
--1.1. Tạo Database
create database De06_ChuDinhDuc
use De06_ChuDinhDuc


--1.2. Tạo bảng Vattu_DucCD
create table Vattu_DucCD
(
MaVT_4021 varchar(10) primary key,
TenVT_4021 nvarchar(100),
donvitinh_4021 nvarchar(20),
dongia_4021 int
)

--1.3. Tạo bảng Kho_DucCD
create table Kho_DucCD
(
Makho_4021 varchar(10) primary key,
Tenkho_4021 nvarchar(100),
Loaikho_4021 nvarchar(30),
HotenQLkho_4021 nvarchar(30)
)

--1.4. Tạo bảng Xuatkho_DucCD
create table Xuatkho_DucCD
(
MaXK_4021 varchar(10) primary key,
Makho_4021 varchar(10),
Ngaylap_4021 date,
constraint FK_Kho_DucCD foreign key (Makho_4021) references Kho_DucCD(Makho_4021)
)

--1.5. Tạo bảng ChitietXuatkho
create table ChitietXuatkho_DucCD
(
MaXK_4021 varchar(10),
MaVT_4021 varchar(10),
soluongxuat_4021 int,
constraint PK_ChitietXuatkho primary key (MaXK_4021, MaVT_4021),
constraint FK_Xuatkho_DucCD foreign key (MaXK_4021) references Xuatkho_DucCD(MaXK_4021),
constraint FK_Vattu_DucCD foreign key (MaVT_4021) references Vattu_DucCD(MaVT_4021)
)
--Bài kiểm tra thực hành
--Chu Đình Đức 20194021

--5.Tạo Store procedure với các yêu cầu sau:
--5.2Thao tác insert bảngKhovới các dữ liệu như sau:
--(MK0008 –KhoVat tu Xay dungHà Nam Minh –123, Xây dựng,Ngô Văn Minh) 
create proc KhoInsert (@makho varchar(10), @tenkho nvarchar(100),@loaikho nvarchar(30), @hotenqlkho nvarchar(30))
as 
insert into Kho_DucCD
values (@makho, @tenkho, @loaikho, @hotenqlkho)

KhoInsert 'MK0008', N'-KhoVat tu Xay dungHà Nam Minh-123', N'Xây dựng', N'Ngô Văn Minh'

--5.1Thao tác select các Vật tư có Loại Vật tư “Điện lạnh”
create procedure  VattuSelect
as
begin 
	select vt.MaVT_4021, vt.TenVT_4021, vt.donvitinh_4021, vt.dongia_4021
	from Vattu_DucCD vt, Kho_DucCD k, Xuatkho_DucCD xk, ChitietXuatkho_DucCD ctxk
	where vt.MaVT_4021 = ctxk.MaVT_4021
		and ctxk.MaXK_4021 = xk.MaXK_4021
		and xk.Makho_4021 = k.Makho_4021
		and k.Loaikho_4021 like N'Điện lạnh%'
	group by vt.MaVT_4021, vt.TenVT_4021, vt.donvitinh_4021, vt.dongia_4021
end 
VattuSelect


--5.3Thao tác select thông tin về Kho có tổng số lượng xuất kho >=2400.
--Với các thông Makho, TenKho,tổng số lượngvật tư đã xuấttrong năm 2021.
create proc KhoSelect
as
begin 
	select  k.Makho_4021, k.Tenkho_4021, sum(ctxk.soluongxuat_4021) as tongsovattu
	from Kho_DucCD k, Xuatkho_DucCD xk, ChitietXuatkho_DucCD ctxk, Vattu_DucCD vt
	where vt.MaVT_4021 = ctxk.MaVT_4021
		and ctxk.MaXK_4021 = xk.MaXK_4021
		and xk.Makho_4021 = k.Makho_4021
		and year(xk.Ngaylap_4021) =2021 
	group by k.Makho_4021, k.Tenkho_4021
	having sum(ctxk.soluongxuat_4021) >= 2400
end
KhoSelect

--4. Viết các câu lệnh SQL thực hiện các truy vấn sau
--4.3. Đưa ra danh sáchMã kho, Tên kho, họ tên Quản lý kho với tổng số lượng xuất>=2000 thu được trong năm 2021
select k.Makho_4021, k.Tenkho_4021, k.HotenQLkho_4021, sum (ct.soluongxuat_4021) as [Tổng số lượng xuất]
from Kho_DucCD k, Vattu_DucCD vt, Xuatkho_DucCD xk, ChitietXuatkho_DucCD ct
where k.Makho_4021 = xk.Makho_4021
and xk.MaXK_4021 = ct.MaXK_4021
and ct.MaVT_4021 = vt.MaVT_4021
and year(xk.Ngaylap_4021) = 2021
group by k.Makho_4021, k.Tenkho_4021, k.HotenQLkho_4021

--4.2. Đưa ra kho có mã kho, tên kho, tổng số lượng xuất, tổng tiền thu đượccao nhất năm 2021
select top 1 k.Makho_4021, k.Tenkho_4021, ct.soluongxuat_4021, sum (vt.dongia_4021*ct.soluongxuat_4021) as [Tổng tiền thu được]
from Kho_DucCD k, Vattu_DucCD vt, Xuatkho_DucCD xk, ChitietXuatkho_DucCD ct
where k.Makho_4021 = xk.Makho_4021
and xk.MaXK_4021 = ct.MaXK_4021
and ct.MaVT_4021 = vt.MaVT_4021
and year(xk.Ngaylap_4021) = 2021
group by k.Makho_4021, k.Tenkho_4021, ct.soluongxuat_4021

--4.1. Đưa ra MaVT, tên Tên vật tư, số lượng xuất,tổng tiền thu đượccủa các loại kho có ‘Điện%’, trong tháng 12 năm 2021
select vt.MaVT_4021, vt.TenVT_4021, ct.soluongxuat_4021, sum (vt.dongia_4021*ct.soluongxuat_4021) as [Tổng tiền thu được]
from Kho_DucCD k, Vattu_DucCD vt, Xuatkho_DucCD xk, ChitietXuatkho_DucCD ct
where k.Makho_4021 = xk.Makho_4021
and xk.MaXK_4021 = ct.MaXK_4021
and ct.MaVT_4021 = vt.MaVT_4021
and month(xk.Ngaylap_4021) = 12 and year(xk.Ngaylap_4021) = 2021
and k.Loaikho_4021 like N'Điện %'
group by vt.MaVT_4021, vt.TenVT_4021, ct.soluongxuat_4021

--3. Nhập dữ liệu vào các bảng
--3.4. Nhâp dữ liệu bảng ChitietXuatkho_DucCD 
insert into ChitietXuatkho_DucCD
values ('XK001', 'UN004', 100),
('XK001', 'UN005', 200),
('XK001', 'UN006', 250),
('XK002', 'UN004', 120),
('XK002', 'UN005', 160),
('XK002', 'UN006', 190),
('XK003', 'UN004', 20),
('XK003', 'UN005', 60),
('XK003', 'UN006', 10),
('XK004', 'VT001', 120),
('XK004', 'VT002', 80),
('XK004', 'VT003', 150),
('XK005', 'VT001', 320),
('XK005', 'VT002', 180),
('XK005', 'VT003', 50),
('XK006', 'VT001', 620),
('XK006', 'VT002', 580),
('XK006', 'VT003', 450),
('XK007', 'UN005', 367),
('XK007', 'UN006', 567),
('XK007', 'VT001', 67),
('XK007', 'VT002', 87),
('XK008', 'UN004', 700),
('XK008', 'UN005', 367),
('XK008', 'VT002', 187),
('XK008', 'VT003', 367),
('XK009', 'UN005', 367),
('XK009', 'UN006', 400),
('XK009', 'VT001', 287),
('XK009', 'VT003', 367)
--3.3. Nhâp dữ liệu bảng Xuatkho_DucCD
insert into Xuatkho_DucCD
values ('XK001', 'MKN001', '2021-10-01'),
('XK002', 'MKN001', '2021-11-10'),
('XK003', 'MKN001', '2021-12-15'),
('XK004', 'MKD002', '2021-10-18'),
('XK005', 'MKD002', '2021-11-20'),
('XK006', 'MKD002', '2021-12-25'),
('XK007', 'MKD003', '2021-10-12'),
('XK008', 'MKD003', '2021-11-19'),
('XK009', 'MKD003', '2021-12-20')

--3.2. Nhâp dữ liệu bảng Kho_DucCD
insert into Kho_DucCD
values ('MKD002', N'Kho vật tư Công ty TNHH Điện Lạnh Hoa Mai', N'Điện lạnh', N'Ngô Văn Minh'),
('MKD003', N'Kho vật tư Công ty Điện- Nhựa Nam Hà', N'Điện dân dụng', N'Trần Thị Thủy'),
('MKN001', N'Kho vật tư Công ty TNHH Nhựa Tiền Phong', N'Nhựa', N'Hoàng Văn An')
--3.1. Nhâp dữ liệu bảng Vattu_DucCD
insert into Vattu_DucCD
values ('UN004', N'Ống nhựa tiền phong đường kính 20', N'Mét', 8900),
('UN005', N'Ống nhựa tiền phong đường kính 45', N'Cuộn', 1600),
('UN006', N'Ống nhựa tiền phong đường kính 10', N'bộ', 7200),
('VT001', N'Cáp đồng 2 ruột bọc cách điện XLPE', N'Mét', 1900),
('VT002', N'Cáp đồng đơn bọc cách điện XLPE', N'Cuộn', 1600),
('VT003', N'Cáp đồng 3 ruột bọc cách điện XLPE', N'bộ', 2900)
