

function Get-StatusFromValue {

    Param($SV)

    switch($SV) {
        0 { " Disconnected" }
        1 { " Connecting" }
        2 { " Connected" }
        3 { " Disconnecting" }
        4 { " Hardware not present" }
        5 { " Hardware disabled" }
        6 { " Hardware malfunction" }
        7 { " Media disconnected" }
        8 { " Authenticating" }
        9 { " Authentication succeeded" }
        10 { " Authentication failed" }
        11 { " Invalid Address" }
        12 { " Credentials Required" }
        Default { " Not connected" }
    }

} #end Get-StatusFromValue function

Function Test-Chocolatey {
    [CmdletBinding()]
    param (
        [Parameter()]
        [String]$Version
    )

    Try {
        Test-Path $env:ChocolateyInstall
    } Catch {
        $ErrorMessage = $_.Exception.Message
        $FailedItem = $_.Exception.ItemName
        "Variable does not exist"
    }

    if (Test-Path $env:ChocolateyInstall -ErrorAction Ignore) {
        Write-Output "Chocolatey Installed"
    } else {
        Write-Output "Chocolatey Not Installed"
    }
    Write-Output "Desktop folder path: $path"

} # Test-Chocolatey

Function Get-WSShellDesktop {
    # \users\username\appdata\locallow\sun\java\deployment

    #[enum]::GetValues([environment+SpecialFolder])

    #New-Object System.Shell
    $wshell = New-Object -comObject WScript.Shell 
    #Assign a path to Desktop to the variable $path
    $path = [system.Environment]::GetFolderPath('Desktop')
    #$wshell | Get-Member

    $wshell.SpecialFolders | Format-Table
    $wshell.SpecialFolders | Get-Member

} # Get-SpecialFolder

Function Get-SpecialFolder {
    $myDesktop = [Environment]::GetFolderPath('Desktop')
    $myDocs = [environment]::GetFolderPath('mydocuments')
    $myPrograms = [environment]::GetFolderPath('Programs')
    $myRecent = [environment]::GetFolderPath('Recent')
    $mySendTo = [environment]::GetFolderPath('SendTo')
    $myStartMenu = [environment]::GetFolderPath('StartMenu')

    $commonDesktop = [environment]::GetFolderPath('CommonDesktopDirectory')
    $commonDocuments = [environment]::GetFolderPath('CommonDocuments')
    $commonPrograms = [environment]::GetFolderPath('CommonPrograms')
    $commonStartMenu = [environment]::GetFolderPath('CommonStartMenu')
    $commonStartUp = [environment]::GetFolderPath('CommonStartup')
    Get-Variable  
}

#Get-CimInstance -Class win32_networkadapter -computer $computer | Select-Object Name, @{LABEL="Status"; EXPRESSION={Get-StatusFromValue $_.NetConnectionStatus }}

#Get-NetAdapter -Physical

#Get-SpecialFolder
Get-WSShellDesktop


