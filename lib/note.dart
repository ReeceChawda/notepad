import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;

  @HiveField(1)
  String text;

  @HiveField(2)
  bool isPriority;

  @HiveField(3)
  bool isSelected;

  Note(this.title, this.text, {this.isPriority = false, this.isSelected = false});
}


