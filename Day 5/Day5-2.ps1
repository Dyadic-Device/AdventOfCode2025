using namespace System
using namespace System.Collections.Generic

$inFile = $args[0]
$inRaw = Get-Content $inFile

$Ranges = [List[Tuple[long,string]]]::new()

0..($inRaw.IndexOf("") - 1 ) | ForEach-Object {
  $split = $inRaw[$_].Split('-')
  $ranges.Add([Tuple]::Create([long]$split[0], 's'))
  $ranges.Add([Tuple]::Create([long]$split[1], 'e'))
}

$sortRanges = $ranges | Sort-Object -Property @{Expression="Item1";Descending=$false},@{Expression="Item2";Descending=$true} 

$totalIDs = 0

$depth = 0
$sortRanges | ForEach-Object {
  $val = $_
  #Write-Host ("Current Value: {0}{1}. Depth is {2} before actions taken." -f $val[1],$val[0],$depth)
  switch ($val[1]) {
    's' { 
      if ($depth -eq 0) {
        $start = $val[0]
      }
      $depth++
    }
    'e' {
      $depth--
      if ($depth -eq 0) {
        $end = $val[0]
        #Write-Host "Adding range $start-$end to total."
        $totalIDs += $end - $start + 1
      }     
    }
  }
}

Write-Host "Total number of Fresh Ingredients is $totalIDs."

