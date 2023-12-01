import 'package:hive/hive.dart';

part 'note.g.dart';

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;

  @HiveField(1)
  String text;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  bool isPriority;

  @HiveField(4)
  bool isSelected;

  Note(this.title, this.text,
      {required this.date, this.isPriority = false, this.isSelected = false});
}
