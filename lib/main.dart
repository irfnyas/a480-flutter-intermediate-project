import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/service/api_service.dart';
import 'data/service/cache_service.dart';
import 'module/detail/provider.dart';
import 'module/home/provider.dart';
import 'module/login/provider.dart';
import 'module/post/provider.dart';
import 'module/register/provider.dart';
import 'util/route.dart';
import 'util/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (context) => CacheService(),
        ),
        Provider(
          create: (context) => ApiService(
            context.read<CacheService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(
            context.read<ApiService>(),
            context.read<CacheService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DetailProvider(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => LoginProvider(
            context.read<ApiService>(),
            context.read<CacheService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => RegisterProvider(
            context.read<ApiService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PostProvider(
            context.read<ApiService>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      darkTheme: darkTheme,
      theme: lightTheme,
      routerConfig: routes,
    );
  }
}
