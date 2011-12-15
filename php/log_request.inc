<?
const NEWLINE = "\n";
const BLANK = '';

function generate_url() {
//  return $_SERVER['SERVER_NAME'].':'.$_SERVER['SERVER_PORT'].$_SERVER['REQUEST_URI'];
  return $_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
}

function log_request() {
 $DEBUG_OUTPUT = DIRECTORY_SEPARATOR . 'tmp' . DIRECTORY_SEPARATOR . 'request.' .  date("Ymd.Hi"). '.txt';
 $fh=fopen($DEBUG_OUTPUT,'a');
 fwrite($fh,generate_url().NEWLINE);
 fclose($fh);
 return 0;
}

log_request();

?>

