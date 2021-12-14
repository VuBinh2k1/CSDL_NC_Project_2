USE [HOAYEUTHUONG]
GO

-- == Xóa tất cả dữ liệu trong bảng ==
-- disable all triggers
EXEC sp_MSForEachTable 'DISABLE TRIGGER ALL ON ?'

-- disable all constraints
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'

-- delete data in all tables
EXEC sp_MSforeachtable 'SET QUOTED_IDENTIFIER ON; DELETE FROM ?'

-- enable all constraints
EXEC sp_MSForEachTable 'ALTER TABLE ? WITH CHECK CHECK CONSTRAINT ALL'

-- enable all triggers
EXEC sp_MSForEachTable 'ENABLE TRIGGER ALL ON ?'
GO