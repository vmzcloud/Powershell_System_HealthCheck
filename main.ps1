Get-ChildItem ".\Function\Function_*.ps1" | %{.$_}

#set plink directory path
$env:Path += "D:\Benny\HealthCheck\System_HealthCheck"
$CSV_Base = ".\CSV"
$Server_csv = ".\Example.csv"
$Profile_csv = ".\Info\Server_Profile.csv"

Housekeep_CSV_Folder
Housekeep_HTML_Folder
$Projects = Create_Folder

foreach ($Project in $Projects){
	$Project_name = $Project.project

	if ($Project_name -ne $null){
		Get_Connectivity_csv($Project_name)
		#PS_get_iLo_Status_csv($Project_name)
		#Plink_get_Linux_Basic_csv($Project_name)
		SNMP_get_Synology_info_csv($Project_name)
		SNMP_get_Smart_UPS_info_csv($Project_name)
		#Plink_get_df_csv
		Export-ALL-HTML($Project_name)
	}
}
