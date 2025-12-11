$inFile = $args[0]
$inRaw = Get-Content $inFile

class Range {
  [long]$start = 0
  [long]$end = 0
}

$ranges = New-Object System.Collections.ArrayList

0..($inRaw.IndexOf("") - 1 ) | ForEach-Object {
  $split = $inRaw[$_].Split('-')
  $ranges += [range]@{
    start = [long]$split[0]
    end = [long]$split[1]
  }
}

$ranges | ForEach-Object {
  Write-Host ("{0}-{1}" -f $_.start,$_.end)
}


$collateRanges = New-Object System.Collections.ArrayList

$ranges | ForEach-Object {
  $foo = $_
  $start = $foo.start
  $end = $foo.end

  Write-Host "Checking Range $start-$end"
  
  #Create temp ranges array of other ranges
  $tempRanges = New-Object System.Collections.ArrayList
  $ranges | ForEach-Object {
    $bar = $_
    if ($bar -ne $foo) {$tempRanges.Add($bar) | Out-Null}
  }

  Write-Host $TempRanges

  # As long as there are still tempranges left, go through each
  $iter = 0
  $noRemove = $true
  while ($tempRanges.Count -gt 0) {
    $bar = $tempRanges[$iter]
    $remove = $false
    $fullOverlap = $false
    $tstart = $bar.start
    $tend = $bar.end

    Write-Host "Checking range $iter in Temp Ranges. Range is $tstart-$tend"

    if (($start -lt $tstart) -and ($end -gt $tstart) -and ($end -lt $tend)) {
      Write-Host "High overlap"
      $foo.end = $tend
      $end = $tend
      $remove = $true
      $noRemove = $false
    }
    if (($end -gt $tend) -and ($start -gt $tstart) -and ($start -lt $tend)) {
      Write-Host "Low Overlap"
      $foo.start = $tstart
      $start = $tstart
      $remove = $true
      $noRemove = $false
    }
    if (($start -le $tstart) -and ($end -ge $tend) -and -not $remove) {
      Write-Host "Full overlap"
      $fullOverlap = $true
    }
    if ($remove) {
      $tempRanges.removeAt($iter)
      $ranges | ForEach-Object {
        $wam = $_
        if (($wam -ne $foo) -and ($wam -ne $bar)) {$tempRanges.Add($wam) | Out-Null}
      }
      $iter = 0
    }
    else {
      Write-Host "No overlap."
      $tempRanges.removeAt($iter)
    }
  }

  #Check Collated Ranges
  $collateRanges | ForEach-Object {
    $bam = $_
    $tstart2 = $bam.start
    $tend2 = $bam.end

    if (($start -ge $tstart2) -and ($end -le $tend2)) {
      $fulloverlap = $false
      $noRemove = $false
    }
  }

  if ($fullOverlap -or $noRemove) {
    $collateRanges.Add($foo)
    Write-host "added $start-$end to collated ranges."
  }
}

<#
$ranges | ForEach-Object {
  $foo = $_
  $iter = 0
  $start = $foo.start
  $end = $foo.end
  while (($iter -lt $tempRanges.Count) -and (-not $remove)) {
    $remove = $false
    $tstart = $tempRanges[$iter].start
    $tend = $tempRanges[$iter].end

    #if start of range is lower than temprange and end is within temprange
    if (($start -lt $tstart) -and ($end -gt $tstart) -and ($end -lt $tend)) {
      #expand current range
      $foo.end = $tend

      #remove old temprange
      $remove = $true
    }

    #if end of range is greater than temprange and start is within temprange
    if (($end -gt $tend) -and ($start -gt $tstart) -and ($start -lt $tend)) {
      #expand current range
      $foo.start = $tstart

      #remove old temprange
      $remove = $true
    }
    
    #if old range needs to be removed...
    if ($remove){
      #remove the range
      $tempRanges.RemoveAt($iter)

      #dial back the iter so we don't miss any
      $iter = -1
    }

    $iter++
  }

  #after going through all tempranges, add collated range to Collated ranges
  $collateRanges.Add($foo) | Out-Null
}
#>

$total = 0
$collateRanges | forEach-Object {
  Write-Host ("{0}-{1}" -f $_.start,$_.end)
  $total += ($_.end - $_.start + 1)
}

Write-Host "Total Legal IDs = $total"

