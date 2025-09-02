// widgets/home_hero_carousel.dart (ou deixa no mesmo ficheiro se preferires)
import 'package:flutter/material.dart';

class HeroCarousel extends StatefulWidget {
  /// Aceita qualquer Future, para evitar erros de generics
  final Future<dynamic> future;
  /// Função para resolver URL de imagem (ex.: Api.resolve)
  final String Function(String?) resolve;

  const HeroCarousel({
    super.key,
    required this.future,
    required this.resolve,
  });

  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

class _HeroCarouselState extends State<HeroCarousel> {
  final _pageCtrl = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.hasError) {
          return SizedBox(
            height: 160,
            child: Center(child: Text('Erro: ${snap.error}')),
          );
        }

        // Normaliza a lista de banners
        final List banners =
            (snap.data is List) ? (snap.data as List).take(3).toList() : const [];
        if (banners.isEmpty) return const SizedBox(height: 160);

        return Column(
          children: [
            SizedBox(
              height: 160,
              child: PageView.builder(
                controller: _pageCtrl,
                itemCount: banners.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  // Normaliza cada item como Map<String, dynamic>
                  final raw = banners[i];
                  final Map<String, dynamic> b = (raw is Map)
                      ? raw.map((k, v) => MapEntry(k.toString(), v))
                      : <String, dynamic>{};

                  final imgUrl = widget.resolve(b['image_url']?.toString());

                  return _HeroCard(
                    imageUrl: imgUrl,
                    title: (b['title'] ?? '').toString(),
                    subtitle: (b['subtitle'] ?? '').toString(),
                    cta: (b['cta_label'] ?? 'Abrir').toString(),
                    onPressed: () {
                      final action = (b['cta_action'] ?? '').toString();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Ação: $action')),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                banners.length,
                (i) => Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == _index ? Colors.black87 : Colors.black26,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// Usa o mesmo _HeroCard que já tinhas
class _HeroCard extends StatelessWidget {
  final String imageUrl, title, subtitle, cta;
  final VoidCallback? onPressed;
  const _HeroCard({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.cta,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _cardDeco(),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFEDEDED),
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image_outlined,
                    size: 40, color: Colors.black38),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.0),
                    Colors.black.withOpacity(0.35)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style:
                        const TextStyle(color: Colors.white70, fontSize: 12)),
                const Spacer(),
                ElevatedButton(
                  onPressed: onPressed ?? () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black.withOpacity(0.85),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: Text(cta),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mantém o teu _cardDeco()
BoxDecoration _cardDeco() => BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: const [
        BoxShadow(color: Color(0x1F000000), blurRadius: 12, offset: Offset(0, 4))
      ],
    );
