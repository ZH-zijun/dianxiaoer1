// 店小二 V4.0 - 主入口
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'config/constants.dart';
import 'providers/config_provider.dart';
import 'providers/order_provider.dart';
import 'providers/ui_provider.dart';
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const DianXiaoErApp());
}

class DianXiaoErApp extends StatelessWidget {
  const DianXiaoErApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConfigProvider()),
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.bgPrimary,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accent,
            secondary: AppColors.accentSecondary,
            surface: AppColors.cardBg,
          ),
          fontFamily: 'PingFang SC',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
          ),
          dialogTheme: DialogThemeData(
            backgroundColor: Colors.transparent,
          ),
        ),
        home: const MainScreen(),
      ),
    );
  }
}
