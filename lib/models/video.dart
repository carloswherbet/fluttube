import 'dart:convert';

class Video {
  final String id;
  final String title;
  final String description;
  final String thumb;
  final String channel;

  Video({this.id, this.title, this.description, this.thumb, this.channel});

  factory Video.fromJson(Map<String, dynamic> jsonMap) {
    return Video(
      id: jsonMap['id']['videoId'],
      title: jsonMap['snippet']['title'],
      description: jsonMap['snippet']['description'],
      thumb: jsonMap['snippet']['thumbnails']['high']['url'],
      channel: jsonMap['snippet']['channelTitle'],
    );
  }

  factory Video.fromPrefs(Map<String, dynamic> jsonMap) {
    return Video(
      id: jsonMap['videoId'],
      title: jsonMap['title'],
      description: jsonMap['description'],
      thumb: jsonMap['thumb'],
      channel: jsonMap['channel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'videoId': id,
      'title': title,
      'description': description,
      'thumb': thumb,
      'channel': channel,
    };
  }
}
