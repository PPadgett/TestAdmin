# Test Admin and/or Elevate to Admin

This PowerShell script is designed to check whether the current user is an administrator. If not, it attempts to elevate the script to run as an administrator. Here's a breakdown of the script:

1. **Cmdlet Binding Parameters:** 
    * `DefaultParameterSetName` is set to 'Default', meaning if no parameters are explicitly specified when the script is run, 'Default' parameters will be used.
    * `SupportsShouldProcess` is set to `$true`, enabling the cmdlet to support the common 'WhatIf' and 'Confirm' parameters.
    * `PositionalBinding` is set to `$false`, which means the parameters are not bound by their position in the command but by their names.
    * `HelpUri` provides a URL where users can find more information about the script.
    * `ConfirmImpact` is set to 'Medium', it sets the level of impact that operations have on the system.

2. **Parameters:**
    * `$TestCommand`: A boolean parameter that checks if the current user has administrator privileges.

3. **Self-Elevation Script Body:** 
    * The script first prints the current command being run as an administrator.
    * Checks if the user is an administrator. If not, it prints a message stating that the script is not running with administrative rights.
    * If the Windows operating system build number is greater or equal to 6000 (which indicates the presence of User Account Control or UAC), it proceeds to run the script as an administrator. It does this by starting a new PowerShell process using the `Start-Process` cmdlet with the `-Verb Runas` parameter, which runs the process with administrator privileges.
    * If the system doesn't support UAC, a warning message is displayed, asking the user to rerun the script with administrative privileges.
    * The `Break` statement is used to terminate the script if it isn't run as an administrator.

4. **Running Code Needing Elevation:** 
    * The `$TestCommand` is then run, which in this case simply returns whether the current user is an administrator. 

This script is useful when you want to ensure that a PowerShell script is only run by an administrator or elevated user.
