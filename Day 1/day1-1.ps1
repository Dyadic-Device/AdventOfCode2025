$output = 0
$dial = 50
Get-Content $args[0] | ForEach-Object {
  $temp = $_
  $dir = $temp.substring(0,1)
  $num = $temp.substring(1)
  ($dir -eq 'L') ? ($dial = ($dial - [int]$num) % 100) : ($dial = ($dial + [int]$num) % 100) | Out-Null
  ($dial -lt 0) ? ($dial += 100) : $null | Out-Null
  Write-Host "The dial is rotated $temp to point at $dial"
  ($dial -eq 0) ? ($output++) : $null | Out-Null
}

Write-Host $output