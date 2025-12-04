$sum = 0

(Get-Content $args[0]) -split "," | ForEach-Object {
  $range = $_ -split "-"
  $num = [long]$range[0]
  $end = [long]$range[1]

  while ($num -le $end) {
    $str = [string]$num
    $valid = $true

    if ($str.Length -le 1) {
      $num++
      continue
    }

    1..[int]$($str.Length / 2) | ForEach-Object {
      $i = $_
      if ($str.Length % $i -eq 0) {
        $tmp = $str.Substring(0, $i)
        $tmp = [string]$tmp * ($str.Length / $i)
        if ($tmp -eq $str) {
          $valid = $false
        }
      }
    }

    if ($valid -eq $false) {
      Write-Host "Invalid ID Found: $num"
      $sum += $num
    }
    $num++
  }
}

Write-Host $sum
