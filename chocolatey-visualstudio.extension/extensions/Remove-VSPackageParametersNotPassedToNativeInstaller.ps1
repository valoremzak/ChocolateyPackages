function Remove-VSPackageParametersNotPassedToNativeInstaller
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)] [hashtable] $PackageParameters,
        [Parameter(Mandatory = $true)] [string] $TargetDescription,
        [string[]] $Blacklist,
        [string[]] $Whitelist
    )

    Remove-VSNegatedPackageParameters -PackageParameters $PackageParameters -RemoveNegativeSwitches

    $hasWhitelist = ($Whitelist | Measure-Object).Count -gt 0
    $parametersToRemove = $PackageParameters.Keys | Where-Object { $Blacklist -contains $_ -or ($hasWhitelist -and $Whitelist -notcontains $_) }
    foreach ($parameterToRemove in $parametersToRemove)
    {
        if ($parameterToRemove -eq $null)
        {
            continue
        }

        Write-Debug "Filtering out package parameter not passed to the ${TargetDescription}: '$parameterToRemove'"
        $PackageParameters.Remove($parameterToRemove)
    }
}