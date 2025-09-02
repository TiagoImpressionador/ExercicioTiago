<?php
// --------- bootstrap ---------
$ROOT = dirname(__DIR__); // D:\Xampp\htdocs\myapi
require_once $ROOT . '/src/Utils.php';
require_once $ROOT . '/src/Database.php';

cors_and_json_headers();
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') { http_response_code(204); exit; }

// rota calculada (funciona com e sem .htaccess)
$uri  = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$base = rtrim(dirname($_SERVER['SCRIPT_NAME']), '/');   // /myapi/public
$path = '/' . ltrim(substr($uri, strlen($base)), '/');  // e.g. /catalog
$path = $_GET['p'] ?? $path; // fallback
$method = $_SERVER['REQUEST_METHOD'];
$pdo = Database::pdo();

// --------- endpoints ---------

// root/ping
if ($method === 'GET' && ($path === '/' || $path === '')) {
  json_ok(['message' => 'API up']);
}
if ($method === 'GET' && $path === '/health') {
  json_ok(['status' => 'ok']);
}

// lista itens do catálogo
// GET /catalog?type=course | event (opcional)
if ($method === 'GET' && $path === '/catalog') {
  $type = $_GET['type'] ?? null;
  if ($type) {
    $st = $pdo->prepare(
      "SELECT id,item_type,title,slug,thumbnail_url,description,
              published_at,event_kind,event_start_at,event_location
       FROM catalog_items
       WHERE item_type=? AND is_published=1
       ORDER BY published_at DESC, id DESC"
    );
    $st->execute([$type]);
  } else {
    $st = $pdo->query(
      "SELECT id,item_type,title,slug,thumbnail_url,description,
              published_at,event_kind,event_start_at,event_location
       FROM catalog_items
       WHERE is_published=1
       ORDER BY published_at DESC, id DESC"
    );
  }
  json_ok($st->fetchAll());
}

// detalhe de item
// GET /catalog/{id}
if ($method === 'GET' && preg_match('#^/catalog/(\d+)$#', $path, $m)) {
  $st = $pdo->prepare("SELECT * FROM catalog_items WHERE id=?");
  $st->execute([(int)$m[1]]);
  $row = $st->fetch();
  if (!$row) json_err('Item não encontrado', 404);
  json_ok($row);
}

// aulas de um curso
// GET /courses/{id}/lessons
if ($method === 'GET' && preg_match('#^/courses/(\d+)/lessons$#', $path, $m)) {
  $courseId = (int)$m[1];

  // valida que é um course
  $chk = $pdo->prepare("SELECT item_type FROM catalog_items WHERE id=?");
  $chk->execute([$courseId]);
  $rt = $chk->fetch();
  if (!$rt || $rt['item_type'] !== 'course') json_err('Curso inválido', 400);

  $st = $pdo->prepare(
    "SELECT id,section_index,section_title,lesson_index,title,
            video_url,duration_seconds,free_preview,is_favorite,favorite_count
     FROM lessons
     WHERE course_item_id=?
     ORDER BY section_index, lesson_index"
  );
  $st->execute([$courseId]);
  json_ok($st->fetchAll());
}

// progresso do utilizador num curso (SEM token, recebe user_id na rota)
// GET /users/{userId}/courses/{courseId}/progress
if ($method === 'GET' && preg_match('#^/users/(\d+)/courses/(\d+)/progress$#', $path, $m)) {
  $userId = (int)$m[1];
  $courseId = (int)$m[2];

  $st = $pdo->prepare(
    "SELECT l.id AS lesson_id, l.section_index, l.lesson_index, l.title,
            IFNULL(p.watched_pct,0) watched_pct,
            IFNULL(p.last_position_seconds,0) last_position_seconds,
            IFNULL(p.is_completed,0) is_completed
     FROM lessons l
     LEFT JOIN user_lesson_progress p ON p.lesson_id=l.id AND p.user_id=?
     WHERE l.course_item_id=?
     ORDER BY l.section_index, l.lesson_index"
  );
  $st->execute([$userId, $courseId]);
  json_ok($st->fetchAll());
}

