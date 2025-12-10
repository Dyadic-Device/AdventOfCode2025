$inFile = $args[0]
$inRaw = Get-Content $inFile

$TileRows = @()
$TileCols = @()

$inRaw | ForEach-Object {
  $split = $_.Split(',')
  $tileRows += $split[0]
  $tileCols += $split[1]
}

function GetArea {
  param( [int]$ind1, [int]$ind2 )
  $width = [Math]::Abs($tileRows[$ind1] - $tileRows[$ind2]) + 1
  $height = [Math]::Abs($tileCols[$ind1] - $tileCols[$ind2]) + 1

  return $height * $width
}

$maxArea = 0
$MaxInd1 = 0
$MaxInd2 = 0

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