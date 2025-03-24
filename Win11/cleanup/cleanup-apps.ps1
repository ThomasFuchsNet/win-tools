param(
    [String] $WhitelistPath = "$PSScriptRoot\..\res\winapps.whitelist"
)
function cleanup-appx {
    param(
        [String[]] $AppX
    )
    foreach($app in $appx){
        $result = get-appxpackage -AllUsers | ?{ -not ($_.Name -like $app.trim()) }
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
        $result =  Get-AppProvisionedPackage -online | ?{ -not ($_.DisplayName -like $app.trim())}
        foreach($package in $result){
            Remove-AppxProvisionedPackage -PackageName $package.PackageName -online
        }
    }
}

#### START #####


$AppWhitelist = get-content $WhitelistPath
cleanup-appx $AppWhitelist
cleanup-provis $AppWhitelist