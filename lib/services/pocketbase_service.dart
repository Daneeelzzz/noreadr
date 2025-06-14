import 'package:pocketbase/pocketbase.dart';

class PocketBaseService {
  static final pb = PocketBase('http://127.0.0.1:8090');

  static Future<List<RecordModel>> fetchBookmarks() async {
    if (!pb.authStore.isValid || pb.authStore.model == null) {
      throw Exception("User belum login");
    }

    final userId = pb.authStore.model.id;

    final result = await pb.collection('bookmarks').getFullList(
      filter: 'user_id="$userId"',
      sort: '-created',
      expand: 'novel_id',
    );

    return result;
  }

  static Future<void> login(String email, String password) async {
    try {
      final result = await pb.collection('users').authWithPassword(email, password);
      pb.authStore.save(result.token, result.record);
      print("Login berhasil: ${result.record.id}");
    } catch (e) {
      print("Login gagal: $e");
      rethrow;
    }
  }

  static Future<void> register(String email, String password, String name) async {
    try {
      await pb.collection('users').create(body: {
        "email": email,
        "password": password,
        "passwordConfirm": password,
        "name": name,
      });
      print("Registrasi berhasil");
    } catch (e) {
      print("Gagal daftar: $e");
      rethrow;
    }
  }

  static void logout() {
    pb.authStore.clear();
    print("Logout berhasil");
  }

  static bool isLoggedIn() {
    return pb.authStore.isValid;
  }

  static String getUserName() {
    return pb.authStore.model?.data['name'] ?? 'Guest';
  }

  static String getUserEmail() {
    return pb.authStore.model?.data['email'] ?? 'anonymous@example.com';
  }

  static String getUserAvatar() {
    final user = pb.authStore.model as RecordModel?;
    return user != null && user.data['avatar'] != null && user.data['avatar'].isNotEmpty
        ? pb.getFileUrl(user, user.data['avatar']).toString()
        : '';
  }
    static Future<List<RecordModel>> fetchNovels() async {
      try {
        final result = await pb.collection('novels').getFullList(
          sort: '-created',
        );
        return result;
      } catch (e) {
        print('ERROR FETCH NOVELS: $e');
        rethrow;
      }
    }
  static String getNovelCoverImage(RecordModel novel) {
    return novel.data['cover_image'] != null && novel.data['cover_image'].isNotEmpty
        ? pb.getFileUrl(novel, novel.data['cover_image']).toString()
        : '';
  }
}