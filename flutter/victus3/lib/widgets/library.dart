import 'package:flutter/material.dart';
import '../controllers/api.dart';
import '../utils/video_player_page.dart';

/// =====================
///  TAB: Biblioteca
///  - Lista cursos da API
///  - Ao tocar num curso → lista de aulas
///  - Ao tocar numa aula → abre o player
/// =====================

class LibraryTab extends StatelessWidget {
  const LibraryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<dynamic>>(
        future: Api.listCourses(), // GET /catalog?type=course
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Erro: ${snap.error}'));
          }
          final items = snap.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('Sem cursos'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final c = items[i] as Map<String, dynamic>;
              final title = (c['title'] ?? '').toString();
              final desc = (c['description'] ?? '').toString();
              final thumb = (c['thumbnail_url'] ?? '').toString();

              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                tileColor: Colors.white,
                leading: _Thumb(url: thumb),
                title: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  desc,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LessonsScreen(course: c)),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  final String url;
  const _Thumb({required this.url});

  @override
  Widget build(BuildContext context) {
    final resolved = url.isEmpty ? '' : Api.resolve(url);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: resolved.isEmpty
          ? Container(
              width: 56,
              height: 56,
              color: const Color(0xFFEDEDED),
              child: const Icon(
                Icons.play_circle_outline,
                color: Colors.black38,
              ),
            )
          : Image.network(
              resolved,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 56,
                height: 56,
                color: const Color(0xFFEDEDED),
                child: const Icon(
                  Icons.image_not_supported,
                  color: Colors.black38,
                ),
              ),
            ),
    );
  }
}

/// =====================
///  SCREEN: Aulas do Curso
/// =====================

class LessonsScreen extends StatefulWidget {
  final Map<String, dynamic> course;
  const LessonsScreen({super.key, required this.course});

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  late Future<List<dynamic>> _future;

  @override
  void initState() {
    super.initState();
    final id =
        int.tryParse(widget.course['id'].toString()) ??
        widget.course['id'] as int;
    _future = Api.lessons(id); // GET /courses/{id}/lessons
  }

  @override
  Widget build(BuildContext context) {
    final title = (widget.course['title'] ?? 'Curso').toString();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: FutureBuilder<List<dynamic>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Erro: ${snap.error}'));
          }
          final lessons = (snap.data ?? [])
              .map((e) => e as Map<String, dynamic>)
              .toList();
          if (lessons.isEmpty) {
            return const Center(child: Text('Sem aulas'));
          }

          // Agrupa por secção (section_title)
          final Map<String, List<Map<String, dynamic>>> groups = {};
          for (final l in lessons) {
            final sec = (l['section_title'] ?? 'Aulas').toString();
            groups.putIfAbsent(sec, () => []).add(l);
          }
          final entries = groups.entries.toList();

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
            itemCount: entries.length,
            itemBuilder: (_, idx) {
              final secTitle = entries[idx].key;
              final secLessons = entries[idx].value;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: idx == 0,
                    title: Text(
                      secTitle,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    children: [
                      for (final l in secLessons) _LessonTile(lesson: l),
                      const SizedBox(height: 6),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Map<String, dynamic> lesson;
  const _LessonTile({required this.lesson});

  String _fmtSec(dynamic v) {
    final s = int.tryParse(v?.toString() ?? '') ?? 0;
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$m:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final title = (lesson['title'] ?? 'Aula').toString();
    final dur = _fmtSec(lesson['duration_seconds']);
    final url = Api.resolve((lesson['video_url'] ?? '').toString());
    print('VIDEO URL => $url');

    return ListTile(
      leading: const Icon(Icons.play_circle_outline),
      title: Text(title),
      subtitle: Text('Duração: $dur'),
      onTap: () {
        if (url.isEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Sem vídeo nesta aula')));
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayerPage(title: title, url: url),
          ),
        );
      },
    );
  }
}
