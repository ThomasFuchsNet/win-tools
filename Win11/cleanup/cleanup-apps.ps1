param(
    [String] $WhitelistPath = $PSScriptRoot\..\res\winapps.whitelist
)


$AppWhitelist = get-content $WhitelistPath
cleanup-appx $AppWhitelist
cleanup-provis $AppWhitelist
cleanup-appx {
    param(
        [String[]] $AppX
    )
    foreach($app in $appx){
        $result = get-appxpackage -AllUsers | ?{ $_.Name -like $app.trim() }
        foreach($package in $result){
            Remove-Appxpackage -Package $package.PackageFullName -AllUsers -Force
        }
    }
}

cleanup-provis{
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