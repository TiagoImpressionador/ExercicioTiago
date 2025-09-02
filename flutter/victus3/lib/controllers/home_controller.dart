import 'package:flutter/material.dart';
import 'api.dart';
import '../models/session.dart';

class HomeController extends ChangeNotifier {
  // Bottom bar
  int _tabIndex = 0;
  int get tabIndex => _tabIndex;
  set tabIndex(int i) {
    if (i == _tabIndex) return;
    _tabIndex = i;
    notifyListeners();
  }

  // Nome do utilizador (para o header)
  String get userName => (Session.user?['name'] ?? '...').toString();

  // Future dos banners (cacheado)
  late final Future<dynamic> bannersFuture = Api.homeBanners();

  // Resolver URL da imagem (usado pelo HeroCarousel)
  String resolveImage(String? path) => Api.resolve((path ?? '').toString());
}
