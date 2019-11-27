$dir = '\\[^\\/:*?"<>|]+'
$pattern = "^([a-zA-Z]:$dir)($dir)*\\?$"
($args[0] -match $pattern) -and ($args[0].Length -le 247)