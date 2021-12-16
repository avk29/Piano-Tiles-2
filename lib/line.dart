import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'note.dart';
import 'tile.dart';

class Line extends AnimatedWidget {
  final int lineNumber;
  final List<Note> currentNotes;
  final Function(Note) onTileTap;

  const Line(
      {Key? key,
      required this.lineNumber,
      required this.currentNotes,
      required this.onTileTap,
      required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;

    double height = MediaQuery.of(context).size.height;
    double tileHeight = height / 4;

    //To get only notes for a particular line
    List<Note> particularLine =
        currentNotes.where((note) => note.line == lineNumber).toList();

    //To map notes to a widget
    List<Widget> tiles = particularLine.map((note) {
      //To specify note distance from the top
      int index = currentNotes.indexOf(note);
      double offset = (3 - index + animation.value) * tileHeight;

      return Transform.translate(
        offset: Offset(0, offset),
        child: Tile(
          height: tileHeight,
          state: note.state,
          onTap: () => onTileTap(note),
        ),
      );
    }).toList();

    return SizedBox.expand(
      child: Stack(
        children: tiles,
      ),
    );
  }
}
