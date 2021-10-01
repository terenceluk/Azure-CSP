# Connect to Azure tenant
Connect-AzAccount

#List Subscriptions

$SubscriptionList = Get-AzSubscription

Write-Host "There are $($SubscriptionList.count) subscriptions in this tenant"
# Starting at 1 rather than 0 so number will be shifted
$index = 1
foreach ( $SubscriptionObject in $SubscriptionList)
    {
        Write-Host " [$($index)] Name: $($SubscriptionObject.name) | ID: $($SubscriptionObject.Id) | State: $($SubscriptionObject.state)"
        $index++
    }


# Ask to select subscription with number and check to see if the selection is within range of subscriptions
Do 
    { 
        "`n"
        [Int]$SubscriptionSelection = Read-Host "Please enter the number for the subscription that currently has a role assigned to the Foreign Principal"
        # Check if invalid value is entered
        if ($SubscriptionSelection -gt $SubscriptionList.count -or $SubscriptionSelection -lt 1){
            Write-Host "Please enter a valid selection:"
            $index = 1
            foreach ( $SubscriptionObject in $SubscriptionList)
                {
                    Write-Host " [$($index)] Name: $($SubscriptionObject.name) | ID: $($SubscriptionObject.Id) | State: $($SubscriptionObject.state)"
                    $index++
                }
        }
    }
    Until ($SubscriptionSelection -le $SubscriptionList.count -and $SubscriptionSelection -ge 1)


# Reduce the index number by 1 to shift the 1 back to 0, 2 to 1, and so on in the array
$SubscriptionSelection--
$SubscriptionObject = $SubscriptionList[$SubscriptionSelection]
"`n"
Write-Host "Subscription ""Name: $($SubscriptionObject.name) | ID: $($SubscriptionObject.Id) | State: $($SubscriptionObject.state)" -NoNewline; Write-Host " selected." -ForegroundColor Green

$subscriptionID = "/subscriptions/" + $SubscriptionObject.Id

# List the current Foreign Principals assigned a role on the subscription

##Get-AzRoleAssignment -Scope $subscriptionID | Where-Object {$_.DisplayName -match "Foreign Principal*"} | Select DisplayName, RoleDefinitionName

$ForeignPrincipalList = Get-AzRoleAssignment -Scope $subscriptionID | Where-Object {$_.DisplayName -match "Foreign Principal*"} 

Write-Host "There are $($ForeignPrincipalList.count) Foreign Principals with roles on this subscription"
# Starting at 1 rather than 0 so number will be shifted
$index = 1
foreach ( $ForeignPrincipalObject in $ForeignPrincipalList)
    {
        Write-Host " [$($index)] Name: $($ForeignPrincipalObject.DisplayName) | Role: $($ForeignPrincipalObject.RoleDefinitionName)"
        $index++
    }

# Ask to select Foreign Principal with number and check to see if the selection is within range of Foreign Principals
Do 
    { 
        "`n"
        [Int]$ForeignPrincipalSelection = Read-Host "Please enter the number for the Foreign Principal that you would like to assign to another subscription"
        # Check if invalid value is entered
        if ($ForeignPrincipalSelection -gt $ForeignPrincipalList.count -or $ForeignPrincipalSelection -lt 1){
            Write-Host "Please enter a valid selection:"
            $index = 1
            foreach ( $ForeignPrincipalObject in $ForeignPrincipalList)
                {
                    Write-Host " [$($index)] Name: $($ForeignPrincipalObject.DisplayName) | Role: $($ForeignPrincipalObject.RoleDefinitionName)"
                    $index++
                }
        }
    }
    Until ($ForeignPrincipalSelection -le $ForeignPrincipalList.count -and $ForeignPrincipalSelection -ge 1)


# Reduce the index number by 1 to shift the 1 back to 0, 2 to 1, and so on in the array
$ForeignPrincipalSelection--
$ForeignPrincipalObject = $ForeignPrincipalList[$ForeignPrincipalSelection]
"`n"
Write-Host "Subscription ""Name: $($ForeignPrincipalObject.DisplayName) | Role: $($ForeignPrincipalObject.RoleDefinitionName)" -NoNewline; Write-Host " selected." -ForegroundColor Green

$foreignPrincpalObjectID = $ForeignPrincipalObject.ObjectID

# List out the subscriptions again for selecting which one to grant Foreign Principal permissions

$SubscriptionList = Get-AzSubscription

Write-Host "There are $($SubscriptionList.count) subscriptions in this tenant"
# Starting at 1 rather than 0 so number will be shifted
$index = 1
foreach ( $SubscriptionObject in $SubscriptionList)
    {
        Write-Host " [$($index)] Name: $($SubscriptionObject.name) | ID: $($SubscriptionObject.Id) | State: $($SubscriptionObject.state)"
        $index++
    }


