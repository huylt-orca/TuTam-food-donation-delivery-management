
import 'package:flutter/material.dart';



class ThemeConfig {
  static ThemeData createTheme({
    required Brightness brightness,
    required Color background,
    required Color primaryText,
    required Color secondaryText,
    required Color accentColor,
    required Color divider,
    required Color buttonText,
    required Color cardBackground,
    required Color disabled,
    required Color error,
  }) {
    final baseTextTheme = brightness == Brightness.dark
        ? Typography.blackMountainView
        : Typography.whiteMountainView;

    return ThemeData(
      brightness: brightness,
      canvasColor: background,
      cardColor: background,
      dividerColor: divider,
      dividerTheme: DividerThemeData(
        color: divider,
        space: 1,
        thickness: 1,
      ),
      cardTheme: CardTheme(
        color: cardBackground,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
      ),
      backgroundColor: background,
      primaryColor: accentColor,
      hintColor: accentColor,
      toggleableActiveColor: accentColor,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.amber,
      ),
      
      
      fontFamily: '',
      textTheme: TextTheme(
        displayLarge: baseTextTheme.displayLarge?.copyWith(
          color: primaryText,
          fontSize: 34.0,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: baseTextTheme.displayMedium?.copyWith(
          color: primaryText,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: baseTextTheme.displaySmall?.copyWith(
          color: secondaryText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: primaryText,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          color: primaryText,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: primaryText,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: secondaryText,
          fontSize: 15,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: primaryText,
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          color: primaryText,
          fontSize: 12.0,
          fontWeight: FontWeight.w700,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: primaryText,
          fontSize: 11.0,
          fontWeight: FontWeight.w300,
        ),
        labelSmall: baseTextTheme.labelSmall?.copyWith(
          color: secondaryText,
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: primaryText,
          fontSize: 16.0,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: baseTextTheme.titleSmall?.copyWith(
          color: secondaryText,
          fontSize: 11.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static ThemeData get lightTheme => createTheme(
        brightness: Brightness.light,
        background: Colors.white,
        cardBackground: Colors.white,
        primaryText: Colors.black,
        secondaryText: Colors.black,
        accentColor: Colors.black,
        divider: Colors.black,
        buttonText: Colors.black,
        disabled: Colors.grey,
        error: Colors.red,
      );

  static ThemeData get darkTheme => createTheme(
        brightness: Brightness.dark,
        background: Colors.white,
        cardBackground: Colors.grey,
        primaryText: Colors.black,
        secondaryText: Colors.black,
        accentColor: Colors.black,
        divider: Colors.black,
        buttonText: Colors.black,
        disabled: Colors.grey,
        error: Colors.red,
      );
}


/*
  ThemeData
 bool? applyElevationOverlayColor,  // xác định liệu áp dụng màu nền trang trí (elevation overlays) hay không
  NoDefaultCupertinoThemeData? cupertinoOverrideTheme,  // Cho phép bạn ghi đè cài đặt giao diện Cupertino (iOS) mặc định.
  Iterable<ThemeExtension<dynamic>>? extensions, //  Một danh sách các đối tượng ThemeExtension, có thể được sử dụng để mở rộng và tùy chỉnh chủ đề.
  InputDecorationTheme? inputDecorationTheme,  // Xác định chủ đề cho các widget input decoration.
  MaterialTapTargetSize? materialTapTargetSize, //  Xác định kích thước của các điểm chạm (tap targets) trong thiết kế Material.
  PageTransitionsTheme? pageTransitionsTheme, // Tùy chỉnh hiệu ứng chuyển trang.
  TargetPlatform? platform, // Chỉ định nền tảng mục tiêu (iOS, Android, v.v.) cho chủ đề được thiết kế
  ScrollbarThemeData? scrollbarTheme, // Tùy chỉnh giao diện của thanh cuộn.
  InteractiveInkFeatureFactory? splashFactory, // tùy chỉnh để tạo ra các tính năng ink tương tác (như ripples).
  bool? useMaterial3, // chỉ định liệu ứng dụng nên sử dụng kiểu dáng của Thiết kế Material 3 hay không.
  VisualDensity? visualDensity, // Điều chỉnh khoảng cách và bố cục của các phần tử giao diện người dùng
  Brightness? brightness, // Xác định độ sáng của chủ đề tổng thể (sáng hoặc tối).
  Color? canvasColor, // Đặt màu của nền ứng dụng.
  Color? cardColor, // Xác định màu của các thẻ (cards) trong ứng dụng.
  ColorScheme? colorScheme, // Một bảng màu đã định sẵn xác định màu chính và màu phụ.
  Color? colorSchemeSeed, // Một màu sử dụng như một "hạt giống" để tạo ra các màu khác trong chủ đề.
  Color? dialogBackgroundColor, // Đặt màu nền cho các hộp thoại (dialogs).
  Color? disabledColor, // Xác định màu cho các phần tử giao diện bị tắt.
  Color? dividerColor, //  Đặt màu của các đường chia cách (dividers).
  Color? focusColor, // Xác định màu cho các phần tử giao diện đang được tập trung.
  Color? highlightColor, // Đặt màu cho các điểm nổi bật (highlights).
  Color? hintColor, // Xác định màu cho các gợi ý (hints).
  Color? hoverColor, // Đặt màu cho các phần tử giao diện khi con trỏ chuột di chuyển qua chúng (hover).
  Color? indicatorColor, // Xác định màu cho các chỉ báo (indicators).
  Color? primaryColor, //  Đặt màu chủ đạo (primary color) cho ứng dụng.
  Color? primaryColorDark, // Xác định màu tối của màu chủ đạo.
  Color? primaryColorLight, // Xác định màu sáng của màu chủ đạo.
  MaterialColor? primarySwatch, // Sử dụng để xác định màu chủ đạo dựa trên một dải màu (material color swatch).
  Color? scaffoldBackgroundColor, // Đặt màu nền cho khung làm việc (scaffold).
  Color? secondaryHeaderColor, //  Xác định màu cho phần tiêu đề thứ cấp.
  Color? shadowColor, // Xác định màu của bóng đổ.
  Color? splashColor, // Đặt màu cho hiệu ứng nổi bật khi nhấn vào (splash).
  Color? unselectedWidgetColor, // Xác định màu cho các phần tử giao diện chưa được chọn.
  String? fontFamily, // Chọn phông chữ (font family) cho văn bản trong ứng dụng.
  List<String>? fontFamilyFallback, //  Danh sách các phông chữ phụ (fallback fonts) trong trường hợp phông chữ chính không khả dụng.
  String? package, // Xác định gói (package) chứa các tài nguyên giao diện người dùng (UI assets).
  IconThemeData? iconTheme, // Tùy chỉnh chủ đề cho biểu tượng (icon) trong ứng dụng.
  IconThemeData? primaryIconTheme, //  Chủ đề cho biểu tượng chính.
  TextTheme? primaryTextTheme, //  Chủ đề cho văn bản chính.
  TextTheme? textTheme, // Chủ đề cho tất cả các kiểu văn bản.
  Typography? typography, // Xác định kiểu chữ và kích thước chữ mặc định.
  ActionIconThemeData? actionIconTheme, // Chủ đề cho biểu tượng hành động (action icons).
  AppBarTheme? appBarTheme, // Tùy chỉnh giao diện thanh ứng dụng (app bar)
  BadgeThemeData? badgeTheme, //  Chủ đề cho huy hiệu (badge).
  MaterialBannerThemeData? bannerTheme, // Chủ đề cho thông báo banner.
  BottomAppBarTheme? bottomAppBarTheme, // Chủ đề cho thanh ứng dụng dưới cùng (bottom app bar).
  BottomNavigationBarThemeData? bottomNavigationBarTheme, //  Chủ đề cho thanh điều hướng dưới cùng (bottom navigation bar).
  BottomSheetThemeData? bottomSheetTheme, // Chủ đề cho bảng dưới cùng (bottom sheet)
  ButtonBarThemeData? buttonBarTheme, // Chủ đề cho thanh nút (button bar).
  ButtonThemeData? buttonTheme, //  Chủ đề cho nút (button).
  CardTheme? cardTheme, // Chủ đề cho thẻ (card).
  CheckboxThemeData? checkboxTheme, //  Chủ đề cho hộp kiểm (checkbox).
  ChipThemeData? chipTheme, // Chủ đề cho chip, một loại phần tử giao diện hiển thị thông tin ngắn gọn.
  DataTableThemeData? dataTableTheme, // Chủ đề cho bảng dữ liệu (data table).
  DatePickerThemeData? datePickerTheme, // Chủ đề cho các khung chọn ngày (date picker).
  DialogTheme? dialogTheme, // Chủ đề cho hộp thoại (dialog).
  DividerThemeData? dividerTheme, // Chủ đề cho thanh chia cách (divider).
  DrawerThemeData? drawerTheme, // Chủ đề cho menu bên (drawer).
  DropdownMenuThemeData? dropdownMenuTheme, // Chủ đề cho menu thả xuống (dropdown menu).
  ElevatedButtonThemeData? elevatedButtonTheme, // Chủ đề cho nút gồ ghề (elevated button).
  ExpansionTileThemeData? expansionTileTheme, // Chủ đề cho tiêu đề mở rộng (expansion tile).
  FilledButtonThemeData? filledButtonTheme, // Chủ đề cho nút filled (filled button).
  FloatingActionButtonThemeData? floatingActionButtonTheme, // Chủ đề cho nút hành động nổi (floating action button).
  IconButtonThemeData? iconButtonTheme, // Chủ đề cho nút biểu tượng (icon button).
  ListTileThemeData? listTileTheme, //  Chủ đề cho mục danh sách (list tile).
  MenuBarThemeData? menuBarTheme, // Chủ đề cho thanh menu (menu bar).
  MenuButtonThemeData? menuButtonTheme, // Chủ đề cho nút menu (menu button).
  MenuThemeData? menuTheme, // Chủ đề cho menu (menu).
  NavigationBarThemeData? navigationBarTheme, // Chủ đề cho thanh điều hướng (navigation bar).
  NavigationDrawerThemeData? navigationDrawerTheme, // Chủ đề cho menu điều hướng bên (navigation drawer).
  NavigationRailThemeData? navigationRailTheme, // Chủ đề cho thanh điều hướng (navigation rail).
  OutlinedButtonThemeData? outlinedButtonTheme, // Chủ đề cho nút outlined (outlined button).
  PopupMenuThemeData? popupMenuTheme, // Chủ đề cho menu bật lên (popup menu).
  ProgressIndicatorThemeData? progressIndicatorTheme, // Chủ đề cho các chỉ báo tiến trình (progress indicators).
  RadioThemeData? radioTheme,  // Chủ đề cho nút radio.
  SearchBarThemeData? searchBarTheme, // Chủ đề cho thanh tìm kiếm (search bar).
  SearchViewThemeData? searchViewTheme, //  Chủ đề cho khung xem tìm kiếm (search view).
  SegmentedButtonThemeData? segmentedButtonTheme, // Chủ đề cho nút segmented (segmented button).
  SliderThemeData? sliderTheme, // Chủ đề cho thanh trượt (slider).
  SnackBarThemeData? snackBarTheme, //  Chủ đề cho thông báo snackbar.
  SwitchThemeData? switchTheme, // Chủ đề cho nút chuyển đổi (switch).
  TabBarTheme? tabBarTheme, // Chủ đề cho thanh tab (tab bar).
  TextButtonThemeData? textButtonTheme, // Chủ đề cho nút văn bản (text button).
  TextSelectionThemeData? textSelectionTheme, // Chủ đề cho việc chọn văn bản (text selection).
  TimePickerThemeData? timePickerTheme, // Chủ đề cho khung chọn thời gian (time picker).
  ToggleButtonsThemeData? toggleButtonsTheme, // Chủ đề cho nút chuyển đổi (toggle buttons). 
  TooltipThemeData? tooltipTheme, // Chủ đề cho chú thích (tooltip).
  AndroidOverscrollIndicator? androidOverscrollIndicator, // Xác định giao diện đánh vượt trên Android.
  Color? toggleableActiveColor, // Xác định màu cho các phần tử có thể chuyển đổi.
  Color? selectedRowColor, // Xác định màu cho hàng được chọn.
  Color? errorColor, // Đặt màu cho các thông báo lỗi.
  Color? backgroundColor, // Đặt màu nền chung cho ứng dụng.
  Color? bottomAppBarColor, // Xác định màu cho thanh ứng dụng dưới cùng.
*/