function Load_HPEiLoCmdlets_Module {

	Import-Module HPEiLoCmdlets
}

function PS_get_iLo_Status_csv {
	param([string] $Project)
	
	Load_HPEiLoCmdlets_Module
	
	$CSV_folder = "$CSV_Base\$Project"
	$Servers = Import-csv "$Server_csv" | where {$_.Profile -eq "HP_iLo"}
		
	Foreach ($Server in $Servers){
		$user = $Server.user
		$IP = $Server.IP
		$Pass = $Server.Pass
		$Hostname = $Server.Hostname
		$Connection = Connect-HPEiLO -IP $IP -Username $user -Password $Pass -DisableCertificateAuthentication -WarningAction SilentlyContinue
		$getServerInfo = Get-HPEiLOServerInfo -Connection $Connection
		
		$getServerInfo | select IP, ServerName, @{N='Serial';E={(Find-HPEiLO $IP).SerialNumber}}, 
			@{N='ILOGen';E={$Connection.iLOGeneration}}, 
			@{N='Server Family';E={$Connection.ServerFamily}},
			@{N='Server Model';E={$Connection.ServerModel}},
			@{N='Server Generation';E={$Connection.ServerGeneration}},
			Status | Export-CSV -Path $CSV_folder\HP_iLo.csv -NoTypeInformation -Append
			
		Disconnect-HPEiLO -Connection $Connection
	}	
	Write-Host "Save to $CSV_folder\HP_iLo.csv"
}