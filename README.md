# Azure-CSP
Scripts for Azure CSP related activities

Scripts related to ASR

AssignSubscriptionRoleToForeignIdentity.ps1 - Script that performs the following:
1. Use the Connect-AzAccount to connect to Azure
2. Retrieve the list of subscriptions and prompt the user to select one that already has the Foreign Principal assigned with a role
3. Retrieve the list of Foreign Principals assigned to the subscription and prompt the user to select the one that will be used to assign a role for another subscription
4. Retrieve the list of subscriptions again and prompt the user to select one that we are to assign the Foreign Principal assigned with a role
5. Prompt the user to choose whether to assign the Foreign Principal the Owner or Reader role
6. If Reader role is selected, prompt user if they want to also add the Support Request Contributor as well (tickets cannot be opened if the CSP Foreign Principal has Reader role but not Support Request Contributor role)
7. Prompt the user to confirm the assignment with Y or N
8. Output the result
