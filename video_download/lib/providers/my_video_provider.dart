import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:video_player/video_player.dart';
import 'package:video_downlad/db.dart';
import 'package:video_downlad/info_saved.dart';

class MyVideoProvider with ChangeNotifier {
  VideoPlayerController? _vCont;
  VideoPlayerController? get getVidCont => _vCont;
  bool isSaved = false;

  void initializeVideoPlayer(String filePath) async {
    // inicializar el video player
    _vCont = await VideoPlayerController.file(File(filePath))
      ..addListener(() => notifyListeners())
      ..setLooping(false)
      ..initialize().then((value) async {
        // 7: cargar el progreso guardado del video
        await loadConfigs();
        notifyListeners();
      });
  }

  void isPlayOrPause(bool isPlay) {
    if (isPlay) {
      _vCont!.pause();
    } else {
      _vCont!.play();
    }
    notifyListeners();
  }

  // TODO 6: cargar datos
  Future<void> loadConfigs() async {
    if (_vCont != null) {
      String milisStr = await DB.progress();
      int milis = int.parse(milisStr);
      Duration position = Duration(milliseconds: milis);
      await _vCont!.seekTo(position);
      await _vCont!.setVolume(1);
    }
    notifyListeners();
  }

  // TODO 10: guardar datos
  Future saveConfigs() async {
    try {
      Duration position = _vCont!.value.position;
      Progress progress = Progress(minutes: position.inMilliseconds.toString());
      DB.update(progress);
      isSaved = true;
      notifyListeners();
    } catch (e) {
      print("Error al guardar: ${e.toString()}");
      isSaved = false;
      notifyListeners();
    }
  }
}
