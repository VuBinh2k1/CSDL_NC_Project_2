﻿USE [HOAYEUTHUONG]
GO
--NHÂN VIÊN
-- Nhân viên kiểm tra tình trạng hóa đơn của KH
CREATE OR ALTER PROCEDURE KTRA_HD @MAHD INT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM HOADON WHERE MAHD = @MAHD)
	BEGIN
		PRINT N'Hóa đơn không tồn tại'
		ROLLBACK TRAN
	END
	SELECT * 
	FROM HOADON 
	WHERE MAHD = @MAHD
END
GO
EXEC KTRA_HD 1
GO
--Nhân viên kiểm tra thông tin chấm công
CREATE OR ALTER PROCEDURE XEM_BCCONG @MANV INT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM NHANVIEN WHERE MANV = @MANV)
	BEGIN
		PRINT N'Nhân viên không tồn tại'
		RETURN
	END

	IF NOT EXISTS (SELECT PCC.* FROM NHANVIEN NV, PHIEUCHAMCONG PCC WHERE PCC.MaNV = NV.MaNV AND NV.MaNV = @MANV)
	BEGIN
		PRINT N'Nhân viên chưa có thông tin chấm công'
		RETURN
	END

	SELECT NV.MaNV, NV.TenNV, NV.LoaiNV, PCC.GioCham, PCC.NgayCham
	FROM NHANVIEN NV, PHIEUCHAMCONG PCC
	WHERE PCC.MaNV = NV.MaNV AND NV.MaNV = @MANV
END
GO
EXEC XEM_BCCONG 5