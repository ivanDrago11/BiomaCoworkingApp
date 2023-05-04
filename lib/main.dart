
import 'package:flutter/material.dart';
import 'package:flutter_bioma_application/pages/areasScreen.dart';
import 'package:flutter_bioma_application/providers/area_provider.dart';
import 'package:flutter_bioma_application/providers/auth_providers.dart';
import 'package:flutter_bioma_application/providers/user_provider.dart';
import 'package:flutter_bioma_application/utils/notifications_service.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'pages/login.dart';

void main() {
  runApp(const AppState());
}
class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      ChangeNotifierProvider(create: (context) => AuthService()),
      ChangeNotifierProvider(create: (context) => UserService()),
      ChangeNotifierProvider(create: (context) => AreaService())
    ],
    child: const MyApp(),);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: NotificationsService.messengerKey,
      debugShowCheckedModeBanner: false,
      title: 'Bioma App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: 'login',
      routes: {
        'login' : (context) => const LoginScreen(),
        'areas' : (context) => const AreasScreen(),
      },
    );
  }

}


