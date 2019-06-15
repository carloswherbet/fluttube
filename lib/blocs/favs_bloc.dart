import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttube/models/video.dart';

class FavsBloc implements BlocBase {
  Map<String, Video> _favs = {};
  final _favsStreamController = StreamController<Map<String, Video>>.broadcast();

  Stream<Map<String, Video>> get outFavs => _favsStreamController.stream;

  void toggleFavorite(Video video) {
    if (_favs.containsKey(video.id))
      _favs.remove(video.id);
    else
      _favs[video.id] = video;

    _favsStreamController.sink.add(_favs);
  }

  @override
  void dispose() {
    _favsStreamController.close();
  }
}
