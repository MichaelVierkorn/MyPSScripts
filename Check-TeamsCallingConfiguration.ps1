function Check-TeamsDirectRoutingConfig 
{
param (
$UPN
#,
#[Switch]$All=$False
)
$Datas = @()


#get userdata
$ADUser = Get-ADUser -filter 'Userprincipalname -eq $UPN' -Properties *
$TeamsUser = get-CSOnlineUser $UPN
$Groups = $ADUser.Memberof

#check groups
if($Groups){
$TeamsGroups = $Groups | ?{$_ -like "CN=GG_Teams_Calling*"}
foreach($TeamsGroup in $TeamsGroups){
$Pos = $TeamsGroup.IndexOf(",")
$AssignedGroups = $AssignedGroups + $TeamsGroup.Substring(20,$Pos-19)
}

}
else{
$AssignedGroups = "No Group Assigned"

}



#Create Properties and fill with userdata

$Properties=@{
            UserPrincipalName =$ADUser.Userprincipalname
            Mail=$ADUser.Mail
            SamAccountname = $ADUser.SamAccountname
		    ea3=$ADUser.extensionAttribute3
		    ea4=$ADUser.extensionAttribute4
		    ea5=$ADUser.extensionAttribute5
            ea14=$ADUser.extensionAttribute14
		    LineUri=$TeamsUser.LineUri
		InterpretedUserType = $TeamsUser.InterpretedUserType
            TenantDialPlan = $TeamsUser.TenantDialPlan
            OnlineVoiceRoutingPolicy = $TeamsUser.OnlineVoiceRoutingPolicy
            AssignedGroups = $AssignedGroups
            
	    }


$Object = New-Object psobject -Property $Properties
$Datas += $Object
return $Datas | select UserPrincipalName,SamAccountname,ea14,ea3,ea5,ea4,LineUri,InterpretedUserType,TenantDialPlan,TeamsCallingPolicy,OnlineVoiceRoutingPolicy,AssignedGroups

}
