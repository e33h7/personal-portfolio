-- =============================================
-- Task Management App - Database Script
-- Chạy script này trong SQL Server Management Studio
-- =============================================

-- Tạo database
CREATE DATABASE TaskManagementDB;
GO

USE TaskManagementDB;
GO

-- =============================================
-- Bảng Users: Lưu thông tin người dùng
-- =============================================
CREATE TABLE Users (
    Id       INT           IDENTITY(1,1) PRIMARY KEY,
    Name     NVARCHAR(100) NOT NULL,
    Email    NVARCHAR(150) NOT NULL UNIQUE,
    Password NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME     DEFAULT GETDATE()
);
GO

-- =============================================
-- Bảng Tasks: Lưu thông tin công việc
-- =============================================
CREATE TABLE Tasks (
    Id          INT           IDENTITY(1,1) PRIMARY KEY,
    Title       NVARCHAR(200) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Deadline    DATETIME      NULL,
    Priority    NVARCHAR(20)  NOT NULL DEFAULT 'Medium',   -- Low / Medium / High
    Status      NVARCHAR(20)  NOT NULL DEFAULT 'Pending',  -- Pending / InProgress / Done
    UserId      INT           NOT NULL,
    CreatedAt   DATETIME      DEFAULT GETDATE(),
    UpdatedAt   DATETIME      DEFAULT GETDATE(),

    CONSTRAINT FK_Tasks_Users FOREIGN KEY (UserId) REFERENCES Users(Id) ON DELETE CASCADE
);
GO

-- =============================================
-- Dữ liệu mẫu (tùy chọn)
-- =============================================
INSERT INTO Users (Name, Email, Password) VALUES
    (N'Admin', 'admin@demo.com', 'admin123'),
    (N'Nguyễn Văn An', 'an@demo.com', '123456');
GO

INSERT INTO Tasks (Title, Description, Deadline, Priority, Status, UserId) VALUES
    (N'Hoàn thiện báo cáo đồ án', N'Viết báo cáo cuối kỳ môn Lập trình C#', '2024-12-31', 'High',   'InProgress', 1),
    (N'Ôn tập Cơ sở dữ liệu',    N'Ôn lại SQL, normalization',              '2024-12-20', 'Medium', 'Pending',    1),
    (N'Nộp bài tập lớn môn Mạng', N'Bài tập lớn thiết kế mạng LAN',        '2024-12-15', 'High',   'Done',       1),
    (N'Đọc sách Clean Code',      N'Đọc 3 chương đầu',                       '2025-01-10', 'Low',    'Pending',    2);
GO

-- =============================================
-- View tiện ích: Hiển thị task kèm tên user
-- =============================================
CREATE VIEW vw_TasksWithUser AS
    SELECT
        t.Id,
        t.Title,
        t.Description,
        t.Deadline,
        t.Priority,
        t.Status,
        t.UserId,
        u.Name  AS UserName,
        u.Email AS UserEmail,
        t.CreatedAt,
        t.UpdatedAt
    FROM Tasks t
    INNER JOIN Users u ON t.UserId = u.Id;
GO

-- =============================================
-- Stored Procedure: Thống kê task theo trạng thái
-- =============================================
CREATE PROCEDURE sp_GetTaskStats
    @UserId INT
AS
BEGIN
    SELECT
        COUNT(*)                                    AS Total,
        SUM(CASE WHEN Status = 'Pending'    THEN 1 ELSE 0 END) AS Pending,
        SUM(CASE WHEN Status = 'InProgress' THEN 1 ELSE 0 END) AS InProgress,
        SUM(CASE WHEN Status = 'Done'       THEN 1 ELSE 0 END) AS Done
    FROM Tasks
    WHERE UserId = @UserId;
END
GO

PRINT N'Database TaskManagementDB đã được tạo thành công!';
