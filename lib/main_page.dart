import 'package:flutter/material.dart';
import 'package:piano_tiles_2/song_provider.dart';
import 'line_divider.dart';
import 'line.dart';
import 'note.dart';
import 'package:audioplayers/audioplayers.dart';

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
  int points = 0;
  bool hasStarted = false;
  bool isPlaying = true;
  final player = AudioCache();

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed && isPlaying) {
        if (notes[currentNoteIndex].state != Notestate.tapped) {
          //game is over
          setState(() {
            isPlaying = false; //this will stop the game
            notes[currentNoteIndex].state = Notestate.missed;
          });
          animationController.reverse().then((_) =>
              _showFinishDialog()); //this will reverse the last animation (last note)
        } else if (currentNoteIndex == notes.length - 5) {
          //song is finished
          _showFinishDialog();
        } else {
          //if the song did not end
          setState(() => ++currentNoteIndex); //increase the song index
          animationController.forward(
              from: 0); //start the animation all over again
        }
      }
    });
    // animationController.forward(); //start the animation for the first time
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
        fit: StackFit.passthrough,
        children: [
          Image.asset(
            'assets/images/background_image.jpg',
            fit: BoxFit.cover,
          ),
          Row(
            children: [
              _drawLine(0),
              const LineDivider(),
              _drawLine(1),
              const LineDivider(),
              _drawLine(2),
              const LineDivider(),
              _drawLine(3),
              const LineDivider(),
            ],
          ),
          _drawPoints(),
        ],
      ),
    );
  }

  void _onTap(Note note) {
    bool areAllPreviousTapped = notes
        .sublist(0, note.orderNo)
        .every((n) => n.state == Notestate.tapped);
    if (areAllPreviousTapped) {
      if (!hasStarted) {
        setState(() => hasStarted = true);
        animationController.forward();
      }
      _playNote(note);
      setState(() {
        note.state = Notestate.tapped;
        points++;
      });
    }
  }

  _drawLine(int lineNumber) {
    return Expanded(
        child: Line(
      lineNumber: lineNumber,
      currentNotes: notes.sublist(currentNoteIndex, currentNoteIndex + 5),
      onTileTap: _onTap,
      animation: animationController,
    ));
  }

  _drawPoints() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 32),
        child: Text(
          "$points",
          style: const TextStyle(
              color: Colors.red, fontSize: 70, fontFamily: 'Alata'),
        ),
      ),
    );
  }

  _playNote(Note note) {
    switch (note.line) {
      //To play a sound depending on the line number of the Note
      case 0:
        player.play('sounds/a.wav');
        return;
      case 1:
        player.play('sounds/c.wav');
        return;
      case 2:
        player.play('sounds/e.wav');
        return;
      case 3:
        player.play('sounds/f.wav');
        return;
    }
  }

  void _restart() {
    setState(() {
      hasStarted = false;
      isPlaying = true;
      notes = initNotes();
      points = 0;
      currentNoteIndex = 0;
    });
    animationController.reset();
  }

  void _showFinishDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over! \nScore: $points"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                "RESTART",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    ).then(
        (_) => _restart()); //restart the game when the popup dialogue is closed
  }
}
