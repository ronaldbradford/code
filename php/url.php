<?

const NEWLINE = "\n";
const BLANK = '';

function generate_url() {
 $u='?';
 foreach ($_GET as $k => $p) {
   $u .= $k .'='.str_replace(' ','%20',$p) . '&';
 }
 return $u;
}

function debug_url() {
 $DEBUG_OUTPUT = DIRECTORY_SEPARATOR . 'tmp' . DIRECTORY_SEPARATOR . 'url.txt';
 $fh=fopen($DEBUG_OUTPUT,'a');
 $v=var_export($_GET,TRUE);
 fwrite($fh,str_replace(NEWLINE,BLANK,$v).NEWLINE);
 fwrite($fh,generate_url().NEWLINE);
 fclose($fh);
 return 0;
}
?>
