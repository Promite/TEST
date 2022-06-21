#builds resources
#

#random string for directories
function random_text {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
    }

#variable
$wd = random_text
$path = "$env:temp/$wd"
echo $path

# go to temp, make working directory
mkdir $path
cd $path
echo "" > poc.txt