// atualizar progresso (SEM token; envia user_id no body)
// POST /progress  { user_id, lesson_id, watched_pct, last_position_seconds, is_completed }
if ($method === 'POST' && $path === '/progress') {
  $b = body_json();
  $userId   = (int)($b['user_id'] ?? 0);
  $lessonId = (int)($b['lesson_id'] ?? 0);
  $pct      = (float)($b['watched_pct'] ?? 0);
  $pos      = (int)($b['last_position_seconds'] ?? 0);
  $done     = (int)($b['is_completed'] ?? 0);
  if ($userId <= 0 || $lessonId <= 0) json_err('user_id e lesson_id obrigatórios', 422);

  $sql =
    "INSERT INTO user_lesson_progress (user_id,lesson_id,watched_pct,last_position_seconds,is_completed,last_watched_at)
     VALUES (?,?,?,?,?,NOW())
     ON DUPLICATE KEY UPDATE
       watched_pct=VALUES(watched_pct),
       last_position_seconds=VALUES(last_position_seconds),
       is_completed=VALUES(is_completed),
       last_watched_at=VALUES(last_watched_at)";
  $st = $pdo->prepare($sql);
  $st->execute([$userId,$lessonId,$pct,$pos,$done]);
  json_ok(['user_id'=>$userId,'lesson_id'=>$lessonId,'watched_pct'=>$pct,'last_position_seconds'=>$pos,'is_completed'=>$done]);
}

// matrículas do user (cursos)
// GET /users/{userId}/courses
if ($method === 'GET' && preg_match('#^/users/(\d+)/courses$#', $path, $m)) {
  $userId = (int)$m[1];
  $st = $pdo->prepare(
    "SELECT ci.id,ci.title,ci.slug,ci.thumbnail_url
     FROM enrollments e
     JOIN catalog_items ci ON ci.id=e.item_id AND ci.item_type='course'
     WHERE e.user_id=?
     ORDER BY ci.title"
  );
  $st->execute([$userId]);
  json_ok($st->fetchAll());
}

// inscrições do user (eventos)
// GET /users/{userId}/events
if ($method === 'GET' && preg_match('#^/users/(\d+)/events$#', $path, $m)) {
  $userId = (int)$m[1];
  $st = $pdo->prepare(
    "SELECT ci.id,ci.title,ci.event_kind,ci.event_start_at,ci.event_location, r.status
     FROM user_item_registrations r
     JOIN catalog_items ci ON ci.id=r.item_id AND ci.item_type='event'
     WHERE r.user_id=?
     ORDER BY ci.event_start_at DESC"
  );
  $st->execute([$userId]);
  json_ok($st->fetchAll());
}

// pesos do user
// GET /users/{userId}/weight
if ($method === 'GET' && preg_match('#^/users/(\d+)/weight$#', $path, $m)) {
  $userId = (int)$m[1];
  $st = $pdo->prepare(
    "SELECT date, weight_kg FROM user_weight_log
     WHERE user_id=? ORDER BY date"
  );
  $st->execute([$userId]);
  json_ok($st->fetchAll());
}

// banners e lembretes (Home)
if ($method === 'GET' && $path === '/home/banners') {
  $st = $pdo->query(
    "SELECT id,title,subtitle,image_url,cta_label,cta_action,item_id,position
     FROM home_banners WHERE is_active=1 ORDER BY position"
  );
  json_ok($st->fetchAll());
}
if ($method === 'GET' && $path === '/home/reminders') {
  $st = $pdo->query(
    "SELECT id,title,body
     FROM reminders
     WHERE is_active=1
       AND (active_from IS NULL OR active_from<=CURDATE())
       AND (active_to   IS NULL OR active_to>=CURDATE())
     ORDER BY id DESC LIMIT 20"
  );
  json_ok($st->fetchAll());
}


// LOGIN (sem tokens; só valida user e password_hash)
// POST /auth/login  { "email": "...", "password": "..." }
if ($method === 'POST' && $path === '/auth/login') {
  $b = body_json();
  $email = trim($b['email'] ?? '');
  $pass  = (string)($b['password'] ?? '');

  if ($email === '' || $pass === '') {
    json_err('Email e password são obrigatórios', 422);
  }

  $pdo = Database::pdo();
  $st = $pdo->prepare("SELECT id,name,email,password_hash,role,status FROM users WHERE email=? AND status='active'");
  $st->execute([$email]);
  $u = $st->fetch();
  if (!$u) json_err('Credenciais inválidas', 401);

  // Para testes: aceita password em claro igual ao que está guardado em password_hash
  $ok = password_verify($pass, $u['password_hash']) || ($pass === $u['password_hash']);
  if (!$ok) json_err('Credenciais inválidas', 401);

  json_ok(['user' => [
    'id'    => (int)$u['id'],
    'name'  => $u['name'],
    'email' => $u['email'],
    'role'  => $u['role'],
    'status'=> $u['status'],
  ]]);
}


// 404
json_err('Not Found: ' . $path, 404);
