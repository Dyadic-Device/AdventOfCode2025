$inFile = $args[0]
$inRaw = Get-Content $inFile
$juncs = New-Object System.Collections.ArrayList
$iter = 0

class Junction {
  [int]$X
  [int]$Y
  [int]$Z
  [int]$circ

  [String] toString() {
    return "($($this.X), $($this.Y), $($this.Z))"
  }
}

function GetDist {
  param( [Junction]$foo, [Junction]$bar )

  return [Math]::Sqrt( [Math]::Pow($foo.X - $bar.X, 2) + [Math]::Pow($foo.Y - $bar.Y, 2) + [Math]::Pow($foo.Z - $bar.Z, 2) )
}

function GetCircCount {
  param( $List, [int]$foo ) 
  $count = 0
  $List | ForEach-Object {
    if ($_.circ -eq $foo) {
      $count++
    }
  }

  return $count
}

# Turn input into junction objects and add to Juncs arrayList
$inRaw | ForEach-Object {
  $split = $_.Split(',')
  $temp = New-Object -TypeName Junction -Property @{X = [int]$split[0]; Y = [int]$split[1]; Z = [int]$split[2]; circ = $iter}

  $juncs.Add($temp) | Out-Null
  $iter++
}
# Create a hash table of connections and distances
$dists = @{}
0..$($juncs.count - 2) | ForEach-Object {
  $foo = $_
  $($foo+1)..$($juncs.count - 1) | ForEach-Object {
    $bar = $_
    $dists.Add("$foo-$bar", (GetDist $juncs[$foo] $juncs[$bar]))
  }
}

# For each connections...
$lastDist = 0
$dist = 0
$iter = 1
while($added -lt $juncs.Count) {
  # Find the shortest connection
  $min = [int]::MaxValue
  $con = $iter
  

  # For each pair of junctions...
  0..$($juncs.Count - 2) | ForEach-Object {
    $foo = $_
    $($_+1)..$($juncs.Count - 1) | ForEach-Object {
      $bar = $_
      $dist = $dists["$foo-$bar"]
      
      #If the distance is minimum and larger than the last dist...
      if (($dist -le $min) -and ($dist -gt $lastDist)) {
        # Note the indices and update the minimum
        $juncMin1 = $juncs.IndexOf($juncs[$foo])
        $juncMin2 = $juncs.IndexOf($juncs[$bar])
        $min = $dist
      }
    }
  }
  # After shortest connection is found, set all connected circuits to match lower circ #.
  $oldcirc1 = $juncs[$juncMin1].circ
  $oldcirc2 = $juncs[$juncMin2].circ
  ($oldcirc1 -lt $oldcirc2) ? $($newcirc = $oldcirc1; $oldcirc = $oldcirc2) : $($newcirc = $oldcirc2; $oldcirc = $oldcirc1)
  $added = 0

  $juncs | ForEach-Object {
    if (($_.circ -eq $oldcirc1) -or ($_.circ -eq $oldcirc2)) {
      $_.circ = $newcirc
      $added++
    }
  }

  $lastDist = $min
  Write-Host "Connection $con found between junction $($juncs[$juncMin1].toString()) and $($juncs[$juncMin2].toString()). Dist = $($dists["$juncmin1-$juncmin2"]); Circuit # $newcirc attached $oldcirc and now has $added junctions."
  $iter++
}

$circs = @()
$totalCircs = 0
$juncs | ForEach-Object {
  if ($_.circ -notin $circs) {
    $circs += $_.circ
    $totalCircs++
  }
}
Write-Host "Total circuits: $totalCircs; Active circuits: $circs"

Write-Host ("X coords of final 2 junctions: {0} / {1} ; Final result: {2}" -f $juncs[$juncMin1].X, $juncs[$juncMin2].X,$($juncs[$juncMin1].X * $juncs[$juncMin2].X))
