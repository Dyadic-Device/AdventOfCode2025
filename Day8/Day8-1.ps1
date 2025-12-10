$inFile = $args[0]
$inRaw = Get-Content $inFile
$juncs = New-Object System.Collections.ArrayList
$iter = 0
$circNum = $args[1]

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
1..$circNum | ForEach-Object {
  # Find the shortest connection
  $min = [int]::MaxValue
  $con = $_
  

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
}

<#
$juncs | ForEach-Object {
  $foo = $_.X
  $bar = $_.Y
  $wam = $_.Z
  $bam = $_.circ

  Write-Host "Junction ($foo, $bar, $wam) is part of Circuit $bam."
}
#>

$circs = @()
$totalCircs = 0
$juncs | ForEach-Object {
  if ($_.circ -notin $circs) {
    $circs += $_.circ
    $totalCircs++
  }
}
Write-Host "Total circuits: $totalCircs; Active circuits: $circs"

$max1, $max2, $max3 = 0
$circ1, $circ2, $circ3 = $circs[0]
$circs | ForEach-Object {
  $num = GetCircCount $juncs $_
  Write-Host ("Circuit {0} has {1} members." -f $_,$num)
  if ($num -gt $max1) {
    $max3 = $max2
    $circ3 = $circ2
    $max2 = $max1
    $circ2 = $circ1
    $max1 = $num
    $circ1 = $_
  }
  elseif ($num -gt $max2) {
    $max3 = $max2
    $circ3 = $circ2
    $max2 = $num
    $circ2 = $_
  }
  elseif ($num -gt $max3) {
    $max3 = $num
    $circ3 = $_
  }
}
Write-Host "Three biggest circuits are $circ1, $circ2, $circ3 with respective counts $max1, $max2, $max3."
Write-Host "Final result is $($max1 * $max2 * $max3)"