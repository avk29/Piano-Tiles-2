import 'package:flutter/material.dart';
import 'package:piano_tiles_2/note.dart';

class Tile extends StatelessWidget {
  final double height;
  final Notestate state;
  final VoidCallback onTap;

  const Tile(
      {Key? key,
      required this.height,
      required this.state,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: GestureDetector(
        onTapDown: (_) => onTap(),
        child: Container(color: color),
      ),
    );
  }

  Color get color {
    switch (state) {
      case Notestate.ready:
        return Colors.black;
      case Notestate.tapped:
        return Colors.white10;
      case Notestate.missed:
        return Colors.red;

      default:
        return Colors.black;
    }
  }
}
