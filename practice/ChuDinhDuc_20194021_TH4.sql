-- Bài thực hành 4
-- Chu Đình Đức 20194021
use QLBONGDA_CHUDINHDUC
-- b. Bài tập về Trigger
-- b5. Khi thêm tên quốc gia, kiểm tra tên quốc gia không được trùng với tên quốc gia đã có
create trigger b5 on QUOCGIA_DUCCD
after insert
as begin
	declare @maqg varchar(5) , @tenqg nvarchar(60)
	select @maqg= MAQG_4021, @tenqg = TENQG_4021
	from inserted
	if @tenqg not in (select TENQG_4021
				from QUOCGIA_DUCCD)
		print N'Đã thêm quốc gia thành công'
	else 
		print N'Tên quốc gia không hợp lệ'
		rollback transaction;	 
		--delete from inserted where MACT_4004 = @mact
end
insert into QUOCGIA_DUCCD
values ( 'JP', N'Nhật Bản')
-- b4. Khi thêm cầu thủ mới, kiểm tra số lượng cầu thủ nước ngoài ở mỗi câu lạc bộ chỉ được 
-- phép đăng ký tối đa 8 cầu thủ
create trigger b4 on CAUTHU_DUCCD
after insert
as begin
	declare @mact numeric(18, 0), @maqg varchar(5), @maclb varchar(5)
	select @mact= MACT_4021, @maqg = MAQG_4021, @maclb =MACLB_4021
	from inserted
	if (@maqg = 'VN')
			print N'Đã thêm cầu thủ thành công'
	else 
		begin 
			if (select  count( ct.MACT_4021) as SoCauThu
			from CAULACBO_DUCCD clb, CAUTHU_DUCCD ct
			where clb.MACLB_4021 =	@maclb
				and ct.MACLB_4021 = @maclb
				and ct.MAQG_4021 <> 'VN'
			group by clb.MACLB_4021)=8
			begin
			print N'Đã đủ số lượng cầu thủ nước ngoài'
			rollback transaction	 
			end
			else
			print N'Đã thêm cầu thủ thành công'
		end
		--delete from inserted where MACT_4004 = @mact
end
insert into CAUTHU_DUCCD(HOTEN_4021, VITRI_4021, NGAYSINH_4021, DIACHI_4021, MACLB_4021, MAQG_4021,SO_4021)
values (N'Chu Dinh Duc', N'Thủ môn', 2001-07-26,null, 'GDT','VN',26)
drop trigger b4
-- b3. Khi thêm thông tin cầu thủ thì in ra câu thông báo bằng Tiếng Việt ‘Đã thêm cầu thủ mới’
create trigger b3 on CAUTHU_DUCCD
after insert
as begin
		print N'Đã thêm cầu thủ mới'
end
insert into CAUTHU_DUCCD(HOTEN_4021, VITRI_4021, NGAYSINH_4021, DIACHI_4021, MACLB_4021, MAQG_4021,SO_4021)
values (N'Chu Dinh Duc', N'Thủ môn', 2001-07-26,null, 'GDT','VN',26)
drop trigger b3
-- b2. Khi thêm cầu thủ mới, kiểm tra số áo của cầu thủ thuộc cùng một câu lạc bộ phải khác nhau
create trigger b2 on CAUTHU_DUCCD
after insert
as begin
	declare @mact numeric(18, 0) , @so int
	select @mact= MACT_4021, @so = SO_4021
	from inserted
	if @so not in (select SO_4021
				from CAUTHU_DUCCD)
		print N'Đã thêm cầu thủ thành công'
	else 
		print N'Số áo không hợp lệ'
		rollback transaction;	 
		--delete from inserted where MACT_4004 = @mact
end
insert into CAUTHU_DUCCD(HOTEN_4021, VITRI_4021, NGAYSINH_4021, DIACHI_4021, MACLB_4021, MAQG_4021,SO_4021)
values (N'Chu Dinh Duc', N'Thủ môn', 2001-07-26,null, 'GDT','VN',26)
drop trigger b2
-- b1. Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cầu thủ chỉ thuộc một trong các vị trí sau: 
-- Thủ môn, Tiền đạo, Tiền vệ, Trung vệ, Hậu vệ.
alter trigger b1 on CAUTHU_DUCCD
after insert
as begin
	declare @mact numeric(18, 0) , @vitri nvarchar(20)
	select @mact= MACT_4021, @vitri = VITRI_4021
	from inserted
	if @vitri in (N'Thủ môn', N'Tiền đạo', N'Tiền vệ', N'Trung vệ', N'Hậu vệ')
		print N'Đã thêm cầu thủ thành công'
	else 
		print N'Vị trí không hợp lệ'
		rollback transaction;	 
