import 'package:flutter/material.dart';
import 'package:todo_web_app/constants/colors.dart';
import 'package:todo_web_app/utils/utils.dart';
import 'package:todo_web_app/views/noteAnalyticsView.dart';
import 'package:todo_web_app/views/noteListView.dart';

class LeftNavigationBar extends StatefulWidget {
  const LeftNavigationBar({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LeftNavigationBarState createState() => _LeftNavigationBarState();
}

class _LeftNavigationBarState extends State<LeftNavigationBar> {
  int selectedIndex = 0; // Indice de l'item sélectionné

  List<Widget> contents = [
    const NoteAnalyticsView(),
    const NoteListView(),
    const NoteListView()
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LeftNavigationBarItem(
                icon: Icons.analytics,
                index: 0,
                selectedIndex: selectedIndex,
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                  // Ajoute ici la logique pour la page d'accueil
                },
              ),
              Container(
                height: 4,
                width: 40,
                color: selectedIndex == 0
                    ? Utils.getColorFromHex(ProjectColors.color2)
                    : Colors.white,
              ),
              LeftNavigationBarItem(
                icon: Icons.task,
                index: 1,
                selectedIndex: selectedIndex,
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                  // Ajoute ici la logique pour la page de recherche
                },
              ),
              Container(
                height: 4,
                width: 40,
                color: selectedIndex == 1
                    ? Utils.getColorFromHex(ProjectColors.color2)
                    : Colors.white,
              ),
              // LeftNavigationBarItem(
              //   icon: Icons.settings,
              //   index: 2,
              //   selectedIndex: selectedIndex,
              //   onTap: () {
              //     setState(() {
              //       selectedIndex = 2;
              //     });
              //     // Ajoute ici la logique pour la page de paramètres
              //   },
              // ),
              // Ajoute d'autres éléments selon tes besoins
            ],
          ),
        ),
        const VerticalDivider(),
        Expanded(child: contents[selectedIndex])
      ],
    );
  }
}

class LeftNavigationBarItem extends StatelessWidget {
  final IconData icon;
  final int index;
  final int selectedIndex;
  final VoidCallback onTap;

  const LeftNavigationBarItem({
    Key? key,
    required this.icon,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        icon,
        color: index == selectedIndex
            ? Utils.getColorFromHex(ProjectColors.color2)
            : Colors.black,
      ),
      onPressed: onTap,
    );
  }
}
