function SNMP_get_Smart_UPS_info_csv {
	param([string] $Project)
		
	$CSV_folder = "$CSV_Base\$Project"
	$Servers = Import-csv "$Server_csv" | where {$_.Profile -eq "Server_UPS"}
	
    If ($Servers -ne $null){
		$SNMP = New-Object -ComObject olePrn.OleSNMP
		
		"Hostname,model,Battery_capacity,Battery_runtime_remain,Battery_replace" >> $CSV_folder\Smart_UPS.csv
		
		Foreach ($Server in $Servers){
			$user = $Server.user
			$IP = $Server.IP
			$Pass = $Server.Pass
			$Hostname = $Server.Hostname
			$snmp_community = $Server.snmp_community
			
			$snmp.open($IP,$snmp_community,2,1000)
			$model = "-"
			$Battery_capacity = "-"
			$Battery_runtime_remain = "-1"
			$Battery_replace = "-1"
			
			if ($snmp_community -ne "-"){
				$model = $snmp.get('.1.3.6.1.4.1.318.1.1.1.1.1.1.0')
				$Battery_capacity = $snmp.get('.1.3.6.1.4.1.318.1.1.1.2.2.1.0')
				$Battery_runtime_remain = $snmp.get('.1.3.6.1.4.1.318.1.1.1.2.2.3.0')
				$Battery_replace = $snmp.get('.1.3.6.1.4.1.318.1.1.1.2.2.4.0')
			}	
			
			$Battery_runtime_remain_translate = Translate_Battery_runtime_remain($Battery_runtime_remain)
			$Battery_replace_translate = Translate_Battery_replace($Battery_replace)
			
			"$Hostname,$model,$Battery_capacity,$Battery_runtime_remain_translate,$Battery_replace_translate" >> $CSV_folder\Smart_UPS.csv
		}	
		Write-Host "Save to $CSV_folder\Smart_UPS.csv"
	}
}

function Translate_Battery_replace {
	param([Int] $Battery_replace)
	
	if ($Battery_replace -eq 1){
		Return "OK"
	}
	Elseif ($Battery_replace -eq 2){
		Return "battery needs replacing"
	}
	Else {
		Return "Unknown"
	}
}

function Translate_Battery_runtime_remain {
	param([Int] $Battery_runtime_remain)
	
	$Battery_runtime_sec = $Battery_runtime_remain / 100
	$ts =  [timespan]::fromseconds($Battery_runtime_sec)
	$Battery_runtime_hr = ("{0:hh\:mm}" -f $ts)
	
	Return $Battery_runtime_hr
}