# Module created by Microsoft.PowerShell.Crescendo
# Version: 1.1.0
# Schema: https://aka.ms/PowerShell/Crescendo/Schemas/2022-06
# Generated at: 10/25/2023 21:20:19
class PowerShellCustomFunctionAttribute : System.Attribute {
    [bool]$RequiresElevation
    [string]$Source
    PowerShellCustomFunctionAttribute() { $this.RequiresElevation = $false; $this.Source = "Microsoft.PowerShell.Crescendo" }
    PowerShellCustomFunctionAttribute([bool]$rElevation) {
        $this.RequiresElevation = $rElevation
        $this.Source = "Microsoft.PowerShell.Crescendo"
    }
}

# Returns available errors
# Assumes that we are being called from within a script cmdlet when EmitAsError is used.
function Pop-CrescendoNativeError {
param ([switch]$EmitAsError)
    while ($__CrescendoNativeErrorQueue.Count -gt 0) {
        if ($EmitAsError) {
            $msg = $__CrescendoNativeErrorQueue.Dequeue()
            $er = [System.Management.Automation.ErrorRecord]::new([system.invalidoperationexception]::new($msg), $PSCmdlet.Name, "InvalidOperation", $msg)
            $PSCmdlet.WriteError($er)
        }
        else {
            $__CrescendoNativeErrorQueue.Dequeue()
        }
    }
}
# this is purposefully a filter rather than a function for streaming errors
filter Push-CrescendoNativeError {
    if ($_ -is [System.Management.Automation.ErrorRecord]) {
        $__CrescendoNativeErrorQueue.Enqueue($_)
    }
    else {
        $_
    }
}

