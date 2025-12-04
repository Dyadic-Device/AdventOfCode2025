$sum = 0

(Get-Content $args[0]) -split "," | ForEach-Object {
  $range = $_ -split "-"
  $num = [long]$range[0]
  $end = [long]$range[1]

  while ($num -le $end) {
    $str = [string]$num
    if ($str.Length % 2 -eq 0) {
      $s1 = $str.Substring(0, $str.Length/2)
      $s2 = $str.Substring($str.Length/2)
      if ($s1 -eq $s2) {
        Write-Host "Invalid ID found: $num"
        $sum += $num
      }
    }
    $num++
  }
}

Write-Host $sum
