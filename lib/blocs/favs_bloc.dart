import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttube/models/video.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavsBloc implements BlocBase {
  final _keyFav = 'favorites';

  Map<String, Video> _favs = {};
  final _favsStreamController =
      BehaviorSubject<Map<String, Video>>(seedValue: {});

  FavsBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains(_keyFav)) {
        _favs = json
            .decode(prefs.getString(_keyFav))
            .map((key, value) => MapEntry(key, Video.fromPrefs(value)))
            .cast<String, Video>();

        _favsStreamController.add(_favs);
      }
    });
  }

  Stream<Map<String, Video>> get outFavs => _favsStreamController.stream;

  void toggleFavorite(Video video) {
    if (_favs.containsKey(video.id))
      _favs.remove(video.id);
    else
      _favs[video.id] = video;

    _favsStreamController.sink.add(_favs);

    _saveFav();
  }

  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString(_keyFav, json.encode(_favs));
    });
  }

  void clearFavs() {
    _favsStreamController.sink.add({});
    SharedPreferences.getInstance().then((prefs) => prefs.clear());
  }

  @override
  void dispose() {
    _favsStreamController.close();
  }
}
