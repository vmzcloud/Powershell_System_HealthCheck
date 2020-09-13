function Export-ALL-HTML {
	param([string] $Project)
	
	Export-Full-HTML-Page($Project)
}

function Export-Full-HTML-Page {
	param([string] $Project)
	
	$CSV_Con_file = "$CSV_Base\$Project\Connectivity_test.csv"
	$CSV_Linux_file = "$CSV_Base\$Project\Linux.csv"
	$CSV_HP_iLo_file = "$CSV_Base\$Project\HP_iLo.csv"
	$CSV_Syno_NAS_file = "$CSV_Base\$Project\Synology_NAS.csv"
	$CSV_Smart_UPS_file = "$CSV_Base\$Project\Smart_UPS.csv"
	$HTML_file = ".\HTML\$Project.html"
	
	$HTML_Report_sytle = "<link rel=stylesheet type=text/css href=./mystyle.css charset=utf-8>"
	$HTML_Report_header = "<!DOCTYPE html><html><head><Title>$heading</Title>$HTML_Report_sytle</head><body><hr>"
	$today_modified = Get-date
	$Update_date = "Updated :" + $today_modified
	
	$Con_html_content = Export-Table-HTML($CSV_Con_file)("Connectivity")
	$Lin_html_content = Export-Table-HTML($CSV_Linux_file)("Linux")
	$iLo_html_content = Export-Table-HTML($CSV_HP_iLo_file)("HP_iLo")
	$SynoNAS_html_content = Export-Table-HTML($CSV_Syno_NAS_file)("Synology_NAS")
	$SmartUPS_html_content = Export-Table-HTML($CSV_Smart_UPS_file)("Smart_UPS")
	
	$HTML_Report_footer = "</body></html>"
	
	$HTML_Report = $HTML_Report_header + $Update_date + $Con_html_content + $Lin_html_content + $iLo_html_content + $SynoNAS_html_content + $SmartUPS_html_content + $HTML_Report_footer
	
	$HTML_Report | Out-File $HTML_file
	Write-Host "File saved to $HTML_file"
}

function Export-Single-HTML-Page {
	param([string] $csvfilepath, [string] $htmlfilepath, [string] $heading)
	$HTML_Report_sytle = "<link rel=stylesheet type=text/css href=./mystyle.css charset=utf-8>"
	$HTML_Report_header = "<!DOCTYPE html><html><head><Title>$heading</Title>$HTML_Report_sytle</head><body><hr>"
	$today_modified = Get-date
	$Update_date = "Updated :" + $today_modified
	$html_content = Export-Table-HTML($csvfilepath)($heading)
	$HTML_Report_footer = "</body></html>"
	
	$HTML_Report = $HTML_Report_header + $Update_date + $html_content + $HTML_Report_footer
	
	$HTML_Report | Out-File $htmlfilepath
	Write-Host "File saved to $htmlfilepath"
}

function Export-Table-HTML {
	param([string] $filepath, [string] $heading)
	
	if (Test-Path $filepath){
	
		$txt = Import-CSV -Path $filepath
		[string]$txt2html = $txt | ConvertTo-Html 
		
		$txt2html -match "<body>(?<content>.*)</body>" | out-null
		$txt2html_tbl = $matches['content']
		
		$txt2html_tbl = Convert-to-Image($txt2html_tbl)
		
		$heading = "<h2>$heading</h2>"
		$No_info = ""
		If (!$txt) {
			$No_info = "No Information"
		}
		$heading_table_html = $heading + $No_info + $txt2html_tbl
	}
	Return $heading_table_html
}

function Convert-to-Image {
	param([string] $html_content)
	
	#UP
	$html_content = $html_content -replace "TEST_OK","<img src=./Images/UP.png>"
	
	#DOWN
	$html_content = $html_content -replace "TEST_FAIL","<img src=./Images/DOWN.png>"
	
	#Linux_Server
	$html_content = $html_content -replace "Linux_Server","<img src=./Images/Linux.png>"
	
	#Windows_Server
	$html_content = $html_content -replace "Windows_Server","<img src=./Images/Windows.png>"
	
	#HP_iLO
	$html_content = $html_content -replace "HP_iLO","<img src=./Images/HP.png>"
	
	#Server_UPS
	$html_content = $html_content -replace "Server_UPS","<img src=./Images/UPS.png>"
	
	#Server_UPS
	$html_content = $html_content -replace "Synology_NAS","<img src=./Images/NAS.png>"
	
	Return $html_content
}
