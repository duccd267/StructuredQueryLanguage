--Bài thực hành 2
--Chu Đình Đức - 4021
use QLBONGDA_CHUDINHDUC
--c. Các toán tử nâng cao 
--c4. Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) 
--    của câu lạc bộ (CLB) đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009 
select td.NGAYTD_4021, svd.TENSAN_4021, clb1.TENCLB_4021, clb2.TENCLB_4021, td.KETQUA_4021
from TRANDAU_DUCCD td, SANVD_DUCCD svd, CAULACBO_DUCCD clb1, CAULACBO_DUCCD clb2 
where td.MASAN_4021 = svd.MASAN_4021
and td.MACLB1_4021 = clb1.MACLB_4021
and td.MACLB2_4021 = clb2.MACLB_4021
and td.VONG_4021 <= 3
and (td.MACLB1_4021 in (select MACLB_4021 from BANGXH_DUCCD where HANG_4021 = 1 and VONG_4021 = 3 and NAM_4021 = 2009)
or  td.MACLB2_4021 in (select MACLB_4021 from BANGXH_DUCCD where HANG_4021 = 1 and VONG_4021 = 3 and NAM_4021 = 2009))

--c3. Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ có thứ hạng ở vòng 3 năm 2009 lớn hơn 6 hoặc nhỏ hơn 3 
select ct.HOTEN_4021
from CAUTHU_DUCCD ct, CAULACBO_DUCCD clb, BANGXH_DUCCD bxh
where ct.MACLB_4021 = clb.MACLB_4021
and clb.MACLB_4021 = bxh.MACLB_4021
and bxh.VONG_4021 = 3
and bxh.NAM_4021 = 2009
and bxh.HANG_4021 between 3 and 6

--c2. Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại bất kỳ một câu lạc bộ nào
select hlv.TENHLV_4021
from HUANLUYENVIEN_DUCCD hlv, QUOCGIA_DUCCD qg, HLV_CLB_DUCCD hlvclb
where hlv.MAHLV_4021 = hlvclb.MAHLV_4021
and hlv.MAQG_4021 = qg.MAQG_4021
and qg.TENQG_4021 = N'Việt Nam'
and hlvclb.VAITRO_4021 is null
and hlvclb.MACLB_4021 is null

--c1. Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ mà chưa có số điện thoại 
insert into HUANLUYENVIEN_DUCCD
values ('HVL07',N'Nguyễn Văn A',2001-07-27,NULL,NULL,'VN')
insert into HUANLUYENVIEN_DUCCD
values ('HVL08',N'Nguyễn Văn B',2001-07-28,NULL,NULL,'VN')
insert into HLV_CLB_DUCCD
values ('HVL07','GDT',N'HLV Thủ môn')
select hlv.TENHLV_4021
from HUANLUYENVIEN_DUCCD hlv, HLV_CLB_DUCCD hlvclb
where hlv.MAHLV_4021 = hlvclb.MAHLV_4021 
and hlv.DIENTHOAI_4021 is null
and hlvclb.VAITRO_4021 is not null

--b. Các phép toán trên nhóm
--b5. Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp hạng vòng 3, năm 2009 
select top 1 clb.TENCLB_4021, tinh.TENTINH_4021
from CAULACBO_DUCCD clb, TINH_DUCCD tinh, BANGXH_DUCCD bxh
where clb.MATINH_4021 = tinh.MATINH_4021
and clb.MACLB_4021 = bxh.MACLB_4021
and bxh.VONG_4021 = 3 
and bxh.NAM_4021 = 2009
order by bxh.DIEM_4021 desc

--b4. Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc bộ thuộc địa bàn tỉnh đó quản lí
select tinh.TENTINH_4021, count(ct.MACT_4021) as [Số lượng tiền đạo]
from TINH_DUCCD tinh, CAUTHU_DUCCD ct, CAULACBO_DUCCD clb
where ct.MACLB_4021 = clb.MACLB_4021
and clb.MATINH_4021 = tinh.MATINH_4021
and ct.VITRI_4021 = N'Tiền đạo'
group by tinh.TENTINH_4021

--b3. Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước ngoài (có quốc tịch khác Việt Nam) 
--    tương ứng của các câu lạc bộ có nhiều hơn 2 cầu thủ nước ngoài. 
select clb.MACLB_4021, clb.TENCLB_4021, svd.TENSAN_4021, svd.DIACHI_4021, count(ct.MACT_4021) as [Số lượng cầu thủ]
from CAULACBO_DUCCD clb, CAUTHU_DUCCD ct, SANVD_DUCCD svd, QUOCGIA_DUCCD qg
where clb.MACLB_4021 = ct.MACLB_4021
and clb.MASAN_4021 = svd.MASAN_4021
and qg.MAQG_4021 = ct.MAQG_4021 
and qg.TENQG_4021 <> N'Việt Nam'
group by clb.MACLB_4021, clb.TENCLB_4021, svd.TENSAN_4021, svd.DIACHI_4021
having count(ct.MACT_4021) > 2

--b2. Thống kê số lượng cầu thủ nước ngoài (có quốc tịch khác Việt Nam) của mỗi câu lạc bộ 
select clb.TENCLB_4021, count(ct.MAQG_4021) as [Số lượng cầu thủ nước ngoài]
from CAULACBO_DUCCD clb, CAUTHU_DUCCD ct, QUOCGIA_DUCCD qg
where clb.MACLB_4021 = ct.MACLB_4021
and ct.MAQG_4021 = qg.MAQG_4021
and qg.TENQG_4021 <> N'Việt Nam'
group by clb.TENCLB_4021

