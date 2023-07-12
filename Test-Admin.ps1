# This is a cmdlet binding block that defines some properties of the script.
# DefaultParameterSetName sets the default parameter set used when multiple sets are available.
# SupportsShouldProcess provides cmdlets the option to execute commands.
# PositionalBinding allows parameters to be provided in an arbitrary position.
# HelpUri provides the URL where the help file for this script is located.
# ConfirmImpact is the level of impact the cmdlet operation has on the system. Here, it's set to 'Medium'.

[CmdletBinding(DefaultParameterSetName = 'Default', 
    SupportsShouldProcess = $true, 
    PositionalBinding = $false,
    HelpUri = 'http://www.microsoft.com/',
    ConfirmImpact = 'Medium')]
[Alias()]
[OutputType([String])]
# This script takes one parameter, a boolean named TestCommand. It's default value is the result of the query if the current user is an administrator.
Param(
    [bool]
    $TestCommand = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
)
#####################################################################################
# If using Script Param during SelfElevation Run Please place them above this line  #
#####################################################################################
###################################
# SelfElevation Script Body Start #
###################################
Write-Verbose "Script/Command being Passthru as Administrator:  $($MyInvocation.Line)"

# Check if current user is an administrator.
If (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Verbose "Script is not run with administrative user"

    # Check if operating system is UAC enabled.
    If ((Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object BuildNumber).BuildNumber -ge 6000) {
        Write-Verbose "Found UAC-enabled system. Elevating ..."

        # Get the command that called this script.
        $CommandLine = $MyInvocation.Line.Replace($MyInvocation.InvocationName, $MyInvocation.MyCommand.Definition)
        Write-Verbose "Command Line PassThru:  $CommandLine"

        # Restart the script with administrative privileges.
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "$CommandLine"
        Write-Output "Opened New Session/Window:  Script is now running in elevated mode as Administrator"
    } 
    else {
        Write-Verbose "System does not support UAC"
        Write-Warning "This script requires administrative privileges. Elevation not possible. Please re-run with administrative account."
    }
    # Exit the script if not run with administrative privileges.
    Break
}
#################################
# SelfElevation Script Body End #
#################################
############################################################
# Run your code that needs to be elevated below this line  #
############################################################
$TestCommand
