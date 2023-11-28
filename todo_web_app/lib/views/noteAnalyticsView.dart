import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_web_app/constants/colors.dart';
import 'package:todo_web_app/models/note.dart';
import 'package:todo_web_app/utils/utils.dart';
import 'package:todo_web_app/viewModels/notesViewModel.dart';

class NoteAnalyticsView extends StatefulWidget {
  const NoteAnalyticsView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NoteAnalyticsViewState createState() => _NoteAnalyticsViewState();
}

class _NoteAnalyticsViewState extends State<NoteAnalyticsView> {
  @override
  void initState() {
    super.initState();
  }

  String? greeting;
  String getGreeting() {
    var heure = DateTime.now().hour;
    if (heure < 12) {
      setState(() {
        greeting = "☀️Bonjour";
      });
    } else if (heure < 18) {
      setState(() {
        greeting = "🌕Bon après-midi";
      });
    } else {
      setState(() {
        greeting = "🌑Bonne nuit";
      });
    }
    return greeting!;
  }

  @override
  Widget build(BuildContext context) {
    NotesViewModel notesViewModel = Provider.of<NotesViewModel>(context);
    notesViewModel.fetchActiveAndCompletedNotes();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Statistiques",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(getGreeting(),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                Text(DateTime.now().toIso8601String().split("T")[0],
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 100),
          LayoutBuilder(
            builder: (context, constraints) {
              // Check the available width and decide the layout
              if (constraints.maxWidth > 600) {
                // Larger screen, display in a Row
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BoxItem(
                        NoteLength: notesViewModel.activeNotes.length,
                        text: "Active notes"),
                    const SizedBox(width: 20),
                    BoxItem(
                        NoteLength: notesViewModel.completedNotes.length,
                        text: "Completed notes"),
                  ],
                );
              } else {
                // Smaller screen, display in a Column
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BoxItem(
                        NoteLength: notesViewModel.activeNotes.length,
                        text: "Active Notes"),
                    const SizedBox(height: 20),
                    BoxItem(
                        NoteLength: notesViewModel.completedNotes.length,
                        text: "Completed Notes"),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class BoxItem extends StatelessWidget {
  final int NoteLength;
  final String text;

  const BoxItem({super.key, required this.NoteLength, required this.text});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: 250,
      height: 160,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  text == "Active notes"
                      ? const Icon(
                          Icons.data_usage,
                          size: 70,
                          color: Colors.deepOrange,
                        )
                      : const Icon(
                          Icons.check_circle,
                          size: 70,
                          color: Colors.teal,
                        ),
                  Text(
                    NoteLength.toString(),
                    style: TextStyle(
                        fontSize: width * 0.02, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }
}
