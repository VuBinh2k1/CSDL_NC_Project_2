USE HOAYEUTHUONG
GO 

------------------------- TỐI ƯU HÓA CÂU TRUY VẤN 1 -------------------------

-- Tạo chỉ mục trên thuộc tính MaKHGui của bảng HOADON bao gồm thêm thuộc thích TongTien
CREATE NONCLUSTERED INDEX IDX_TV1 ON HOADON(MaKHGui) INCLUDE (TongTien)

-- Thực hiện lại
SELECT MaKHGui, SUM(TONGTIEN) AS 'Tổng đã chi'
FROM HOADON HD 
GROUP BY MaKHGui
ORDER BY SUM(TONGTIEN) DESC

------------------------- TỐI ƯU HÓA CÂU TRUY VẤN 2 -------------------------

-- Tạo chỉ mục trên thuộc tính ChuDe của bảng CT_HOADON bao gồm thêm thuộc thích TenSP
CREATE NONCLUSTERED INDEX IDX_TV2
ON [dbo].[SANPHAM_CHUDE] ([ChuDe])
INCLUDE ([TenSP])

-- Thực hiện lại
DECLARE @ChuDe VARCHAR(50)= 'Cây thông'

SELECT MaSP, TenSP
FROM SANPHAM_CHUDE
WHERE ChuDe LIKE @ChuDe 

------------------------- TỐI ƯU HÓA CÂU TRUY VẤN 3 -------------------------

-- Tạo chỉ mục trên thuộc tính ThanhTien của bảng CT_HOADON
CREATE NONCLUSTERED INDEX IDX_TV3 ON CT_HOADON(ThanhTien)

-- Thực hiện lại
DECLARE @N INT = 100

SELECT TOP(@N) SP.MaSP, SP.TenSP, SUM(CTHD.ThanhTien) AS 'Doanh số'
FROM CT_HOADON CTHD JOIN SANPHAM SP ON CTHD.MaSP = SP.MaSP
GROUP BY SP.MaSP, SP.TenSP
ORDER BY SUM(CTHD.ThanhTien)

------------------------- TỐI ƯU HÓA CÂU TRUY VẤN 4 -------------------------

------------------------- TỐI ƯU HÓA CÂU TRUY VẤN 5 -------------------------

-- Tạo định nghĩa phân đoạn theo từng quý
CREATE PARTITION FUNCTION PartFunc(DATETIME) 
AS RANGE RIGHT FOR VALUES ('2021-01-01', '2021-04-01', '2021-07-01', '2021-10-01')

-- Tạo filegroup
ALTER DATABASE HOAYEUTHUONG ADD FILEGROUP FG1
ALTER DATABASE HOAYEUTHUONG ADD FILEGROUP FG2
ALTER DATABASE HOAYEUTHUONG ADD FILEGROUP FG3
ALTER DATABASE HOAYEUTHUONG ADD FILEGROUP FG4

-- Thêm data file vào mỗi filegroup
ALTER DATABASE HOAYEUTHUONG ADD FILE (NAME = N'F1', FILENAME = N'D:\DATA\PartDB_F1.ndf') TO FILEGROUP FG1
ALTER DATABASE HOAYEUTHUONG ADD FILE (NAME = N'F2', FILENAME = N'D:\DATA\PartDB_F2.ndf') TO FILEGROUP FG2
ALTER DATABASE HOAYEUTHUONG ADD FILE (NAME = N'F3', FILENAME = N'D:\DATA\PartDB_F3.ndf') TO FILEGROUP FG3
ALTER DATABASE HOAYEUTHUONG ADD FILE (NAME = N'F4', FILENAME = N'D:\DATA\PartDB_F4.ndf') TO FILEGROUP FG4

-- Phân đoạn bảng


-- Thực hiện lại
DECLARE @Quy INT = 1
DECLARE @Nam INT = 2021

SELECT CH.TenCH, SUM(TongTien) AS 'Doanh Thu'
FROM HOADON HD 
JOIN HOADON_VANCHUYEN HD_VC ON HD.MaHD = HD_VC.MaHD
JOIN CUAHANG CH ON HD.MaCH = CH.MaCH
WHERE DATEPART(qq, HD_VC.ThoiGianGiao) = @Quy AND
	  DATEPART(yy, HD_VC.ThoiGianGiao) = @Nam
GROUP BY CH.MaCH, CH.TenCH

------------------------- TỐI ƯU HÓA CÂU TRUY VẤN 6 -------------------------

-- Tạo chỉ mục trên thuộc tính NGAYCHAM của bảng PHIEUCHAMCONG
CREATE NONCLUSTERED INDEX IDX_TV6 ON PHIEUCHAMCONG(MANV)

-- Thực hiện lại
DECLARE @Thang INT = 1
DECLARE @Nam_1 INT = 2021

SELECT NV.MaNV, NV.TenNV, COUNT(PCC.NGAYCHAM) AS 'SONGAY'
FROM NHANVIEN NV JOIN PHIEUCHAMCONG PCC ON PCC.MaNV = NV.MaNV
WHERE DATEPART(MM, PCC.NGAYCHAM) = @Thang AND
	  DATEPART(YY, PCC.NGAYCHAM) = @Nam_1
GROUP BY NV.MaNV, NV.TenNV
HAVING COUNT(PCC.GioCham) >= 2

