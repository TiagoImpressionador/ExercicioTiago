<?php
require_once __DIR__ . '/../Database.php';
require_once __DIR__ . '/../Helpers.php';
require_once __DIR__ . '/../Auth.php';

class CatalogController {
  public static function listItems() {
    // ?type=course|event
    $type = $_GET['type'] ?? null;
    $pdo = Database::pdo();
    if ($type) {
      $stmt = $pdo->prepare("SELECT id,item_type,title,slug,thumbnail_url,description,published_at,event_kind,event_start_at,event_location
                             FROM catalog_items WHERE item_type=? AND is_published=1 ORDER BY published_at DESC");
      $stmt->execute([$type]);
    } else {
      $stmt = $pdo->query("SELECT id,item_type,title,slug,thumbnail_url,description,published_at,event_kind,event_start_at,event_location
                           FROM catalog_items WHERE is_published=1 ORDER BY published_at DESC");
    }
    json_ok($stmt->fetchAll());
  }

  public static function item($id) {
    $pdo = Database::pdo();
    $stmt = $pdo->prepare("SELECT * FROM catalog_items WHERE id=?");
    $stmt->execute([$id]);
    $it = $stmt->fetch();
    if (!$it) json_err('Item não encontrado', 404);
    json_ok($it);
  }

  public static function lessonsOfCourse($courseId) {
    // opcional: verificar que é course
    $pdo = Database::pdo();
    $chk = $pdo->prepare("SELECT item_type FROM catalog_items WHERE id=?");
    $chk->execute([$courseId]);
    $row = $chk->fetch();
    if (!$row || $row['item_type'] !== 'course') json_err('Curso inválido', 400);

    $stmt = $pdo->prepare("SELECT id, section_index, section_title, lesson_index, title, video_url, duration_seconds, free_preview, is_favorite, favorite_count
                           FROM lessons WHERE course_item_id=?
                           ORDER BY section_index, lesson_index");
    $stmt->execute([$courseId]);
    json_ok($stmt->fetchAll());
  }
}
?> 