end
-- drop trigger b1
insert into CAUTHU_DUCCD(HOTEN_4021, VITRI_4021, NGAYSINH_4021, DIACHI_4021, MACLB_4021, MAQG_4021,SO_4021)
values (N'Chu Dinh Duc', N'Thủmôn', 2001-07-26,null, 'GDT','VN',26)
-- a.Bài tập về Store Procedure
-- a8. Ứng với mỗi bảng trong CSDL QLBongDa, bạn hãy viết 4 stored Procedure 
-- ứng với 4 công việc Insert/Update/Delete/Select.
-- Trong đó Stored procedure update và delete lấy khóa chính làm tham số  
-- a8.5. HLVCLB
-- a8.5.4 Delete
create proc a854(@mahlv varchar(5), @maclb varchar(5))
as begin  
	delete
	from HLV_CLB_DUCCD
	where MAHLV_4021 =@mahlv 
	and MACLB_4021 = @maclb
end
a854 'HLV08', 'CDD'
a851
-- a8.5.3 Update
create proc a853(@mahlv varchar(5), @maclb varchar(5), @vaitro nvarchar(100))
as begin  
	update HLV_CLB_DUCCD
	set VAITRO_4021 = @vaitro
	where MAHLV_4021 =@mahlv 
	and MACLB_4021 = @maclb
end
a853 'HLV08', 'CDD', N'HLV Thủ môn'
a851
-- a8.5.2 Insert
create proc a852(@mahlv varchar(5), @maclb varchar(5), @vaitro nvarchar(100))
as  
	insert into HLV_CLB_DUCCD
	values (@mahlv, @maclb, @vaitro) 

a842 'CDD', N'Team CDD', 'LA','LA'
a852 'HLV08', 'CDD', N'HLV Chính'
a851


-- a8.5.1 Select
create proc a851
as 
	select * from HLV_CLB_DUCCD
-- drop procedure a851
a851
-- a8.4. CLB
-- a8.4.4 Delete
create proc a844(@maclb varchar(5))
as begin  
	delete
	from CAULACBO_DUCCD
	where MACLB_4021 = @maclb
end
a844 'CDD'
a841
-- a8.4.3 Update
create proc a843(@maclb varchar(5), @tenclb nvarchar(100), @masan varchar(5), @matinh varchar(5))
as begin  
	update CAULACBO_DUCCD
	set TENCLB_4021 = @tenclb,
	MASAN_4021 = @masan,
	MATINH_4021 = @matinh
	where MACLB_4021 = @maclb
end
a843 'CDD', N'Chu Dinh Duc 2', 'CL','KH'
a841
-- a8.4.2 Insert
create proc a842(@maclb varchar(5), @tenclb nvarchar(100), @masan varchar(5), @matinh varchar(5))
as  
	insert into CAULACBO_DUCCD
	values (@maclb, @tenclb, @masan, @matinh) 

a842 'CDD', N'Chu Dinh Duc', 'NT','KH'
a841
-- a8.4.1 Select
create proc a841
as 
	select * from CAULACBO_DUCCD
-- drop procedure a841
a841

-- a8.3. HLV
-- a8.3.4 Delete
create proc a834(@mahlv varchar(5))
as begin  
	delete
	from HUANLUYENVIEN_DUCCD
	where MAHLV_4021 = @mahlv
end
a834 'HLV09'
a831
-- a8.3.3 Update
create proc a833(@mahlv varchar(5), @tenhlv nvarchar(100), 
			@ngaysinh datetime, @diachi nvarchar(200), @dienthoai nvarchar(20), @magq varchar(5))
as begin  
	update HUANLUYENVIEN_DUCCD
	set TENHLV_4021 = @tenhlv,
	NGAYSINH_4021 = @ngaysinh,
	DIACHI_4021 =@diachi,
	DIENTHOAI_4021 = @dienthoai,
	MAQG_4021 = @magq
	where MAHLV_4021 = @mahlv
end
a833 'HLV09', N'Chu Dinh Duc Duc', null, null, N'9999', 'VN'
a831
-- a8.3.2 Insert
create proc a832(@mahlv varchar(5), @tenhlv nvarchar(100), 
			@ngaysinh datetime, @diachi nvarchar(200), @dienthoai nvarchar(20), @magq varchar(5))
as  
	insert into HUANLUYENVIEN_DUCCD
	values (@mahlv, @tenhlv, @ngaysinh, @diachi, @dienthoai, @magq) 

a832 'HLV09', N'Chu Dinh Duc', null, null, null, 'VN'
a831
-- a8.3.1 Select
create proc a831
as 
	select * from HUANLUYENVIEN_DUCCD
