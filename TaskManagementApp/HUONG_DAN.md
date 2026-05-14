# Task Management App — Hướng dẫn chạy project

## Yêu cầu cài đặt

| Phần mềm | Phiên bản tối thiểu | Tải về |
|----------|---------------------|--------|
| Visual Studio | 2022 (Community miễn phí) | https://visualstudio.microsoft.com |
| .NET SDK | 8.0 | Cài kèm Visual Studio |
| SQL Server | 2019+ hoặc Express (miễn phí) | https://www.microsoft.com/sql-server |
| SSMS | 19+ | https://aka.ms/ssmsfullsetup |

---

## Bước 1: Tạo Database

1. Mở **SQL Server Management Studio (SSMS)**
2. Kết nối đến SQL Server instance của bạn
3. Mở file **`SQL/CreateDatabase.sql`**
4. Nhấn **F5** hoặc nút **Execute** để chạy script
5. Kiểm tra database `TaskManagementDB` đã xuất hiện trong Object Explorer

---

## Bước 2: Cấu hình Connection String

Mở file `TaskManagementApp/App.config` và sửa thẻ `<connectionStrings>`:

### Trường hợp 1: SQL Server Express (thường gặp nhất)
```xml
<add name="TaskManagementDB"
     connectionString="Server=.\SQLEXPRESS;Database=TaskManagementDB;Integrated Security=True;TrustServerCertificate=True;"
     providerName="System.Data.SqlClient" />
```

### Trường hợp 2: SQL Server Developer/Standard
```xml
<add name="TaskManagementDB"
     connectionString="Server=localhost;Database=TaskManagementDB;Integrated Security=True;TrustServerCertificate=True;"
     providerName="System.Data.SqlClient" />
```

### Trường hợp 3: Dùng SQL Authentication (có username/password)
```xml
<add name="TaskManagementDB"
     connectionString="Server=localhost;Database=TaskManagementDB;User Id=sa;Password=YourPassword;TrustServerCertificate=True;"
     providerName="System.Data.SqlClient" />
```

> **Mẹo:** Nếu không biết tên instance, mở SSMS và xem tên ở cột "Server name" khi kết nối.

---

## Bước 3: Mở và chạy project

1. Mở file **`TaskManagementApp.sln`** bằng Visual Studio 2022
2. Chờ Visual Studio khôi phục các NuGet packages (tự động)
3. Nhấn **F5** hoặc nút ▶ **Start** để chạy
4. Form **Đăng nhập** sẽ xuất hiện

---

## Tài khoản demo (có sẵn trong database)

| Email | Mật khẩu | Ghi chú |
|-------|----------|---------|
| admin@demo.com | admin123 | Tài khoản admin |
| an@demo.com | 123456 | Tài khoản mẫu |

---

## Cấu trúc Project

```
TaskManagementApp/
├── TaskManagementApp.sln          ← File mở bằng Visual Studio
├── SQL/
│   └── CreateDatabase.sql         ← Script tạo database (chạy trước)
└── TaskManagementApp/
    ├── TaskManagementApp.csproj   ← File cấu hình project
    ├── App.config                 ← Connection string (SỬA Ở ĐÂY)
    ├── Program.cs                 ← Điểm khởi chạy
    │
    ├── Models/                    ← Các lớp dữ liệu
    │   ├── User.cs                  Thông tin người dùng
    │   └── TaskItem.cs              Thông tin công việc
    │
    ├── Database/                  ← Kết nối database
    │   └── DatabaseConnection.cs    Cung cấp SqlConnection
    │
    ├── Services/                  ← Xử lý logic nghiệp vụ
    │   ├── UserService.cs           Đăng nhập, đăng ký
    │   └── TaskService.cs           CRUD công việc, thống kê
    │
    └── Forms/                     ← Giao diện người dùng
        ├── LoginForm.cs             Form đăng nhập
        ├── RegisterForm.cs          Form đăng ký
        ├── MainForm.cs              Form chính (sidebar + dashboard)
        └── AddEditTaskForm.cs       Form thêm/sửa công việc
```

---

## Chức năng

| # | Chức năng | Cách dùng |
|---|-----------|-----------|
| 1 | Đăng nhập | Nhập email + mật khẩu → Đăng nhập |
| 2 | Đăng ký | Click "Đăng ký ngay" ở form login |
| 3 | Xem danh sách | Tự động hiển thị sau đăng nhập |
| 4 | Thêm task | Nút **➕ Thêm** trên toolbar |
| 5 | Sửa task | Chọn task → Nút **✏ Sửa** hoặc double-click |
| 6 | Xóa task | Chọn task → Nút **🗑 Xóa** |
| 7 | Hoàn thành | Chọn task → Nút **✅ Hoàn thành** |
| 8 | Tìm kiếm | Gõ từ khóa vào ô tìm kiếm → Enter |
| 9 | Lọc trạng thái | Click menu bên trái (Chờ xử lý / Đang làm / Xong) |
| 10 | Thống kê | Các ô số liệu ở đầu trang tự động cập nhật |

---

## Lỗi thường gặp

### ❌ "Cannot connect to SQL Server"
- Kiểm tra SQL Server đang chạy (Windows Services > SQL Server)
- Kiểm tra tên instance trong connection string
- Thử đổi `.\SQLEXPRESS` → `localhost` hoặc tên máy tính

### ❌ "Database not found"
- Chắc chắn đã chạy file `SQL/CreateDatabase.sql`
- Kiểm tra trong SSMS có database `TaskManagementDB` chưa

### ❌ NuGet packages lỗi
- Trong Visual Studio: **Tools → NuGet Package Manager → Restore NuGet Packages**

### ❌ Build lỗi "TargetFramework"
- Cài .NET 8 SDK: https://dotnet.microsoft.com/download/dotnet/8.0
- Hoặc đổi `<TargetFramework>net8.0-windows</TargetFramework>` thành `net6.0-windows`

---

## Mở rộng thêm (gợi ý cho đồ án)

- **Xuất Excel:** Dùng thư viện `EPPlus` hoặc `ClosedXML`
- **Dark Mode:** Dùng thư viện `MaterialSkin2`
- **Nhắc nhở deadline:** Dùng `System.Windows.Forms.Timer` check hàng ngày
- **Hash mật khẩu:** Dùng `BCrypt.Net` thay vì lưu plaintext
- **Báo cáo PDF:** Dùng thư viện `iTextSharp` hoặc `QuestPDF`

---

*Chúc bạn làm đồ án thành công! 🎓*
