import 'package:flutter/material.dart';
import 'library.dart' as lib;

import '../controllers/home_controller.dart';
import 'hero_carousel.dart';
import 'home_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomeController controller;

  @override
  void initState() {
    super.initState();
    controller = HomeController();
  }

  @override
  void dispose() {
    // Só chama dispose se o teu HomeController tiver recursos a libertar.
    // (Se estender ChangeNotifier, isto está correto.)
    controller.dispose();
    super.dispose();
  }

  void _onPlus() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const SizedBox(
        height: 220,
        child: Center(child: Text('Ação rápida (+)')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTabContent(controller: controller),
      const PlanTab(),
      const lib.LibraryTab(),
      const ProfileTab(),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: IndexedStack(index: controller.tabIndex, children: pages),
      floatingActionButton: FloatingActionButton(
        onPressed: _onPlus,
        backgroundColor: const Color(0xFFD9A8A5),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNavBar(
        currentIndex: controller.tabIndex,
        onChanged: (i) => setState(() => controller.tabIndex = i),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onChanged;
  const _BottomNavBar({required this.currentIndex, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const active = Color(0xFFD9A8A5);
    const inactive = Colors.black38;

    Widget item({
      required IconData icon,
      required String label,
      required int idx,
      Widget? customIcon,
    }) {
      final selected = currentIndex == idx;
      final color = selected ? active : inactive;
      return Expanded(
        child: InkWell(
          onTap: () => onChanged(idx),
          child: Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                customIcon ?? Icon(icon, color: color, size: 24),
                const SizedBox(height: 2),
                Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SafeArea(
        top: false,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            notchMargin: 8,
            color: Colors.white,
            elevation: 8,
            child: SizedBox(
              height: 68,
              child: Row(
                children: [
                  item(icon: Icons.home_rounded, label: 'Home', idx: 0),
                  item(icon: Icons.restaurant_menu_rounded, label: 'Plano', idx: 1),
                  const SizedBox(width: 56),
                  item(icon: Icons.video_library_rounded, label: 'Biblioteca', idx: 2),
                  item(
                    icon: Icons.person,
                    label: 'Perfil',
                    idx: 3,
                    customIcon: CircleAvatar(
                      radius: 12,
                      backgroundColor: currentIndex == 3 ? active : Colors.black26,
                      child: const CircleAvatar(radius: 10, backgroundColor: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeTabContent extends StatelessWidget {
  final HomeController controller;
  const HomeTabContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24 + 64),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HomeHeader está no teu home_widgets.dart e recebe o controller
            HomeHeader(controller: controller),
            const SizedBox(height: 12),

            // >>> HeroCarousel AGORA COM OS PARÂMETROS OBRIGATÓRIOS <<<
            HeroCarousel(
              future: controller.bannersFuture,     // Future dos banners (no controller)
              resolve: controller.resolveImage,     // Função para resolver URL (no controller)
            ),

            const SizedBox(height: 14),
            const ReminderCard(),
            const SizedBox(height: 14),
            const RowCards(),
          ],
        ),
      ),
    );
  }
}

// Outros tabs (placeholders)
class PlanTab extends StatelessWidget {
  const PlanTab({super.key});
  @override
  Widget build(BuildContext context) =>
      const SafeArea(child: Center(child: Text('Plano')));
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) =>
      const SafeArea(child: Center(child: Text('Perfil')));
}
