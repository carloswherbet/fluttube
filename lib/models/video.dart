import 'dart:convert';

class Video {
  final String id;
  final String title;
  final String description;
  final String thumb;
  final String chanel;

  Video({this.id, this.title, this.description, this.thumb, this.chanel});

  factory Video.fromJson(Map<String, dynamic> jsonMap) {
    return Video(
      id: jsonMap['id']['videoId'],
      title: jsonMap['snippet']['title'],
      description: jsonMap['snippet']['description'],
      thumb: jsonMap['snippet']['thumbnails']['high']['url'],
      chanel: jsonMap['snippet']['channelTitle'],
    );
  }
}
