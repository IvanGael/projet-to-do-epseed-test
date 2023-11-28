import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_web_app/animations/lottie_animations.dart';
import 'package:todo_web_app/constants/colors.dart';
import 'package:todo_web_app/models/note.dart';
import 'package:todo_web_app/utils/utils.dart';
import 'package:todo_web_app/viewModels/notesViewModel.dart';
import 'package:todo_web_app/widgets/roundedCheckBox.dart';

class NoteListView extends StatefulWidget {
  const NoteListView({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _NoteListViewState createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  late NotesViewModel tvm;
  DateTime today = DateTime.now();

  _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      today = day;
    });
  }

  bool noData = false;

  final TextEditingController _textFieldTitleController =
      TextEditingController();
  final TextEditingController _textFieldContentController =
      TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

  void handleAddNote() {
    String title = _textFieldTitleController.text.toString();
    String content = _textFieldContentController.text.toString();

    if (title.isEmpty || content.isEmpty) {
      if (title.isEmpty) {
        _titleFocusNode.requestFocus();
        // const snackBar = SnackBar(
        //   backgroundColor: Colors.redAccent,
        //   content: Text(
        //     "Veuillez saisir un titre",
        //     style: TextStyle(color: Colors.white),
        //   ),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (content.isEmpty) {
        _contentFocusNode.requestFocus();
        // const snackBar = SnackBar(
        //   backgroundColor: Colors.redAccent,
        //   content: Text("Veuillez saisir un contenu",
        //       style: TextStyle(color: Colors.white)),
        // );
        // ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      tvm.addNewNote(Note(
          title: title, content: content, color: "#ffcc00", status: "Active"));
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Alerte',
          message: 'Note ajoutée avec succès!',
          contentType: ContentType.success,
        ),
      );

      Navigator.of(context).pop();

      _textFieldTitleController.clear();
      _textFieldContentController.clear();

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  void showAddNoteDialog(BuildContext context) {
    showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (context, animation1, animation2, widget) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation1),
            child: FadeTransition(
                opacity:
                    Tween<double>(begin: 0.5, end: 1.0).animate(animation1),
                child: AlertDialog(
                  alignment: Alignment.center,
                  title: Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.green[600],
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(10),
                            right: Radius.circular(10))),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_task,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "Nouvelle note",
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Titre',
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        controller: _textFieldTitleController,
                        focusNode: _titleFocusNode,
                        onEditingComplete: () {
                          _contentFocusNode.requestFocus();
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Contenu',
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                        controller: _textFieldContentController,
                        focusNode: _contentFocusNode,
                      )
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Annuler",
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        // backgroundColor: MaterialStateProperty.all<Color>(Colors.green[600]!)
                      ),
                      child: const Text(
                        "Ajouter",
                        style: TextStyle(color: Colors.black),
                      ),
                      onPressed: () {
                        handleAddNote();
                      },
                    ),
                  ],
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none),
                )),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    NotesViewModel notesViewModel = Provider.of<NotesViewModel>(context);
    notesViewModel.fetchNotes();

    setState(() {
      tvm = notesViewModel;
    });

    if (notesViewModel.notes.isEmpty) {
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          noData = true;
        });
      });
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     Container(
          //       width: width / 2, // Ajuste la largeur du calendrier
          //       height: 400,
          //       child: TableCalendar(
          //         locale: "fr_FR",
          //         headerStyle: const HeaderStyle(
          //           formatButtonVisible: false,
          //           titleCentered: true,
          //         ),
          //         availableGestures: AvailableGestures.all,
          //         firstDay: DateTime.utc(2010, 10, 16),
          //         lastDay: DateTime.utc(2030, 3, 14),
          //         focusedDay: today,
          //         onDaySelected: _onDaySelected,
          //         selectedDayPredicate: (day) => isSameDay(day, today),
          //       ),
          //     ),
          //   ],
          // ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mes notes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
          const Divider(),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () {
                      showAddNoteDialog(context);
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green[700]!),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(14),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Ajouter une note",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ))
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: width / 2,
                child: notesViewModel.notes.isEmpty
                    ? Center(
                        child: noData == false
                            ? CupertinoActivityIndicator(
                                color:
                                    Utils.getColorFromHex(ProjectColors.color2),
                                radius: 20,
                              )
                            : const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  LottieNoDataAnimation(),
                                  Text("Aucune note ajoutée pour le moment"),
                                ],
                              ),
                      )
                    : ListView.builder(
                        itemCount: notesViewModel.notes.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Note note = notesViewModel.notes[index];
                          return NoteItem(note: note);
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoteItem extends StatefulWidget {
  final Note note;

  const NoteItem({Key? key, required this.note}) : super(key: key);

  @override
  State<NoteItem> createState() => _NoteItemState();
}

class _NoteItemState extends State<NoteItem> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.note.status != "Active";
  }

  String formatDateTimeToFrench(DateTime dateTime) {
    final daysOfWeek = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche'
    ];
    final months = [
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre'
    ];

    String dayOfWeek = daysOfWeek[dateTime.weekday - 1];
    String dayOfMonth = dateTime.day.toString();
    String month = months[dateTime.month - 1];
    String year = dateTime.year.toString();
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');

    return '$dayOfWeek $dayOfMonth $month $year à $hour h : $minute';
  }

  final TextEditingController _textFieldTitleController =
      TextEditingController();
  final TextEditingController _textFieldContentController =
      TextEditingController();

  Note? noteDetails;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    NotesViewModel notesViewModel = Provider.of<NotesViewModel>(context);

    void handleUpdateNote() {
      String title = _textFieldTitleController.text.toString();
      String content = _textFieldContentController.text.toString();

      if (title.isEmpty || content.isEmpty) {
        if (title.isEmpty) {
          const snackBar = SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
              "Veuillez saisir un titre",
              style: TextStyle(color: Colors.white),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        if (content.isEmpty) {
          const snackBar = SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Veuillez saisir un contenu",
                style: TextStyle(color: Colors.white)),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        notesViewModel.updateNote(Note(
            id: widget.note.id,
            title: title,
            content: content,
            color: widget.note.color,
            status: widget.note.status,
            createdAt: widget.note.createdAt));
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Alerte',
            message: 'Note mise à jour avec succès!',
            contentType: ContentType.warning,
          ),
        );

        Navigator.of(context).pop();

        _textFieldTitleController.clear();
        _textFieldContentController.clear();

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    }

    void showUpdateNoteDialog(BuildContext context) {
      showGeneralDialog(
          context: context,
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation1, animation2) {
            return Container();
          },
          transitionBuilder: (context, animation1, animation2, widget) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation1),
              child: FadeTransition(
                  opacity:
                      Tween<double>(begin: 0.5, end: 1.0).animate(animation1),
                  child: AlertDialog(
                    alignment: Alignment.center,
                    title: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_task,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Editer une note",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Titre',
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          controller: _textFieldTitleController,
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            hintText: 'Contenu',
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                          controller: _textFieldContentController,
                        )
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Annuler",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          // backgroundColor: MaterialStateProperty.all<Color>(Colors.green[600]!)
                        ),
                        child: const Text(
                          "Mettre à jour",
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          handleUpdateNote();
                        },
                      ),
                    ],
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                  )),
            );
          });
    }

    void showNoteInfosDialog(BuildContext context) {
      showGeneralDialog(
          context: context,
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation1, animation2) {
            return Container();
          },
          transitionBuilder: (context, animation1, animation2, widget) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.5, end: 1.0).animate(animation1),
              child: FadeTransition(
                  opacity:
                      Tween<double>(begin: 0.5, end: 1.0).animate(animation1),
                  child: AlertDialog(
                    alignment: Alignment.center,
                    title: Container(
                      width: 200,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.green[600],
                          borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(10),
                              right: Radius.circular(10))),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Détails de la note",
                            style: TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              "Titre : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              noteDetails!.title,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              "Contenu : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              noteDetails!.content,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   mainAxisSize: MainAxisSize.max,
                        //   children: [
                        //     const Text(
                        //       "Date de création : ",
                        //       style: TextStyle(fontSize: 15),
                        //     ),
                        //     Text(
                        //       formatDateTimeToFrench(noteDetails!.createdAt!),
                        //       style: const TextStyle(
                        //           fontSize: 15, fontWeight: FontWeight.w700),
                        //     )
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const Text(
                              "Status : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              noteDetails!.status,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700),
                            )
                          ],
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        child: const Text(
                          "Fermer",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none),
                  )),
            );
          });
    }

    return Container(
        width: width / 2,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.green[700]!,
                    width: 2,
                    style: BorderStyle.solid)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedCheckbox(
                        isChecked: isChecked,
                        onTap: (bool newValue) {
                          setState(() {
                            isChecked = newValue;
                          });
                          setState(() {
                            widget.note.status =
                                isChecked == true ? "Completed" : "Active";
                          });
                          notesViewModel.updateNote(widget.note);
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Alerte',
                              message: 'Note mise à jour avec succès!',
                              contentType: ContentType.warning,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        },
                      ),
                      Column(
                        children: [
                          isChecked
                              ? Text(
                                  widget.note.title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough),
                                )
                              : Text(
                                  widget.note.title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none),
                                ),
                          Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.black,
                              ),
                              Text(
                                formatDateTimeToFrench(widget.note.createdAt!),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.info,
                          color: Colors.cyan,
                        ),
                        onPressed: () {
                          setState(() {
                            noteDetails = Note(
                                title: widget.note.title,
                                content: widget.note.content,
                                createdAt: widget.note.createdAt,
                                status: widget.note.status);
                          });
                          showNoteInfosDialog(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_note,
                          color: Colors.orangeAccent,
                        ),
                        onPressed: () {
                          _textFieldTitleController.text = widget.note.title;
                          _textFieldContentController.text =
                              widget.note.content;
                          showUpdateNoteDialog(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          notesViewModel.deleteNote(widget.note);
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Alerte',
                              message: 'Note supprimée avec succès!',
                              contentType: ContentType.success,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        },
                      )
                    ],
                  );
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedCheckbox(
                        isChecked: isChecked,
                        onTap: (bool newValue) {
                          setState(() {
                            isChecked = newValue;
                          });
                          setState(() {
                            widget.note.status =
                                isChecked == true ? "Completed" : "Active";
                          });
                          notesViewModel.updateNote(widget.note);
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Alerte',
                              message: 'Note mise à jour avec succès!',
                              contentType: ContentType.warning,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        },
                      ),
                      Column(
                        children: [
                          isChecked
                              ? Text(
                                  widget.note.title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough),
                                )
                              : Text(
                                  widget.note.title,
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.none),
                                ),
                          Wrap(
                            children: [
                              Row(
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.black,
                              ),
                              Container(
                                width: 50,
                                child: Text(
                                  formatDateTimeToFrench(widget.note.createdAt!),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          )
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.info,
                          color: Colors.cyan,
                        ),
                        onPressed: () {
                          setState(() {
                            noteDetails = Note(
                                title: widget.note.title,
                                content: widget.note.content,
                                createdAt: widget.note.createdAt,
                                status: widget.note.status);
                          });
                          showNoteInfosDialog(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_note,
                          color: Colors.orangeAccent,
                        ),
                        onPressed: () {
                          _textFieldTitleController.text = widget.note.title;
                          _textFieldContentController.text =
                              widget.note.content;
                          showUpdateNoteDialog(context);
                        },
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_forever,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          notesViewModel.deleteNote(widget.note);
                          final snackBar = SnackBar(
                            elevation: 0,
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.transparent,
                            content: AwesomeSnackbarContent(
                              title: 'Alerte',
                              message: 'Note supprimée avec succès!',
                              contentType: ContentType.success,
                            ),
                          );

                          ScaffoldMessenger.of(context)
                            ..hideCurrentSnackBar()
                            ..showSnackBar(snackBar);
                        },
                      )
                    ],
                  );
                }
              }),
            ),
          ),
        ));
  }
}
