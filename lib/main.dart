import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gp_management/model/info.dart';
import 'package:gp_management/model/jurisdictions.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final firestoreService = locator<FirestoreService>();

  @override
  void initState() {
    super.initState();
    firestoreService.getData();
  }

  initFirebaseApp() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () {
                  var random = Random();
                  firestoreService.addData(
                      'ps_seppa',
                      Datum(
                          fileNumber: 'filfedeNumber',
                          quantity: 'quantfwesdity',
                          purpose: 'purposfwesde',
                          name: 'ngwfesdame',
                          location: 'locaawfestion',
                          id: 'idawfes${random.nextInt(10000)}',
                          category: 'categwefsdory',
                          servicing: 'serviawfescing'));
                },
                child: Text("Add data")),
            FutureBuilder(
              future: firestoreService.getJurisdictionList(),
              builder: (BuildContext context,
                  AsyncSnapshot<Jurisdictions> snapshot) {
                return snapshot.connectionState != ConnectionState.done
                    ? CircularProgressIndicator()
                    : Text(jurisdictionsToJson(snapshot.data!));
              },
            )
          ],
        ),
      ),
    );
  }
}
