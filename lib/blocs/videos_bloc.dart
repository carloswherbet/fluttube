import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttube/models/video.dart';
import 'package:fluttube/util/api.dart';

class VideosBloc implements BlocBase {
  Api _api;
  List<Video> _videos;
  final _videosStreamController = StreamController<List<Video>>();
  final _searchStreamController = StreamController<String>();

  VideosBloc() {
    _api = Api();

    _searchStreamController.stream.listen(_search);
  }

  Stream get outVideos => _videosStreamController.stream;
  Sink get inSearch => _searchStreamController.sink;

  void _search(String search) async {
    if (search != null) {
      _videosStreamController.sink.add([]);
      _videos = await _api.search(search);
    } else
      _videos += await _api.nextPage();

    _videosStreamController.sink.add(_videos);
  }

  @override
  void dispose() {
    _videosStreamController.close();
    _searchStreamController.close();
  }
}
