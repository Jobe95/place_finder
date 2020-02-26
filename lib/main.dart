import 'package:flutter/material.dart';
import 'package:place_finder/pages/homePage.dart';
import 'package:place_finder/viewmodels/placeListViewModel.dart';
import 'package:provider/provider.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => PlaceListViewModel(),
        child: HomePage(),
      ),
    );
  }
}
