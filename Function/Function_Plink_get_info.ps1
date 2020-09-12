function Plink_get_Linux_Basic_csv {
	param([string] $Project)
	
	$CSV_folder = "$CSV_Base\$Project"
	$Servers_SSH = Connectivity_Join($Project)
	$Servers = $Servers_SSH | where {$_.SSH_Port -eq "TEST_OK"}
	
	If ($Servers.count -gt 0){
		"Hostname,Redhat_Release,Kernel" >> $CSV_folder\Linux.csv
		
		Foreach ($Server in $Servers){
			$user = $Server.user
			$IP = $Server.IP
			$Pass = $Server.Pass
			$Hostname = $Server.Hostname
			.\plink.exe -no-antispoof $user@$IP -pw $Pass 'cat /etc/redhat-release; uname -r' | Tee-Object -variable Linux_Basic_raw_data
			$Linux_Basic_csv_data = $Hostname + "," + $Linux_Basic_raw_data[0] + "," + $Linux_Basic_raw_data[1]
			$Linux_Basic_csv_data | out-file $CSV_folder\Linux.csv -Append
		}	
		Write-Host "Save to $CSV_folder\Linux.csv"
	}
}