-- drop procedure a831
a831
-- a8.2. CT
-- a8.2.4 Delete
create proc a824(@mact numeric(18, 0))
as begin  
	delete
	from CAUTHU_DUCCD
	where MACT_4021 = @mact
	end
a824 25
a821
-- a8.2.3 Update
create proc a823(@mact numeric(18, 0),@hoten nvarchar(100),@vitri nvarchar(20),
			@ngaysinh datetime,@diachi nvarchar(200),@maclb varchar(5),@maqg varchar(5),@so int)
as
begin  
	update CAUTHU_DUCCD
	set HOTEN_4021 =@hoten,
	VITRI_4021 = @vitri,
	NGAYSINH_4021 = @ngaysinh,
	DIACHI_4021 = @diachi,
	MACLB_4021 = @maclb,
	MAQG_4021 = @maqg,
	SO_4021 = @so
	where MACT_4021 =@mact
end
a823 25, N'Chu Dinh Ducc', N'Tiền đạo', null, null, 'GDT', 'VN', 7
a821

-- a8.2.2 Insert
create proc a822(@hoten nvarchar(100),@vitri nvarchar(20),
			@ngaysinh datetime,@diachi nvarchar(200),@maclb varchar(5),@maqg varchar(5),@so int)
as  
	insert into CAUTHU_DUCCD
	values (@hoten, @vitri, @ngaysinh, @diachi, @maclb, @maqg, @so) 

a822 N'Chu Dinh Ducc', N'Thủ môn', null, null, 'BBD', 'VN', 26
a821

-- a8.2.1 Select
create proc a821
as 
	select * from CAUTHU_DUCCD
-- drop procedure a821
a821

-- a8.1. QG
-- a8.1.4 Delete
create proc a814(@maqg varchar(5))
as
begin  
	delete
	from QUOCGIA_DUCCD
	where MAQG_4021 =@maqg 
end
a814 'JP'
a811

-- a8.1.3 Update
create proc a813(@maqg varchar(5), @tenqg nvarchar(30))
as
begin  
	update QUOCGIA_DUCCD
	set TENQG_4021 = @tenqg
	where MAQG_4021 =@maqg
end
a813 'JP', N'Nhật Bản 1'
a811

-- a8.1.2 Insert
create proc a812(@maqg varchar(5), @tenqg nvarchar(30))
as  
 insert into QUOCGIA_DUCCD
 values (@maqg, @tenqg) 

a812 'Y6', N'Italia'
a811
-- a8.1.1 Select
create proc a811
as 
	select * from QUOCGIA_DUCCD
-- drop procedure select_quocgia_th4a8
a811

-- a75. Cho biết tên tỉnh, số lượng câu thủ đang thi đấu ở vị trí
-- tiền đạo trong các câu lạc bộ thuộc địa bàn tỉnh đó quản lý
create procedure a75
as begin
	select t.TENTINH_4021, count(ct.MACT_4021) as [SL]  
	from TINH_DUCCD t, CAUTHU_DUCCD ct, CAULACBO_DUCCD clb
	where t.MATINH_4021 = clb.MATINH_4021
	and clb.MACLB_4021 = ct.MACLB_4021
	and ct.VITRI_4021 = N'Tiền Đạo'
	group by t.TENTINH_4021                                                   
end
execute a75
-- a74. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài 
-- (có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ nhiều hơn 2 cầu thủ nước ngoài 
alter procedure a74
as begin
	select clb.MACLB_4021, clb.TENCLB_4021, svd.TENSAN_4021, svd.DIACHI_4021, count(MACT_4021) as [SOLUONG] 
	from CAULACBO_DUCCD clb, SANVD_DUCCD svd, CAUTHU_DUCCD ct, QUOCGIA_DUCCD qg
	where clb.MASAN_4021 = svd.MASAN_4021
	and clb.MACLB_4021 = ct.MACLB_4021
	and ct.MAQG_4021 = qg.MAQG_4021
	and qg.TENQG_4021 <> N'Việt Nam'
	group by clb.MACLB_4021, clb.TENCLB_4021, svd.TENSAN_4021, svd.DIACHI_4021
	having count(MACT_4021) > 2
end
execute a74
-- a73. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò
-- và tên CLB đang làm việc của các huấn luyện viên có quốc tịch “Việt Nam” 
alter procedure a73
as begin
	select hlv.MAHLV_4021, hlv.TENHLV_4021, hlv.NGAYSINH_4021, hlv.DIACHI_4021, hc.VAITRO_4021, clb.TENCLB_4021
	from HUANLUYENVIEN_DUCCD hlv, HLV_CLB_DUCCD hc, CAULACBO_DUCCD clb, QUOCGIA_DUCCD qg
	where hlv.MAHLV_4021 = hc.MAHLV_4021
	and hc.MACLB_4021 = clb.MACLB_4021
	and hlv.MAQG_4021 = qg.MAQG_4021
	and qg.TENQG_4021 = N'Việt Nam'
end
execute a73
-- a72.  Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) 
-- các trận đấu vòng 3 của mùa bóng năm 2009
alter procedure a72
as begin
	select td.MATRAN_4021, td.NGAYTD_4021, svd.TENSAN_4021, clb1.TENCLB_4021, clb2.TENCLB_4021, td.KETQUA_4021
	from TRANDAU_DUCCD td, CAULACBO_DUCCD clb1, CAULACBO_DUCCD clb2, SANVD_DUCCD svd
	where td.MACLB1_4021 = clb1.MACLB_4021
	and td.MACLB2_4021 = clb2.MACLB_4021
	and td.MASAN_4021 = svd.MASAN_4021
	and td.VONG_4021 = 3
	and td.NAM_4021 = 2009
