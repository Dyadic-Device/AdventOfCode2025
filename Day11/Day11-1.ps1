using namespace System.Collections.Generic

$inFile = $args[0]
$inRaw = Get-Content $inFile

class device {
    [string]$name
    [string[]]$outputs

    [string]ToString() {
        $ret = "$($this.name):"
        $this.outputs | ForEach-Object {
            $ret += " $_"
        }

        return $ret
    }
}

$totalpaths = 0
function getPaths {
    param( [string] $in )

    #Write-Host "Testing paths for $in..."
    if ($devices[$in] -eq "out") {
        $Script:totalpaths++
        #Write-Host "Device leads out, adding to total valid paths. Currently $totalpaths."
    }
    else {
        #Write-Host "Device does not lead out. Trying subpaths..."
        $devices[$in] | ForEach-Object {
            getPaths $_
        }
    }
}

$devices = @{}

$inRaw | ForEach-Object {
    $split = $_.Split()

    $devices.Add($split[0].Substring(0,3), $split[1..($split.Length - 1)])
}

$devices["you"] | ForEach-Object {
    getPaths $_
}

Write-Host $totalpaths
