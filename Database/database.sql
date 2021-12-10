USE [master]
GO

DROP DATABASE IF EXISTS [HOAYEUTHUONG]
GO
CREATE DATABASE [HOAYEUTHUONG]
GO
USE [HOAYEUTHUONG]
GO

DROP TABLE IF EXISTS [DS_PHANLOAI];
DROP TABLE IF EXISTS [SANPHAM];
DROP TABLE IF EXISTS [SANPHAM_CHUDE];
DROP TABLE IF EXISTS [NHACUNGCAP];
DROP TABLE IF EXISTS [DS_CUNGCAP];
DROP TABLE IF EXISTS [PHIEUMUA];
DROP TABLE IF EXISTS [CT_PHIEUMUA];
GO

/*==============================================================*/
/* Groupe: Sanpham, nguyenlieu                                  */
/*==============================================================*/
CREATE TABLE [dbo].[DS_PHANLOAI](
	MaSo		int IDENTITY(1,1)	not null,
	Loai		varchar(20)			not null,
	UNIQUE (MaSo, Loai),
	CONSTRAINT PK_PHANLOAI PRIMARY KEY(MaSo)
);

CREATE TABLE [dbo].[SANPHAM](
	MaSP		int					not null,
	Loai		varchar(20)			not null,
	TenSP		nvarchar(40)		not null,
	NgaySangTao	date				null,
	DonGiaSP	numeric(8,2)		null,
	GiamGiaSP	numeric(8,2)		null,
	ThongTinSP	nvarchar(255)		null,
	TinhTrangSP	nvarchar(20)		null,
	CONSTRAINT PK_SANPHAM PRIMARY KEY(MaSP)
);

CREATE TABLE [dbo].[SANPHAM_CHUDE](
	MaSP		int					not null,
	ChuDe		nvarchar(20)		not null,
	LoaiChuDe	nvarchar(20)		not null,
	TenSP		nvarchar(40)		null,
	CONSTRAINT PK_SANPHAM_CHUDE PRIMARY KEY(MaSP, ChuDe, LoaiChuDe)
);

/*==============================================================*/
/* Group: ThanhPhan                                             */
/*==============================================================*/
CREATE TABLE [dbo].[NHACUNGCAP](
	MaNCC		int IDENTITY(1,1)	not null,
	TenNCC		nvarchar(40)		not null,
	SdtNCC		char(10)			null,
	DiaChiNCC	nvarchar(255)		null,
	CONSTRAINT PK_NHACUNGCAP PRIMARY KEY(MaNCC)
);

CREATE TABLE [dbo].[DS_CUNGCAP](
	MaNCC		int					not null,
	MaSo		int					not null,
	Loai		varchar(20)			not null,
	CONSTRAINT PK_DS_CUNGCAP PRIMARY KEY(MaNCC, MaSo)
);

/*==============================================================*/
/* Group: Cac loai Phieu                                        */
/*==============================================================*/
CREATE TABLE [dbo].[PHIEUMUA](
	SoPM		int IDENTITY(1,1)	not null,
	MaNCC		int					not null,
	MaCH		int					null,
	NgayLapPM	date				not null,
	TinhTrangGiao nvarchar(20)		null,
	TongChiPhi	numeric(8,2)		null,
	CONSTRAINT PK_PHIEUMUA PRIMARY KEY(SoPM)
);

CREATE TABLE [dbo].[CT_PHIEUMUA](
	SoPM		int					not null,
	MaSo		int					not null,
	Loai		varchar(20)			not null, 
	SoLuongMua	int					not null,
	CONSTRAINT PK_CT_PHIEUMUA PRIMARY KEY(SoPM, MaSo, Loai)
);


GO



/*==============================================================*/
/* Foreign key                                                  */
/*==============================================================*/
ALTER TABLE [dbo].[SANPHAM]
ADD CONSTRAINT FK_SANPHAM_PHANLOAI FOREIGN KEY(MaSP, Loai)
REFERENCES [dbo].[DS_PHANLOAI](MaSo, Loai)

ALTER TABLE [dbo].[SANPHAM_CHUDE]
ADD CONSTRAINT FK_SANPHAM_CHUDE FOREIGN KEY(MaSP)
REFERENCES [dbo].[SANPHAM](MaSP)

ALTER TABLE [dbo].[DS_CUNGCAP]
ADD CONSTRAINT FK_CUNGCAP_NCC FOREIGN KEY(MaNCC)
REFERENCES [dbo].[NHACUNGCAP](MaNCC)

ALTER TABLE [dbo].[DS_CUNGCAP]
ADD CONSTRAINT FK_CUNGCAP_SANPHAM FOREIGN KEY(MaSo, Loai)
REFERENCES [dbo].[DS_PHANLOAI](MaSo, Loai)

ALTER TABLE [dbo].[PHIEUMUA]
ADD CONSTRAINT FK_PHIEUMUA_NCC FOREIGN KEY(MaNCC)
REFERENCES [dbo].[NHACUNGCAP](MaNCC)
/*
ALTER TABLE [dbo].[PHIEUMUA]
ADD CONSTRAINT FK_PHIEUMUA_CH FOREIGN KEY(MaCH)
REFERENCES [dbo].[CUAHANG](MaCH)
--*/
ALTER TABLE [dbo].[CT_PHIEUMUA]
ADD CONSTRAINT FK_PHIEUMUA FOREIGN KEY(SoPM)
REFERENCES [dbo].[PHIEUMUA](SoPM)

ALTER TABLE [dbo].[CT_PHIEUMUA]
ADD CONSTRAINT FK_PHIEUMUA_SANPHAM FOREIGN KEY(MaSo, Loai)
REFERENCES [dbo].[DS_PHANLOAI](MaSo, Loai)

GO



/*==============================================================*/
/* Default values                                               */
/*==============================================================*/
ALTER TABLE [dbo].[SANPHAM] ADD DEFAULT 'SanPham' FOR Loai
ALTER TABLE [dbo].[SANPHAM] ADD DEFAULT ((0)) FOR DonGiaSP
ALTER TABLE [dbo].[SANPHAM] ADD DEFAULT ((0)) FOR GiamGiaSP
ALTER TABLE [dbo].[SANPHAM] ADD DEFAULT N'Còn hàng' FOR TinhTrangSP

ALTER TABLE [dbo].[PHIEUMUA] ADD DEFAULT N'Chưa giao' FOR TinhTrangGiao
ALTER TABLE [dbo].[PHIEUMUA] ADD DEFAULT ((0)) FOR TongChiPhi
ALTER TABLE [dbo].[CT_PHIEUMUA] ADD DEFAULT ((0)) FOR SoLuongMua
GO



/*==============================================================*/
/* Trigger                                                      */
/*==============================================================*/
CREATE OR ALTER TRIGGER [dbo].[ChuDe_TenSP]
ON [dbo].[SANPHAM_CHUDE]
FOR INSERT
AS
BEGIN
	INSERT INTO [dbo].[SANPHAM_CHUDE](MaSP, ChuDe, LoaiChuDe, TenSP)
	SELECT i.MaSP, i.ChuDe, i.LoaiChuDe,
		CASE WHEN i.TenSP IS NOT NULL THEN i.TenSP 
			ELSE (SELECT sp.TenSP FROM SANPHAM sp WHERE sp.MaSP = i.MaSP)END
	FROM inserted i
END
GO
ALTER TABLE [dbo].[SANPHAM_CHUDE] ENABLE TRIGGER [ChuDe_TenSP]
GO



