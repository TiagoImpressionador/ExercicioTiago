<?php
require_once __DIR__ . '/../Database.php';
require_once __DIR__ . '/../Helpers.php';
require_once __DIR__ . '/../Auth.php';

class LessonController {
  public static function myProgress($courseId) {
    $uid = require_auth();
    $pdo = Database::pdo();
    $stmt = $pdo->prepare("
      SELECT l.id AS lesson_id, l.title, IFNULL(p.watched_pct,0) watched_pct,
             IFNULL(p.last_position_seconds,0) last_position_seconds, IFNULL(p.is_completed,0) is_completed
      FROM lessons l
      LEFT JOIN user_lesson_progress p ON p.lesson_id = l.id AND p.user_id = ?
      WHERE l.course_item_id = ?
      ORDER BY l.section_index, l.lesson_index
    ");
    $stmt->execute([$uid, $courseId]);
    json_ok($stmt->fetchAll());
  }

  public static function updateProgress() {
    $uid = require_auth();
    $b = body_json();
    $lessonId = (int)($b['lesson_id'] ?? 0);
    $pct      = (float)($b['watched_pct'] ?? 0);
    $pos      = (int)($b['last_position_seconds'] ?? 0);
    $done     = (int)($b['is_completed'] ?? 0);

    if ($lessonId <= 0) json_err('lesson_id obrigatório', 422);

    $pdo = Database::pdo();
    $sql = "INSERT INTO user_lesson_progress (user_id, lesson_id, watched_pct, last_position_seconds, is_completed, last_watched_at)
            VALUES (?,?,?,?,?,NOW())
            ON DUPLICATE KEY UPDATE
              watched_pct=VALUES(watched_pct),
              last_position_seconds=VALUES(last_position_seconds),
              is_completed=VALUES(is_completed),
              last_watched_at=VALUES(last_watched_at)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([$uid, $lessonId, $pct, $pos, $done]);
    json_ok(['lesson_id' => $lessonId, 'watched_pct' => $pct, 'last_position_seconds' => $pos, 'is_completed' => $done]);
  }
}
?>
