# detect SillyTavern server process (node.exe running server.js)
$p = Get-CimInstance Win32_Process -Filter "Name='node.exe'" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -match 'server[.]js' } | Select-Object -First 1
if ($p) { Write-Output $p.ProcessId }
