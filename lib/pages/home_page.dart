import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttube/blocs/favs_bloc.dart';
import 'package:fluttube/blocs/videos_bloc.dart';
import 'package:fluttube/delegates/data_search.dart';
import 'package:fluttube/models/video.dart';
import 'package:fluttube/pages/my_favorites.dart';
import 'package:fluttube/widgets/video_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _bloc = BlocProvider.of<VideosBloc>(context);
    final _favsBloc = BlocProvider.of<FavsBloc>(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Container(
          height: 25,
          child: Image.asset('assets/yt_logo_rgb_dark.png'),
        ),
        elevation: 0,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: _favsBloc.outFavs,
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text('${snapshot.data.length}');
                else
                  Container();
              },
            ),
          ),
          IconButton(
            icon: Icon(FontAwesomeIcons.solidHeart),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => MyFavorites()));
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String result =
                  await showSearch(context: context, delegate: DataSearch());

              if (result != null) _bloc.inSearch.add(result);
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _bloc.outVideos,
        initialData: [],
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container();
          else {
            return ListView.builder(
              itemCount: snapshot.data.length + 1,
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(video: snapshot.data[index]);
                } else if (index > 1) {
                  _bloc.inSearch.add(null);
                  return Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                } else {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Text(
                        'Faça uma pesquisa',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
