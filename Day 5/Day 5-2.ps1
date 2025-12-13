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

            # Also, check for min/max:
            if ([long]$min -eq 0 -or [long]$split[0] -lt $min) {
                $min = [long]$split[0]
            }
            if ([long]$split[1] -gt $max) {
                $max = [long]$split[1]
            }
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
Write-Host "Min $min / Max $max"
# After all ranges are collected,
 
$ranges | ForEach-Object {
    $num1 = [long]$_[0]
    $num2 = [long]$_[1]
    $inc = $num1
    while ($inc -le $num2) {
        if ($fresh -notcontains $inc) {
            $fresh += $inc
        }
        $inc++
    } 
}
Write-Host "Total of $($fresh.Length) ingredient IDs are fresh."


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