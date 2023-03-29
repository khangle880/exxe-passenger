import "package:dart_amqp/dart_amqp.dart";
import "package:state_notifier/state_notifier.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RabbitmqHelper {
  static RabbitmqHelper instance = RabbitmqHelper();

  static RabbitmqHelper get I => instance;

  static String get host =>
      dotenv.maybeGet('RABBITMQHOST', fallback: null) ?? "";

  static String get username =>
      dotenv.maybeGet('RABBITMQUSERNAME', fallback: null) ?? "";

  static String get password =>
      dotenv.maybeGet('RABBITMQPASSWORD', fallback: null) ?? "";

  Future<RemoveListener> initListen(
      String deviceId, void Function(AmqpMessage event) onData) async {
    Client client = Client(
      settings: ConnectionSettings(
        host: host,
        port: 5672,
        virtualHost: "ajnvfzzu",
        authProvider: PlainAuthenticator(username, password),
      ),
    );
    Channel channel = await client.channel();
    Queue queue = await channel.queue(deviceId);
    Consumer consumer = await queue.consume();
    consumer.listen(onData);
    return () {
      client.close();
    };
  }

  void sendLocation(Map<String, dynamic> location, String deviceId) async {
    Client client = Client(
      settings: ConnectionSettings(
        host: host,
        port: 5672,
        virtualHost: "ajnvfzzu",
        authProvider: PlainAuthenticator(username, password),
      ),
    );
    Channel channel = await client.channel();
    Queue queue = await channel.queue("update-location-devices");
    queue.publish((location..addAll({"device_id": deviceId})));
    client.close();
  }
}
