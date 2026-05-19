# Import required module
Import-Module ActiveDirectory

# Import the CSV file
$users = Import-Csv -Path "C:\users.csv"

# Loop through each user
foreach ($user in $users) {

    $password = ConvertTo-SecureString "P@ssword" -AsPlainText -Force
    $samName = "$($user.GivenName).$($user.Surname)"

    try {
        New-ADUser -Name $samName `
                   -GivenName $user.GivenName `
                   -Surname $user.Surname `
                   -UserPrincipalName "$($samName)@calmendares.local" `
                   -SamAccountName $samName `
                   -Department $user.Department `
                   -Path $user.OU_Path `
                   -City $user.City `
                   -Company $user.Company `
                   -State $user.State `
                   -OfficePhone $user.Phone `
                   -AccountPassword $password `
                   -Enabled $true `
                   -PasswordNeverExpires $false `
                   -ChangePasswordAtLogon $true `
                   -ErrorAction Stop

        Add-ADGroupMember -Identity $user.Group_Name -Members $samName -ErrorAction Stop

        Write-Host "SUCCESS: $samName"
    }
    catch {
        Write-Host "FAILED: $samName --> $($_.Exception.Message)"
    }
}

Write-Host "`nAll users have been created successfully!"
