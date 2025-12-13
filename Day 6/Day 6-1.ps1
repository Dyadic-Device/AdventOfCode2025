$inFile = $args[0]
$RawIn = Get-Content $inFile
$TrimIn = @()
$DocLength = $RawIn.Length
$i = 0
while ($i -lt $DocLength){
    $TrimIn += $rawIn[$i] -replace '\s+', ' '
    $i++
}

$probnum = $TrimIn[0].trim().split().Length
$ops = $TrimIn[-1].trim().Split()
$res = [long[]]$TrimIn[0].trim().Split()
$total = 0


$TrimIn[1..$($DocLength-2)] | ForEach-Object {
    $rawline = $_
    $split = [long[]]$rawline.trim().split()
    $inc = 0
    while ($inc -le $($probnum - 1)) {
        switch($ops[$inc]) {
            '*' {$res[$inc] *= $split[$inc]; break}
            '+' {$res[$inc] += $split[$inc]; break}
        }
        $inc++
    }
}

$res | ForEach-Object {
    Write-Host "Result is $_"
    $total += $_
}

Write-Host "Grand total is $total."