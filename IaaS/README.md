


use the same reagion for all resources
Create a resource group in 


create a virtual network 
	address space 10.0.0.0/20
   	subnet FE     10.0.0.0/24

Add a subnet to the virtual network
  	BE 	10.1.0.0/24 no network security group
 
Create a Virtual network gateway (VPN, Route-based, standart SKU) with a public IP (any IP address) 10.0.15.0/24 for the previously created VNET 
REMARK: Provisioning a virtual network gateway may take up to 45 minutes (STATE UPDATING...)

Assign a Point To Site Address pool: 10.0.16.0/25
REMARK: Assigning a Point To Site Address pool takes a few minutes to complete  (STATE UPDATING...)

Add a VM to the FE subnet without a public IP

Create a Web application

Connect it to the VNET

Verify the connection 
  using Konsole and tcpping check the connection to VM1
  using Konsole and tcpping check the connection to VM2


Create an Application Gateway
	Subnet FE 
	New Public IP
	HTTP listener

REMARK: Application Gateways take about 15 minutes to create (STATE UPDATING...)

Create a fronend listener
  Retreive the public IP of the Application Gateway
  Create a A NAME record for that ip (mygateway.bekkops.xyz)
  Create a frontend listener on port 80 called 
Takes a while to create/update application gateway

Create a backend pool


Create a rule
