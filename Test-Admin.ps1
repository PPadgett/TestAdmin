[CmdletBinding(DefaultParameterSetName = 'Default', 
    SupportsShouldProcess = $true, 
    PositionalBinding = $false,
    HelpUri = 'http://www.microsoft.com/',
    ConfirmImpact = 'Medium')]
[Alias()]
[OutputType([String])]
Param(
    [scriptblock]
    $TestCommand = {([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")}
)
#####################################################################################
# If using Script Param during SelfElevation Run Please place them above this line  #
#####################################################################################
###################################
# SelfElevation Script Body Start #
###################################
Write-Verbose "Script/Command being Passthru as Administrator:  $($MyInvocation.Line)"

If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Verbose "Script is not run with administrative user"

    If ((Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object BuildNumber).BuildNumber -ge 6000) {
        Write-Verbose "Found UAC-enabled system. Elevating ..."

        $CommandLine = $MyInvocation.Line.Replace($MyInvocation.InvocationName, $MyInvocation.MyCommand.Definition)
        Write-Verbose "Command Line PassThru:  $CommandLine"

        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "$CommandLine"
        Write-Output "Opened New Session/Window:  Script is now running in elevated mode as Administrator"
    } 
    else {
        Write-Verbose "System does not support UAC"
        Write-Warning "This script requires administrative privileges. Elevation not possible. Please re-run with administrative account."
    }
    Break
}
#################################
# SelfElevation Script Body End #
#################################
############################################################
# Run your code that needs to be elevated below this line  #
############################################################

([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")