--b1. Thống kê số lượng cầu thủ của mỗi câu lạc bộ 
select clb.TENCLB_4021, count(ct.MACT_4021) as [Số lượng cầu thủ]
from CAULACBO_DUCCD clb, CAUTHU_DUCCD ct
where clb.MACLB_4021 = ct.MACLB_4021
group by clb.TENCLB_4021

--a. Truy vấn cơ bản
--a10. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc mà câu lạc bộ đó đóng ở tỉnh Binh Dương
select hlv.MAHLV_4021, hlv.TENHLV_4021, hlv.NGAYSINH_4021, hlv.DIACHI_4021, hlvclb.VAITRO_4021, clb.TENCLB_4021
from HUANLUYENVIEN_DUCCD hlv, HLV_CLB_DUCCD hlvclb, CAULACBO_DUCCD clb, TINH_DUCCD tinh
where hlv.MAHLV_4021 = hlvclb.MAHLV_4021
and hlvclb.MACLB_4021 = clb.MACLB_4021
and clb.MATINH_4021 = tinh.MATINH_4021
and tinh.TENTINH_4021 = N'Bình Dương'

--a9. Lấy tên 3 câu lạc bộ có điểm cao nhất sau vòng 3 năm 2009 
select clb.TENCLB_4021
from BANGXH_DUCCD bxh, CAULACBO_DUCCD clb
where bxh.MACLB_4021 = clb.MACLB_4021
and bxh.VONG_4021 = 3
and bxh.HANG_4021 < 4

--a8. Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc của các huấn luyện viên có quốc tịch “Việt Nam”
select hlv.MAHLV_4021, hlv.TENHLV_4021, hlv.NGAYSINH_4021, hlv.DIACHI_4021, hlvclb.VAITRO_4021, clb.TENCLB_4021
from HUANLUYENVIEN_DUCCD hlv, HLV_CLB_DUCCD hlvclb, CAULACBO_DUCCD clb, QUOCGIA_DUCCD qg
where hlv.MAHLV_4021 = hlvclb.MAHLV_4021
and hlvclb.MACLB_4021 = clb.MACLB_4021
and hlv.MAQG_4021 = qg.MAQG_4021
and qg.TENQG_4021 = N'Việt Nam'

--a7. Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận đấu vòng 2 của mùa bóng năm 2009
select td.MATRAN_4021, td.NGAYTD_4021, svd.TENSAN_4021, clb1.TENCLB_4021, clb2.TENCLB_4021, td.KETQUA_4021
from TRANDAU_DUCCD td, SANVD_DUCCD svd, CAULACBO_DUCCD clb1, CAULACBO_DUCCD clb2
where td.MASAN_4021 = svd.MASAN_4021 
and td.MACLB1_4021 = clb1.MACLB_4021 
and td.MACLB2_4021 = clb2.MACLB_4021
and td.VONG_4021 = 2 
and td.NAM_4021 = 2009

--a6. Hiển thị thông tin tất cả các cầu thủ đang thi đấu trong câu lạc bộ có sân nhà là “Long An” 
insert into CAUTHU_DUCCD
values (N'Chu Đình Đức',N'Thủ môn',2001-07-26,NULL,'GDT','VN',100)
select ct.* 
from CAUTHU_DUCCD ct, CAULACBO_DUCCD clb, SANVD_DUCCD svd
where ct.MACLB_4021 = clb.MACLB_4021 
and clb.MASAN_4021 = svd.MASAN_4021
and svd.TENSAN_4021 = N'Long An'

--a5. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng ‘SHB Đà Nẵng’ có quốc tịch “Bra-xin” 
select ct.MACT_4021, ct.HOTEN_4021, ct.NGAYSINH_4021, ct.DIACHI_4021, ct.VITRI_4021
from CAUTHU_DUCCD ct, CAULACBO_DUCCD clb, QUOCGIA_DUCCD qg
where ct.MAQG_4021 = qg.MAQG_4021 
and ct.MACLB_4021 = clb.MACLB_4021
and clb.TENCLB_4021 = N'SHB Đà Nẵng' 
and qg.TENQG_4021 = N'Bra-xin'

--a4. Hiển thi thông tin tất cả các cầu thủ có quốc tịch Việt Nam thuộc câu lạc bộ Becamex Bình Dương 
select ct.*
from CAUTHU_DUCCD ct, CAULACBO_DUCCD clb, QUOCGIA_DUCCD qg
where ct.MAQG_4021 = qg.MAQG_4021 
and ct.MACLB_4021 = clb.MACLB_4021
and qg.TENQG_4021 = N'Việt Nam' 
and clb.TENCLB_4021 = N'BECAMEX BÌNH DƯƠNG'

--a3. Cho biết tên, ngày sinh, địa chỉ, điện thoại của tất cả các huấn luyện viên
select TENHLV_4021, NGAYSINH_4021, DIACHI_4021, DIENTHOAI_4021
from HUANLUYENVIEN_DUCCD

--a2. Hiển thị thông tin tất cả các cầu thủ có số áo là 7 chơi ở vị trí Tiền vệ
select *
from CAUTHU_DUCCD
where SO_4021 = 7 and VITRI_4021 = N'Tiền vệ'


--a1. Cho biết thông tin (mã cầu thủ, họ tên, số áo, vị trí, ngày sinh, địa chỉ) của tất cả các cầu thủ
select ct.MACT_4021, ct.HOTEN_4021, ct.SO_4021, ct.VITRI_4021, ct.NGAYSINH_4021, ct.DIACHI_4021
from CAUTHU_DUCCD ct