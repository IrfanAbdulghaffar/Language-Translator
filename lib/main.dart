import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:translator_app/firebase_options.dart';
import 'package:translator_app/utils/routes/routes.dart';
import 'package:translator_app/utils/routes/routes_names.dart';
import 'package:translator_app/utils/shared_pref_instance.dart';
import 'package:translator_app/view_model/login_view_model.dart';
import 'package:translator_app/view_model/splash_screen_view_model.dart';
import 'package:flutter_waya/flutter_waya.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreference.instance.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashScreenViewModel()),
        ChangeNotifierProvider(create: (_) => AuthenticationViewModel()),
      ],
      child: MaterialApp(
        navigatorKey: GlobalWayUI().navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(

          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: RoutesNames.splash,
        onGenerateRoute: Routes.generateRoutes,

      ),
    );
  }
}


