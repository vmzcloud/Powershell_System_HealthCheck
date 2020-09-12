function SNMP_get_Synology_info_csv {
	param([string] $Project)
		
	$CSV_folder = "$CSV_Base\$Project"
	$Servers = Import-csv "$Server_csv" | where {$_.Profile -eq "Synology_NAS"}
	
    If ($Servers -ne $null){
		$SNMP = New-Object -ComObject olePrn.OleSNMP
		
		"Hostname,model_Name,serial_Number,version,systemStatus" >> $CSV_folder\Synology_NAS.csv
		
		Foreach ($Server in $Servers){
			$user = $Server.user
			$IP = $Server.IP
			$Pass = $Server.Pass
			$Hostname = $Server.Hostname
			$snmp_community = $Server.snmp_community
			
			$snmp.open($IP,$snmp_community,2,1000)
			$modelName = "-"
			$serialNumber = "-"
			$version = "-"
			$systemStatus = "-1"
			
			Write-Host $snmp_community
			
			if ($snmp_community -ne "-"){
			Write-Host "Hello"
				$modelName = $snmp.get('.1.3.6.1.4.1.6574.1.5.1.0')
				$serialNumber = $snmp.get('.1.3.6.1.4.1.6574.1.5.2.0')
				$version = $snmp.get('.1.3.6.1.4.1.6574.1.5.3.0')
				$systemStatus = $snmp.get('.1.3.6.1.4.1.6574.1.1.0')
			}
			
			$systemStatus_translate = Translate_Synology_SystemStatus($systemStatus)
			
			"$Hostname,$modelName,$serialNumber,$version,$systemStatus_translate" >> $CSV_folder\Synology_NAS.csv
		}	
		Write-Host "Save to $CSV_folder\Synology_NAS.csv"
	}
}

function Translate_Synology_SystemStatus {
	param([Int] $systemStatus)
	
	if ($systemStatus -eq 1){
		Return "Normal"
	}
	Elseif ($systemStatus -eq 2){
		Return "Failed"
	}
	Else {
		Return "Unknown"
	}
}