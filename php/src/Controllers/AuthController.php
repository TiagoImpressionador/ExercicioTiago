<?php
require_once __DIR__ . '/myapi/src/Database.php';
require_once __DIR__ . '/myapi/src/Helpers.php';
require_once __DIR__ . '/myapi/src/Auth.php';

class AuthController {
  public static function login() {
    $b = body_json();
    $email = trim($b['email'] ?? '');
    $pass  = $b['password'] ?? '';

    if ($email === '' || $pass === '') json_err('Credenciais obrigatórias', 422);

    $pdo = Database::pdo();
    $stmt = $pdo->prepare("SELECT id, password_hash, name, role FROM users WHERE email=? AND status='active'");
    $stmt->execute([$email]);
    $u = $stmt->fetch();
    if (!$u || !password_verify($pass, $u['password_hash'])) {
      json_err('Email ou password inválidos', 401);
    }
    $token = issue_token((int)$u['id']);
    json_ok(['token' => $token, 'user' => ['id' => (int)$u['id'], 'name' => $u['name'], 'role' => $u['role']]]);
  }

  public static function logout() {
    $hdr = $_SERVER['HTTP_AUTHORIZATION'] ?? '';
    if (stripos($hdr, 'Bearer ') === 0) {
      $token = substr($hdr, 7);
      if ($token) revoke_token($token);
    }
    json_ok(['message' => 'Logged out']);
  }
}
?> 
