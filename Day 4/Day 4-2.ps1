# Initial Vars
$total = 0
$inFile = $args[0]
$StartGrid = Get-Content $inFile
$iter = 0
$oldgrid = $StartGrid

function RemoveRolls {
  $grid = $args[0]
  $newgrid = @()
  $colLength = $grid.Length
  $rowlength = $grid[0].Length
  $removed = 0

  0..($colLength - 1) | ForEach-Object {
    $i = $_
    switch ($i) {
      0 {$adjrows = @($i, $($i+1)) ; break}
      ($colLength - 1) {$adjrows = @($($i-1), $i) ; break}
      default {$adjrows = @($($i-1), $i, $($i+1))}
    }

    $newstr = ""

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

      if ($adjnum -lt 4 -and $grid[$i][$j] -eq '@') {$total++; $removed++; $newstr += 'x'}
      else {$newstr += $grid[$i][$j]}
    }
    $newgrid += $newstr
  }

  Write-Output $newgrid
}

function countRolls {
  $cgrid = $args[0]
  $count = 0

  $cgrid | ForEach-Object {
    $str = $_
    0..($str.Length - 1) | ForEach-Object {
      if ($str[$_] -eq 'x') {$count++}
    }
  }

  Write-Output $count
}

function clearRolls {
  $ingrid = $args[0]
  $outgrid = @()

  0..($ingrid.Length-1) | ForEach-Object {
    $i = $_
    $str = ""
    0..($ingrid[0].Length - 1) | ForEach-Object {
      $j = $_
      if ($ingrid[$i][$j] -eq 'x') {$str += '.'}
      else {$str += $ingrid[$i][$j]}
    }
    $outgrid += $str
  }

  Write-Output $outgrid
}

do {
  $rem = 0
  $grid2 = RemoveRolls $oldgrid
  $rem = countRolls $grid2
  Write-Host "During iteration $iter, $rem rolls were removed for a total of $total."
  $total += $rem
  $newgrid = clearRolls $grid2
  $oldgrid = $newgrid
  $iter++
} while ($rem -gt 0)

Write-Host "A total of $total rolls were removed during all iterations."