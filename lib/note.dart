class Note {
  String title;
  String text;
  bool isPriority;
  bool isSelected;

  Note(this.title, this.text, {this.isPriority =false, this.isSelected = false});
}
