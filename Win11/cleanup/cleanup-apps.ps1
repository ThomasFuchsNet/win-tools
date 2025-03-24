param(
    [String] $ListPath = "$PSScriptRoot\..\res\winapps.whitelist",
    [Switch] $Blacklist = $false
)

### Blacklist Removeal Logic ###
function cleanup-appx {
    param(
        [String[]] $AppX
    )
    foreach($app in $appx){
        $result = get-appxpackage -AllUsers | ?{ $_.Name -like $app.trim() }
        foreach($package in $result){
            Remove-Appxpackage -Package $package.PackageFullName -AllUsers
        }
    }
}

function cleanup-provis{
    param(
        [String[]] $provis
    )
    foreach($app in $provis){
        $result =  Get-AppProvisionedPackage -online | ?{ $_.DisplayName -like $app.trim() }
        foreach($package in $result){
            Remove-AppxProvisionedPackage -PackageName $package.PackageName -online
        }
    }
}

#### START #####
$Applist = get-content $ListPath

if(-not $Blacklist)
{   
    $bApps = get-appxpackage -AllUsers | %{$_.Name}
    foreach ($app in $Applist){
        $bApps = $bApps | ?{$_ -notlike $app}
    }
    $pApps = get-AppxProvisionedPackage -online | %{$_.DisplayName}
    foreach($app in $pApps){
        $pApps = $pApps | ?{$_ -notlike $app}
    }
    cleanup-appx $bApps
    cleanup-provis $pApps
}  
else {
    cleanup-appx $Applist
    cleanup-provis $Applist
}