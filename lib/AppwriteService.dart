import 'package:appwrite/appwrite.dart';

class AppwriteService {
  static final AppwriteService _instance = AppwriteService._internal();

  late Client client;
  late Databases database;

  factory AppwriteService() {
    return _instance;
  }

  AppwriteService._internal() {
    client = Client()
      ..setEndpoint('https://cloud.appwrite.io/v1')
      ..setProject('67525f66001bea5784e3');

    database = Databases(client);
  }
}

final appwriteService = AppwriteService();