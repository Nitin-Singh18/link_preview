import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_preview_app/services/local/db.dart';

import 'modules/home/view/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarDatabase.open();
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, child) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Date Recorder',
          home: HomeView(),
        );
      },
    );
  }
}
