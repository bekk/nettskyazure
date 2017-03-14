function InstallSeq()
{
	mkdir "d:\seq" -force
	$wc = New-Object net.webclient
	$wc.Downloadfile('https://getseq.net/Download/Begin?version=latest', 'd:\seq.msi')
	Start-Process -FilePath "D:\seq.msi" -ArgumentList "/quiet /norestart" -Wait -WorkingDirectory "d:\"		
  & 'C:\Program Files\Seq\Seq.exe' install --storage="d:\seq" --listen="http://localhost:5341"
	& 'C:\Program Files\Seq\Seq.exe' start			
	netsh advfirewall firewall add rule "name=Seq Server" dir=in action=allow protocol=TCP localport=5341
	Start-Sleep -s 10
	Get-WMIObject win32_service | Where-Object {$_.Name -imatch "seq"}; foreach ($service in $services){sc.exe failure $service.name reset= 86400 actions= restart/5000/restart/5000/reboot/5000}	
}
