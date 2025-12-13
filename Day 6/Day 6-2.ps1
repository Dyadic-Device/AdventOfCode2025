$inFile = $args[0]
$rawIn = Get-Content $inFile
$linelength = $rawIn[0].Length
$opsStr = $rawIn[-1] -replace '\s+', ' '
$ops = $opsStr.trim().split()
$probnum = $ops.Length
$digits = $rawIn.Length - 1
$nums = @()
$resArray = @()
$total = 0

$($linelength - 1)..0 | ForEach-Object {
    $col = $_
    $str = ""
    0..$($digits - 1) | ForEach-Object {
        $str += $RawIn[$_][$col]
    }
    $nums += [long]$str
}

$opIndex = $probnum - 1
switch ($ops[$opIndex]) {
    '+' {$res = 0}
    '*' {$res = 1}
}
$nums | ForEach-Object {
    $num = $_
    if ($num -eq 0) {
        $opIndex--
        $resArray += $res
        switch ($ops[$opIndex]) {
            '+' {$res = 0}
            '*' {$res = 1}
        }
        return
    }
    else {
        switch ($ops[$opindex]) {
            '*' {$res *= $num}
            '+' {$res += $num}
        }
    }
}
$resArray += $res

Write-Host $resArray

$resArray | ForEach-Object {
    $total += $_
}

Write-Host "Total is $total."