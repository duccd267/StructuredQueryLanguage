-- Bài thực hành 3
-- Chu Đình Đức 20194021
use QLBONGDA_CHUDINHDUC
-- d. Bài tập về View
-- d13. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) 
-- của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009 
create view View13 as
select td.NGAYTD_4021, svd.TENSAN_4021, clb1.TENCLB_4021 as [TENCLB1], clb2.TENCLB_4021 as [TENCLB2], td.KETQUA_4021
from TRANDAU_DUCCD td, SANVD_DUCCD svd, CAULACBO_DUCCD clb1, CAULACBO_DUCCD clb2 
where td.MASAN_4021 = svd.MASAN_4021
and td.MACLB1_4021 = clb1.MACLB_4021
and td.MACLB2_4021 = clb2.MACLB_4021
and td.VONG_4021 <= 3
and (td.MACLB1_4021 in (select MACLB_4021 from BANGXH_DUCCD where HANG_4021 = 4 and VONG_4021 = 3 and NAM_4021 = 2009)
or  td.MACLB2_4021 in (select MACLB_4021 from BANGXH_DUCCD where HANG_4021 = 4 and VONG_4021 = 3 and NAM_4021 = 2009))
go
select * from View13;

-- d12. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) 
-- của câu lạc bộ CLB đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009 
create view View12 as
select td.NGAYTD_4021, svd.TENSAN_4021, clb1.TENCLB_4021 as [TENCLB1], clb2.TENCLB_4021 as [TENCLB2], td.KETQUA_4021
from TRANDAU_DUCCD td, SANVD_DUCCD svd, CAULACBO_DUCCD clb1, CAULACBO_DUCCD clb2 
where td.MASAN_4021 = svd.MASAN_4021
and td.MACLB1_4021 = clb1.MACLB_4021
and td.MACLB2_4021 = clb2.MACLB_4021
and td.VONG_4021 <= 3
and (td.MACLB1_4021 in (select MACLB_4021 from BANGXH_DUCCD where HANG_4021 = 1 and VONG_4021 = 3 and NAM_4021 = 2009)
or  td.MACLB2_4021 in (select MACLB_4021 from BANGXH_DUCCD where HANG_4021 = 1 and VONG_4021 = 3 and NAM_4021 = 2009))
go
select * from View12;

-- d11. Cho biết kết quả các trận đấu trên sân khách (MACLB, NAM, VONG,  SOBANTHANG,SOBANTHUA) 
create view View11 as
select td.MACLB1_4021, td.NAM_4021, td.VONG_4021,
left(td.KETQUA_4021,charindex('-',td.KETQUA_4021,1)-1) as [SOBANTHUA], 
right(td.KETQUA_4021,charindex('-',td.KETQUA_4021,1)-1) as [SOBANTHANG]
from TRANDAU_DUCCD td
go
select * from View11

-- d10. Cho biết kết quả các trận đấu trên sân nhà (MACLB, NAM, VONG, SOBANTHANG, SOBANTHUA) 
create view View10 as
select td.MACLB1_4021, td.NAM_4021, td.VONG_4021,
left(td.KETQUA_4021,charindex('-',td.KETQUA_4021,1)-1) as [SOBANTHANG], 
right(td.KETQUA_4021,charindex('-',td.KETQUA_4021,1)-1) as [SOBANTHUA]
from TRANDAU_DUCCD td
go
select * from View10

-- d9. Cho biết kết quả các trận đấu đã diễn ra (MACLB1, MACLB2, NAM, VONG,SOBANTHANG,SOBANTHUA) 
create view View9 as
select td.MACLB1_4021, td.MACLB2_4021, td.NAM_4021, td.VONG_4021, 
left(td.KETQUA_4021,charindex('-',td.KETQUA_4021,1)-1) as [SOBANTHANG], 
right(td.KETQUA_4021,charindex('-',td.KETQUA_4021,1)-1) as [SOBANTHUA]
from TRANDAU_DUCCD td;
go
select * from View9;

-- d8. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại bất kỳ một câu lạc bộ nào 
create view View8 as
select hlv.*
from HUANLUYENVIEN_DUCCD hlv, HLV_CLB_DUCCD hc, QUOCGIA_DUCCD qg
where hlv.MAHLV_4021 = hc.MAHLV_4021
and hlv.MAQG_4021 = qg.MAQG_4021
and qg.TENQG_4021 = N'Việt Nam'
and hc.VAITRO_4021 is null;
go
select * from View8;

