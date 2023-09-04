import 'package:firebase_messaging/firebase_messaging.dart';

class firebasepush{
  final _firebasePush=FirebaseMessaging.instance;

  Future<void>handlebackgroundmessage(RemoteMessage message)async{
    print('Title: ${message.notification!.title}');
    print('Body: ${message.notification!.body}');
    print('Payload: ${message.data}');
  }

  Future<void> initNotif()async{
    await _firebasePush.requestPermission();
    final fcmToken=await _firebasePush.getToken();
    print('Token: $fcmToken');
    FirebaseMessaging.onBackgroundMessage(handlebackgroundmessage);
  }
}