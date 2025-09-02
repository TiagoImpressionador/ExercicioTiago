<?php
require_once __DIR__ . '/Helpers.php';
require_once __DIR__ . '/Database.php';

function random_token(): string {
  return bin2hex(random_bytes(32)); // 64 chars
}

function issue_token(int $userId, int $hours = 72): string {
  $pdo = Database::pdo();
  $token = random_token();
  $stmt = $pdo->prepare(
    "INSERT INTO api_tokens (token,user_id,expires_at)
     VALUES (?, ?, DATE_ADD(NOW(), INTERVAL ? HOUR))"
  );
  $stmt->execute([$token, $userId, $hours]);
  return $token;
}

function auth_header_token(): ?string {
  // Lê "Authorization: Bearer <token>"
  $headers = function_exists('getallheaders') ? getallheaders() : [];
  $auth = $headers['Authorization'] ?? $headers['authorization'] ?? $_SERVER['HTTP_AUTHORIZATION'] ?? '';
  if (preg_match('/^Bearer\s+([A-Za-z0-9]+)$/', trim($auth), $m)) {
    return $m[1];
  }
  return null;
}

function current_user_id_or_null(): ?int {
  $token = auth_header_token();
  if (!$token) return null;

  $pdo = Database::pdo();
  $stmt = $pdo->prepare(
    "SELECT user_id FROM api_tokens
     WHERE token = ? AND expires_at > NOW()
     LIMIT 1"
  );
  $stmt->execute([$token]);
  $row = $stmt->fetch();
  return $row['user_id'] ?? null;
}

function require_auth(): int {
  $uid = current_user_id_or_null();
  if (!$uid) json_err('Unauthorized', 401);
  return $uid;
}

function revoke_token(string $token): void {
  $pdo = Database::pdo();
  $pdo->prepare("DELETE FROM api_tokens WHERE token=?")->execute([$token]);
}
