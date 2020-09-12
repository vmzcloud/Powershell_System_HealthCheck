function Create_Folder {
	$Servers = Import-csv "$Server_csv"
	$Projects = $Servers | select Project -unique
	
	foreach ($Project in $Projects){
		$Folder_Name = $Project.project
		New-Item -Path $CSV_Base\$Folder_Name -ItemType directory
		Write-Host "$Folder_Name Folder Created"
	}
	Return $Projects
}

function Housekeep_CSV_Folder {
	Remove-Item $CSV_Base\* -Recurse -Confirm:$false
	Write-Host "CSV Folder HouseKeep Completed"
}

function Housekeep_HTML_Folder {
	$HTML_Folder = ".\HTML"
	Remove-Item "$HTML_Folder\*.html" -Confirm:$false
	Write-Host "HTML Folder HouseKeep Completed"
}