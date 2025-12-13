$inFile = $args[0]
$inRaw = Get-Content $inFile
$inArray = @()
$inRaw | ForEach-Object {
    $inArray += ,$_.ToCharArray()
}

Write-Host $inArray


$row = 1
$rowmax = $inRaw.Length - 1

$col = 0
$colmax = $inRaw[0].Length - 1

$splits = 0

$row..$rowmax | ForEach-Object {
    $rowindex = $_

    $col..$colmax | ForEach-Object {
        $colindex = $_

        $current = $inArray[$rowindex][$colindex]
        $above = $inArray[$rowindex - 1][$colindex]

        switch ($current) {
            '.' {
                switch ($above) {
                    'S' {$inArray[$rowindex][$colindex] = "|"; break}
                    '|' {$inArray[$rowindex][$colindex] = "|"; break}
                }
                break
            }
            '^' {
                switch ($above) {
                    '|' {$inArray[$rowindex][$colindex - 1] = '|'; $inArray[$rowindex][$colindex + 1] = '|'; $splits++; break}
                }
                break
            }
        }
    }
}

Write-Host "Total splits is $splits"