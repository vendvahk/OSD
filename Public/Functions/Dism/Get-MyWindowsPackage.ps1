function Get-MyWindowsPackage {
    [CmdletBinding(DefaultParameterSetName = 'Online')]
    param (
        [Parameter(Mandatory = $true, ParameterSetName = "Offline", ValueFromPipeline = $false, ValueFromPipelineByPropertyName = $true)]
        [string]$Path,

        [ValidateSet('Installed','Superseded')]
        [string]$PackageState,

        [ValidateSet('FeaturePack','Foundation','LanguagePack','OnDemandPack','SecurityUpdate','Update')]
        [string]$ReleaseType,

        [ValidateSet('FOD','Language','LanguagePack','Update','Other')]
        [string]$Category,

        [string[]]$Culture,

        [string[]]$Like,
        [string[]]$Match,

        [System.Management.Automation.SwitchParameter]$Detail
    )
    #=================================================
    #   Require Admin Rights
    #=================================================
    if ((Get-OSDGather -Property IsAdmin) -eq $false) {
        Write-Warning "$($MyInvocation.MyCommand) requires Admin Rights ELEVATED"
        Break
    }
    #=================================================
    #   Test Get-WindowsPackage
    #=================================================
    if (Get-Command -Name Get-WindowsPackage -ErrorAction SilentlyContinue) {
        Write-Verbose 'Verified command Get-WindowsPackage'
    } else {
        Write-Warning 'Get-MyWindowsPackage requires Get-WindowsPackage which is not present'
        Break
    }
    #=================================================
    #   Get Module Path
    #=================================================
    $GetModuleBase = Get-Module -Name OSD | Select-Object -ExpandProperty ModuleBase -First 1
    #=================================================
    #   Get-WindowsPackage
    #=================================================
    if ($PSCmdlet.ParameterSetName -eq 'Online') {
        $GetAllItems = Get-WindowsPackage -Online
    }
    if ($PSCmdlet.ParameterSetName -eq 'Offline') {
        $GetAllItems = Get-WindowsPackage -Path $Path
    }
    #=================================================
    #   Like
    #=================================================
    foreach ($Item in $Like) {
        $GetAllItems = $GetAllItems | Where-Object {$_.PackageName -like "$Item"}
    }
    #=================================================
    #   Match
    #=================================================
    foreach ($Item in $Match) {
        $GetAllItems = $GetAllItems | Where-Object {$_.PackageName -match "$Item"}
    }
    #=================================================
    #   PackageState
    #=================================================
    if ($PackageState) {$GetAllItems = $GetAllItems | Where-Object {$_.PackageState -eq $PackageState}}
    #=================================================
    #   ReleaseType
    #=================================================
    if ($ReleaseType) {$GetAllItems = $GetAllItems | Where-Object {$_.ReleaseType -eq $ReleaseType}}
    #=================================================
    #   Category
    #=================================================
    #Get-MyWindowsPackage -Category FOD
    if ($Category -eq 'FOD') {
        $GetAllItems = $GetAllItems | Where-Object {$_.PackageName -match 'FOD'}
    }
    #Get-MyWindowsPackage -Category Language
    if ($Category -eq 'Language') {
        $GetAllItems = $GetAllItems | Where-Object {$_.ReleaseType -ne 'LanguagePack'}
        $GetAllItems = $GetAllItems | Where-Object {($_.PackageName -split ',*~')[3] -ne ''}
    }
    #Get-MyWindowsPackage -Category LanguagePack
    if ($Category -eq 'LanguagePack') {
        $GetAllItems = $GetAllItems | Where-Object {$_.ReleaseType -eq 'LanguagePack'}
    }
    #Get-MyWindowsPackage -Category Update
    if ($Category -eq 'Update') {
        $GetAllItems = $GetAllItems | Where-Object {$_.ReleaseType -match 'Update'}
    }
    #Get-MyWindowsPackage -Category Other
    if ($Category -eq 'Other') {
        $GetAllItems = $GetAllItems | Where-Object {$_.PackageName -notmatch 'FOD'}
        $GetAllItems = $GetAllItems | Where-Object {($_.PackageName -split ',*~')[3] -eq ''}
        $GetAllItems = $GetAllItems | Where-Object {$_.ReleaseType -ne 'LanguagePack'}
        $GetAllItems = $GetAllItems | Where-Object {$_.ReleaseType -notmatch 'Update'}
    }
    #=================================================
    #   Culture
    #=================================================
    $FilteredItems = @()
    if ($Culture) {
        foreach ($Item in $Culture) {
            $FilteredItems += $GetAllItems | Where-Object {$_.PackageName -match "$Item"}
        }
    } else {
        $FilteredItems = $GetAllItems
    }
    #=================================================
    #   Dictionary
    #=================================================
    if (Test-Path "$GetModuleBase\Resources\Dictionary\Get-MyWindowsPackage.json") {
        $GetAllItemsDictionary = Get-Content "$GetModuleBase\Resources\Dictionary\Get-MyWindowsPackage.json" | ConvertFrom-Json
    }
    #=================================================
    #   Create Object
    #=================================================
    if ($Detail -eq $true) {
        $Results = foreach ($Item in $FilteredItems) {
            $ItemProductName    = ($Item.PackageName -split ',*~')[0]
            $ItemArchitecture   = ($Item.PackageName -split ',*~')[2]
            $ItemCulture        = ($Item.PackageName -split ',*~')[3]
            $ItemVersion        = ($Item.PackageName -split ',*~')[4]

            $ItemDetails = $null
            $ItemDetails = $GetAllItemsDictionary | `
                Where-Object {($_.ProductName -notmatch 'Package_for_DotNetRollup')} | `
                Where-Object {($_.ProductName -notmatch 'Package_for_RollupFix')} | `
                Where-Object {($_.ProductName -eq $ItemProductName)} | `
                Where-Object {($_.Culture -eq $ItemCulture)} | `
                Select-Object -First 1

            if ($null -eq $ItemDetails) {
                Write-Verbose "$($Item.PackageName) ... gathering details" -Verbose
                if ($PSCmdlet.ParameterSetName -eq 'Online') {
                    $ItemDetails = Get-WindowsPackage -PackageName $Item.PackageName -Online
                }
                if ($PSCmdlet.ParameterSetName -eq 'Offline') {
                    $ItemDetails = Get-WindowsPackage -PackageName $Item.PackageName -Path $Path
                }
            }

            $DisplayName = $ItemDetails.DisplayName
            if ($DisplayName -eq '') {$DisplayName = $ItemProductName}
            if ($ItemProductName -match 'Package_for_DotNetRollup') {$DisplayName = 'DotNet_Cumulative_Update'}
            if ($ItemProductName -match 'Package_for_RollupFix') {$DisplayName = 'Latest_Cumulative_Update'}
            if ($ItemProductName -match 'Package_for_KB') {$DisplayName = ("$ItemProductName" -replace "Package_for_")}

            if ($PSCmdlet.ParameterSetName -eq 'Online') {
                [PSCustomObject] @{
                    DisplayName     = $DisplayName
                    Architecture    = $ItemArchitecture
                    Culture         = $ItemCulture
                    Version         = $ItemVersion
                    ReleaseType     = $Item.ReleaseType
                    PackageState    = $Item.PackageState
                    InstallTime     = $Item.InstallTime
                    CapabilityId    = $ItemDetails.CapabilityId
                    Description     = $ItemDetails.Description
                    PackageName     = $Item.PackageName
                    Online          = $Item.Online
                    ProductName     = $ItemProductName
                }
            }
            if ($PSCmdlet.ParameterSetName -eq 'Offline') {
                [PSCustomObject] @{
                    DisplayName     = $DisplayName
                    Architecture    = $ItemArchitecture
                    Culture         = $ItemCulture
                    Version         = $ItemVersion
                    ReleaseType     = $Item.ReleaseType
                    PackageState    = $Item.PackageState
                    InstallTime     = $Item.InstallTime
                    CapabilityId    = $ItemDetails.CapabilityId
                    Description     = $ItemDetails.Description
                    PackageName     = $Item.PackageName
                    Path            = $Item.Path
                    ProductName     = $ItemProductName
                }
            }
        }
    } else {
        #Build Object
        $Results = foreach ($Item in $FilteredItems) {
            $ItemProductName    = ($Item.PackageName -split ',*~')[0]
            $ItemArchitecture   = ($Item.PackageName -split ',*~')[2]
            $ItemCulture        = ($Item.PackageName -split ',*~')[3]
            $ItemVersion        = ($Item.PackageName -split ',*~')[4]

            if ($PSCmdlet.ParameterSetName -eq 'Online') {
                [PSCustomObject] @{
                    ProductName     = $ItemProductName
                    Architecture    = $ItemArchitecture
                    Culture         = $ItemCulture
                    Version         = $ItemVersion
                    ReleaseType     = $Item.ReleaseType
                    PackageState    = $Item.PackageState
                    InstallTime     = $Item.InstallTime
                    PackageName     = $Item.PackageName
                    Online          = $Item.Online
                }
            }
            if ($PSCmdlet.ParameterSetName -eq 'Offline') {
                [PSCustomObject] @{
                    ProductName     = $ItemProductName
                    Architecture    = $ItemArchitecture
                    Culture         = $ItemCulture
                    Version         = $ItemVersion
                    ReleaseType     = $Item.ReleaseType
                    PackageState    = $Item.PackageState
                    InstallTime     = $Item.InstallTime
                    PackageName     = $Item.PackageName
                    Path            = $Item.Path
                }
            }
        }
    }
    #=================================================
    #   Rebuild Dictionary
    #=================================================
    $Results | `
    Sort-Object ProductName, Culture | `
    Where-Object {$_.Architecture -notmatch 'wow64'} | `
    Where-Object {$_.ProductName -notmatch 'Package_for_DotNetRollup'} | `
    Where-Object {$_.ProductName -notmatch 'Package_for_RollupFix'} | `
    Where-Object {$_.PackageState -ne 'Superseded'} | `
    Select-Object PackageName, ProductName, Architecture, Culture, DisplayName, CapabilityId, Description | `
    ConvertTo-Json | `
    Out-File "$env:TEMP\Get-MyWindowsPackage.json" -Width 2000 -Force
    #=================================================
    #   Return
    #=================================================
    Return $Results
    #=================================================
}
