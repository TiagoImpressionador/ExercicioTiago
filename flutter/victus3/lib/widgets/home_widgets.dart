// lib/widgets/home_widgets.dart
import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';

class HomeHeader extends StatelessWidget {
  final HomeController controller;
  const HomeHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Olá, ${controller.userName}',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.group_outlined)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline)),
      ],
    );
  }
}

class RowCards extends StatelessWidget {
  const RowCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(flex: 10, child: ProgressCard()),
        SizedBox(width: 12),
        Expanded(flex: 12, child: UpcomingEventsCard()),
      ],
    );
  }
}

class ReminderCard extends StatelessWidget {
  const ReminderCard({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: cardDeco().copyWith(
        gradient: const LinearGradient(
          colors: [Color(0xFFF5D8D6), Color(0xFFF0E5E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: const [
          Text('LEMBRETE DO DIA:',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
          SizedBox(height: 10),
          Text(
            'É importante agradecer pelo hoje,\nsem nunca desistir do amanhã!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class ProgressCard extends StatelessWidget {
  const ProgressCard({super.key});
  @override
  Widget build(BuildContext context) {
    const value = 0.65;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: cardDeco(),
      child: Row(
        children: [
          SizedBox(
            width: 88,
            height: 88,
            child: Stack(
              alignment: Alignment.center,
              children: const [
                SizedBox(
                  width: 88,
                  height: 88,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 10,
                    backgroundColor: Color(0xFFE9E2E2),
                  ),
                ),
                Text('2kg\nperdidos', textAlign: TextAlign.center),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Continua assim!\nEstás no bom caminho 👏',
                style: TextStyle(fontSize: 13)),
          ),
        ],
      ),
    );
  }
}

class UpcomingEventsCard extends StatelessWidget {
  const UpcomingEventsCard({super.key});

  @override
  Widget build(BuildContext context) {
    // helper local que cria cada “pill”
    Widget pill(String date, String title) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 46,
                child: Text(date,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 6),
              Expanded(child: Text(title)),
            ],
          ),
        );

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Próximos eventos:',
              style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          pill('23/05', 'Masterclass'),
          const SizedBox(height: 8),
          pill('12/08', 'Workshop'),
          const SizedBox(height: 8),
          TextButton(onPressed: () {}, child: const Text('+ 1 evento')),
        ],
      ),
    );
  }
}

BoxDecoration cardDeco() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18),
    boxShadow: const [
      BoxShadow(color: Color(0x1F000000), blurRadius: 12, offset: Offset(0, 4))
    ],
  );
}
