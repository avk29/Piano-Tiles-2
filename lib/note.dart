class Note {
  final int orderNo;
  final int line;
  Notestate state = Notestate.ready;

  Note(this.orderNo, this.line);
}

enum Notestate { ready, tapped, missed }