# Ask to select subscription with number and check to see if the selection is within range of subscriptions
Do 
    { 
        "`n"
        [Int]$SubscriptionSelection = Read-Host "Please enter the number for the subscription that you want assign a Foreign Principal role to"
        # Check if invalid value is entered
        if ($SubscriptionSelection -gt $SubscriptionList.count -or $SubscriptionSelection -lt 1){
            Write-Host "Please enter a valid selection:"
            $index = 1
            foreach ( $SubscriptionObject in $SubscriptionList)
                {
                    Write-Host " [$($index)] Name: $($SubscriptionObject.name) | ID: $($SubscriptionObject.Id) | State: $($SubscriptionObject.state)"
                    $index++
                }
        }
    }
    Until ($SubscriptionSelection -le $SubscriptionList.count -and $SubscriptionSelection -ge 1)


# Reduce the index number by 1 to shift the 1 back to 0, 2 to 1, and so on in the array
$SubscriptionSelection--
$SubscriptionObject = $SubscriptionList[$SubscriptionSelection]
"`n"
Write-Host "Subscription ""Name: $($SubscriptionObject.name) | ID: $($SubscriptionObject.Id) | State: $($SubscriptionObject.state)" -NoNewline; Write-Host " selected." -ForegroundColor Green

$subscriptionID = "/subscriptions/" + $SubscriptionObject.Id

# Ask what type of role this Foreign Principal is supposed to be assigned - Owner or Reader and verify that either 1 or 2 is entered

"`n"
        Write-Host "Please select the role you want to assign the Foreign Principal on this subscription:"

Do 
    { 
        Write-Host "[1] Owner"
        Write-Host "[2] Reader"
        $roleToAssign  = Read-Host
        
        # Check if invalid value is entered
        if ($RoleToAssign -ne 1 -or $RoleToAssign -ne 2){
            Write-Host "Please enter a valid selection:"
        }
    }
    Until ($RoleToAssign -eq 1 -or $RoleToAssign -eq 2)

    if($RoleToAssign -eq 1) {
        Write-Host "Owner" -NoNewline; Write-Host " selected." -ForegroundColor Green
        $AssigningRole = "Owner"
     }else {
        Write-Host "Reader" -NoNewline; Write-Host " selected." -ForegroundColor Green
        $AssigningRole = "Reader"
     }

if ($AssigningRole -eq "Reader") {
    Do 
    { 
    $Proceed = Read-Host "Would you also like to assign the Support Request Contributor as well? Y/N"
    # Check if invalid value is entered
        if ($Proceed -eq "Y"){

            $SupportRequestContributor = $true
            Write-Host "Support Request Contributor" -NoNewline; Write-Host " selected." -ForegroundColor Green
        }elseif ($Proceed -eq "N"){
            Write-Host "Support Request Contributor will not be assigned."
        }else {
            Write-Host "Please enter a valid selection of Y or N."
        }
    }
    Until ($Proceed -eq "Y" -or $Proceed -eq "N")
}

if ($SupportRequestContributor = $true) {
    Write-Host "You are about to assign the role" $AssigningRole "and Support Request Contributor to the subscription" $subscriptionID 
} else {
    Write-Host "You are about to assign the role" $AssigningRole "to the subscription" $subscriptionID 
}

Do 
    { 
    $Proceed = Read-Host "Please confirm to proceed: Y/N"
    # Check if invalid value is entered
        if ($Proceed -eq "Y"){

            # I’ve had mixed results with the -ObjectType parameter. Some tenants appear to require it and some do not. If an error is thrown indicating the ObjectType is unknown, remove the -ObjectType "ForeignGroup"

            New-AzRoleAssignment -ObjectId $foreignPrincpalObjectID -Scope $subscriptionID -RoleDefinitionName $AssigningRole -ObjectType "ForeignGroup"
            
            # Assign Support Request Contributor if user selected Yes for it

            if ($SupportRequestContributor = $true) {
                New-AzRoleAssignment -ObjectId $foreignPrincpalObjectID -Scope $subscriptionID -RoleDefinitionName "Support Request Contributor" -ObjectType "ForeignGroup"
            }
            
            Write-Host "Successfully Assigned" $AssigningRole "to" $subscriptionID "."
            
            if ($SupportRequestContributor = $true) {
                Write-Host "Successfully Assigned Support Request Contributor to" $subscriptionID "."
            }


        }elseif ($Proceed -eq "N"){
            Write-Host "Terminating script. Goodbye."
        }else {
            Write-Host "Please enter a valid selection of Y or N."
        }
    }
    Until ($Proceed -eq "Y" -or $Proceed -eq "N")
