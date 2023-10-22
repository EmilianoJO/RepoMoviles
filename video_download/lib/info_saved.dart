// import 'package:isar/isar.dart';

class Progress {
  int id = 0;
  String minutes;

  Progress({required this.minutes});

  Map<String, dynamic> toMap() {
    return {'id': id, 'minutes': minutes};
  }
}
