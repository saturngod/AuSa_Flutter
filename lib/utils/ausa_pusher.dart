import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class AuSaPusher {
  AuSaPusher._privateConstructor() {
    _initPusher();
  } 

  static final AuSaPusher _instance = AuSaPusher._privateConstructor(); // Singleton instance

  factory AuSaPusher.instance() {
    return _instance;
  }

  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance(); 
  final API_KEY = "28427b70b22ef2e1d217";
  final API_CLUSTER = "us2";

  Future<void> _initPusher() async {
    await pusher.init(apiKey: API_KEY, cluster: API_CLUSTER);
  }

  void connect() async {
    await pusher.connect();
  }


}