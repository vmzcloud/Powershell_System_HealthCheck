function Profile_Join {
	$Servers = Import-csv "$Server_csv"
	$Profile = Import-csv "$Profile_csv"
	$Servers_with_Profile = Join-Object -Left $Servers -Right $Profile -LeftJoinProperty Profile -RightJoinProperty Profile -Type AllInLeft
	Return $Servers_with_Profile
}

function Connectivity_Join {
	param([string] $Project)
	
	$CSV_folder = "$CSV_Base\$Project"
	
	$Servers = Import-csv "$Server_csv"
	$Connectivtiy = Import-csv "$CSV_folder\Connectivity_test.csv" | Select IP,SSH_Port,RDP_Port
	
	$Servers_with_Connectivity = Join-Object -Left $Servers -Right $Connectivtiy -LeftJoinProperty IP -RightJoinProperty IP -Type AllInLeft
	Return $Servers_with_Connectivity
}