
function Set-Flex
{
param (
$UPN,
$Site
)

$ADUser = get-ADUser -filter 'UserprincipalName -eq $UPN' -properties *

if($ADUser.extensionattribute5){$Site = $ADUser.extensionattribute5} 
elseif($ADUser.extensionattribute3) {$Site = $ADUser.extensionattribute3} 
if(!($Site)){throw "Site not set"}
if(!($ADUser)){throw "User not Found"}

$VoiceRoutingPolicy =  $Site + "-Unrestricted"
$SIPAddress = $ADUser.Userprincipalname
$DialPlan = $Site
$Number = $ADUser.extensionattribute4

$SIPAddress
$Number
$DialPlan
$VoiceRoutingPolicy


Set-CsPhoneNumberAssignment -Identity  $SIPAddress -PhoneNumber $Number -PhoneNumberType DirectRouting 
Grant-CsTenantDialPlan -Identity $SIPAddress -PolicyName  $DialPlan 
Grant-CsTeamsCallingPolicy -identity $SIPAddress -PolicyName $NULL
Grant-CsOnlineVoiceRoutingPolicy -Identity  $SIPAddress -PolicyName $VoiceRoutingPolicy
 
}