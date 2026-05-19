# =============================================
# Carlos Almendares
# Microsoft server capstone
# 05/13/26
# =============================================

"Report generated on: $(Get-Date)" | Out-File $ReportPath -Append

# Import Active Directory Module
Import-Module ActiveDirectory

# =============================================
# Section 1: Define Report Path and Initialize Output
# =============================================

$ReportPath = Join-Path -Path $PSScriptRoot -ChildPath "DomainReport.txt"

# Clear out any previous report
if (Test-Path $ReportPath) { Remove-Item $ReportPath }

# =============================================
# Section 2: User Report Section 
# =============================================

"==================" | Out-File $ReportPath 
"User Report" | Out-File $ReportPath -Append
"==================" | Out-File $ReportPath -Append

Get-ADUser -Filter * -Property DistinguishedName, HomeDirectory, Company |
Select-Object Name, DistinguishedName, HomeDirectory, Company |
Format-Table -AutoSize | Out-File $ReportPath -Append

# =============================================
# Section 3: Get all OUs
# =============================================

"`n==================" | Out-File $ReportPath -Append
"OU Report" | Out-File $ReportPath -Append
"==================" | Out-File $ReportPath -Append

Get-ADOrganizationalUnit -Filter * |
Select-Object Name, DistinguishedName |
Sort-Object Name |
Format-Table -AutoSize | Out-File $ReportPath -Append

# =============================================
# Section 4: Departmental Groups and their Members
# =============================================

"`n==================" | Out-File $ReportPath -Append
"Security Group Membership Report" | Out-File $ReportPath -Append
"==================" | Out-File $ReportPath -Append

# Retrieve all departmental groups

$DepartmentalGroups = @(
    "Accounting_Group", "Developers_Group", "Executive_Group", 
    "HR_Group", "InfoTech_Group", "Manufacturing_Group", 
    "Marketing_Group", "Networking_Group", "Sales_Group", "SysAdmin_Group"
)

foreach ($GroupName in $DepartmentalGroups) {
    $Group = Get-ADGroup -Identity $GroupName -ErrorAction SilentlyContinue
    if ($Group) {
        "$GroupName" | Out-File $ReportPath -Append
        
        $Members = Get-ADGroupMember -Identity $GroupName -ErrorAction SilentlyContinue | 
                   Select-Object -ExpandProperty Name
        
        if ($Members) {
            $Members | ForEach-Object { "  - $_" | Out-File $ReportPath -Append }
        } else {
            "  (No members)" | Out-File $ReportPath -Append
        }
        "" | Out-File $ReportPath -Append
    }
}

# =============================================
# Section 5: Home Directory Report
# =============================================

"`n==================" | Out-File $ReportPath -Append
"Home Directory Report" | Out-File $ReportPath -Append
"==================" | Out-File $ReportPath -Append

Get-ADUser -Filter * -Property Name, HomeDirectory, Department, Tittle |
Where-Object { $_.HomeDirectory -ne $null -and $_.HomeDirectory -ne "" } |
Select-Object Name, Department, Title, HomeDirectory |
Sort-Object Name |
Format-Table -AutoSize | Out-File $ReportPath -Append

# =============================================
# Section 6: Departmental Folder Permissions
# =============================================

"`n==================" | Out-File $ReportPath -Append
"Departmental Folder Permissions" | out-File $ReportPath -Append
"==================" | Out-File $ReportPath -Append

# Define the path where your department folders are located
$DepartmentFoldersPath = "\\CA-FS1\C$\DFSRoots\Corporate"

# Verify the directory exists before checking permissions
if (Test-Path $DepartmentFoldersPath) {
    Get-ChildItem $DepartmentFoldersPath -Directory | ForEach-Object {
        $folder = $_.FullName
        "`nFolder: $folder" | Out-File $ReportPath -Append
        Get-Acl $folder | Select-Object -ExpandProperty Access |
        Select-Object IdentityReference, FileSystemRights, AccessControlType |
        Format-Table -AutoSize | Out-File $ReportPath -Append
    }
} else {
    "`nDepartmental folder path not found: $DepartmentFoldersPath" | Out-File $ReportPath -Append
}

# =============================================
# Section 7: Computer Report
# =============================================

"`n==================" | Out-File $ReportPath -Append
"Computer Report" | Out-File $ReportPath -Append
"==================" | Out-File $ReportPath -Append

# Retrieve all computer objects in the domain
Get-ADComputer -Filter * -Property Name, OperatingSystem, LastLogonDate |
Select-Object Name, OperatingSystem, @{Name="LastLogonDate";Expression={($_.LastLogonDate).ToString("MM/dd/yyyy")}} |
Sort-Object Name |
Format-Table -AutoSize | Out-File $ReportPath -Append

# =============================================
# Section 8: Server/ System Report
# =============================================

"`n==================" | Out-File $ReportPath -Append
"Server/System Report" | Out-File $ReportPath -Append
"==================" | Out-File $ReportPath -Append

# Get all servers
$Servers = Get-ADComputer -Filter "OperatingSystem -like '*server*'" -Property Name,OperatingSystem,IPv4Address

foreach ($Server in $Servers) {
    $ServerName = $Server.Name
    $IP = $Server.IPv4Address
    $OS = $Server.OperatingSystem

    "`nServer: $ServerName" | Out-File $ReportPath -Append
    "Operating System: $OS" | Out-File $ReportPath -Append
    "IP Address: $IP" | Out-File $ReportPath -Append

    # Get system info for all servers

    try {
        $RAM = (Get-CimInstance -ClassName Win32_ComputerSystem -ComputerName $ServerName -ErrorAction Stop).TotalPhysicalMemory / 1GB
        $Roles = (Get-WindowsFeature -ComputerName $ServerName | Where-Object {$_.Installed -eq $true}).Name
        "Installed Roles:" | Out-File $ReportPath -Append
        $Roles | ForEach-Object { "  $_" | Out-File $ReportPath -Append }
        "System RAM: $([math]::Round($RAM,2)) GB" | Out-File $ReportPath -Append
    } Catch {
        "Could not retrieve system info for $ServerName" | Out-File $ReportPath -Append
    }

    "`n---------------------" | Out-File $ReportPath -Append
}