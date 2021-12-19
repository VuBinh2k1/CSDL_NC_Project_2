﻿USE [HOAYEUTHUONG]
GO

--TÌM KIẾM SP (Theo chủ đề)
CREATE OR ALTER PROC TIMEKIEMSP_CHUDE @ChuDe NVARCHAR (20), @ChuDe_2 NVARCHAR(20) = NULL
AS
BEGIN
	IF @ChuDe_2 = N'' OR @ChuDe_2 IS NULL
	BEGIN
		SELECT ChuDe, MaSP, TenSP
		FROM SANPHAM_CHUDE
		WHERE ChuDe = @ChuDe
	END
	ELSE
	BEGIN
		--này là menu ... nào ấn vào thì sẽ dùng TIEMKIEMSP
		SELECT ChuDe, MaSP, TenSP
		FROM SANPHAM_CHUDE
		WHERE ChuDe = @ChuDe AND LoaiChuDe = @ChuDe_2
	END
END
GO
EXEC TIMEKIEMSP_CHUDE N'Bánh', N'Socola'
GO

--TÌM KIẾM SP
CREATE OR ALTER PROCEDURE TIMKIEMSP @MASP INT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM SANPHAM WHERE MASP = @MASP)
	BEGIN
		PRINT N'Sản phẩm hiện không tồn tại'
		RETURN
	END

	SELECT *
	FROM SANPHAM
	WHERE MASP = @MASP
END
GO

--ĐẶT HÀNG
GO
CREATE OR ALTER PROCEDURE THEMVAOGIOHANG @MAKH INT, @MAHD INT, @MASP INT, @SL INT
AS
BEGIN
	IF @MAHD = 0
	BEGIN
		INSERT HOADON(MaKHGui,TongTien) VALUES (@MAKH, 0)
		SET @MaHD = SCOPE_IDENTITY()
		INSERT CT_HOADON(MaHD,MaSP,SoLuong) VALUES (@MaHD, @MASP, @SL)
	END
	ELSE 
	BEGIN
		IF NOT EXISTS (SELECT * FROM HOADON WHERE MAHD = @MAHD AND MaKHGui = @MAKH)
		BEGIN
			PRINT N'Hóa đơn này không phải của bạn'
			RETURN
		END
		INSERT CT_HOADON(MaHD,MaSP,SoLuong) VALUES (@MAHD, @MASP, @SL)
	END
	SELECT @MAHD AS 'MaHD'	--return MAHOADON để dùng cho lần add tiếp theo
END
GO
--ÁP DỤNG VOUCHER
CREATE OR ALTER PROCEDURE APDUNGVOUCHER @MAHD INT, @VOUCHER CHAR(10)
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM VOUCHER WHERE MaVoucher = @VOUCHER)
	BEGIN
		PRINT N'Voucher không tồn tại'
		RETURN
	END

	UPDATE HOADON SET MaVoucher = @VOUCHER WHERE MAHD = @MAHD
END
GO
--Thanh toán
CREATE OR ALTER PROCEDURE THANHTOAN @MAHD INT, 
									@HINHTHUCTT NVARCHAR(50),
									--THÔNG TIN NGƯỜI NHẬN
									@HOTENNGUOINHAN NVARCHAR(50),
									@SDTNGNHAN CHAR(10),
									@DIACHI NVARCHAR(MAX),
									@EMAIL NVARCHAR(MAX),
									@THOIGIANGIAO DATE,
									@LOINHAN NVARCHAR(MAX)
AS
BEGIN TRAN
	--Cập nhật TTHĐ
	UPDATE HOADON SET HinhThucTToan = @HINHTHUCTT, TinhTrangTToan = N'Đã thanh toán', TinhTrangHD = N'Đã xác nhận' WHERE MAHD = @MAHD
	DECLARE @VOUCHER CHAR(10)
	SET @VOUCHER = (SELECT MaVoucher FROM HOADON WHERE MaHD = @MAHD)
	--Kiểm tra và trừ số lần sử dụng Voucher
	IF @VOUCHER IS NOT NULL
	BEGIN
		UPDATE VOUCHER
		SET SoLanSuDung = SoLanSuDung - 1
		WHERE MaVoucher = @VOUCHER
	END

	DECLARE @MaKHNhan INT = (SELECT MaKH FROM KHACHHANG WHERE TenKH = @HOTENNGUOINHAN AND SdtKH = @SDTNGNHAN)	--tìm kiếm khách hàng 

	IF @HOTENNGUOINHAN IS NOT NULL AND @HOTENNGUOINHAN != N''
	BEGIN
		SET @MaKHNhan = (SELECT MaKH FROM KHACHHANG WHERE SdtKH = @SDTNGNHAN)
		IF @MaKHNhan IS NULL
		BEGIN
			INSERT KHACHHANG(TenKH,SdtKH,DiaChiKH,EmailKH) VALUES (@HOTENNGUOINHAN, @SDTNGNHAN, @DIACHI, @EMAIL)
			SET @MaKHNhan = SCOPE_IDENTITY()
		END
	END
	INSERT HOADON_VANCHUYEN(MaHD,MaKHNhan, DiaChiNhan, ThoiGianGiao, LoiNhan) VALUES (@MAHD, @MaKHNhan, @DIACHI, @THOIGIANGIAO, @LOINHAN)
COMMIT TRAN
GO
