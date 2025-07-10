import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';

import 'core/controller/app_controller.dart';
import 'core/controller/audio_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'common/colors.dart';
import 'common/text_styles.dart';

final Logger _logger = Logger();

class MusicApp extends StatelessWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: '音乐升降调',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: AppColors.primary,
            scaffoldBackgroundColor: AppColors.background,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              titleTextStyle: AppTextStyles.appBarTitle,
            ),
            textTheme: AppTextStyles.textTheme,
            useMaterial3: true,
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('zh', 'CN'),
            Locale('en', 'US'),
          ],
          locale: const Locale('zh', 'CN'),
          getPages: AppPages.routes,
          initialBinding: InitBinding(),
          initialRoute: AppRoutes.home,
        );
      },
    );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    _logger.i("MusicApp InitBinding dependencies start");
    
    // 注册控制器
    Get.put<AppController>(AppController());
    Get.put<AudioController>(AudioController());
    
    _logger.i("MusicApp InitBinding dependencies end");
  }
} 