function Invoke-Minizinc
{
[PowerShellCustomFunctionAttribute(RequiresElevation=$False)]
[CmdletBinding()]

param(
[Parameter(Position=0)]
[PSDefaultValue(Value="gecode")]
[string]$Solver = "gecode",
[Parameter(Position=1)]
[string[]]$Data,
[Parameter(Position=2)]
[string]$ModelPath,
[Parameter(Position=3)]
[string[]]$DataPath
    )

BEGIN {
    $PSNativeCommandUseErrorActionPreference = $false
    $__CrescendoNativeErrorQueue = [System.Collections.Queue]::new()
    $__PARAMETERMAP = @{
         Solver = @{
               OriginalName = '--solver'
               OriginalPosition = '0'
               Position = '0'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         Data = @{
               OriginalName = '-D'
               OriginalPosition = '0'
               Position = '1'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         ModelPath = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '2'
               ParameterType = 'string'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
         DataPath = @{
               OriginalName = ''
               OriginalPosition = '0'
               Position = '3'
               ParameterType = 'string[]'
               ApplyToExecutable = $False
               NoGap = $False
               ArgumentTransform = '$args'
               ArgumentTransformType = 'inline'
               }
    }

    $__outputHandlers = @{
        default = @{ StreamOutput = $False; Handler = 'convertMinizincOutput' }
    }
}

PROCESS {
    $__boundParameters = $PSBoundParameters
    $__defaultValueParameters = $PSCmdlet.MyInvocation.MyCommand.Parameters.Values.Where({$_.Attributes.Where({$_.TypeId.Name -eq "PSDefaultValueAttribute"})}).Name
    $__defaultValueParameters.Where({ !$__boundParameters["$_"] }).ForEach({$__boundParameters["$_"] = get-variable -value $_})
    $__commandArgs = @()
    $MyInvocation.MyCommand.Parameters.Values.Where({$_.SwitchParameter -and $_.Name -notmatch "Debug|Whatif|Confirm|Verbose" -and ! $__boundParameters[$_.Name]}).ForEach({$__boundParameters[$_.Name] = [switch]::new($false)})
    if ($__boundParameters["Debug"]){wait-debugger}
    foreach ($paramName in $__boundParameters.Keys|
            Where-Object {!$__PARAMETERMAP[$_].ApplyToExecutable}|
            Where-Object {!$__PARAMETERMAP[$_].ExcludeAsArgument}|
            Sort-Object {$__PARAMETERMAP[$_].OriginalPosition}) {
        $value = $__boundParameters[$paramName]
        $param = $__PARAMETERMAP[$paramName]
        if ($param) {
            if ($value -is [switch]) {
                 if ($value.IsPresent) {
                     if ($param.OriginalName) { $__commandArgs += $param.OriginalName }
                 }
                 elseif ($param.DefaultMissingValue) { $__commandArgs += $param.DefaultMissingValue }
            }
            elseif ( $param.NoGap ) {
                # if a transform is specified, use it and the construction of the values is up to the transform
                if($param.ArgumentTransform -ne '$args') {
                    $transform = $param.ArgumentTransform
                    if($param.ArgumentTransformType -eq 'inline') {
                        $transform = [scriptblock]::Create($param.ArgumentTransform)
                    }
                    $__commandArgs += & $transform $value
                }
                else {
                    $pFmt = "{0}{1}"
                    # quote the strings if they have spaces
                    if($value -match "\s") { $pFmt = "{0}""{1}""" }
                    $__commandArgs += $pFmt -f $param.OriginalName, $value
                }
            }
            else {
                if($param.OriginalName) { $__commandArgs += $param.OriginalName }
                if($param.ArgumentTransformType -eq 'inline') {
                   $transform = [scriptblock]::Create($param.ArgumentTransform)
                }
                else {
                   $transform = $param.ArgumentTransform
                }
                $__commandArgs += & $transform $value
            }
        }
    }
    $__commandArgs = $__commandArgs | Where-Object {$_ -ne $null}
    if ($__boundParameters["Debug"]){wait-debugger}
    if ( $__boundParameters["Verbose"]) {
         Write-Verbose -Verbose -Message "/Applications/MiniZincIDE.app/Contents/Resources/minizinc"
         $__commandArgs | Write-Verbose -Verbose
    }
    $__handlerInfo = $__outputHandlers[$PSCmdlet.ParameterSetName]
    if (! $__handlerInfo ) {
        $__handlerInfo = $__outputHandlers["Default"] # Guaranteed to be present
    }
    $__handler = $__handlerInfo.Handler
    if ( $PSCmdlet.ShouldProcess("/Applications/MiniZincIDE.app/Contents/Resources/minizinc $__commandArgs")) {
    # check for the application and throw if it cannot be found
        if ( -not (Get-Command -ErrorAction Ignore "/Applications/MiniZincIDE.app/Contents/Resources/minizinc")) {
          throw "Cannot find executable '/Applications/MiniZincIDE.app/Contents/Resources/minizinc'"
        }
        if ( $__handlerInfo.StreamOutput ) {
            if ( $null -eq $__handler ) {
                & "/Applications/MiniZincIDE.app/Contents/Resources/minizinc" $__commandArgs
            }
            else {
                & "/Applications/MiniZincIDE.app/Contents/Resources/minizinc" $__commandArgs 2>&1| Push-CrescendoNativeError | & $__handler
            }
        }
        else {
            $result = & "/Applications/MiniZincIDE.app/Contents/Resources/minizinc" $__commandArgs 2>&1| Push-CrescendoNativeError
            & $__handler $result
        }
    }
    # be sure to let the user know if there are any errors
    Pop-CrescendoNativeError -EmitAsError
  } # end PROCESS

<#
.SYNOPSIS
minizinc: Unrecognized option or bad format `-?'
minizinc: MiniZinc driver.
Usage: minizinc  [<options>] [-I <include path>] <model>.mzn [<data>.dzn ...] or just <flat>.fzn
More info with "/Applications/MiniZincIDE.app/Contents/Resources/minizinc --help"

.DESCRIPTION See help for /Applications/MiniZincIDE.app/Contents/Resources/minizinc

.PARAMETER Solver



.PARAMETER Data



.PARAMETER ModelPath



.PARAMETER DataPath




#>
}


function convertMinizincOutput {
    param (
        $InputObject
    )
    $removedLastSolutionIndicator = $InputObject -replace "==========",""
    $joined = ($removedLastSolutionIndicator -join "`n").Trim()
    $processedOutput = $joined -split "----------" | Where-Object {! [string]::IsNullOrEmpty($_)}
    $ret = $processedOutput | ConvertFrom-Json -Depth 10
    return $ret
}
