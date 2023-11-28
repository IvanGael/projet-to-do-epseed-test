import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_web_app/constants/colors.dart';
import 'package:todo_web_app/utils/utils.dart';
import 'package:todo_web_app/viewModels/notesViewModel.dart';
import 'package:todo_web_app/views/noteListView.dart';
import 'package:todo_web_app/widgets/leftNavigationBar.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => NotesViewModel()),
            // Ajoute d'autres providers pour tes ViewModels ici
          ],
          child: const MyApp(),
        ),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoApp',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
          useMaterial3: true,
          fontFamily: 'Chillax'),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      // backgroundColor: Utils.getColorFromHex(ProjectColors.color3),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image.asset(
          //   "images/neobrutalism.jpg",
          //   fit: BoxFit.cover,
          // ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Utils.getColorFromHex(ProjectColors.color1),
                  Utils.getColorFromHex(ProjectColors.color2),
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: const [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                margin: const EdgeInsets.all(10),
                child: Card(
                  elevation: 10,
                  child: Container(
                    width: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: const LeftNavigationBar(),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
