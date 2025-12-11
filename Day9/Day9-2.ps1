$inFile = $args[0]
$inRaw = Get-Content $inFile

$TileRows = @()
$TileCols = @()

$inRaw | ForEach-Object {
  $split = $_.Split(',')
  $tileRows += [int]$split[0]
  $tileCols += [int]$split[1]
}

function GetArea {
  param( [int]$ind1, [int]$ind2 )
  $width = [Math]::Abs($tileRows[$ind1] - $tileRows[$ind2]) + 1
  $height = [Math]::Abs($tileCols[$ind1] - $tileCols[$ind2]) + 1

  return $height * $width
}

function CheckArea {
  param( [int]$ind1, [int]$ind2 )
  $pass = $true

  if ($tileRows[$ind1] -gt $tileRows[$ind2]) {
    $Rowstart = $tileRows[$ind1]
    $Rowend = $tilerows[$ind2]
  }
  else {
    $Rowstart = $tileRows[$ind2]
    $Rowend = $tileRows[$ind1]
  }

  if ($tilecols[$ind1] -gt $tilecols[$ind2]) {
    $colstart = $tilecols[$ind1]
    $colend = $tilecols[$ind2]
  }
  else {
    $colstart = $tilecols[$ind2]
    $colend = $tilecols[$ind1]
  }

  $rowstart..$rowend | ForEach-Object {
    $foo = $_
    $colstart..$colend | ForEach-Object {
      $bar = $_

      if ($floor[$foo][$bar] -eq '.') {
        $pass = $false
      }
    }
  }

  return $pass
}

$maxArea = 0
$MaxInd1 = 0
$MaxInd2 = 0

<#
0..$($TileRows.Count - 2) | ForEach-Object {
  $foo = $_
  1..$($TileRows.Count - 1) | ForEach-Object {
    $area = GetArea $foo $_
    if ($area -gt $maxArea) {
      $maxArea = $area
      $MaxInd1 = $foo
      $MaxInd2 = $_
    }
  }
}

Write-Host ("Max area is {0} with tiles at indices ({1}, {2}) and ({3},{4})." -f $maxArea,$tileRows[$MaxInd1],$TileCols[$MaxInd1],$TileRows[$MaxInd2],$TileCols[$MaxInd2])
#>

# Get Min and Max of Arrays
$rowMin = [int]::MaxValue
$rowmax = 0
$colmin = [int]::MaxValue
$colmax = 0

$tileRows | ForEach-Object {
  ($_ -lt $rowMin) ? $($rowMin = $_) : $null
  ($_ -gt $rowMax) ? $($rowMax = $_) : $null
}

$tileCols | ForEach-Object {
  ($_ -lt $colMin) ? $($colMin = $_) : $null
  ($_ -gt $colMax) ? $($colMax = $_) : $null
}

# Reduce values based on minimums
0..$($TileRows.Count -1 ) | ForEach-Object {
  $TileRows[$_] -= $rowMin
  $TileCols[$_] -= $colmin
}
$RowMax -= $rowMin
$colmax -= $colmin
$rowMin = 0
$colmin = 0

# Create Floor
$floor = @($null)
0..$rowMax | ForEach-Object {
  $foo = $_
  $floor += @($null)
  0..$colMax | ForEach-Object {
    $floor[$foo] += ,'.'
  }
}

# Drop first tile
$floor[$tileRows[0]][$TileCols[0]] = '#'
#For every other tile, move from last tile to current tile and drop tiles along the way.
1..$($TileRows.Count - 1) | ForEach-Object {
  $rowcurrent = $tileRows[$_]
  $rowlast = $tilerows[$_ - 1]
  $colcurrent = $Tilecols[$_]
  $collast = $TileCols[$_ - 1]

  $rowlast..$rowcurrent | ForEach-Object {
    $foo = $_
    $collast..$colcurrent | ForEach-Object {
      $bar = $_
      $floor[$foo][$bar] = '#'
    }
  }
}
#Move from final tile to start
$rowcurrent = $tileRows[0]
$rowlast = $tilerows[$tilerows.Count - 1]
$colcurrent = $Tilecols[0]
$collast = $TileCols[$tilerows.Count - 1]

$rowlast..$rowcurrent | ForEach-Object {
  $foo = $_
  $collast..$colcurrent | ForEach-Object {
    $bar = $_
    $floor[$foo][$bar] = '#'
  }
}


# Row by row, Fill in blank spaces
0..$($floor.Count - 2) | ForEach-Object {
  $inside = $false
  $foo = $_
  Write-Host $floor[$foo]
  0..$($floor[$foo].Count - 2) | ForEach-Object {
    $bar = $_
    Write-Host $floor[$foo][$bar]
    switch ($floor[$foo][$bar]) {
      '.' {$inside ? $($floor[$foo][$bar] = '#') : $null}
      '#' {$inside ? $($inside = $false) : $(if ($floor[$foo][$bar + 1] -eq '.') {$inside = $true})}
    }
  }
}


$floor | ForEach-Object {
  $_ | ForEach-Object {
    Write-Host $_ -NoNewline
  }
  Write-Host ""
}