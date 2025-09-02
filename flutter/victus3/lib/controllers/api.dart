// lib/api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform; // <- para Platform.isAndroid (ok para Android/iOS/desktop)

// Se fores compilar para Web e não precisares de Platform, remove a linha acima.

class Api {
  /// BASE dinâmica:
  /// - Web: localhost
  /// - Android emulador: 10.0.2.2
  /// - iOS/desktop: localhost (ajusta se precisares)
  static String get base {
    if (kIsWeb) return 'http://localhost/myapi/public';
    if (Platform.isAndroid) return 'http://10.0.2.2/myapi/public';
    return 'http://localhost/myapi/public';
    // Se testares num telemóvel físico, troca por:
    // return 'http://<IP_DA_TUA_MÁQUINA>/myapi/public';
  }

  /// Converte caminho relativo (ex.: /img/b1.jpg) em URL absoluta
  static String resolve(String pathOrUrl) {
    if (pathOrUrl.isEmpty) return '';
    if (pathOrUrl.startsWith('http')) return pathOrUrl;
    return '$base${pathOrUrl.startsWith('/') ? pathOrUrl : '/$pathOrUrl'}';
  }

  // ----------------- chamadas -----------------

  static Future<List<dynamic>> homeBanners() async {
    final r = await http.get(Uri.parse('$base/home/banners'));
    final j = jsonDecode(r.body);
    if (j['success'] == true) return List<dynamic>.from(j['data']);
    throw j['error'] ?? 'Erro ao carregar banners';
    }

  static Future<List<dynamic>> listCourses() async {
    final r = await http.get(Uri.parse('$base/catalog?type=course'));
    final j = jsonDecode(r.body);
    if (j['success'] == true) return List<dynamic>.from(j['data']);
    throw j['error'] ?? 'Erro ao carregar cursos';
  }

  static Future<List<dynamic>> lessons(int courseId) async {
    final r = await http.get(Uri.parse('$base/courses/$courseId/lessons'));
    final j = jsonDecode(r.body);
    if (j['success'] == true) return List<dynamic>.from(j['data']);
    throw j['error'] ?? 'Erro ao carregar aulas';
  }

  /// Login “simples” (sem token) – usa o teu endpoint quando tiveres
  static Future<Map<String, dynamic>> login(String email, String password) async {
    // MOCK: devolve só o nome a partir do email
    final name = email.split('@').first;
    return {'id': 0, 'name': name, 'email': email};
  }
}
