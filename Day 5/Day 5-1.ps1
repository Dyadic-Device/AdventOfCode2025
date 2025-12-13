$inFile = $args[0]
$in = Get-Content $inFile
$parseRange = $true
$ranges = @()
$total = 0

# For each line in the input...
$in | ForEach-Object {

    #If we're getting the ranges, parse as range
    if ($parseRange) {
        # Get the range, split it, and add it to the ranges array
        $raw = $_

        # If it is a range...
        if ($raw -like "*-*") {
            $split = $raw.Split('-')
            $ranges += ,@($split[0], $split[1])
            Write-Host "Added $($split[0])-$($split[1]) to ranges."
        }
        else {
            $parseRange = $false
        }
    }

    #Otherwise, parse as ingredient
    else {
        # Get the ingredient, assume it's spoiled.
        $ing = $_
        $spoiled = $true

        Write-Host "Testing $ing..."

        # For each range you have...
        $ranges | ForEach-Object {
            # If you know the ingredient is fresh, move on.
            if ($spoiled -eq $false) {
                return
            }
            # if it's spoiled but lies within the current range, alert user, increment total, and mark it as fresh.
            elseif ([long]$ing -ge [long]$_[0] -and [long]$ing -le [long]$_[1]) {
                Write-Host "Ingredient $ing is fresh because it falls into range $($_[0])-$($_[1])."
                $total++
                $spoiled = $false
            }
            # Otherwise, move on to the next range.
        }
        # If still spoiled after checking, alert user
        if ($spoiled) {
            Write-Host "Ingredient $ing is spoiled because it does not fall into any range."
        }
    }
}

# Write the final total.
Write-Host "$total ingredients are fresh."