end
execute a72

-- a71. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của 
-- các cầu thủ thuộc đội bóng “SHB Đà Nẵng” có quốc tịch “Bra-xin” 
create procedure a71
as begin
	select ct.MACT_4021, ct.HOTEN_4021, ct.NGAYSINH_4021, ct.DIACHI_4021, ct.VITRI_4021
	from CAUTHU_DUCCD ct, CAULACBO_DUCCD clb, QUOCGIA_DUCCD qg
	where ct.MACLB_4021 = clb.MACLB_4021
	and ct.MAQG_4021 = qg.MAQG_4021
	and clb.TENCLB_4021 = N'SHB Đà Nẵng'
	and qg.TENQG_4021 = N'Bra-xin'
end
execute a71
-- a6. Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n
create procedure a6
@n int
as begin
	print N'Chu Dinh Duc 20194021';
	declare @sum int; set @sum = 0;
	declare @i int; set @i = 0; 
	declare @str nvarchar(1000); set @str = N'';
	while (@i <= @n)
		begin
		set @str = concat(@str, @i, ' ');
		set @sum = @sum + @i;
		set @i = @i + 2;
		end
	print concat(N'Các số chẵn từ 1 đến ', @n, N' là: ', @str);
	print concat(N'Tổng các số chẵn từ 1 đến ', @n, N' là: ', @sum);
end
exec a6 10
-- a5. Nhập vào số nguyên @n. In ra các số từ 1 đến @n
create procedure a5
@n int
as begin
	print N'Chu Dinh Duc 20194021';
	declare @i int; set @i = 1;
	print concat(N'Các số từ 1 đến ',@n, N' là: ');
	declare @str nvarchar(1000);
	while (@i <= @n)
		begin
		set @str = concat(@str, @i, ' ');
		set @i = @i + 1;
		end
	print @str;
end
exec a5 10
-- a4. Nhập vào 2 số @s1,@s2. Xuất min và max của chúng 
-- Cho thực thi và in giá trị của các tham số này để kiểm tra
create procedure a4
@s1 int, @s2 int
as begin
	declare @max int, @min int 
	print N'Chu Dinh Duc 20194021';
	if (@s1 < @s2)
		begin
		set @max = @s2;
		set @min = @s1;
		end
	else 
		begin
		set @max = @s1;
		set @min = @s2;
		end
print N'@max là: ' + cast(@max as nvarchar(10));
print N'@min là: ' + cast(@min as nvarchar(10));
end
exec a4 1, 2

-- a3. Nhập vào 2 số @s1,@s2. In ra câu “Tổng là : @tg’ với @tg = @s1+@s2 
create procedure a3
@s1 int, @s2 int, @tg int out
as
begin
print N'Chu Dinh Duc 20194021';
set @tg = @s1 + @s2
print N'Tổng là: 1 + 2 = ' + convert(nvarchar(10),@tg)
end
declare @sum int
exec a3 1, 2, @sum out
-- a2. In ra dòng chữ “ Xin chào” + @ten với @ten là tham số đầu vào là tên của bạn. 
-- Cho thực thi và in giá trị cảu các tham số này để kiểm tra
create procedure a2
as
begin
print N'Chu Dinh Duc 20194021';
declare @ten varchar(10)
set @ten = N'Duc'
print N'Xin chào ' + @ten
end
exec a2
-- a1. In ra dòng chữ “Xin Chao” 
create procedure a1
as
begin
print N'Chu Dinh Duc 20194021';
print N'Xin Chao';
end
exec a1