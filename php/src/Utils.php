<?php
function cors_and_json_headers() {
  $cfg = require __DIR__ . '/config.php';
  header('Content-Type: application/json; charset=utf-8');
  header('Access-Control-Allow-Origin: ' . $cfg['cors_allow_origin']);
  header('Access-Control-Allow-Headers: Content-Type, Authorization');
  header('Access-Control-Allow-Methods: GET,POST,PUT,PATCH,DELETE,OPTIONS');
}
function json_ok($data=[], int $code=200){ http_response_code($code); echo json_encode(['success'=>true,'data'=>$data], JSON_UNESCAPED_UNICODE); exit; }
function json_err(string $msg,int $code=400,$extra=[]){ http_response_code($code); echo json_encode(['success'=>false,'error'=>$msg,'extra'=>$extra], JSON_UNESCAPED_UNICODE); exit; }
function body_json(): array { $raw=file_get_contents('php://input'); $d=json_decode($raw,true); return is_array($d)?$d:[]; }
