﻿USE [HOAYEUTHUONG]
GO
CREATE OR ALTER TRIGGER THANHTIEN_CTHD
ON CT_HOADON
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @GIASP DECIMAL(19,4)
	SET @GIASP = (SELECT DonGiaSP FROM SANPHAM SP, inserted I WHERE SP.MASP = I.MaSP)
	- (SELECT GiamGiaSP FROM SANPHAM SP, inserted I WHERE SP.MASP = I.MaSP)

	UPDATE CT_HOADON
	SET ThanhTien = I.SoLuong * @GIASP
	FROM inserted I, CT_HOADON CT
	WHERE CT.MaHD = I.MaHD AND I.MaSP = CT.MaSP
END
GO

CREATE OR ALTER TRIGGER TONGTIEN_HOADON
ON CT_HOADON
FOR INSERT, UPDATE
AS
BEGIN
	UPDATE HOADON
	SET TongTien = 0
	FROM inserted I, HOADON HD
	WHERE HD.MaHD = I.MaHD 
END
GO

CREATE OR ALTER TRIGGER DELETE_CTHOADON
ON CT_HOADON
FOR DELETE
AS
BEGIN
	DECLARE @VOUCHER DECIMAL(19,4), @SLSD INT
	SET @VOUCHER = (SELECT VC.GiaTri FROM VOUCHER VC, HOADON HD, deleted D WHERE HD.MaVoucher = VC.MaVoucher AND HD.MaHD = D.MaHD)
	SET @SLSD =  (SELECT VC.SoLanSuDung FROM VOUCHER VC, HOADON HD, deleted D WHERE HD.MaVoucher = VC.MaVoucher AND HD.MaHD = D.MaHD)
	
	IF @VOUCHER IS NULL OR @SLSD = 0
	BEGIN
		SET @VOUCHER = 0
	END
	UPDATE HOADON
	SET 
		TongTien = TongTien - (SELECT ThanhTien * (1 - @VOUCHER) FROM deleted)
	FROM deleted D, HOADON HD
	WHERE D.MaHD = HD.MaHD
END
GO
CREATE OR ALTER TRIGGER UPDATE_TONGTIEN
ON HOADON
FOR UPDATE
AS
BEGIN
	DECLARE @THANHTIEN DECIMAL(19,4), @VOUCHER DECIMAL(3,2), @PHIVC DECIMAL(19,4), @SLSD INT
	SET @VOUCHER = 0
	SET @THANHTIEN = (SELECT SUM(CTHD.ThanhTien) FROM CT_HOADON CTHD, inserted I WHERE I.MaHD = CTHD.MaHD GROUP BY CTHD.MaHD)
	SET @VOUCHER = (SELECT VC.GiaTri FROM VOUCHER VC, HOADON HD, inserted I WHERE HD.MaVoucher = VC.MaVoucher AND HD.MaHD = I.MaHD)
	SET @SLSD = (SELECT VC.SoLanSuDung FROM VOUCHER VC, HOADON HD, inserted I WHERE HD.MaVoucher = VC.MaVoucher AND HD.MaHD = I.MaHD)

	SET @PHIVC = 0
	IF @VOUCHER IS NULL OR @SLSD = 0
	BEGIN
		SET @VOUCHER = 0
	END
	
	SET @PHIVC = (SELECT HDVC.PhiVanChuyen FROM HOADON_VANCHUYEN HDVC, inserted I WHERE I.MaHD = HDVC.MaHD)
	IF @PHIVC IS NULL
	BEGIN
		SET @PHIVC = 0
	END

	UPDATE HOADON
	SET TongTien = @THANHTIEN * (1 - @VOUCHER) + @PHIVC
	FROM inserted I, HOADON HD
	WHERE HD.MaHD = I.MaHD 
END