-- d7. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong 1 c âu lạc bộ mà chưa có số điện thoại 
create view View7 as
select hlv.TENHLV_4021
from HUANLUYENVIEN_DUCCD hlv
where hlv.DIENTHOAI_4021 IS NULL;
go
select * from View7;

-- d6. Cho biết tên câu lạc bộ,tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp hạng của vòng 3 năm 2009 
create view View6 as
select top 1 clb.TENCLB_4021, t.TENTINH_4021
from CAULACBO_DUCCD clb, TINH_DUCCD t,BANGXH_DUCCD bxh
where clb.MATINH_4021 = t.MATINH_4021
and clb.MACLB_4021 = bxh.MACLB_4021
and bxh.VONG_4021 = 3
and bxh.NAM_4021 = 2009
order by bxh.HANG_4021 asc;
go
select * from View6;

-- d5. Cho biết tên tỉnh, số lượng câu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc bộ thuộc địa bàn tỉnh đó quản lý
create view View5 as
select t.TENTINH_4021, count(ct.MACT_4021) as SLTĐ
from  TINH_DUCCD t, CAUTHU_DUCCD ct, CAULACBO_DUCCD clb
where ct.MACLB_4021 = clb.MACLB_4021
and clb.MATINH_4021 = t.MATINH_4021
and ct.VITRI_4021 = N'Tiền Đạo'
group by t.TENTINH_4021;
go
select * from View5;

