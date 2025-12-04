$total = 0

Get-Content $args[0] | ForEach-Object {
  $row = $_
  $max1 = 0
  $max2 = 0

  # Find biggest possible first digit in row
  0..($row.Length-2) | ForEach-Object { ($row[$_] -gt $max1) ? $($max1 = $row[$_]) : $null}

  # Find biggest possible second digit in row
  ($row.IndexOfAny($max1)+1)..($row.Length-1) | ForEach-Object { ($row[$_] -gt $max2) ? $($max2 = $row[$_]) : $null}

  $num = "$max1" + "$max2"

  $total += [int]$num
}

Write-Output $total