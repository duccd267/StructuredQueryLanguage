--Ôn tập bài thực hành 2
--Chu Đình Đức - 20194021
use QLCONGTY_CHUDINHDUC
--IV. Viết các câu lệnh SQL thực hiện các truy vấn sau
--3. Tìm những nhân viên (MaNV_MSSV, TenNhanvien) có khả năng thực hiện tất cả các dự án được phân công
select nv.MaNV_4021, nv.Hoten_NV_4021
from NHANVIEN_DucCD nv, PHANCONG_DucCD pc
where nv.MaNV_4021 = pc.MaNV_4021
group by nv.MaNV_4021, nv.Hoten_NV_4021
having sum(pc.Songaycong_4021) <= 30

--2.Tìm mã, tên nhân viên, số dự án tham gia và tổng lương các dự án của mỗi nhân viên
select nv.MaNV_4021, nv.Hoten_NV_4021, count(pc.MaNV_4021) as [So du an tham gia],
sum(cv.Luongchucvu_4021*pc.Songaycong_4021) as [Tong luong]
from NHANVIEN_DucCD nv, CHUCVU_DucCD cv, PHANCONG_DucCD pc
where nv.MaCV_4021 = cv.Machucvu_4021
and nv.MaNV_4021 = pc.MaNV_4021
group by nv.MaNV_4021, nv.Hoten_NV_4021

--1. Tìm các nhân viên đang thực hiện dự án Mã “DA05”  (Tenduan_MSSV, Tien luong = songaycong*Luongchucvu)
select nv.Hoten_NV_4021, pc.Songaycong_4021*cv.Luongchucvu_4021 as [Tien luong]
from NHANVIEN_DucCD nv, CHUCVU_DucCD cv, PHANCONG_DucCD pc
where nv.MaNV_4021 = pc.MaNV_4021
and nv.MaCV_4021 = cv.Machucvu_4021
and pc.MaDA_4021 = 'DA05'

--III. Nhập dữ liệu cho các bảng (Mỗi bảng ít nhất 5 bản ghi)
--Dữ liệu bảng PHANCONG_DucCD
insert into PHANCONG_DucCD(MaNV_4021,MaDA_4021,Songaycong_4021)
values ('NV003','DA02',10),
('NV003','DA03',10),
('NV004','DA02',24),
('NV004','DA03',24),
('NV005','DA02',10),
('NV005','DA03',10),
('NV005','DA04',10),
('NV005','DA05',10),
('NV006','DA02',24)

--Dữ liệu bảng NHANVIEN_DucCD
insert into NHANVIEN_DucCD(MaNV_4021,Hoten_NV_4021,Ngaysinh_4021,Gioitinh_4021,MaPB_4021,MaCV_4021)
values ('NV003',N'NGUEN VAN NAM','1992-10-15 00:00','Nam','KHMT','GV-TS'),
('NV004',N'NGUYEN LAN HUONG','1992-01-01 00:00','Nữ','KHMT','GD'),
('NV005',N'DINH THU HANG','1992-01-01 00:00','Nữ','KTMT','TBM'),
('NV006',N'TRAN NAM ANH','1992-01-01 00:00','Nam','KTMT','PTBM'),
('NV008',N'NGUYEN THI THU','1992-01-01 00:00','Nữ','TTM','PV')

--Dữ liệu bảng DUAN_DucCD
insert into DUAN_DucCD(MaDA_4021,Tenduan_4021,Kinhphi_4021,Ngay_BD_4021,Ngay_KT_4021)
values ('DA02',N'QUAN LY THONG TIN CSVC',1500000,'2019-01-01','2021-01-01'),
('DA03',N'QUAN LY THONG TIN PHÒNG THÍ NGHIỆM',2000000,'2019-01-10','2021-01-10'),
('DA04',N'QUAN LY THONG TIN KHOA HOC CONG NGHE',2400000,'2019-01-10','2021-01-10'),
('DA05',N'QUAN LY THONG TIN SINH VIEN',2500000,'2019-09-05','2021-09-05'),
('DA06',N'QUAN LY THONG TIN DAOTAO',2600000,'2019-09-01','2021-09-01')