-- d4. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài 
-- (có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ nhiều hơn 2 cầu thủ nước ngoài 
create view View4 as
select clb.MACLB_4021, clb.TENCLB_4021, svd.TENSAN_4021, svd.DIACHI_4021, count(ct.MACT_4021) as SOLUONCAUTHUNUOCNGOAI
from CAULACBO_DUCCD clb, SANVD_DUCCD svd, QUOCGIA_DUCCD qg, CAUTHU_DUCCD ct
where 
clb.MACLB_4021 = ct.MACLB_4021
and clb.MASAN_4021 = svd.MASAN_4021
and clb.MACLB_4021 = ct.MACLB_4021
and ct.MAQG_4021 = qg.MAQG_4021
and qg.TENQG_4021 <> N'Việt Nam'
group by 
clb.MACLB_4021, clb.TENCLB_4021, svd.TENSAN_4021, svd.DIACHI_4021
having count(ct.MACT_4021) > 2;
go
select * from View4;

-- d3. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc
-- của các huấn luyện viên có quốc tịch “Việt Nam” 
create view View3
as
select hlv.MAHLV_4021, hlv.TENHLV_4021, hlv.NGAYSINH_4021, hlv.DIACHI_4021, hc.VAITRO_4021, clb.TENCLB_4021
from HUANLUYENVIEN_DUCCD hlv, HLV_CLB_DUCCD hc, CAULACBO_DUCCD clb, QUOCGIA_DUCCD qg
where hlv.MAHLV_4021 = hc.MAHLV_4021
and hc.MACLB_4021 = clb.MACLB_4021
and hlv.MAQG_4021 = qg.MAQG_4021
and qg.TENQG_4021 = N'Việt Nam';
go
select * from View3;

-- d2. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận đấu vòng 3 của mùa bóng năm 2009
create view View2 as
select td.MATRAN_4021, td.NGAYTD_4021, svd.TENSAN_4021, clb1.TENCLB_4021 as TENCLB1, clb2.TENCLB_4021 AS TENCLB2,td.KETQUA_4021
from TRANDAU_DUCCD td, SANVD_DUCCD svd, CAULACBO_DUCCD clb1, CAULACBO_DUCCD clb2
where td.MASAN_4021 = svd.MASAN_4021
and td.MACLB1_4021 = clb1.MACLB_4021
and td.MACLB2_4021 = clb2.MACLB_4021
and td.VONG_4021 = 3
and NAM_4021 = 2009;

select * from View2;

-- d1. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bón g “SHB Đà Nẵng” có quốc tịch “Bra-xin”
create view View1 as
select  ct.MACT_4021 , ct.HOTEN_4021, ct.NGAYSINH_4021, ct.DIACHI_4021, ct.VITRI_4021
from CAUTHU_DUCCD ct, CAULACBO_DUCCD clb, QUOCGIA_DUCCD qg
where ct.MACLB_4021 = clb.MACLB_4021
and ct.MAQG_4021 = qg.MAQG_4021
and clb.TENCLB_4021 =  N'SHB Đà Nẵng'
and qg.TENQG_4021 = 'Bra-xin';

select * from View1

-- c. Bài tập về Rule
-- c4. Kiểm tra kết quả trận đấu có dạng số_bàn_thắng- số_bàn_thua 
alter table TRANDAU_DUCCD
add constraint CHK_KETQUA CHECK(KETQUA_4021 LIKE '%-%' );
go

-- c3. Khi thêm cầu thủ mới, kiểm tra cầu thủ đó có tuổi phải đủ 18 trở lên (chỉ tính năm sinh) 
alter table CAUTHU_DUCCD
add constraint CHK_TUOI check( year(getdate()) - year(NGAYSINH_4021) >= 18);
GO

-- c2. Khi phân công huấn luyện viên, kiểm tra vai trò của huấn luyện viên chỉ thuộc một trong các vai trò sau: 
-- HLV chính, HLV phụ, HLV thể lực, HLV thủ môn
alter table HLV_CLB_DUCCD
add constraint CHK_VAITRO check (VAITRO_4021 IN(N'HLV Chính',N'HLV phụ',N'HLV thủ môn'));
go

-- c1. Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cầu thủ chỉ thuộc một trong các vị trí sau: Thủ môn, tiền đạo, tiền vệ, trung vệ, hậu vệ
alter table CAUTHU_DUCCD
add constraint CHK_VITRI check ( VITRI_4021 IN (N'Thủ môn',N'Tiền đạo',N'Tiền vệ', N'Trung vệ',N'Hậu vệ'));
go

-- b. Truy vấn con
-- b5. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại ( chỉ tính sân nhà) trong mùa giải năm 2009
select distinct MACLB1_4021
from TRANDAU_DUCCD td1
where not exists (select MACLB_4021 from CAULACBO_DUCCD clb1 
	except ((select MACLB2_4021 from TRANDAU_DUCCD td2 where td1.MACLB1_4021 = td2.MACLB1_4021) 
	union (SELECT MACLB_4021 from CAULACBO_DUCCD clb2 where MACLB_4021 = td1.MACLB1_4021)))

-- b4. Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại (kể cả sân nhà và sân khách) trong mùa giải năm 2009
select distinct MACLB_4021, TENCLB_4021
from CAULACBO_DUCCD clb 
where not exists (
	select MACLB_4021 from CAULACBO_DUCCD clb1
	where clb1.MACLB_4021 != clb.MACLB_4021
		except (( select MACLB1_4021 as MACLB_4021 from TRANDAU_DUCCD td1
		where td1.MACLB2_4021 = clb.MACLB_4021)
			union (select MACLB2_4021 as MACLB_4021 from TRANDAU_DUCCD td2
			where td2.MACLB1_4021 = clb.MACLB_4021)))

-- b3. Cho biết danh sách các trận đấu ( NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) 
-- của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009
select td.NGAYTD_4021,  svd.TENSAN_4021, clb1.TENCLB_4021, clb2.TENCLB_4021, td.KETQUA_4021
from TRANDAU_DUCCD td, CAULACBO_DUCCD clb1, CAULACBO_DUCCD clb2, SANVD_DUCCD svd
where td.MACLB1_4021 = clb1.MACLB_4021
and td.MACLB2_4021 = clb2.MACLB_4021
and td.MASAN_4021 = svd.MASAN_4021
and 
(clb1.MACLB_4021 = ( select top 1 BANGXH_DUCCD.MACLB_4021 from BANGXH_DUCCD where BANGXH_DUCCD.VONG_4021 = 3 and BANGXH_DUCCD.NAM_4021 = 2009 order by BANGXH_DUCCD.HANG_4021 desc)
or
clb2.MACLB_4021 = ( select top 1 BANGXH_DUCCD.MACLB_4021 from BANGXH_DUCCD where BANGXH_DUCCD.VONG_4021 = 3 and BANGXH_DUCCD.NAM_4021 = 2009 order by BANGXH_DUCCD.HANG_4021 desc));

-- b2. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có hiệu số bàn thắng bại cao nhất năm 2009
select distinct clb.TENCLB_4021 , t.TENTINH_4021
from CAULACBO_DUCCD clb INNER JOIN TINH_DUCCD t on clb.MATINH_4021 = t.MATINH_4021 INNER JOIN BANGXH_DUCCD bxh on clb.MACLB_4021 = bxh.MACLB_4021
where clb.MACLB_4021 = 
	(select top 1 MACLB_4021 from BANGXH_DUCCD where NAM_4021 = 2009 
	order by ((convert(int, substring(HIEUSO_4021,1,1))) - (convert(int, substring(HIEUSO_4021,3,1)))) desc)
and NAM_4021 = 2009;


-- b1. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài 
-- (Có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài
select clb.MACLB_4021, clb.TENCLB_4021, svd.TENSAN_4021, svd.DIACHI_4021, count(ct.MACT_4021) as [Số lượng]
from CAULACBO_DUCCD clb, SANVD_DUCCD svd, CAUTHU_DUCCD ct, QUOCGIA_DUCCD qg
where clb.MASAN_4021 = svd.MASAN_4021
and clb.MACLB_4021 = ct.MACLB_4021
and ct.MAQG_4021 = qg.MAQG_4021
and qg.TENQG_4021 <> N'Việt Nam'
group by clb.MACLB_4021, clb.TENCLB_4021, svd.TENSAN_4021, svd.DIACHI_4021
having count(ct.MACT_4021) >= 2

-- a. Xử lý chuỗi, ngày giờ
-- a6. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có số bàn thắng nhiều nhất tính đến hết vòng 3 năm 2009 
select top 1 clb.TENCLB_4021, t.TENTINH_4021
from CAULACBO_DUCCD clb, TINH_DUCCD t, BANGXH_DUCCD bxh 
where clb.MATINH_4021 = t.MATINH_4021
and clb.MACLB_4021 = bxh.MACLB_4021
and bxh.VONG_4021 = 3
and bxh.NAM_4021 = 2009
order by (cast(left(bxh.HIEUSO_4021,charindex('-',bxh.HIEUSO_4021,1)-1) as int)) desc

-- a5. Cho biết tên câu lạc bộ có huấn luyện viên trưởng sinh vào ngày 20 tháng 5 
select clb.TENCLB_4021
from CAULACBO_DUCCD clb, HUANLUYENVIEN_DUCCD hlv, HLV_CLB_DUCCD hc
where clb.MACLB_4021 = hc.MACLB_4021
and hlv.MAHLV_4021 = hc.MAHLV_4021
and hc.VAITRO_4021 = N'HLV Chính'
and day(hlv.NGAYSINH_4021) = 20
and month(hlv.NGAYSINH_4021) = 5 

-- a4. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ của những huấn luyện viên Việt Nam có tuổi nằm trong khoảng 35-55
select hlv.MAHLV_4021, hlv.TENHLV_4021, hlv.NGAYSINH_4021, hlv.DIACHI_4021
from HUANLUYENVIEN_DUCCD hlv, QUOCGIA_DUCCD qg
where hlv.MAQG_4021 = qg.MAQG_4021
and qg.TENQG_4021 = N'Việt Nam'
and year(getdate()) - year(hlv.NGAYSINH_4021) between 35 and 55

-- a3. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ không phải là họ “Nguyễn“ 
select ct.MACT_4021, ct.HOTEN_4021, ct.NGAYSINH_4021
from CAUTHU_DUCCD ct
where ct.HOTEN_4021 not like N'Nguyễn%'

-- a2. Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ lót là “Công” 
select ct.MACT_4021, ct.HOTEN_4021, ct.NGAYSINH_4021
from CAUTHU_DUCCD ct
where ct.HOTEN_4021 like N'%_Công_%'

-- a1. Cho biết NGAYTD, TENCLB1, TENCLB2, KETQUA các trận đấu diễn ra vào tháng 3 trên sân nhà mà không bị thủng lưới
select td.NGAYTD_4021, clb1.TENCLB_4021, clb2.TENCLB_4021, td.KETQUA_4021
from  TRANDAU_DUCCD td, CAULACBO_DUCCD clb1, CAULACBO_DUCCD clb2
where td.MACLB1_4021 = clb1.MACLB_4021
and td.MACLB2_4021 = clb2.MACLB_4021
and month(td.NGAYTD_4021) = 3
and ((left(td.KETQUA_4021,1) = 0 and clb2.MASAN_4021 = td.MASAN_4021)
or (right(td.KETQUA_4021,1) = 0 and clb1.MASAN_4021 = td.MASAN_4021))