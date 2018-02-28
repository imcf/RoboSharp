[CmdletBinding()]
Param(
    [Parameter(Mandatory=$True)][string] $SolutionDir,
    [Parameter(Mandatory=$True)][string] $ConfigurationName
)

$CsTemplate = @"
public static class BuildDetails
{{
    public const string GitCommitName = "{0}";
    public const string GitBranch = "{1}";
    public const string GitMajor = "{2}";
    public const string GitMinor = "{3}";
    public const string GitPatch = "{4}";
    public const string GitTagDist = "{5}";
    public const string BuildDate = "{6}";
    public const string GitCommit = "{7}";
}}
"@

function Write-BuildDetails {
    Param (
        [Parameter(Mandatory=$True)]
        [String]$Target,

        [Parameter(Mandatory=$True)]
        [Array]$Desc,

        [Parameter(Mandatory=$True)]
        [String]$Branch,

        [Parameter(Mandatory=$True)]
        [String]$Date
    )

    $CommitName = "$($Desc[0]).$($Desc[1]).$($Desc[2])-$($Desc[3])-$($Desc[4])"
    $Commit = $Desc[4].Substring(1)
    Write-Output "$($Target.Substring($Target.LastIndexOf('\')+1)) -> $($Target)"
    $Code = $CsTemplate -f `
        $CommitName, `
        $Branch, `
        $Desc[0], `
        $Desc[1], `
        $Desc[2], `
        $Desc[3], `
        $Date, `
        $Commit
    Write-Verbose "/// generated code ///`n$($Code)`n/// generated code ///`n"
    Out-File -FilePath $Target -Encoding ASCII -InputObject $Code
}

function Parse-GitDescribe([string]$CommitName) {
    Write-Verbose "Parsing 'git describe' result [$($CommitName)]..."
    try {
        $Items = $CommitName.Split('-').Split('.')
        if ($Items.Length -ne 5) {
            Write-Verbose "unexpected number of items found in [$($CommitName)]"
            throw
        }
    }
    catch {
        throw "Can't parse commit name [$($CommitName)]!"
    }
    Write-Verbose "Just some $($Items[2]) commits after the last tag."
    ForEach ($Item in $Items) {
        Write-Verbose " - $($Item)"
    }
    Return $Items
}


$ErrorActionPreference = "Stop"

$OldLocation = Get-Location
Set-Location $SolutionDir -ErrorAction Stop

try {
    $CommitName = & git describe --tags --long --match "[0-9].[0-9].[0-9]"
    if (-Not $?) { throw }
    $GitStatus = & git status --porcelain
    if (-Not $?) { throw }
    $GitBranch = & git symbolic-ref --short HEAD
    if (-Not $?) { throw }

    $DescItems = Parse-GitDescribe $CommitName

    if ($GitStatus.Length -gt 0) {
        $StatusWarning = "  <--  WARNING, repository has uncommitted changes!"
        $CommitName += "-unclean"
    }
}
catch {
    $ex = $_.Exception.Message
    $CommitName = "commit unknown"
    $GitBranch = "branch unknown"
    Write-Output "$(">"*8) Running git failed, using default values! $("<"*8)"
    Write-Output $ex
}


$Date = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

# the dotted short format can be used in the AssemblyInformationalVersion
# property, as this will magically be parsed and reported as "Version" when
# examining the executable using "Get-Command AutoTx.exe | Format-List *"
$DateShort = Get-Date -Format 'yyyy.MM.dd.HHmm'


$BuildDetailsCS = "$($SolutionDir)\RoboSharp\BuildDetails.cs"


Write-Output $(
    "build-config: [$($ConfigurationName)]"
    "build-date:   [$($Date)]"
    "git-branch:   [$($GitBranch)]"
    "git-describe: [$($CommitName)]$($StatusWarning)"
)

Write-BuildDetails $BuildDetailsCS $DescItems $GitBranch $DateShort

Set-Location $OldLocation