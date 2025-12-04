
$output = 0
$dial = 50
Write-Host "The dial starts by pointing at $dial."
Get-Content $args[0] | ForEach-Object {
  $temp = $_
  $dir = $temp.substring(0,1)
  $num = [int]$temp.substring(1)

  while ($num -gt 0) {
    switch ($dir) {
      'L' {
        $dial--
        $num--
        break
      }
      'R' {
        $dial++
        $num--
        break
      }
    }
    
    switch ($dial) {
      -1  { $dial = 99 ; break}
      0   { $output++ ; break}
      100 { $dial = 0; $output++; break}
    }
  }

  Write-Host "The dial is rotated $temp to point at $dial. Output $output"
}

Write-Host $output