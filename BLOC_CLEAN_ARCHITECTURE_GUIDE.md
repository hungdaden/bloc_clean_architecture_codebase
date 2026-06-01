# HƯỚNG DẪN CHI TIẾT: BLoC & CLEAN ARCHITECTURE TRONG FLUTTER
*(Tài liệu ôn tập & Chuẩn bị phỏng vấn)*

Clean Architecture là một kiến trúc phần mềm chia project thành nhiều lớp (layers) độc lập với nhau, với nguyên tắc cốt lõi là **Dependency Rule**: Lớp bên ngoài phụ thuộc vào lớp bên trong, nhưng lớp bên trong không hề biết gì về lớp bên ngoài. 

Khi kết hợp với **BLoC (Business Logic Component)** làm State Management, chúng ta thường chia ứng dụng thành 3 layers chính: **Domain**, **Data**, và **Presentation (App/UI)**.

---

## 1. TỔNG QUAN VỀ CÁC LAYER (LỚP)

1. **Domain Layer (Lớp cốt lõi - Trong cùng):**
   - Chứa Business Logic (Quy tắc nghiệp vụ cốt lõi) của ứng dụng.
   - Hoàn toàn KHÔNG phụ thuộc vào Flutter, không phụ thuộc vào bất kỳ thư viện bên thứ 3 nào (như API, Database).
   - Bao gồm: `Entities` (Dữ liệu cốt lõi), `Repositories` (Chỉ là Interface/Abstract class), `UseCases`.

2. **Data Layer (Lớp dữ liệu):**
   - Chịu trách nhiệm lấy dữ liệu và gửi dữ liệu đi.
   - Phụ thuộc vào Domain Layer.
   - Bao gồm: `Models` (DTO - parse JSON/DB), `Data Sources` (Gọi API, Query DB), `Repositories Impl` (Implement các Interface ở lớp Domain).

3. **Presentation / App Layer (Lớp giao diện):**
   - Nơi tương tác với người dùng.
   - Phụ thuộc vào Domain Layer.
   - Bao gồm: `UI` (Widgets, Pages) và `BLoC` (Event, State, Bloc để quản lý trạng thái).

---

## 2. QUY TRÌNH VIẾT CODE TUẦN TỰ (STEP-BY-STEP)

Khi nhận một task mới (ví dụ: Tính năng Lấy danh sách Thực Đơn - `GetMenu`), bạn **NÊN VIẾT TỪ TRONG RA NGOÀI (Từ Domain -> Data -> Presentation)**.

### BƯỚC 1: XÂY DỰNG DOMAIN LAYER
Bạn bắt đầu ở tầng trong cùng vì nó không phụ thuộc vào ai.

**1.1. Viết Entity (`menu_entity.dart`)**
- Định nghĩa đối tượng thực đơn thuần tuý.
```dart
class MenuEntity {
  final String id;
  final String name;
  final int calories;
  MenuEntity({required this.id, required this.name, required this.calories});
}
```

**1.2. Viết Repository Interface (`menu_repository.dart`)**
- Chỉ khai báo các hàm cần thiết, KHÔNG viết logic gọi API ở đây.
```dart
abstract class MenuRepository {
  Future<List<MenuEntity>> getMenus();
}
```

**1.3. Viết UseCase (`get_menus_use_case.dart`)**
- Nơi gọi hàm từ Repository và xử lý logic nghiệp vụ (nếu có). Trực tiếp phục vụ cho BLoC.
```dart
class GetMenusUseCase {
  final MenuRepository repository;
  GetMenusUseCase(this.repository);

  Future<List<MenuEntity>> execute() async {
    // Có thể check logic gì đó ở đây trước khi return
    return await repository.getMenus();
  }
}
```

---

### BƯỚC 2: XÂY DỰNG DATA LAYER
Bây giờ bạn cần lấy dữ liệu thực tế để truyền cho Domain.

**2.1. Viết Model (`menu_model.dart`)**
- Model dùng để parse dữ liệu từ JSON (API trả về). Nó thường có hàm `fromJson`, `toJson` và `toEntity` để chuyển thành `MenuEntity` cho tầng Domain.
```dart
class MenuModel extends MenuEntity {
  MenuModel({required super.id, required super.name, required super.calories});

  factory MenuModel.fromJson(Map<String, dynamic> json) {
    return MenuModel(
      id: json['id'],
      name: json['name'],
      calories: json['calories'],
    );
  }
}
```

**2.2. Viết Data Source (`menu_remote_data_source.dart`)**
- Nơi trực tiếp gọi API (dùng Dio, Http...).
```dart
abstract class MenuRemoteDataSource {
  Future<List<MenuModel>> fetchMenus();
}

class MenuRemoteDataSourceImpl implements MenuRemoteDataSource {
  final Dio dio; // Hoặc thư viện gọi mạng bất kỳ
  MenuRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MenuModel>> fetchMenus() async {
    final response = await dio.get('/menus');
    return (response.data as List).map((e) => MenuModel.fromJson(e)).toList();
  }
}
```

**2.3. Viết Repository Impl (`menu_repository_impl.dart`)**
- Là cầu nối thực sự: Implement cái interface ở tầng Domain, gọi hàm từ Data Source, bắt lỗi mạng (Exception/Failure), và trả về `Entity`.
```dart
class MenuRepositoryImpl implements MenuRepository {
  final MenuRemoteDataSource remoteDataSource;
  MenuRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<MenuEntity>> getMenus() async {
    try {
      final models = await remoteDataSource.fetchMenus();
      return models; // Vì MenuModel kế thừa MenuEntity
    } catch (e) {
      throw ServerException();
    }
  }
}
```

