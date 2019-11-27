[String]$file = $env:windir + "\bootstat.dat";
$fs = New-Object System.IO.FileStream $file,open;
$fs.seek(8,0);
$fs.writebyte($args[0]);
if($args[0] -eq 1)
{
  $fs.seek(9,0);
  $fs.writebyte($args[1]);
}
$fs.flush();
$fs.close();
