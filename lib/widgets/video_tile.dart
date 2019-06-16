import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttube/blocs/favs_bloc.dart';
import 'package:fluttube/models/video.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:fluttube/util/api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoTile extends StatelessWidget {
  final Video video;

  const VideoTile({this.video});

  @override
  Widget build(BuildContext context) {
    final _favsBloc = BlocProvider.of<FavsBloc>(context);

    return GestureDetector(
      onTap: () {
        FlutterYoutube.playYoutubeVideoById(
            autoPlay: true, apiKey: API_KEY, videoId: video.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                video.thumb,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Tooltip(
                        message: video.title,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text(
                            video.title,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: video.description,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: Text(
                            video.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Tooltip(
                        message: video.channel,
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            video.channel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<Map<String, Video>>(
                  stream: _favsBloc.outFavs,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return IconButton(
                        icon: Icon(
                          snapshot.data.containsKey(video.id)
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: snapshot.data.containsKey(video.id)
                              ? Theme.of(context).primaryColor
                              : Colors.white54,
                          size: 24,
                        ),
                        onPressed: () => _favsBloc.toggleFavorite(video),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
