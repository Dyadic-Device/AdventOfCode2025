using namespace System.Collections.Generic

$inFile = $args[0]
$inRaw = Get-Content $inFile

class machine {
  [char[]] $lights
  [System.Collections.ArrayList] $buttons
  [int[]] $joltage
  
  [string] ToString() {
    $str = ""
    $btnNum = 0
    $str += "LIGHTS: $($this.lights)`n"
    $this.buttons | ForEach-Object {
      $str += "BUTTON $btnNum activates lights $($_.Lights)`n"
    }
    $str += "JOLTAGES: $($this.joltage)"
    return $str
  }

  [bool] TestButtons( [int[]] $PressedButtons ) {
    try {
      [char[]] $res = @()
      0..($this.lights.Length - 1) | ForEach-Object {
        $res += '.'
      }
      $PressedButtons | forEach-Object {
        $foo = $_
        $btn = $this.buttons[$foo]
        $btn.Lights | ForEach-Object {
          $bar = $_
          switch ($res[$bar]) {
            '#' {$res[$bar] = '.'; break}
            '.' {$res[$bar] = '#'; break}
          }
        }

        #Write-Host ("After button {0} is pressed, lights are {1}" -f $foo,[string]$res)
      }
      #Write-Host ("RESULT: {0}`nLIGHTS: {1}" -f [string]$res,[string]$this.lights)
      return ([string]$res -eq [string]$this.lights)

    }
    catch {
      $foo = $Error[0].Exception.Message
      #Write-Host "TestButtons failed due to error: $foo"
      return $false
    }
  }

  [bool] JoltageTest( [int[]] $PressedButtons) {

    return $false
  }

}

class button {
  [int[]] $Lights
}

$machines = [List[machine]]::new()

function GetButtonCombos {
  param( [machine] $InMach )
  $ret = [List[int[]]]::new()
  
  # Create base test cases
  #Write-Host "Adding test cases for button 0:"
  $ret.Add([int[]]@())
  $ret.Add([int[]]@(0))

  # For every other button, take the existing test cases, and add new ones where the button is pressed.
  1..($inMach.buttons.Count - 1) | ForEach-Object {
    $tempBtn = $_
    $cases = $ret.Count
    #Write-Host "Adding test cases for button $tempBtn."

    0..($cases - 1) | ForEach-Object {
      $tmp = $ret[$_].Clone()
      $tmp += $tempBtn
      #Write-Host "Adding $tmp to test cases..."
      $ret.Add($tmp)
    }
  }

  return $ret
}

$inRaw | ForEach-Object {
  $split = $_.split(" ")
  $tempMach = New-Object machine
  $tempMach.buttons = New-Object System.Collections.ArrayList
  $tempMach.lights = $split[0].Substring(1,($split[0].Length - 2)).ToCharArray()
  1..($split.Length - 2) | ForEach-Object {
    $foo = New-Object button
    $split[$_].Substring(1, ($split[$_].Length - 2)).Split(",") | ForEach-Object {$foo.Lights += [int]$_}
    $tempMach.buttons.Add($foo) | Out-Null
  }
  $joltageStr = $split[-1].Substring(1,($split[-1].Length - 2))
  $joltageStr.Split(",") | ForEach-Object {
    $tempMach.joltage += $_
  }  

  $machines.Add($tempMach) | Out-Null
}

$totalpresses = 0

$machines | ForEach-Object {
  $mach = $_

  # Get all button combinations
  $combos = GetButtonCombos $mach
  $validCombos = [List[int[]]]::new()

  # Check combos for validity
  $combos | ForEach-Object {
    $btnCombo = $_
    $valid = $mach.TestButtons($btnCombo)
    #Write-Host "Tested button combo {$btnCombo} which was $valid."
    if ($valid) {$validCombos.Add($btnCombo)}
  }

  # After getting all valid combos, find the minimum amount of presses.
  $minpresses = [int]::MaxValue
  $validCombos | ForEach-Object {
    if ( $_.Count -lt $minpresses ) {$minpresses = $_.Count}
  }

  # After getting min amount of presses, add minimum to total.
  $totalpresses += $minpresses
}

Write-Host "Fewest total presses is $totalpresses."