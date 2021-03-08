# Module Manifest
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'OSD.psm1'

# Version number of his module.
ModuleVersion = '21.3.8.1'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = '9fe5b9b6-0224-4d87-9018-a8978529f6f5'

# Author of this module
Author = 'David Segura @SeguraOSD'

# Company or vendor of this module
CompanyName = 'osdeploy.com'

# Copyright statement for this module
Copyright = '(c) 2021 David Segura osdeploy.com. All rights reserved.'

# Description of the functionality provided by this module
Description = @'
OSD PowerShell Module is a collection of OSD shared functions that can be used WinPE and Windows 10
'@

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = 'Windows PowerShell ISE Host'

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = #'Get-MyAdk','New-MyAdkCopyPE',#ADK
                    'Remove-AppxOnline',#Appx
                    'Get-CimVideoControllerResolution',#Cim
                    'Save-ClipboardImage','Set-ClipboardScreenshot',#Clipboard
                    'Get-ComObjects','Get-ComObjMicrosoftUpdateAutoUpdate','Get-ComObjMicrosoftUpdateInstaller','Get-ComObjMicrosoftUpdateServiceManager',#ComObj
                    'Backup-DiskToFFU',#Backup
                    'Clear-LocalDisk','Get-LocalDisk','Get-LocalPartition',
                    'Clear-USBDisk','Get-USBDisk',
                    'Get-OSDDisk',
                    'Get-OSDDrive',
                    'Get-OSDPartition','Get-USBPartition',
                    'Get-OSDVolume','Get-USBVolume',
                    'New-OSDisk',
                    'Get-DisplayAllScreens','Get-DisplayPrimaryBitmapSize','Get-DisplayPrimaryMonitorSize','Get-DisplayPrimaryScaling','Get-DisplayVirtualScreen','Set-DisRes',#Display
                    'Get-DellCatalogPC','Get-MyDellBios','Update-MyDellBios','Get-MyDellDriverCab','Save-MyDellDriverCab',
                    'Get-OSDDriver','Get-OSDDriverWmiQ',#Driver
                    "Set-WimExecutionPolicy","Set-WindowsImageExecutionPolicy",#ExecutionPolicy
                    'Get-MyBiosSerialNumber','Get-MyBiosVersion','Get-MyComputerManufacturer','Get-MyComputerModel','Get-MyDefaultAUService',#GetMy
                    'Backup-MyBitLockerKeys','Get-MyBitLockerKeyProtectors','Save-MyBitLockerExternalKey','Save-MyBitLockerKeyPackage','Save-MyBitLockerRecoveryPassword','Unlock-MyBitLockerExternalKey',#MyBitlocker
                    'Get-MyWindowsCapability','Get-MyWindowsPackage',#MyWindows
                    'Dismount-MyWindowsImage','Edit-MyWindowsImage','Mount-MyWindowsImage','Update-MyWindowsImage',#MyWindowsImage
                    'Get-OSD','Get-OSDClass','Get-OSDGather','Get-OSDPower','Get-RegCurrentVersion','Get-SessionsXml','Save-OSDDownload',#OSD
                    'Copy-PSModuleToFolder','Copy-PSModuleToWim','Copy-PSModuleToWindowsImage',#PSModule
                    'Get-ScreenPNG', #ScreenPNG
                    'Get-OSDWinPE','Use-WinPEContent', #WinPE
                    'Invoke-UrlExpression','Enable-PEWimPSGallery'

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @(
                    'Dismount-WindowsImageOSD',
                    'Edit-WindowsImageOSD',
                    'Get-OSDSessions',
                    'Mount-OSDWindowsImage',
                    'Mount-WindowsImageOSD',
                    'Update-OSDWindowsImage',
                    'Update-WindowsImageOSD'
                    )

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{
    PSData = @{
        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('OSD','OSDeploy','OSDBuilder')

        # A URL to the license for this module.
        LicenseUri = 'https://github.com/OSDeploy/OSD/blob/master/LICENSE'

        # A URL to the main website for this project.
        ProjectUri = 'https://github.com/OSDeploy/OSD'

        # A URL to an icon representing this module.
        IconUri = 'https://raw.githubusercontent.com/OSDeploy/OSD/master/OSD.png'

        # ReleaseNotes of this module
        ReleaseNotes = 'https://osd.osdeploy.com/release'
    } # End of PSData hashtable
} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''
}