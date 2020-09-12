function Get_Connectivity_csv {
	param([string] $Project)
	$Servers_with_Profile = Profile_Join
	$Servers = $Servers_with_Profile | where {$_.Project -eq $Project}
	
	$CSV_folder = "$CSV_Base\$Project"
	
	"Profile,Hostname,IP,Ping,SSH_Port,RDP_Port" >> $CSV_folder\Connectivity_test.csv
	
	foreach ($server in $Servers){
		$hostname = $server.Hostname
		$IP = $server.IP
		$Profile = $server.Profile
		$YorN_SSH_Port_Test = $server.SSH_Port_Test
		$YorN_RDP_Port_Test = $server.RDP_Port_Test
		
		$Ping_Test = Ping_Test($IP)
		$SSH_Port_Test = Port_Test($IP)(22)($YorN_SSH_Port_Test)
		$RDP_Port_Test = Port_Test($IP)(3389)($YorN_RDP_Port_Test)
		"$Profile,$hostname,$IP,$Ping_Test,$SSH_Port_Test,$RDP_Port_Test" >> $CSV_folder\Connectivity_test.csv
	}
	Write-Host "Save to $CSV_folder\Connectivity_test.csv"
}

function Ping_Test {
	param([string] $IP)
	$Result =  Test-Connection -ComputerName $IP -Count 1 -ErrorAction SilentlyContinue
	
	If ($Result){
		$Ping_Test = "TEST_OK"
	}
	Else{
		$Ping_Test = "TEST_FAIL"
	}
	Write-Host $IP Ping Test: $Ping_Test
	Return $Ping_Test
}

function Port_Test {
	param([string] $IP, [int] $Port, [Int] $YorN)
	If ($YorN -eq 1){
		$Result =  (Test-NetConnection -ComputerName $IP -Port $Port).TcpTestSucceeded
		
		If ($Result){
			$Port_Test = "TEST_OK"
		}
		Else{
			$Port_Test = "TEST_FAIL"
		}
	}
	Else {
		$Port_Test = "N/A"
	}
	
	Write-Host $IP Port Test: $Port_Test
	Return $Port_Test
}
