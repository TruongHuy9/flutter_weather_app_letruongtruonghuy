#  Flutter Weather App - Lê Trường Trường Huy

---

##  Giới thiệu
Ứng dụng **Flutter Weather App** là một ứng dụng di động giúp người dùng tra cứu thông tin thời tiết theo vị trí hoặc tìm kiếm thành phố bất kỳ.

Ứng dụng cung cấp:
- Thời tiết hiện tại
- Dự báo thời tiết nhiều ngày
- Giao diện thay đổi theo điều kiện thời tiết (trời nắng, mưa, ban đêm,...)

---

##  Tính năng chính
-  Lấy vị trí hiện tại của người dùng
-  Tìm kiếm thời tiết theo tên thành phố
-  Hiển thị thời tiết hiện tại:
  - Nhiệt độ
  - Độ ẩm
  - Tốc độ gió
  - Trạng thái thời tiết
-  Dự báo thời tiết (forecast)
-  Hỗ trợ giao diện ngày/đêm
-  Xử lý lỗi (không có mạng, sai tên thành phố,...)
-  Hiển thị loading khi đang tải dữ liệu

---

##  Hướng dẫn cấu hình API (KHÔNG để lộ key)

Ứng dụng sử dụng API thời tiết (ví dụ: OpenWeatherMap)

### Bước 1: Đăng ký API
- Truy cập: https://openweathermap.org/api
- Tạo tài khoản và lấy API Key

### Bước 2: Cấu hình trong project

**KHÔNG commit API key lên GitHub**

Tạo file:
```
lib/config/api_key.dart
```

Nội dung:
```dart
class ApiKey {
  static const String weatherApiKey = "YOUR_API_KEY_HERE";
}
```

Sau đó import:
```dart
import 'config/api_key.dart';
```

---

##  Screenshots


###  Thời tiết mưa
<img width="440" height="866" alt="Screenshot 2026-05-02 232117" src="https://github.com/user-attachments/assets/41c305c0-cac0-415e-8500-02d0d366d199" />

###  Thời tiết nhiều mây
<img width="443" height="870" alt="Screenshot 2026-05-02 232058" src="https://github.com/user-attachments/assets/f8b8f8d5-28d2-4d3f-a1de-06b703295db5" />

###  Màn hình tìm kiếm
<img width="440" height="870" alt="Screenshot 2026-05-02 232205" src="https://github.com/user-attachments/assets/681ca126-afd6-47f5-bc13-3328a4d9e5b0" />

###  Màn hình dự báo
<img width="461" height="897" alt="Screenshot 2026-05-02 232251" src="https://github.com/user-attachments/assets/17dea189-1db7-4314-bf46-b44ac8ffe482" />

###  Trạng thái lỗi
<img width="404" height="831" alt="Screenshot 2026-05-02 234807" src="https://github.com/user-attachments/assets/5008f8c5-c3f1-4704-9beb-4991c9c8850d" />

<img width="416" height="841" alt="Screenshot 2026-05-02 234748" src="https://github.com/user-attachments/assets/42de1148-83f3-4edd-b6a3-0a260857dca5" />

###  Trạng thái loading
![alt text](<Screenshot 2026-05-02 234748.png>)
![alt text](<Screenshot 2026-05-02 234807.png>)

###  Trạng thái Offline
<img width="456" height="877" alt="Screenshot 2026-05-02 231855" src="https://github.com/user-attachments/assets/df6df6cf-b008-47c0-9f18-6ec31db38eea" />
---

##  Cách chạy project

### 1. Clone project
```bash
git clone https://github.com/TruongHuy9/flutter_weather_app_letruongtruonghuy.git
```

### 2. Cài dependencies
```bash
flutter pub get
```

### 3. Chạy ứng dụng
```bash
flutter run
```

---

##  Công nghệ sử dụng
- Flutter (Dart)
- Provider (State Management)
- REST API
- HTTP package
- Geolocator (lấy vị trí)
- Intl (format ngày giờ)

---

##  Hạn chế
- Phụ thuộc vào API bên thứ 3
- Chưa tối ưu UI cho tablet
- Cần internet để hoạt động
- Độ chính xác phụ thuộc API

---

##  Hướng phát triển
-  Thêm lưu danh sách thành phố yêu thích
-  Hỗ trợ đa ngôn ngữ
-  Biểu đồ thời tiết
-  Thông báo thời tiết
-  Tùy chỉnh giao diện (theme)

---

##  Cấu trúc thư mục

<img width="547" height="882" alt="Screenshot 2026-05-02 235155" src="https://github.com/user-attachments/assets/59e521ce-ebcf-4d75-ab7c-bcf88e9613b5" />
<img width="551" height="290" alt="Screenshot 2026-05-02 235208" src="https://github.com/user-attachments/assets/6bfa17ed-382a-44f8-abd4-9eb291b475d4" />

---