---

### BƯỚC 3: XÂY DỰNG PRESENTATION LAYER (UI + BLOC)
Bây giờ dữ liệu đã sẵn sàng, ta cần đưa lên giao diện.

**3.1. Viết State (`menu_state.dart`)**
- Mô tả tất cả các trạng thái có thể có của màn hình (Loading, Có data, Bị lỗi). Thường dùng thư viện `freezed` hoặc `equatable`.
```dart
class MenuState {
  final bool isLoading;
  final List<MenuEntity> menus;
  final String? error;

  MenuState({this.isLoading = false, this.menus = const [], this.error});
  // Các hàm copyWith để tạo state mới...
}
```

**3.2. Viết Event (`menu_event.dart`)**
- Mô tả các hành động từ phía UI (Người dùng mở app, vuốt refesh, bấm nút...).
```dart
abstract class MenuEvent {}

class MenuPageInitiated extends MenuEvent {} // Khi màn hình vừa mở
class MenuRefreshClicked extends MenuEvent {}
```

**3.3. Viết BLoC (`menu_bloc.dart`)**
- Nhận `Event`, gọi `UseCase` tương ứng, đợi kết quả và phát ra `State` (bằng hàm `emit()`) cho UI cập nhật.
```dart
class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetMenusUseCase getMenusUseCase;

  MenuBloc(this.getMenusUseCase) : super(MenuState()) {
    on<MenuPageInitiated>(_onPageInitiated);
  }

  Future<void> _onPageInitiated(MenuPageInitiated event, Emitter<MenuState> emit) async {
    // 1. Emit trạng thái Loading
    emit(state.copyWith(isLoading: true));
    
    try {
      // 2. Gọi UseCase lấy dữ liệu
      final data = await getMenusUseCase.execute();
      // 3. Emit trạng thái Thành công có data
      emit(state.copyWith(isLoading: false, menus: data));
    } catch (e) {
      // 4. Emit trạng thái Lỗi
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
```

**3.4. Viết UI / Page (`menu_page.dart`)**
- Dùng `BlocBuilder`, `BlocListener` để lắng nghe `State` và vẽ giao diện tương ứng. Dùng `bloc.add(Event())` để gửi hành động.
```dart
class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBloc, MenuState>(
      builder: (context, state) {
        if (state.isLoading) return CircularProgressIndicator();
        if (state.error != null) return Text("Lỗi: ${state.error}");
        
        return ListView.builder(
          itemCount: state.menus.length,
          itemBuilder: (context, index) {
            return Text(state.menus[index].name);
          },
        );
      }
    );
  }
}
```

---

## 3. CÂU HỎI PHỎNG VẤN THƯỜNG GẶP (VÀ CÁCH TRẢ LỜI)

1. **Tại sao lại cần chia Repository thành Interface (ở Domain) và Impl (ở Data)?**
   *Đáp:* Để đảm bảo nguyên tắc Dependency Inversion (chữ D trong SOLID). Lớp Domain (Logic nghiệp vụ) chỉ phụ thuộc vào Interface (Khai báo), không phụ thuộc vào lớp Data cụ thể. Nhờ vậy, ta có thể dễ dàng thay đổi cách lấy dữ liệu (từ API sang Local DB) hoặc mock dữ liệu để Test mà không cần sửa một dòng code nào ở tầng Domain.

2. **Sự khác biệt giữa Entity (Domain) và Model (Data) là gì?**
   *Đáp:* `Entity` là đối tượng thuần túy, định nghĩa cấu trúc dữ liệu cốt lõi của ứng dụng. `Model` thuộc tầng Data, ngoài các fields giống Entity, nó chứa thêm logic để parse dữ liệu (toJson, fromJson) từ API hoặc DB. 

3. **Tại sao không gọi thẳng Repository từ BLoC mà phải qua UseCase?**
   *Đáp:* Có thể gọi thẳng (nếu app đơn giản). Tuy nhiên, dùng UseCase có lợi ích:
   - Gom nhóm logic nghiệp vụ phức tạp lại một chỗ. Đôi khi 1 tính năng cần gọi nhiều Repository khác nhau, gom vào 1 UseCase sẽ giúp BLoC nhẹ nhàng hơn (BLoC chỉ lo quản lý State, không lo logic tính toán).
   - Dễ viết Unit Test hơn.

4. **Luồng dữ liệu (Data flow) trong kiến trúc này chạy thế nào?**
   *Đáp:* 
   - **User** thao tác -> **UI** bắn ra một `Event`.
   - **BLoC** nhận `Event`, gọi **UseCase**.
   - **UseCase** gọi **Repository (Interface)**.
   - **RepositoryImpl** thực thi, gọi **DataSource**.
   - **DataSource** gọi API/DB lấy JSON về, parse thành **Model**, trả lại cho **RepositoryImpl**.
   - **RepositoryImpl** map **Model** thành **Entity**, trả về cho **UseCase**.
   - **UseCase** trả **Entity** về cho **BLoC**.
   - **BLoC** đóng gói **Entity** vào **State** và `emit()` ra.
   - **UI** lắng nghe **State** thay đổi và vẽ lại màn hình.

---
*Chúc bạn hiểu rõ kiến trúc này và có một buổi phỏng vấn thành công!*
