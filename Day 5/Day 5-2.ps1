$inFile = $args[0]
$in = Get-Content $inFile
$parseRange = $true
$ranges = @()
$total = 0
[long]$min = 0
[long]$max = 0
$fresh = @()

# For each line in the input...
$in | ForEach-Object {
    #If we're getting the ranges, parse as range
    if ($parseRange) {
        # Get the range, split it, and add it to the ranges array
        $raw = $_

        # If it is a range...
        if ($raw -like "*-*") {
            #Split the string, add it to the array, and inform the user.
            $split = $raw.Split('-')
            $ranges += ,@($split[0], $split[1])
            Write-Host "Added $($split[0])-$($split[1]) to ranges."
        }
        else {
            $parseRange = $false
        }
    }
    #Otherwise, move on
    else {
       return
    }
}

$collateranges += $ranges[0]
# After all ranges are collected, collate them
$ranges[1..$($ranges.Length - 1)] | ForEach-Object {
    Write-Host "Current Range = $_; Collated Ranges = $collateranges"
    # Grab the current range
    $workingRange = $_
    $expandmin = $false
    $expandmax = $false

    # Go through collated ranges and see if there is any overlap. If so, expand it. 
    $collateRanges | ForEach-Object {
        if ($workingRange[0] -gt $_[0] -and $workingRange[0] -lt $_[1] -and $workingRange[1] -gt $_[1]) {
            Write-Host "Pre-expand: $_"
            $expandmax = $true
            $_[1] = $workingRange[1]
            Write-Host "Post-expand: $_"
        }
        if ($workingRange[1] -gt $_[0] -and $workingRange[1] -lt $_[1] -and $workingRange[0] -lt $_[0]) {
            Write-Host "Pre-expand: $_"
            $expandmin = $true
            $_[0] = $workingRange[0]
            Write-Host "Post-Expand: $_"
        }
    }

    if (-not $expandmin -and -not $expandmin) {
        $collateRanges += $workingRange
    }
}

Write-Host $collateranges

$ids = 0
$collateRanges | ForEach-Object {
    $ids += ($_[1] - $_[0] + 1)
}

Write-Host $ids

<#
$ranges | ForEach-Object {
    $num1 = [long]$_[0]
    $num2 = [long]$_[1]
    $inc = $num1
    while ($inc -le $num2) {
        if ($fresh -notcontains $inc) {
            $fresh += $inc
            Write-Host "Ingredient ID $inc added."
        }
        $inc++
    } 
}
Write-Host "Total of $($fresh.Length) ingredient IDs are fresh."
#>

<#
$inc = [long]$min

while ($inc -le $max) {
    $spoiled = $true
    $ranges | ForEach-Object {
            # If you know the ingredient is fresh, move on.
            if ($spoiled -eq $false) {
                return
            }
            # if it's spoiled but lies within the current range, alert user, increment total, and mark it as fresh.
            elseif ([long]$inc -ge [long]$_[0] -and [long]$inc -le [long]$_[1]) {
                $fresh += $inc
                $spoiled = $false
            }
            # Otherwise, move on to the next range.
        }
    $inc++
}
# Write the final total.
Write-Host "$($fresh.Length) ingredient IDs are fresh."
#>