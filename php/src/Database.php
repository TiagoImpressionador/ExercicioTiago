<?php
class Database {
  private static ?PDO $pdo = null;

  public static function pdo(): PDO {
    if (!self::$pdo) {
      $cfg = require __DIR__ . '/config.php';
      self::$pdo = new PDO(
        $cfg['db']['dsn'],
        $cfg['db']['user'],
        $cfg['db']['pass'],
        [
          PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
          PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
      );
    }
    return self::$pdo;
  }
}
