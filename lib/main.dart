import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_management/app.locator.dart';
import 'package:gp_management/app.router.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/screens/add_item/add_item_view.dart';
import 'package:stacked_services/stacked_services.dart';

import 'services/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          primaryColor: Color(0xff556FB5),
          accentColor: Color(0xff7189BF),
          buttonColor: Color(0xff556FB5),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xff556FB5)))),
          textTheme: GoogleFonts.oxygenTextTheme(Theme.of(context).textTheme),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                    headline6: GoogleFonts.oxygen(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ))),
      // home: SafeArea(child: ViewItemsView()),
    );
  }
}
