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

        Write-Host ("After button {0} is pressed, lights are {1}" -f $foo,[string]$res)
      }
      Write-Host ("RESULT: {0}`nLIGHTS: {1}" -f [string]$res,[string]$this.lights)
      return ([string]$res -eq [string]$this.lights)

    }
    catch {
      $foo = $Error[0].Exception.Message
      Write-Host "TestButtons failed due to error: $foo"
      return $false
    }
  }

}

class button {
  [int[]] $Lights
}

$machines = New-Object System.Collections.ArrayList

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

$machines | ForEach-Object {
  Write-Host $_
}

$testbuttons = @(0,1,2)
$test1 = $machines[0].TestButtons($testbuttons)
Write-Host "Results of $testbuttons on machine[0] is $test1."