import 'dart:async';
import 'package:english_words/english_words.dart';

/// Example data as it might be returned by an external service
/// ...this is often a `Map` representing `JSON` or a `FireStore` document
Future<List<Map>> _getExampleServerData(int length) {
  return Future.delayed(const Duration(seconds: 1), () {
    return List<Map>.generate(length, (int index) {
      return {
        "body": WordPair.random().asPascalCase,
        "avatar": 'https://api.adorable.io/avatars/60/${WordPair.random().asPascalCase}.png',
      };
    });
  });
}

/// PostModel has a constructor that can handle the `Map` data
/// ...from the server.
class TaskNotification {
  String body;
  String avatar;
  TaskNotification({required this.body, required this.avatar});
  factory TaskNotification.fromServerMap(Map data) {
    return TaskNotification(
      body: data['body'],
      avatar: data['avatar'],
    );
  }
}

/// PostsModel controls a `Stream` of posts and handles
/// ...refreshing data and loading more posts
class AllTasksNotifications {
  late Stream<List<TaskNotification>> stream;
  bool hasMore = false;

  bool _isLoading = true;
  late List<Map> _data;
  late StreamController<List<Map>> _controller;

  AllTasksNotifications() {
    _data = <Map>[];
    _controller = StreamController<List<Map>>.broadcast();
    _isLoading = false;
    stream = _controller.stream.map((List<Map> postsData) {
      return postsData.map((Map postData) {
        return TaskNotification.fromServerMap(postData);
      }).toList();
    });
    hasMore = true;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({bool clearCachedData = false}) {
    if (clearCachedData) {
      _data = <Map>[];
      hasMore = true;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }
    _isLoading = true;
    return _getExampleServerData(10).then((postsData) {
      _isLoading = false;
      _data.addAll(postsData);
      hasMore = (_data.length < 30);
      _controller.add(_data);
    });
  }
}