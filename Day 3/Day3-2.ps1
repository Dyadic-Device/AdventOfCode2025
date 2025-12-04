$digits = 12
$total = 0

Get-Content $args[0] | ForEach-Object {
  $row = $_
  $index = -1
  $rowjolt = ""

  # For each digit in the eventual answer...
  1..$digits | ForEach-Object {
    $max = 0

    # Find the biggest digit in the valid range
    ($index + 1)..($row.Length - (13 - $_)) | ForEach-Object {
      
      # If the digit is bigger than the max, update the index to that digit.
      ([int]$row[$_] -gt $max) ? $($max = $row[$_] ; $index = $_) : $null
    }

    # After biggest digit is found, append it to the outstring for that row.
    $rowjolt += [string]$max
  }

  # After maximum is found, collate total and print.
  Write-Host "Max joltage for $row is $rowjolt"
  $total += [long]$rowjolt
}

Write-Output $total