--Dữ liệu bảng PHONGBAN_DucCD
insert into PHONGBAN_DucCD(MaPhongBan_4021,TenPhongBan_4021,DiadiemPB_4021)
values ('CNPM',N'CONG NGHE PHAN MEM',N'B1-601'),
('HTTT',N'HE THONG THONG TIN',N'B1-603'),
('KHMT',N'KHOA HOC MAY TINH',N'B1-602'),
('KTMT',N'KY THUAT MAY TINH',N'B1-502'),
('TTM',N'TRUYEN THONG MANG',N'B1-501'),
('TTMT',N'TRUNG TÂM MÁY TÍNH',N'B1-401'),
('VPV',N'VAN PHÒNG VI?N',N'B1-504')

--Dữ liệu bảng CHUCVU_DucCD
insert into CHUCVU_DucCD(Machucvu_4021,Tenchucvu_4021,Luongchucvu_4021)
values ('GD',N'Giam doc',1000),
('GV-TS',N'Giang vien TS',900),
('GVthS',N'Giang vien ThS',700),
('PTBM',N'Pho Truong BM',800),
('PV',N'Can bo ky thuat',600),
('PVT',N'Vien pho',1200),
('TBM',N'Truong BM',1000)

--II. Hãy thực hiện các ràng buộc toàn vẹn sau
--3. Ngày kết thúc sau ngày bắt đầu 2 năm
alter table DUAN_DucCD
add check (year(Ngay_KT_4021) - year(Ngay_BD_4021) >= 2) 

--2. Lương chức vụ >500 và <1500
alter table CHUCVU_DucCD
add check (Luongchucvu_4021 > 500 and Luongchucvu_4021 < 1500)

--1. Nhân viên có tuổi từ 25 trở lên, giới tính gồm Nam, Nữ
alter table NHANVIEN_DucCD
add CHECK (year(getdate())-year(Ngaysinh_4021)>=25)
alter table NHANVIEN_DucCD
add CHECK (Gioitinh_4021 = 'Nam' or Gioitinh_4021 = 'Nữ')

--I. Tạo cơ cở dữ liệu
--6. Tạo bảng PHANCONG_DucCD
create table PHANCONG_DucCD(
MaNV_4021 varchar(5),
MaDA_4021 varchar(5),
Songaycong_4021 int,
primary key (MaNV_4021, MaDA_4021)
)

--5. Tạo bảng DUAN_DucCD
create table DUAN_DucCD(
MaDA_4021 varchar(5) primary key,
Tenduan_4021 nvarchar(200),
Kinhphi_4021 int,
Ngay_BD_4021 smalldatetime,
Ngay_KT_4021 smalldatetime
)

--4. Tạo bảng PHONGBAN_DucCD
create table PHONGBAN_DucCD(
MaPhongBan_4021 varchar(5) primary key,
TenPhongBan_4021 nvarchar(25),
DiadiemPB_4021 nvarchar(25)
)

--3. Tạo bảng CHUCVU_DucCD
create table CHUCVU_DucCD(
Machucvu_4021 varchar(5) primary key,
Tenchucvu_4021 nvarchar(5),
Luongchucvu_4021 int
)

--2. Tạo bảng NHANVIEN_DucCD
create table NHANVIEN_DucCD(
MaNV_4021 varchar(5) primary key,
Hoten_NV_4021 nvarchar(25),
Ngaysinh_4021 smalldatetime,
Gioitinh_4021 char(5),
MaPB_4021 varchar(5),
MaCV_4021 varchar(5),
foreign key (MaPB_4021) references PHONGBAN_DucCD(MaPhongBan_4021),
foreign key (MaCV_4021) references CHUCVU_DucCD(Machucvu_4021)  
)

--1. Tạo database QLCONGTY_CHUDINHDUC
create database QLCONGTY_CHUDINHDUC