# Initial Vars
$total = 0
$newgrid = ""
$inFile = $args[0]
$grid = Get-Content $inFile
$colLength = $grid.Length
$rowlength = $grid[0].Length

0..($colLength - 1) | ForEach-Object {
  $i = $_
  switch ($i) {
    0 {$adjrows = @($i, $($i+1)) ; break}
    ($colLength - 1) {$adjrows = @($($i-1), $i) ; break}
    default {$adjrows = @($($i-1), $i, $($i+1))}
  }

  0..($rowlength - 1) | ForEach-Object {
    $j = $_
    switch ($j) {
      0 {$adjcols = @($j, $($j+1)) ; break}
      ($rowlength - 1) {$adjcols = @($($j-1), $j) ; break}
      default {$adjcols = @($($j-1), $j, $($j+1))}
    }

    $adjnum = 0
    
    $adjrows | ForEach-Object {
      $k = $_
      $adjcols | ForEach-Object {
        $l = $_
        if ($i -eq $k -and $j -eq $l) {$adjnum--}
        if ($grid[$k][$l] -eq '@') {$adjnum++}
      }
    }

    if ($adjnum -lt 4 -and $grid[$i][$j] -eq '@') {$total++; $newgrid += 'x'}
    else {$newgrid += $grid[$i][$j]}
  }
}

0..($colLength - 1) | ForEach-Object {
  $i = $_
  0..($rowlength - 1) | ForEach-Object {
    $j = $_
    Write-Host -NoNewline $newgrid[($i*$rowlength)+$j]
  }
  Write-Host ""
}

Write-Host "A total of $total rolls can be accessed."