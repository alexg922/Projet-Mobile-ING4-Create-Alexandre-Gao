import 'package:pocketbase/pocketbase.dart';

class PocketBaseAPI {
  static const String _baseUrl = 'http://127.0.0.1:8090';

  // Singleton
  static final PocketBaseAPI _instance = PocketBaseAPI._internal();

  factory PocketBaseAPI() => _instance;

  final PocketBase pb;

  PocketBaseAPI._internal() : pb = PocketBase(_baseUrl);

  bool get isLoggedIn => pb.authStore.isValid;

  String get userToken => pb.authStore.token;

  Future<RecordAuth> login(String email, String password) async {
    return await pb.collection('users').authWithPassword(email, password);
  }

  Future<RecordModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    final body = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'passwordConfirm': passwordConfirm,
    };

    return await pb.collection('users').create(body: body);
  }

  void logout() {
    pb.authStore.clear();
  }
}
