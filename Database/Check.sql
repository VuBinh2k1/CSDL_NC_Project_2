USE [HOAYEUTHUONG]
GO

-----------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[DS_PHANLOAI]
ADD CONSTRAINT CHK_Loai CHECK (Loai IN ('SANPHAM', 'NGUYENLIEU', 'SP_MUA', 'BOHOA', 'GAUBONG', 'BANH', 'TRANGTRI'))
GO
-----------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[SANPHAM]
ADD CONSTRAINT CHK_SP_DonGiaSP CHECK (DonGiaSP >= 0)
GO
ALTER TABLE [dbo].[SANPHAM]
ADD CONSTRAINT CHK_SP_GiamGiaSP CHECK (GiamGiaSP >= 0)
GO
ALTER TABLE [dbo].[SANPHAM]
ADD CONSTRAINT CHK_SP_TinhTrangSP CHECK (TinhTrangSP IN (N'Còn hàng', N'Hết hàng'))
GO
-----------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[NGUYENLIEU]
ADD CONSTRAINT CHK_NL_DonGiaNL CHECK (DonGiaNL >= 0)
GO
ALTER TABLE [dbo].[NGUYENLIEU]
ADD CONSTRAINT CHK_NL_SoLuongKHO CHECK (SoLuongKHO >= 0)
GO
ALTER TABLE [dbo].[NGUYENLIEU]
ADD CONSTRAINT CHK_NL_SoLuongToiThieu CHECK (SoLuongToiThieu >= 0)
GO
-----------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[SANPHAM_NGUYENLIEU]
ADD CONSTRAINT CHK_SPNL_SoLuongNL CHECK (SoLuongNL >= 0)
GO
ALTER TABLE [dbo].[SOLUONG_NL]
ADD CONSTRAINT CHK_SLNL_SoLuongCH CHECK (SoLuongCH >= 0)
GO
-----------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[NHANVIEN]
ADD CONSTRAINT CHK_NV_LoaiNV CHECK (LoaiNV IN (N'Quản lý', N'Nhân viên cắm hoa', N'Nhân viên bán hàng', N'Nhân viên giao hàng', N'Nhân viên chăm sóc khách hàng'))
GO
ALTER TABLE [dbo].[NHANVIEN]
ADD CONSTRAINT CHK_NV_LuongCoDinh CHECK (LuongCoDinh >= 0)
GO
ALTER TABLE [dbo].[PHIEULUONG]
ADD CONSTRAINT CHK_PLg_Luong CHECK (Luong >= 0)
GO
-----------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[VOUCHER]
ADD CONSTRAINT CHK_VCH_GiaTri CHECK (GiaTri >= 0)
GO
ALTER TABLE [dbo].[VOUCHER]
ADD CONSTRAINT CHK_VCH_SoLanSuDung CHECK (SoLanSuDung >= 0)
GO
-----------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[HOADON]
ADD CONSTRAINT CHK_HD_TinhTrangTToan CHECK (TinhTrangTToan IN (N'Đã thanh toán', N'Chưa thanh toán'))
GO
ALTER TABLE [dbo].[HOADON]
ADD CONSTRAINT CHK_HD_TinhTrangHD CHECK (TinhTrangHD IN (N'Chưa xác nhận', N'Đã nhận', N'Đang giao', N'Đã giao'))
GO
ALTER TABLE [dbo].[HOADON_VANCHUYEN]
ADD CONSTRAINT CHK_HD_PhiVanChuyen CHECK (PhiVanChuyen >= 0)
GO
-----------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[PHIEUMUA]
ADD CONSTRAINT CHK_PM_TinhTrangGiao CHECK (TinhTrangGiao IN (N'Đã giao', N'Chưa giao'))
GO
ALTER TABLE [dbo].[PHIEUMUA]
ADD CONSTRAINT CHK_PM_TongChiPhi CHECK (TongChiPhi >= 0)
GO
-----------------------------------------------------------------------------------------------------
ALTER TABLE [dbo].[CT_HOADON]
ADD CONSTRAINT CHK_CTHD_SoLuong CHECK (SoLuong >= 0)
GO
ALTER TABLE [dbo].[CT_PHIEUNHAP]
ADD CONSTRAINT CHK_CTPN_SoLuongNhap CHECK (SoLuongNhap >= 0)
GO
ALTER TABLE [dbo].[CT_PHIEUXUAT]
ADD CONSTRAINT CHK_CTPX_SoLuongXuat CHECK (SoLuongXuat >= 0)
GO
ALTER TABLE [dbo].[CT_PHIEUMUA]
ADD CONSTRAINT CHK_CTPM_SoLuongMua CHECK (SoLuongMua >= 0)
GO