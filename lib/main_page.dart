import 'package:flutter/material.dart';
import 'package:piano_tiles_2/song_provider.dart';
import 'line_divider.dart';
import 'line.dart';
import 'note.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  List<Note> notes = initNotes();
  late AnimationController animationController;
  int currentNoteIndex = 0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          ++currentNoteIndex;
        });
        animationController.forward(from: 0);
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/background_image.jpg',
            fit: BoxFit.cover,
          ),
          Row(
            children: [
              _drawline(0),
              const LineDivider(),
              _drawline(1),
              const LineDivider(),
              _drawline(2),
              const LineDivider(),
              _drawline(3),
              const LineDivider(),
            ],
          )
        ],
      ),
    );
  }

  void _onTap(Note note) {
    animationController.forward();
  }

  _drawline(int lineNumber) {
    return Expanded(
        child: Line(
      lineNumber: lineNumber,
      currentNotes: notes.sublist(currentNoteIndex, currentNoteIndex + 5),
      onTileTap: _onTap,
      animation: animationController,
    ));
  }
}
