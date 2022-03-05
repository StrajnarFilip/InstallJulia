$ProgressPreference = 'SilentlyContinue'
$JuliaVersion="1.7.2"
$JuliaDownloadUri="https://julialang-s3.julialang.org/bin/winnt/x64/1.7/julia-1.7.2-win64.zip"

$OriginalLocation=$(Get-Location)

function Add-Path {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $PathToAdd
    )

    [System.Environment]::SetEnvironmentVariable(
        "Path",
        "$([System.Environment]::GetEnvironmentVariable("Path",[System.EnvironmentVariableTarget]::User));${PathToAdd}",
        [System.EnvironmentVariableTarget]::User)
}

function Install-OnWindows {
    # Name the zip
    $JuliaZip = "julia-win64.zip"
    # Download from julialang.org
    Write-Host "Downloading .zip"
    Invoke-WebRequest -Uri $JuliaDownloadUri -OutFile $JuliaZip
    # Unzip
    Write-Host "Extracting .zip"
    Expand-Archive -Path $JuliaZip -DestinationPath "."
    # Cleanup
    Write-Host "Deleting .zip as it's no longer needed"
    Remove-Item $JuliaZip
    Set-Location ".\julia-${JuliaVersion}\bin"
    # Add to user's path (not system's)
    Write-Host "Adding to user's Path"
    Add-Path -PathToAdd $(Get-Location)
    Set-Location $OriginalLocation
}

if (($true -eq $IsLinux) -or ($true -eq $IsMacOS)) {
    Write-Host "Script is not supported on Linux and MacOS."
    exit
}
else {
    Write-Host "Installing Julia ${JuliaVersion}"
    Install-OnWindows
}