import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/model/jurisdictions.dart';
import 'package:gp_management/screens/add_item/add_item_view.dart';
import 'package:gp_management/screens/view_items/view_items_view.dart';

import 'services/firestore_service.dart';
import 'services/setup_locator.dart';

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
      theme: ThemeData(
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
      home: SafeArea(child: ViewItemsView()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final firestoreService = locator<FirestoreService>();

  @override
  void initState() {
    super.initState();
  }

  initFirebaseApp() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: firestoreService.getDataForJurisdiction('ps_seppa'),
                builder: (BuildContext context, AsyncSnapshot<Info> snapshot) {
                  return snapshot.connectionState != ConnectionState.done
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.data.length,
                          itemBuilder: (context, index) {
                            var j = snapshot.data!.data[index];
                            return Text(j.purpose!);
                          });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => AddItemView()))
                      .then((value) {
                    setState(() {});
                  });
                },
                child: Text("Add data")),
          ],
        ),
      ),
    );
  }
}
