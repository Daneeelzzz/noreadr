import 'package:pocketbase/pocketbase.dart';
import '../models/novel.dart'; // Assuming you have this model
import '../models/genre.dart'; // Assuming you have this model

class PocketBaseService {
  static final pb = PocketBase('http://127.0.0.1:8090'); // Update URL if hosted

  // Login pengguna
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

  // Registrasi pengguna
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

  // Logout pengguna
  static void logout() {
    pb.authStore.clear();
    print("Logout berhasil");
  }

  // Cek status login
  static bool isLoggedIn() {
    return pb.authStore.isValid;
  }

  // Mendapatkan nama pengguna
  static String getUserName() {
    return pb.authStore.model?.data['name'] ?? 'Guest';
  }

  // Mendapatkan email pengguna
  static String getUserEmail() {
    return pb.authStore.model?.data['email'] ?? 'anonymous@example.com';
  }

  // Mendapatkan URL avatar pengguna
  static String getUserAvatar() {
    final user = pb.authStore.model as RecordModel?;
    return user != null && user.data['avatar'] != null && user.data['avatar'].isNotEmpty
        ? pb.getFileUrl(user, user.data['avatar']).toString()
        : '';
  }

  // Mendapatkan daftar novel dengan filter dan sort opsional
  static Future<List<Novel>> fetchNovels({String? filter, String? sort}) async {
    try {
      final result = await pb.collection('novels').getFullList(
        filter: filter,
        sort: sort,
        expand: 'genres', // Expand to include genre details
        headers: {'Authorization': 'Bearer ${pb.authStore.token}'},
      );
      return result.map((record) => Novel.fromJson(record.toJson())).toList();
    } catch (e) {
      print('Error fetching novels: $e');
      rethrow;
    }
  }

  // Mendapatkan detail novel berdasarkan ID
  static Future<Novel> fetchNovel(String id) async {
    try {
      final result = await pb.collection('novels').getOne(
        id,
        expand: 'genres', // Expand to include genre details
        headers: {'Authorization': 'Bearer ${pb.authStore.token}'},
      );
      return Novel.fromJson(result.toJson());
    } catch (e) {
      print('Error fetching novel: $e');
      rethrow;
    }
  }

  // Mendapatkan daftar bab berdasarkan novel_id
  static Future<List<RecordModel>> fetchChapters(String novelId) async {
    try {
      final result = await pb.collection('chapters').getFullList(
        filter: 'novel_id = "$novelId"',
        sort: 'chapter_number',
        headers: {'Authorization': 'Bearer ${pb.authStore.token}'},
      );
      return result;
    } catch (e) {
      print('Error fetching chapters: $e');
      rethrow;
    }
  }

  // Mendapatkan daftar bookmark pengguna
  static Future<List<RecordModel>> fetchBookmarks() async {
    if (!pb.authStore.isValid || pb.authStore.model == null) {
      throw Exception("User belum login");
    }

    final userId = pb.authStore.model.id;

    try {
      final result = await pb.collection('bookmarks').getFullList(
        filter: 'user_id = "$userId"',
        sort: '-created',
        expand: 'novel_id',
        headers: {'Authorization': 'Bearer ${pb.authStore.token}'},
      );
      return result;
    } catch (e) {
      print('Error fetching bookmarks: $e');
      rethrow;
    }
  }

  // Mendapatkan URL gambar sampul novel
  static String getNovelCoverImage(RecordModel novel) {
    return novel.data['cover_image'] != null && novel.data['cover_image'].isNotEmpty
        ? pb.getFileUrl(novel, novel.data['cover_image']).toString()
        : '';
  }

  // Menambahkan bookmark
  static Future<void> addBookmark(String novelId) async {
    if (!pb.authStore.isValid || pb.authStore.model == null) {
      throw Exception("User belum login");
    }

    final userId = pb.authStore.model.id;

    try {
      await pb.collection('bookmarks').create(
        body: {
          'user_id': userId,
          'novel_id': novelId,
        },
        headers: {'Authorization': 'Bearer ${pb.authStore.token}'},
      );
      print("Bookmark ditambahkan");
    } catch (e) {
      print('Error adding bookmark: $e');
      rethrow;
    }
  }

  // Mendapatkan daftar genre
  static Future<List<Genre>> fetchGenres() async {
    try {
      final result = await pb.collection('genres').getFullList(
        headers: {'Authorization': 'Bearer ${pb.authStore.token}'},
      );
      return result.map((record) => Genre.fromJson(record.toJson())).toList();
    } catch (e) {
      print('Error fetching genres: $e');
      rethrow;
    }
  }

  // Mendapatkan novel berdasarkan genre ID (untuk relation multiple)
  static Future<List<Novel>> fetchNovelsByGenre(String genreId) async {
    try {
      final result = await pb.collection('novels').getFullList(
        filter: 'genres~"$genreId"', // ~ operator for contains in relation (multiple)
        expand: 'genres',
        headers: {'Authorization': 'Bearer ${pb.authStore.token}'},
      );
      return result.map((record) => Novel.fromJson(record.toJson())).toList();
    } catch (e) {
      print('Error fetching novels by genre: $e');
      rethrow;
    }
  }

  // Pencarian novel
  static Future<List<Novel>> searchNovels(String query) async {
    try {
      final result = await pb.collection('novels').getFullList(
        filter: 'title~"$query" || author~"$query"',
        expand: 'genres',
        headers: {'Authorization': 'Bearer ${pb.authStore.token}'},
      );
      return result.map((record) => Novel.fromJson(record.toJson())).toList();
    } catch (e) {
      print('Error searching novels: $e');
      rethrow;
    }
  }
}