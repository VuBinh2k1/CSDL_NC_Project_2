USE HOAYEUTHUONG
GO 

--Truy vấn 1: Tổng chi phí đặt hàng của tất cả khách hàng gửi, 
--			  kết quả sắp xếp theo thứ tự giảm dần của tổng số tiền đã chi
SELECT MaKHGui, SUM(TONGTIEN) AS 'Tổng đã chi'
FROM HOADON HD 
GROUP BY MaKHGui
ORDER BY SUM(TONGTIEN) DESC

--Truy vấn 2: Tìm kiếm sản phẩm theo chủ đề
DECLARE @ChuDe NVARCHAR(50)= N'Bình hoa tươi'

SELECT MaSP, TenSP
FROM SANPHAM_CHUDE
WHERE ChuDe LIKE @ChuDe 

--Truy vấn 3: Thống kê top n SP bán chạy nhất
DECLARE @N INT = 100

SELECT TOP(@N) SP.MaSP, SP.TenSP, SUM(CTHD.ThanhTien) AS 'Doanh số'
FROM CT_HOADON CTHD JOIN SANPHAM SP ON CTHD.MaSP = SP.MaSP
GROUP BY SP.MaSP, SP.TenSP
ORDER BY SUM(CTHD.ThanhTien)

--Truy vấn 4: Cửa hàng kiểm tra và gửi danh sách các nguyên liệu cần mua thêm
DECLARE @MaCH INT = 18

SELECT NL.MaNL, NL.TenNL, NL.SoLuongToiThieu - SL.SoLuongCH AS 'Số lượng cần mua thêm ít nhất'
FROM NGUYENLIEU NL 
JOIN SOLUONG_NL SL ON NL.MaNL = SL.MaNL 
WHERE SL.MaCH = @MaCH AND
	  SL.SoLuongCH < NL.SoLuongToiThieu

--Truy vấn 5: Thống kê doanh thu của từng cửa hàng theo quý (mỗi 3 tháng)
DECLARE @Quy INT = 1
DECLARE @Nam INT = 2021

SELECT CH.TenCH, SUM(TongTien) AS 'Doanh Thu'
FROM HOADON HD 
JOIN HOADON_VANCHUYEN HD_VC ON HD.MaHD = HD_VC.MaHD
JOIN CUAHANG CH ON HD.MaCH = CH.MaCH
WHERE DATEPART(qq, HD_VC.ThoiGianGiao) = @Quy AND
	  DATEPART(yy, HD_VC.ThoiGianGiao) = @Nam
GROUP BY CH.MaCH, CH.TenCH

--Truy vấn 6: Thống kê số ngày làm việc đủ 2 ca của từng nhân viên (theo tháng)
DECLARE @Thang INT = 1
DECLARE @Nam_1 INT = 2021

SELECT NV.MaNV, NV.TenNV, COUNT(PCC.NGAYCHAM) AS 'SONGAY'
FROM NHANVIEN NV JOIN PHIEUCHAMCONG PCC ON PCC.MaNV = NV.MaNV
WHERE DATEPART(MM, PCC.NGAYCHAM) = @Thang AND
	  DATEPART(YY, PCC.NGAYCHAM) = @Nam_1
GROUP BY NV.MaNV, NV.TenNV
HAVING COUNT(PCC.GioCham) >= 2
