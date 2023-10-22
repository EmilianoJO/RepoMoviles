import 'package:video_downlad/info_saved.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  static Future<Database> getDB() async {
    return openDatabase(join(await getDatabasesPath(), 'video.db'),
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE video (id INTEGER PRIMARY KEY, minutes String)");
    }, version: 1);
  }

  static Future<Future<int>> insert(Progress minutes) async {
    Database db = await getDB();

    return db.insert("video", minutes.toMap());
  }

  static Future<Future<int>> update(Progress minutes) async {
    Database db = await getDB();

    return db.update("video", minutes.toMap(), where: "id=0");
  }

  static Future<String> progress() async {
    Database db = await getDB();

    final List<Map<String, dynamic>> progress = await db.query("video");
    // String minutes = progress[0]['minutes'];
    String minutes;
    if (progress.isEmpty) {
      Progress progres = Progress(minutes: '0');
      insert(progres);
    }

    Progress progres = Progress(minutes: '0');
    // update(progres);
    minutes = progress[0]['minutes'].toString();
    print(progres.toMap());
    print(minutes);
    return minutes;
  }
}
