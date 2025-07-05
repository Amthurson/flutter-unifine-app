import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes/app_router.dart';
import 'config/env_config.dart';
import 'providers/user_provider.dart';
import 'widgets/navigation_bar_widget.dart';
import 'providers/font_size_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigationBarWidgetState> navKey =
    GlobalKey<NavigationBarWidgetState>();

void main() {
  // 设置默认环境为开发环境
  EnvConfig.setEnvironment(Environment.test);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FontSizeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FontSizeProvider>(
      builder: (context, fontSizeProvider, child) {
        return MaterialApp.router(
          key: UniqueKey(),
          title: '统一前端',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          routerConfig: AppRouter.router,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(fontSizeProvider.fontScale),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
