function Plink_get_df_csv {
	$Servers = Import-csv $Linux_server_csv
	Foreach ($Server in $Servers){
		$user = $Server.user
		$IP = $Server.IP
		$Pass = $Server.Pass
		$Hostname = $Server.Hostname
		.\plink.exe -no-antispoof $user@$IP -pw $Pass df -h | Tee-Object -variable df_raw_data
		#remove multi space
		$raw_data1 = $df_raw_data -replace '\s\s+', " "
		#replace "Mounted On" to "Mounted_On"
		$raw_data2 = $raw_data1 -replace "Mounted On", "Mounted_On"
		#replace space to ","
		$raw_data3 = $raw_data2 -replace " ", ","
		#export csv file
		$raw_data3 | out-file $CSV_folder\$Hostname"_df".csv
	}
}