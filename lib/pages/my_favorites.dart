import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttube/blocs/favs_bloc.dart';
import 'package:fluttube/models/video.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fluttube/util/api.dart';

class MyFavorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _favsBloc = BlocProvider.of<FavsBloc>(context);
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black87,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Favoritos',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.black87,
        actions: <Widget>[
          StreamBuilder<Map<String, Video>>(
            stream: _favsBloc.outFavs,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PopupMenuButton(
                  itemBuilder: (context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          value: 'limpar',
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.clear_all),
                              SizedBox(
                                width: 4,
                              ),
                              Text('Limpar todos'),
                            ],
                          ),
                        ),
                      ],
                  onSelected: (_) {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Remover todos os vídeos?',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          content: Text(
                            'Caso confirme, todos os vídeo serão removidos da lista de favoritos!',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancelar'),
                            ),
                            FlatButton(
                              onPressed: () {
                                _favsBloc.clearFavs();
                                Navigator.of(context).pop();
                                _scaffoldKey.currentState.showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      'Vídeos removidos com sucesso!',
                                    ),
                                  ),
                                );
                              },
                              child: Text('Sim'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<Map<String, Video>>(
        stream: _favsBloc.outFavs,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
                children: snapshot.data.values.map((v) {
              return Slidable(
                actionExtentRatio: 0.25,
                actionPane: SlidableDrawerActionPane(),
                secondaryActions: <Widget>[
                  IconSlideAction(
                    caption: 'Remover',
                    color: Colors.red,
                    icon: Icons.delete,
                    onTap: () => showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                'Remover vídeo?',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              content: Text(
                                'Caso confirme, o vídeo será removido da lista de favoritos!',
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancelar'),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    _favsBloc.toggleFavorite(v);
                                    Navigator.of(context).pop();
                                    _scaffoldKey.currentState.showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                          'Vídeo removido com sucesso!',
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text('Sim'),
                                ),
                              ],
                            );
                          },
                        ),
                  ),
                ],
                child: ListTile(
                  onTap: () {
                    FlutterYoutube.playYoutubeVideoById(
                        autoPlay: true, apiKey: API_KEY, videoId: v.id);
                  },
                  leading: Container(
                    height: 50,
                    width: 100,
                    child: Image.network(v.thumb),
                  ),
                  title: Text(
                    v.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList());
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
